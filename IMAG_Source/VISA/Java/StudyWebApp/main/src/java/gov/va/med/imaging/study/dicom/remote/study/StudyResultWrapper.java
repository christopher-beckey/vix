package gov.va.med.imaging.study.dicom.remote.study;

import gov.va.med.imaging.study.rest.types.StudiesResultType;

public class StudyResultWrapper {

    private final StudiesResultType result;
    private final int statusCode;
    public StudyResultWrapper(int code, StudiesResultType result){
        this.result = result;
        this.statusCode = code;
    }


    public StudiesResultType getResult() {
        return result;
    }

    public int getStatusCode() {
        return statusCode;
    }
}
