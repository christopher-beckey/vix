package gov.va.med.imaging.study.dicom.vista;

import java.time.Instant;

public class ImageStoreStatus {

    private final Status status;
    private final Instant failureTime;

    public ImageStoreStatus(Status status, Instant failureTime){
        this.status = status;
        this.failureTime = failureTime;
    }

    public Status getStatus() {
        return status;
    }

    public Instant getFailureTime() {
        return failureTime;
    }

    public enum Status{
        CONNECTED,
        FAILED,
    }
}
