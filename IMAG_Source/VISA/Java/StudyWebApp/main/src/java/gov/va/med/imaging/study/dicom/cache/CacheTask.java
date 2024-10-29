package gov.va.med.imaging.study.dicom.cache;

import java.io.File;

public abstract class CacheTask implements Runnable{ //will eventually use Run() to cache file
    String fileName;

    public boolean isCached(){
        File file = new File(getFileName());
        return file.exists() && !file.isDirectory() && file.canRead() && file.length() > 0;
                //&& file.renameTo(file);//janky windows lock checking
    }

    public String getFileName() {
        return fileName;
    }
}
