package gov.va.med.imaging.vistaimagingdatasource.ingest.conversion;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.FileTypeIdentifierStream;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.vista.storage.SmbStorageUtility;
import gov.va.med.imaging.vistaimagingdatasource.ingest.VistaImagingIngestDataSourceProvider;

import java.io.IOException;
import java.io.InputStream;

public class MovConversion extends MimeConversion {

    private SmbStorageUtility storageUtility = new SmbStorageUtility();

    public MovConversion(){
        super();
    }

    public String convertMovVideo(String cachedFilePath, String cachedFilename, ImageFormat imageFormat)
            throws MethodException {
        String convertedFilename = null;
        String videoConverterExe = VistaImagingIngestDataSourceProvider.getConfiguration().getVideoConverterExe();
        try {
            convertedFilename = storageUtility.changeFileExtension(cachedFilename, "avi");
            executeConversionProcess(videoConverterExe, cachedFilePath, cachedFilename, imageFormat.getMime(), convertedFilename);
        } catch (IOException ioX) {
            ioX.printStackTrace();
        }

        return convertedFilename;
    }
}
