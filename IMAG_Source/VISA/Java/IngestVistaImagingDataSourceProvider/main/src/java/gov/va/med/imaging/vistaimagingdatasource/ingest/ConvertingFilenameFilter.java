package gov.va.med.imaging.vistaimagingdatasource.ingest;

import java.io.File;
import java.io.FilenameFilter;

public class ConvertingFilenameFilter
        implements FilenameFilter {

    private String convertingFilename;

    public ConvertingFilenameFilter(String convertingFilename) {
        this.convertingFilename = convertingFilename;
    }

    public boolean accept(File dir, String name) {
        return (name.startsWith(convertingFilename));
    }
}

