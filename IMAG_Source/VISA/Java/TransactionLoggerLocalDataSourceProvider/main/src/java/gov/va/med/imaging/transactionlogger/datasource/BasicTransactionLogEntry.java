package gov.va.med.imaging.transactionlogger.datasource;

import gov.va.med.imaging.access.TransactionLogEntry;

public class BasicTransactionLogEntry implements TransactionLogEntry {
    private Long startTime;
    private Long elapsedTime;
    private String patientIcn;
    private String queryType;
    private String queryFilter;
    private String commandClassName;
    private Integer itemCount;
    private Long facadeBytesSent;
    private Long facadeBytesReceived;
    private Long dataSourceBytesSent;
    private Long dataSourceBytesReceived;
    private String quality;
    private String machineName;
    private String requestingSite;
    private String originatingHost;
    private String user;
    private String transactionId;
    private String urn;
    private String errorMessage;
    private String modality;
    private String purposeOfUse;
    private String datasourceProtocol;
    private Boolean cacheHit;
    private String responseCode;
    private String exceptionClassName;
    private String realmSiteNumber;
    private Long timeToFirstByte;
    private String vixSoftwareVersion;
    private String respondingSite;
    private Integer dataSourceItemsReceived;
    private Boolean asynchronousCommand;
    private String commandId;
    private String parentCommandId;
    private String remoteLoginMethod;
    private String facadeImageFormatSent;
    private String facadeImageQualitySent;
    private String dataSourceImageFormatReceived;
    private String dataSourceImageQualityReceived;
    private String clientVersion;
    private String dataSourceMethod;
    private String dataSourceVersion;
    private String debugInformation;
    private String dataSourceResponseServer;
    private String threadId;
    private String vixSiteNumber;
    private String requestingVixSiteNumber;
    private String securityTokenApplicationName;

    public BasicTransactionLogEntry() {
    }

    public BasicTransactionLogEntry(Long startTime, Long elapsedTime, String patientIcn, String queryType, String queryFilter, String commandClassName, Integer itemCount, Long facadeBytesSent, Long facadeBytesReceived, Long dataSourceBytesSent, Long dataSourceBytesReceived, String quality, String machineName, String requestingSite, String originatingHost, String user, String transactionId, String urn, String errorMessage, String modality, String purposeOfUse, String datasourceProtocol, Boolean cacheHit, String responseCode, String exceptionClassName, String realmSiteNumber, Long timeToFirstByte, String vixSoftwareVersion, String respondingSite, Integer dataSourceItemsReceived, Boolean asynchronousCommand, String commandId, String parentCommandId, String remoteLoginMethod, String facadeImageFormatSent, String facadeImageQualitySent, String dataSourceImageFormatReceived, String dataSourceImageQualityReceived, String clientVersion, String dataSourceMethod, String dataSourceVersion, String debugInformation, String dataSourceResponseServer, String threadId, String vixSiteNumber, String requestingVixSiteNumber, String securityTokenApplicationName) {
        this.startTime = startTime;
        this.elapsedTime = elapsedTime;
        this.patientIcn = patientIcn;
        this.queryType = queryType;
        this.queryFilter = queryFilter;
        this.commandClassName = commandClassName;
        this.itemCount = itemCount;
        this.facadeBytesSent = facadeBytesSent;
        this.facadeBytesReceived = facadeBytesReceived;
        this.dataSourceBytesSent = dataSourceBytesSent;
        this.dataSourceBytesReceived = dataSourceBytesReceived;
        this.quality = quality;
        this.machineName = machineName;
        this.requestingSite = requestingSite;
        this.originatingHost = originatingHost;
        this.user = user;
        this.transactionId = transactionId;
        this.urn = urn;
        this.errorMessage = errorMessage;
        this.modality = modality;
        this.purposeOfUse = purposeOfUse;
        this.datasourceProtocol = datasourceProtocol;
        this.cacheHit = cacheHit;
        this.responseCode = responseCode;
        this.exceptionClassName = exceptionClassName;
        this.realmSiteNumber = realmSiteNumber;
        this.timeToFirstByte = timeToFirstByte;
        this.vixSoftwareVersion = vixSoftwareVersion;
        this.respondingSite = respondingSite;
        this.dataSourceItemsReceived = dataSourceItemsReceived;
        this.asynchronousCommand = asynchronousCommand;
        this.commandId = commandId;
        this.parentCommandId = parentCommandId;
        this.remoteLoginMethod = remoteLoginMethod;
        this.facadeImageFormatSent = facadeImageFormatSent;
        this.facadeImageQualitySent = facadeImageQualitySent;
        this.dataSourceImageFormatReceived = dataSourceImageFormatReceived;
        this.dataSourceImageQualityReceived = dataSourceImageQualityReceived;
        this.clientVersion = clientVersion;
        this.dataSourceMethod = dataSourceMethod;
        this.dataSourceVersion = dataSourceVersion;
        this.debugInformation = debugInformation;
        this.dataSourceResponseServer = dataSourceResponseServer;
        this.threadId = threadId;
        this.vixSiteNumber = vixSiteNumber;
        this.requestingVixSiteNumber = requestingVixSiteNumber;
        this.securityTokenApplicationName = securityTokenApplicationName;
    }

