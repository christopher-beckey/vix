package gov.va.med.imaging.facade.configuration;

import gov.va.med.imaging.configuration.DetectConfigNonTransientValueChanges;
import gov.va.med.imaging.configuration.RefreshableConfig;
import gov.va.med.imaging.configuration.VixConfiguration;
import gov.va.med.logging.Logger;

import java.util.ArrayList;
import java.util.List;

public class FilterConfiguration extends AbstractBaseFacadeConfiguration
        implements DetectConfigNonTransientValueChanges, RefreshableConfig {
    private boolean isRewriteT = true;
    private List<EncryptedConfigurationPropertyString> toReplace = new ArrayList<>();
    private EncryptedConfigurationPropertyString replacement = new EncryptedConfigurationPropertyString("VISTA IMAGING VIX");
    private static FilterConfiguration filterConfiguration = null;

    public static FilterConfiguration getConfiguration() {
        if (filterConfiguration == null) {
            filterConfiguration = new FilterConfiguration();
            filterConfiguration = (FilterConfiguration) filterConfiguration.loadConfiguration();
        }
        return filterConfiguration;
    }

    @Override
    public boolean hasValueChangesToPersist(boolean autoStoreChanges) {
        boolean retVal = false;
        if(replacement != null) retVal = replacement.isUnencryptedAtRest();
        for(EncryptedConfigurationPropertyString r : toReplace){
            retVal = retVal || r.isUnencryptedAtRest();
        }
        if(autoStoreChanges && retVal) {
            this.storeConfiguration();
        }
        return retVal;
    }

    @Override
    public VixConfiguration refreshFromFile() {
        try {
            return (FilterConfiguration) loadConfiguration();
        } catch (Exception clcX) {
            Logger.getLogger(FilterConfiguration.class).error("FilterConfiguration.refreshFromFile() --> Unable to load FilterConfiguration from file: {}", clcX.getMessage());
            return null;
        }
    }

    @Override
    public AbstractBaseFacadeConfiguration loadDefaultConfiguration() {
        this.isRewriteT = false;
        return this;
    }

    public boolean isRewriteT() {
        return isRewriteT;
    }

    public void setRewriteT(boolean rt) {
        isRewriteT = rt;
    }

    public List<EncryptedConfigurationPropertyString> getToReplace() {
        return toReplace;
    }

    public void setToReplace(List<EncryptedConfigurationPropertyString> toReplace) {
        this.toReplace = toReplace;
    }

    public EncryptedConfigurationPropertyString getReplacement() {
        return replacement;
    }

    public void setReplacement(EncryptedConfigurationPropertyString replacement) {
        this.replacement = replacement;
    }

    public static void main(String[] args){
        FilterConfiguration filterConfiguration = parseArgs(args);
        filterConfiguration.storeConfiguration();
    }

    private static FilterConfiguration parseArgs(String[] args){
        FilterConfiguration filterConfiguration = new FilterConfiguration();
        filterConfiguration.setRewriteT(true);
        if(args.length == 0){
            filterConfiguration.setRewriteT(false);
        }
        for(String arg : args){
            if(arg.toLowerCase().contains("toreplace")){
                String val = arg.substring(arg.lastIndexOf("=")+1);
                filterConfiguration.getToReplace().add(new EncryptedConfigurationPropertyString(val));
            }else if(arg.toLowerCase().contains("replacement")){
                String val = arg.substring(arg.lastIndexOf("=")+1);
                filterConfiguration.setReplacement(new EncryptedConfigurationPropertyString(val));
            }
        }
        return filterConfiguration;
    }
}
