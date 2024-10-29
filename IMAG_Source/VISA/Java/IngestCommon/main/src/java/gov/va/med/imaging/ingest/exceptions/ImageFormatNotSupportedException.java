package gov.va.med.imaging.ingest.exceptions;

public class ImageFormatNotSupportedException
        extends Exception{

    public ImageFormatNotSupportedException() {
    }

    public ImageFormatNotSupportedException(String message) {
        super(message);
    }

    public ImageFormatNotSupportedException(String message, Throwable cause) {
        super(message, cause);
    }

    public ImageFormatNotSupportedException(Throwable cause) {
        super(cause);
    }
}