    @Override
    public Long getStartTime() {
        return startTime;
    }

    public void setStartTime(Long startTime) {
        this.startTime = startTime;
    }

    @Override
    public Long getElapsedTime() {
        return elapsedTime;
    }

    public void setElapsedTime(Long elapsedTime) {
        this.elapsedTime = elapsedTime;
    }

    @Override
    public String getPatientIcn() {
        return patientIcn;
    }

    public void setPatientIcn(String patientIcn) {
        this.patientIcn = patientIcn;
    }

    @Override
    public String getQueryType() {
        return queryType;
    }

    public void setQueryType(String queryType) {
        this.queryType = queryType;
    }

    @Override
    public String getQueryFilter() {
        return queryFilter;
    }

    public void setQueryFilter(String queryFilter) {
        this.queryFilter = queryFilter;
    }

    @Override
    public String getCommandClassName() {
        return commandClassName;
    }

    public void setCommandClassName(String commandClassName) {
        this.commandClassName = commandClassName;
    }

    @Override
    public Integer getItemCount() {
        return itemCount;
    }

    public void setItemCount(Integer itemCount) {
        this.itemCount = itemCount;
    }

    @Override
    public Long getFacadeBytesSent() {
        return facadeBytesSent;
    }

    public void setFacadeBytesSent(Long facadeBytesSent) {
        this.facadeBytesSent = facadeBytesSent;
    }

    @Override
    public Long getFacadeBytesReceived() {
        return facadeBytesReceived;
    }

    public void setFacadeBytesReceived(Long facadeBytesReceived) {
        this.facadeBytesReceived = facadeBytesReceived;
    }

    @Override
    public Long getDataSourceBytesSent() {
        return dataSourceBytesSent;
    }

    public void setDataSourceBytesSent(Long dataSourceBytesSent) {
        this.dataSourceBytesSent = dataSourceBytesSent;
    }

    @Override
    public Long getDataSourceBytesReceived() {
        return dataSourceBytesReceived;
    }

    public void setDataSourceBytesReceived(Long dataSourceBytesReceived) {
        this.dataSourceBytesReceived = dataSourceBytesReceived;
    }

    @Override
    public String getQuality() {
        return quality;
    }

    public void setQuality(String quality) {
        this.quality = quality;
    }

    @Override
    public String getMachineName() {
        return machineName;
    }

    public void setMachineName(String machineName) {
        this.machineName = machineName;
    }

    @Override
    public String getRequestingSite() {
        return requestingSite;
    }

    public void setRequestingSite(String requestingSite) {
        this.requestingSite = requestingSite;
    }

    @Override
    public String getOriginatingHost() {
        return originatingHost;
    }

    public void setOriginatingHost(String originatingHost) {
        this.originatingHost = originatingHost;
    }

    @Override
    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    @Override
    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    @Override
    public String getUrn() {
        return urn;
    }

    public void setUrn(String urn) {
        this.urn = urn;
    }

    @Override
    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    @Override
    public String getModality() {
        return modality;
    }

    public void setModality(String modality) {
        this.modality = modality;
    }

    @Override
    public String getPurposeOfUse() {
        return purposeOfUse;
    }

    public void setPurposeOfUse(String purposeOfUse) {
        this.purposeOfUse = purposeOfUse;
    }

    @Override
    public String getDatasourceProtocol() {
        return datasourceProtocol;
    }

    public void setDatasourceProtocol(String datasourceProtocol) {
        this.datasourceProtocol = datasourceProtocol;
    }

    public Boolean isCacheHit() {
        return cacheHit;
    }

    public void setCacheHit(Boolean cacheHit) {
        this.cacheHit = cacheHit;
    }

    @Override
    public String getResponseCode() {
        return responseCode;
    }

    public void setResponseCode(String responseCode) {
        this.responseCode = responseCode;
    }

    @Override
    public String getExceptionClassName() {
        return exceptionClassName;
    }

    public void setExceptionClassName(String exceptionClassName) {
        this.exceptionClassName = exceptionClassName;
    }

    @Override
    public String getRealmSiteNumber() {
        return realmSiteNumber;
    }

    public void setRealmSiteNumber(String realmSiteNumber) {
        this.realmSiteNumber = realmSiteNumber;
    }

