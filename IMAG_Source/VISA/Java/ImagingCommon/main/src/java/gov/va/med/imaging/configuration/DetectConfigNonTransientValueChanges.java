package gov.va.med.imaging.configuration;

public interface DetectConfigNonTransientValueChanges {

    /*
        Determine if the Java representation of a config has values different from what is persisted that should
        be persisted
     */
    boolean hasValueChangesToPersist(boolean autoStoreChanges);
}
