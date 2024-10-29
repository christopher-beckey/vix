package gov.va.med.imaging.study.dicom.vista;

import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.study.dicom.cache.ImageCacheTask;
import gov.va.med.imaging.study.dicom.remote.image.ImageFetchDto;
import gov.va.med.imaging.url.vista.image.SiteParameterCredentials;
import gov.va.med.logging.Logger;

import java.io.*;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.Map;

public class ImageStorageShare {

    private static final Map<String, ImageStoreStatus> mappedShares = new HashMap<>();
    private final static Logger LOGGER = Logger.getLogger(ImageStorageShare.class);
    private final String[] pathParts;
    private final String sharePath;
    private final Image image;
    private final String callingAe;
    private final String callingIp;
    private final String remoteSiteCode;
    private final ImageCacheTask cacheTask;

    public ImageStorageShare(Image img, String callingIp, String callingAe, String remoteSiteCode,
                             ImageCacheTask imageCacheTask){
        this.image = img;
        this.callingIp = callingIp;
        this.callingAe = callingAe;
        this.remoteSiteCode = remoteSiteCode;
        this.cacheTask = imageCacheTask;
        String networkPath = img.getFullFilename();

        if (networkPath.startsWith("\\")) {
            networkPath = networkPath.substring(2);
        }

        networkPath = networkPath.replace('\\', '/');

        this.pathParts = networkPath.split("/");
        this.sharePath = pathParts[0] + pathParts[1];
        connectToShare();

    }

    public ImageStorageShare(ImageFetchDto fetchDto) {
    	
        String networkPath = fetchDto.getImage().getFullFilename();
        
        if (networkPath.startsWith("\\")) {
            networkPath = networkPath.substring(2);
        }
        
        networkPath = networkPath.replace('\\', '/');

        this.pathParts = networkPath.split("/");
        this.sharePath = pathParts[0] + pathParts[1];
        this.remoteSiteCode = fetchDto.getRemoteSiteCode();
        this.callingAe = fetchDto.getCallingAe();
        this.callingIp = fetchDto.getCallingIp();
        this.image = fetchDto.getImage();
        this.cacheTask = fetchDto.getCacheTask();
        connectToShare();
    }

    public boolean isAvailable() {
    	
        return connectToShare().getStatus().equals(ImageStoreStatus.Status.CONNECTED);
    }

    public String cacheImage() throws ImagingDicomException {
    	
        return !isAvailable() ? null : cacheImageFileFromShare();
    }

    private ImageStoreStatus connectToShare() {
    	
        if(mappedShares.containsKey(sharePath) && mappedShares.get(sharePath).getStatus().equals(ImageStoreStatus.Status.CONNECTED)) {
            return mappedShares.get(sharePath);
        } else if(mappedShares.containsKey(sharePath) &&
                Instant.now().isBefore(mappedShares.get(sharePath).getFailureTime().plus(30,ChronoUnit.SECONDS))) {
            //don't retry within 30 seconds
            return mappedShares.get(sharePath);
        }

        try {
            SiteParameterCredentials siteParameterCredentials =
                    RemoteVistaDataSource.getSiteParameterCredentials(remoteSiteCode, callingAe, callingIp);

            String command = String.format("C:\\Windows\\system32\\net.exe use \\\\%s\\%s /user:%s %s",pathParts[0],
                    pathParts[1],siteParameterCredentials.getUsername(),siteParameterCredentials.getPassword());
            runCmd(command);

            mappedShares.put(sharePath, new ImageStoreStatus(ImageStoreStatus.Status.CONNECTED, null));
        } catch (IOException | ImagingDicomException e) {
            mappedShares.put(sharePath, new ImageStoreStatus(ImageStoreStatus.Status.FAILED, Instant.now()));
            RemoteVistaDataSource.purgeCredsForSite(remoteSiteCode);
        }
        
        return mappedShares.get(sharePath);
    }

    private static String runCmd(String command) throws IOException {
    	
        Process process = Runtime.getRuntime().exec(command);
        String s = null;
        StringBuilder ret = new StringBuilder();
        
        try(BufferedReader stdInput = new BufferedReader(new InputStreamReader(process.getInputStream()));
            BufferedReader stdError = new BufferedReader(new InputStreamReader(process.getErrorStream()))) {

            while ((s = stdInput.readLine()) != null) {
                
            	ret.append(s);
            }

            while ((s = stdError.readLine()) != null) {
                
            	LOGGER.error("Failed to run command {} output is {}", command, s);
            	
                // For some reason, Fortify doesn't like the "+ command +" part.
                if(s.contains("System Error")) 
                	throw new IOException("runCmd(command) was unsuccessfully executed. See log for more info.");
            }
        }
        
        return ret.toString();
    }

    private String cacheImageFileFromShare() throws ImagingDicomException {

        File f = new File(image.getFullFilename());

        File vixCacheFile = null;
        if( f.isFile() && f.canRead() ) {
            
        	vixCacheFile = new File(cacheTask.getFileName());
            
            if(!vixCacheFile.getParentFile().exists()) {
                vixCacheFile.getParentFile().mkdirs();
            }
            
            String interimFileName = vixCacheFile+"_temp";
            File interimFile = new File(interimFileName);
            LOGGER.info("writing {} to {}", image.getImageUrn().toString(), interimFile.getAbsolutePath());
            
            try {
                writeFile(new FileInputStream(f), interimFile);
                if(!interimFile.renameTo(vixCacheFile)) {
                    throw new ImagingDicomException("Failed to rename interim file " + interimFileName);
                }
            } catch (FileNotFoundException e) {
                LOGGER.error("File is not found at the given path {}", f.getAbsolutePath());
                throw new ImagingDicomException("Failed to read file from share " +image.getImageUrn().toString());
            } catch (Exception ex) {
                LOGGER.error("Failed to get file from share, setting share status to failed {}", image.getFullFilename());
                mappedShares.put(sharePath,new ImageStoreStatus(ImageStoreStatus.Status.FAILED, Instant.now()));
                RemoteVistaDataSource.purgeCredsForSite(remoteSiteCode);
                throw new ImagingDicomException("Failed to get file from share, setting share status to failed ");
            }
        } else {
            LOGGER.error("Given path {} is not a file or is unreadable.", f.getAbsolutePath());
            throw new ImagingDicomException("Given path " + f.getAbsolutePath() + " is not a file or unreadable.");
        }
        
        return vixCacheFile.getAbsolutePath();
    }

    private static void writeFile(InputStream r, File file) {
    	
        byte [] buf = new byte[8*1024];
        int n = 0;
        
        try(BufferedInputStream b = new BufferedInputStream(r);
            FileOutputStream fw = new FileOutputStream(file)) {
        	
            long tst = System.currentTimeMillis();
            long byteCount = 0;
            
            while ((n = b.read(buf)) != -1) {
                fw.write(buf, 0, n);
                byteCount += n;
            }
            
            LOGGER.info("Finished reading {} of {} bytes in {} ms", file, byteCount, System.currentTimeMillis() - tst);
            
        } catch (Exception e) {
            LOGGER.error("Could not write file {} error {}", file, e.getMessage());            
        }
    }

    @Override
    public String toString() {
        return "ImageStorageShare{" +
                "sharePath=" + sharePath +
                ", image =" + image.getImageUrn() +
                ", fullFilePath= " + image.getFullFilename() +
                ", cacheFilePath="+ cacheTask.getFileName() +
                '}';
    }
}
