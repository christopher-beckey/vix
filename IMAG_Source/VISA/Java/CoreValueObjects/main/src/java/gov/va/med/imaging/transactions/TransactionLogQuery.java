package gov.va.med.imaging.transactions;

import javax.xml.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;

@XmlRootElement(name = "query")
@XmlAccessorType(XmlAccessType.FIELD)
public class TransactionLogQuery {
    public static final String[] ALLOWED_FIELDS = {"StartTime", "ElapsedTime", "PatientIcn", "QueryType", "QueryFilter", "CommandClassName", "ItemCount", "FacadeBytesSent", "FacadeBytesReceived", "DataSourceBytesSent", "DataSourceBytesReceived", "Quality", "MachineName", "RequestingSite", "OriginatingHost", "User", "TransactionId", "Urn", "ErrorMessage", "Modality", "PurposeOfUse", "DatasourceProtocol", "public abstract Boolean isCacheHit();", "ResponseCode", "ExceptionClassName", "RealmSiteNumber", "TimeToFirstByte", "VixSoftwareVersion", "RespondingSite", "DataSourceItemsReceived", "public abstract Boolean isAsynchronousCommand();", "CommandId", "ParentCommandId", "RemoteLoginMethod", "FacadeImageFormatSent", "FacadeImageQualitySent", "DataSourceImageFormatReceived", "DataSourceImageQualityReceived", "ClientVersion", "DataSourceMethod", "DataSourceVersion", "DebugInformation", "DataSourceResponseServer", "ThreadId", "VixSiteNumber", "RequestingVixSiteNumber", "SecurityTokenApplicationName"};

    @XmlElement(name = "rowLimit")
    private Long rowLimit = 100L;

    @XmlElement(name = "parameters")
    private List<TransactionLogQueryParameter> queryParameters = new ArrayList<>();

    @XmlElement(name = "orderParameters")
    private List<TransactionLogQueryOrder> orderParameters = new ArrayList<>();

    public TransactionLogQuery() {
    }

    public List<TransactionLogQueryParameter> getQueryParameters() {
        return queryParameters;
    }

    public void setQueryParameters(List<TransactionLogQueryParameter> queryParameters) {
        this.queryParameters = queryParameters;
    }

    public List<TransactionLogQueryOrder> getOrderParameters() {
        return orderParameters;
    }

    public void setOrderParameters(List<TransactionLogQueryOrder> orderParameters) {
        this.orderParameters = orderParameters;
    }

    public Long getRowLimit() {
        return rowLimit;
    }

    public void setRowLimit(Long rowLimit) {
        this.rowLimit = rowLimit;
    }
}
