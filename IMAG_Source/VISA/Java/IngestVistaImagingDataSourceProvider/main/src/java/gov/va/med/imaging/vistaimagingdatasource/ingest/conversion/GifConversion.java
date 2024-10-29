package gov.va.med.imaging.vistaimagingdatasource.ingest.conversion;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.FileTypeIdentifierStream;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.vista.storage.SmbStorageUtility;
import gov.va.med.imaging.vistaimagingdatasource.ingest.VistaImagingIngestDataSourceProvider;

import java.io.IOException;
import java.io.InputStream;

public class GifConversion
        extends MimeConversion{

    private SmbStorageUtility storageUtility = new SmbStorageUtility();

    public GifConversion(){
        super();
    }

    public String convertSingleImageGif(String cacheFilePath, String cachedFilename, ImageFormat imageFormat)
            throws MethodException{
        //save inStream to a cached file.
        String convertedFilename = null;
        String imageConverterExe = VistaImagingIngestDataSourceProvider.getConfiguration().getImageConverterExe();
        try {
            convertedFilename = storageUtility.changeFileExtension(cachedFilename, "jpg");
            executeConversionProcess(imageConverterExe, cacheFilePath, cachedFilename, imageFormat.getMime(), convertedFilename);
        } catch (IOException ioX) {
            throw new MethodException("Failed to execute conversion process.");
        }

        return convertedFilename;
    }

    public String convertMultiImageGif(String cacheFilePath, String cachedFilename, ImageFormat imageFormat)
            throws MethodException{
        //save inStream to a cached file.
        String convertedFilename = null;
        String videoConverterExe = VistaImagingIngestDataSourceProvider.getConfiguration().getVideoConverterExe();
        try {
            convertedFilename = storageUtility.changeFileExtension(cachedFilename, "avi");
            executeConversionProcess(videoConverterExe, cacheFilePath, cachedFilename, imageFormat.getMime(), convertedFilename);
        } catch (IOException ioX) {
            throw new MethodException("Failed to execute conversion process.");
        }

        return convertedFilename;
    }
}