    @Override
    public Long getTimeToFirstByte() {
        return timeToFirstByte;
    }

    public void setTimeToFirstByte(Long timeToFirstByte) {
        this.timeToFirstByte = timeToFirstByte;
    }

    @Override
    public String getVixSoftwareVersion() {
        return vixSoftwareVersion;
    }

    public void setVixSoftwareVersion(String vixSoftwareVersion) {
        this.vixSoftwareVersion = vixSoftwareVersion;
    }

    @Override
    public String getRespondingSite() {
        return respondingSite;
    }

    public void setRespondingSite(String respondingSite) {
        this.respondingSite = respondingSite;
    }

    @Override
    public Integer getDataSourceItemsReceived() {
        return dataSourceItemsReceived;
    }

    public void setDataSourceItemsReceived(Integer dataSourceItemsReceived) {
        this.dataSourceItemsReceived = dataSourceItemsReceived;
    }

    public Boolean isAsynchronousCommand() {
        return asynchronousCommand;
    }

    public void setAsynchronousCommand(Boolean asynchronousCommand) {
        this.asynchronousCommand = asynchronousCommand;
    }

    @Override
    public String getCommandId() {
        return commandId;
    }

    public void setCommandId(String commandId) {
        this.commandId = commandId;
    }

    @Override
    public String getParentCommandId() {
        return parentCommandId;
    }

    public void setParentCommandId(String parentCommandId) {
        this.parentCommandId = parentCommandId;
    }

    @Override
    public String getRemoteLoginMethod() {
        return remoteLoginMethod;
    }

    public void setRemoteLoginMethod(String remoteLoginMethod) {
        this.remoteLoginMethod = remoteLoginMethod;
    }

    @Override
    public String getFacadeImageFormatSent() {
        return facadeImageFormatSent;
    }

    public void setFacadeImageFormatSent(String facadeImageFormatSent) {
        this.facadeImageFormatSent = facadeImageFormatSent;
    }

    @Override
    public String getFacadeImageQualitySent() {
        return facadeImageQualitySent;
    }

    public void setFacadeImageQualitySent(String facadeImageQualitySent) {
        this.facadeImageQualitySent = facadeImageQualitySent;
    }

    @Override
    public String getDataSourceImageFormatReceived() {
        return dataSourceImageFormatReceived;
    }

    public void setDataSourceImageFormatReceived(String dataSourceImageFormatReceived) {
        this.dataSourceImageFormatReceived = dataSourceImageFormatReceived;
    }

    @Override
    public String getDataSourceImageQualityReceived() {
        return dataSourceImageQualityReceived;
    }

    public void setDataSourceImageQualityReceived(String dataSourceImageQualityReceived) {
        this.dataSourceImageQualityReceived = dataSourceImageQualityReceived;
    }

    @Override
    public String getClientVersion() {
        return clientVersion;
    }

    public void setClientVersion(String clientVersion) {
        this.clientVersion = clientVersion;
    }

    @Override
    public String getDataSourceMethod() {
        return dataSourceMethod;
    }

    public void setDataSourceMethod(String dataSourceMethod) {
        this.dataSourceMethod = dataSourceMethod;
    }

    @Override
    public String getDataSourceVersion() {
        return dataSourceVersion;
    }

    public void setDataSourceVersion(String dataSourceVersion) {
        this.dataSourceVersion = dataSourceVersion;
    }

    @Override
    public String getDebugInformation() {
        return debugInformation;
    }

    public void setDebugInformation(String debugInformation) {
        this.debugInformation = debugInformation;
    }

    @Override
    public String getDataSourceResponseServer() {
        return dataSourceResponseServer;
    }

    public void setDataSourceResponseServer(String dataSourceResponseServer) {
        this.dataSourceResponseServer = dataSourceResponseServer;
    }

    @Override
    public String getThreadId() {
        return threadId;
    }

    public void setThreadId(String threadId) {
        this.threadId = threadId;
    }

    @Override
    public String getVixSiteNumber() {
        return vixSiteNumber;
    }

    public void setVixSiteNumber(String vixSiteNumber) {
        this.vixSiteNumber = vixSiteNumber;
    }

    @Override
    public String getRequestingVixSiteNumber() {
        return requestingVixSiteNumber;
    }

    public void setRequestingVixSiteNumber(String requestingVixSiteNumber) {
        this.requestingVixSiteNumber = requestingVixSiteNumber;
    }

    @Override
    public String getSecurityTokenApplicationName() {
        return securityTokenApplicationName;
    }

    public void setSecurityTokenApplicationName(String securityTokenApplicationName) {
        this.securityTokenApplicationName = securityTokenApplicationName;
    }
}
