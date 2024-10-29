package gov.va.med.imaging.study.dicom.remote;

import gov.va.med.imaging.study.dicom.cache.CacheTask;
import gov.va.med.imaging.study.dicom.query.StudyQuery;

public class FetchDTO {
    private final StudyQuery query;
    private final CacheTask cacheTask;
    private final String stringURL; //java URL is not always appropriate here

    public FetchDTO(StudyQuery query, CacheTask cacheTask, String stringURL){
        this.query = new StudyQuery(query);
        this.cacheTask = cacheTask;
        this.stringURL = stringURL;
    }

    public StudyQuery getQuery() {
        return query;
    }

    public CacheTask getCacheTask() {
        return cacheTask;
    }

    public String getStringURL() {
        return stringURL;
    }

    public String getCacheFileName() {
        return this.getCacheTask().getFileName();
    }
}
