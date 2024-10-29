package gov.va.med.imaging.study.dicom.remote.image;

import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.cache.ImageCacheTask;
import gov.va.med.imaging.study.dicom.remote.HttpsUtil;
import gov.va.med.logging.Logger;

import javax.net.ssl.HttpsURLConnection;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.concurrent.Callable;
import java.util.zip.GZIPInputStream;

public class ImageFetchTask implements Callable<String> {
	private final String imageUri;//note that this urn contains other query parameters imageQuality and contentType TODO: fix
	private final static Logger LOGGER = Logger.getLogger(ImageFetchTask.class);
	final String remoteSiteNumber;
	private final String remoteHost;
	final ImageCacheTask cacheTask;

	public ImageFetchTask(String imageUri, ImageCacheTask imageCacheTask, String remoteHost, String remoteSiteNumber)
	{
		this.imageUri = imageUri.replace(".useLocalImage", ""); //MIX/ECIA code will send us image unsupported if this is present		;
		this.remoteSiteNumber = remoteSiteNumber;
		this.cacheTask = imageCacheTask;
		this.remoteHost = remoteHost;
	}

	@Override
	public String call()
	{ //return the fileName for now, since LBS wants it
		long startmilli = System.currentTimeMillis();
		if(LOGGER.isDebugEnabled()){
            LOGGER.debug("===>GetImage_ starts. imgUri={}", imageUri);
		}
		HttpsURLConnection resp = null;
		try {
			if(cacheTask.isCached()){
				return cacheTask.getFileName();
			}
			if(isRemoteFetchEnabled() && !this.remoteSiteNumber.equals(DicomService.getSiteInfo().getSiteCode())){
				resp = getImageConnectionRemote();
			}
			if(resp == null || resp.getResponseCode() != 200) {
				resp = getImageConnectionLocal();
			}
			if (resp.getResponseCode() != 200){
                LOGGER.warn("   scpGetImage _{} got http failure. urn= {} status code {}", imageUri, imageUri, resp.getResponseCode());
			}
			else {
				if(LOGGER.isDebugEnabled()){
                    LOGGER.debug("===<GetImage_{} from VIX. Took {} ms.", imageUri, System.currentTimeMillis() - startmilli);
				}
				return cacheSync(resp);
			}
			return null;
		} catch (IOException | URISyntaxException e) {
            LOGGER.error("   scpGetImage for _{} got exception: {}", imageUri, e.getMessage());
			if(LOGGER.isDebugEnabled()){
                LOGGER.debug("scpGetImage for _{} got exception.", imageUri, e);
			}
		}finally {
			if(resp != null){
				resp.disconnect();
			}
		}
		return null;
	}

	private String cacheSync(HttpsURLConnection toCache) throws IOException
	{
		String fileName = cacheTask.getFileName()+"_temp";
		Files.createDirectories(Paths.get(fileName.substring(0, fileName.lastIndexOf("\\"))));
		File interimFile = new File(fileName);
		File vixCacheFile = new File(cacheTask.getFileName());
		try(FileOutputStream os = new FileOutputStream(fileName))
		{
			ReadableByteChannel fetchChannel = null;
			if(toCache != null)
			{
				String encoding = toCache.getContentEncoding();
				if(encoding != null && encoding.contains("gzip"))
				{
					fetchChannel = Channels.newChannel(new GZIPInputStream(toCache.getInputStream()));
				}else
				{
					fetchChannel = Channels.newChannel(toCache.getInputStream());
				}
				os.getChannel().transferFrom(fetchChannel, 0, Long.MAX_VALUE);
			}
		} catch (IOException e)
		{
            LOGGER.error("Cannot save image {} to file: {} error: {}", imageUri, fileName, e.getMessage());
			if(LOGGER.isDebugEnabled()){
                LOGGER.debug("failure to save image details for{}: ", imageUri, e);
			}

			return null;
		}
		if(!interimFile.renameTo(vixCacheFile)){
            LOGGER.error("Failed to rename interim file {}", interimFile.getAbsolutePath());
			return null;
		}
		return vixCacheFile.getAbsolutePath();
	}

	private HttpsURLConnection getImageConnectionRemote() throws IOException, URISyntaxException {
		if(remoteHost == null || remoteHost.equals("")){
			throw new URISyntaxException("", "Cannot connect to a null host");
		}
		return new HttpsUtil(String.format("https://%1s/ImageWebApp/token/image?securityToken=%2s&%3s",
				remoteHost, HttpsUtil.getToken(), imageUri))
				.setImageConnectionProperties(null, null);
	}

	private HttpsURLConnection getImageConnectionLocal() throws IOException, URISyntaxException
	{
		return new HttpsUtil("https://localhost/ImageWebApp/image?" + imageUri)
				.setImageConnectionProperties(DicomService.getScpConfig().getAccessCode().getValue(),
				DicomService.getScpConfig().getVerifyCode().getValue());
	}

	private boolean isRemoteFetchEnabled(){
		return DicomService.getScpConfig().isUseRemoteImageFetch();
	}

}
