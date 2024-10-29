package gov.va.med.imaging.study.dicom;

import gov.va.med.imaging.exchange.business.Region;

public class SiteInfo {
    private String siteAbb;
    private String siteName;
    private String vistaHostName;
    private int vistaPort;
    private String siteNumber;
    private String serviceAccountName;
    private String serviceAccountDuz ;
    private String serviceAccountSsn = "000000001";
    private String localSiteType = "VIX";
    private String versionNumber;
    private Region region;
    private String bseRealm = ""; //used to indicate vista service account data has not been fetched

    public String getSiteAbb() {
        return siteAbb;
    }

    protected void setSiteAbb(String siteAbb) {
        this.siteAbb = siteAbb;
    }

    public String getSiteName() {
        return siteName;
    }

    protected void setSiteName(String siteName) {
        this.siteName = siteName;
    }

    public String getVistaHostName() {
        return vistaHostName;
    }

    protected void setVistaHostName(String vistaHostName) {
        this.vistaHostName = vistaHostName;
    }

    public int getVistaPort() {
        return vistaPort;
    }

    protected void setVistaPort(int vistaPort) {
        this.vistaPort = vistaPort;
    }

    public String getSiteCode() {
        return siteNumber;
    }

    protected void setSiteCode(String siteNumber) {
        this.siteNumber = siteNumber;
    }

    public String getServiceAccountName() {
        return serviceAccountName;
    }

    public void setServiceAccountName(String serviceAccountName) {
        this.serviceAccountName = serviceAccountName;
    }

    public String getServiceAccountDuz() {
        return serviceAccountDuz;
    }

    public void setServiceAccountDuz(String serviceAccountDuz) {
        this.serviceAccountDuz = serviceAccountDuz;
    }

    public String getServiceAccountSsn() {
        return serviceAccountSsn;
    }

    public void setServiceAccountSsn(String serviceAccountSsn) {
        this.serviceAccountSsn = serviceAccountSsn;
    }

    public String getLocalSiteType() {
        return localSiteType;
    }

    protected void setLocalSiteType(String localSiteType) {
        this.localSiteType = localSiteType;
    }

    protected String getVersionNumber() {
        return versionNumber;
    }

    protected void setVersionNumber(String versionNumber) {
        this.versionNumber = versionNumber;
    }

    public String getBseRealm() {
        return bseRealm;
    }

    public void setBseRealm(String bseRealm) {
        this.bseRealm = bseRealm;
    }

    public Region getRegion() {
        return region;
    }

    public void setRegion(Region region) {
        this.region = region;
    }

    @Override
    public String toString() {
        return "SiteInfo{" +
                "siteAbb='" + siteAbb + '\'' +
                ", siteName='" + siteName + '\'' +
                ", vistaHostName='" + vistaHostName + '\'' +
                ", vistaPort=" + vistaPort +
                ", siteNumber='" + siteNumber + '\'' +
                ", serviceAccountName='" + serviceAccountName + '\'' +
                ", serviceAccountDuz='" + serviceAccountDuz + '\'' +
                ", serviceAccountSsn='" + serviceAccountSsn + '\'' +
                ", localSiteType='" + localSiteType + '\'' +
                ", versionNumber='" + versionNumber + '\'' +
                ", region=" + region +
                ", bseRealm='" + bseRealm + '\'' +
                '}';
    }
}
