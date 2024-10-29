package gov.va.med.imaging.ingest;

import java.io.InputStream;

public class ItemStream {


    public ItemStream(InputStream inputStream, String mimeType, String originalFilename, String fieldName) {
        this.inputStream = inputStream;
        this.mimeType = mimeType;
        this.originalFilename = originalFilename;
        this.fieldName = fieldName;
    }

    public ItemStream(InputStream inputStream) {
        this.inputStream = inputStream;
    }

    private InputStream inputStream;
    private String mimeType = null;
    private String originalFilename = null;
    private String fieldName = null;

    public InputStream getInputStream() {
        return inputStream;
    }

    public String getMimeType() {
        return mimeType;
    }

    public String getOriginalFilename() {
        return originalFilename;
    }

    public String getFieldName() { return fieldName; }

}
