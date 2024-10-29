package gov.va.med.imaging.vistaimagingdatasource.ingest.conversion;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.FileTypeIdentifierStream;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.vista.storage.SmbStorageUtility;
import gov.va.med.imaging.vistaimagingdatasource.ingest.VistaImagingIngestDataSourceProvider;
import gov.va.med.imaging.vistaimagingdatasource.ingest.VistaImagingIngestDataSourceService;
import gov.va.med.logging.Logger;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class MimeConversion {

    private final static Logger logger = Logger.getLogger(MimeConversion.class);

    public MimeConversion(){

    }

    protected Logger getLogger(){
        return logger;
    }

    protected void executeConversionProcess(String command, String cachedFilePath, String cachedFilename, String mimeType, String convertedFilename) throws MethodException, IOException {
        //call C# executable.  Pass parameters folder, input filename, mimeType
        String workingDirectory = VistaImagingIngestDataSourceProvider.getConfiguration().getConversionWorkingFolder();
        String convertedFilenameWithoutExtension = StringUtil.MagPiece(cachedFilename, StringUtil.PERIOD, 1);

        StringBuilder sb = new StringBuilder();
        sb.append(command);
        sb.append(" "+cachedFilePath);
        sb.append(" "+cachedFilename);
        sb.append(" "+mimeType);
        sb.append(" "+convertedFilenameWithoutExtension);

        logger.info("Creating converted image/video file with parameters [{}]", sb.toString());
        Process process = Runtime.getRuntime().exec(sb.toString(), null, new File(workingDirectory));
        try
        {
            process.waitFor();
        }
        catch(InterruptedException iX)
        {
            logger.error("Error creating conversion, {}", iX.getMessage());
            return;
        }

        File convertedFile = new File(cachedFilePath + File.separatorChar + convertedFilename);
        if(!convertedFile.exists())
        {
            logger.warn("Did not create converted file [{}]", convertedFilename);
            return;
        }

        return;
    }

    public boolean isGIFMultiImage(String cachedFilespec) throws java.io.IOException {

        String workingDirectory = VistaImagingIngestDataSourceProvider.getConfiguration().getConversionWorkingFolder();
        String cmd = VistaImagingIngestDataSourceProvider.getConfiguration().getGifInfoExe();

        StringBuilder sb = new StringBuilder();
        sb.append(cmd);
        sb.append(" "+cachedFilespec);

        Process proc = Runtime.getRuntime().exec(sb.toString(),null, new File(workingDirectory));
        java.io.InputStream is = proc.getInputStream();
        java.util.Scanner s = new java.util.Scanner(is).useDelimiter("\\A");
        String val = "";
        if (s.hasNext()) {
            val = s.next();
        }
        else {
            val = "";
        }
        val = val.trim();
        if(val.toLowerCase(Locale.ENGLISH).equals("true")){
            return true;
        }
        return false;
    }

}
