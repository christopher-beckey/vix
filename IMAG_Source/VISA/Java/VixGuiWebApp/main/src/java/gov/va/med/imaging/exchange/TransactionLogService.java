package gov.va.med.imaging.exchange;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.access.TransactionLogEntry;
import gov.va.med.imaging.access.TransactionLogWriter;
import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.transactions.TransactionLogQuery;
import gov.va.med.logging.Logger;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("txdb")
public class TransactionLogService {
    private static final Logger LOGGER = Logger.getLogger(TransactionLogService.class);

    @POST
    @Path("/query")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response queryTransactionLogDatabase(TransactionLogQuery transactionLogQuery) {
        if (transactionLogQuery == null) {
            return Response.status(500).entity("Query expected").build();
        }

        // Generic try / catch to handle anything that goes awry
        try {
            // Get router
            VixGuiWebAppRouter router = FacadeRouterUtility.getFacadeRouter(VixGuiWebAppRouter.class);
            if (router == null) {
                return Response.status(500).entity("Internal error; could not obtain router").build();
            }

            // Serialize results to a writer
            JsonTransactionLogWriter writer = new JsonTransactionLogWriter();
            router.getTransactionLogEntries(writer, transactionLogQuery);

            // Get the string out and send that as the response
            return Response.status(200).entity(writer.getContents()).build();
        } catch (MethodException e) {
            LOGGER.error("Error querying transaction log database", e);
            return Response.status(500).entity(StringUtil.cleanString(e.getMessage())).build();
        } catch (Exception e) {
            LOGGER.error("Error querying transaction log database", e);
            return Response.status(500).entity("Error querying transaction log database; please see system logs for details").build();
        }
    }

    // TODO: Switch to more efficient streaming
    private class JsonTransactionLogWriter implements TransactionLogWriter {
        private StringBuilder stringBuilder;
        private int entryIndex;

        public JsonTransactionLogWriter() {
            stringBuilder = new StringBuilder();
            entryIndex = 0;

            stringBuilder.append("{ \"entries\" : [");
        }

        public String getContents() {
            stringBuilder.append("] }");
            return stringBuilder.toString();
        }

        @Override
        public void writeTransactionLogEntry(TransactionLogEntry entry) throws MethodException {
            if (entryIndex > 0) {
                stringBuilder.append(", ");
            }

            stringBuilder.append("{ \"Index\" : \"");
            stringBuilder.append(entryIndex);
            stringBuilder.append("\", \"StartTime\" : \"");
            stringBuilder.append(entry.getStartTime());
            stringBuilder.append("\", \"ElapsedTime\" : \"");
            stringBuilder.append(entry.getElapsedTime());
            stringBuilder.append("\", \"PatientIcn\" : \"");
            stringBuilder.append(escapeJson(entry.getPatientIcn()));
            stringBuilder.append("\", \"QueryType\" : \"");
            stringBuilder.append(escapeJson(entry.getQueryType()));
            stringBuilder.append("\", \"QueryFilter\" : \"");
            stringBuilder.append(escapeJson(entry.getQueryFilter()));
            stringBuilder.append("\", \"CommandClassName\" : \"");
            stringBuilder.append(escapeJson(entry.getCommandClassName()));
            stringBuilder.append("\", \"ItemCount\" : \"");
            stringBuilder.append(entry.getItemCount());
            stringBuilder.append("\", \"FacadeBytesSent\" : \"");
            stringBuilder.append(entry.getFacadeBytesSent());
            stringBuilder.append("\", \"FacadeBytesReceived\" : \"");
            stringBuilder.append(entry.getFacadeBytesReceived());
            stringBuilder.append("\", \"DataSourceBytesSent\" : \"");
            stringBuilder.append(entry.getDataSourceBytesSent());
            stringBuilder.append("\", \"DataSourceBytesReceived\" : \"");
            stringBuilder.append(entry.getDataSourceBytesReceived());
            stringBuilder.append("\", \"Quality\" : \"");
            stringBuilder.append(escapeJson(entry.getQuality()));
            stringBuilder.append("\", \"MachineName\" : \"");
            stringBuilder.append(escapeJson(entry.getMachineName()));
            stringBuilder.append("\", \"RequestingSite\" : \"");
            stringBuilder.append(escapeJson(entry.getRequestingSite()));
            stringBuilder.append("\", \"OriginatingHost\" : \"");
            stringBuilder.append(escapeJson(entry.getOriginatingHost()));
            stringBuilder.append("\", \"User\" : \"");
            stringBuilder.append(escapeJson(entry.getUser()));
            stringBuilder.append("\", \"TransactionId\" : \"");
            stringBuilder.append(escapeJson(entry.getTransactionId()));
            stringBuilder.append("\", \"Urn\" : \"");
            stringBuilder.append(escapeJson(entry.getUrn()));
            stringBuilder.append("\", \"ErrorMessage\" : \"");
            stringBuilder.append(escapeJson(entry.getErrorMessage()));
            stringBuilder.append("\", \"Modality\" : \"");
            stringBuilder.append(escapeJson(entry.getModality()));
            stringBuilder.append("\", \"PurposeOfUse\" : \"");
            stringBuilder.append(escapeJson(entry.getPurposeOfUse()));
            stringBuilder.append("\", \"DatasourceProtocol\" : \"");
            stringBuilder.append(escapeJson(entry.getDatasourceProtocol()));
            stringBuilder.append("\", \"CacheHit\" : \"");
            stringBuilder.append(entry.isCacheHit());
            stringBuilder.append("\", \"ResponseCode\" : \"");
            stringBuilder.append(escapeJson(entry.getResponseCode()));
            stringBuilder.append("\", \"ExceptionClassName\" : \"");
            stringBuilder.append(escapeJson(entry.getExceptionClassName()));
            stringBuilder.append("\", \"RealmSiteNumber\" : \"");
            stringBuilder.append(escapeJson(entry.getRealmSiteNumber()));
            stringBuilder.append("\", \"TimeToFirstByte\" : \"");
            stringBuilder.append(entry.getTimeToFirstByte());
            stringBuilder.append("\", \"VixSoftwareVersion\" : \"");
            stringBuilder.append(escapeJson(entry.getVixSoftwareVersion()));
            stringBuilder.append("\", \"RespondingSite\" : \"");
            stringBuilder.append(escapeJson(entry.getRespondingSite()));
            stringBuilder.append("\", \"DataSourceItemsReceived\" : \"");
            stringBuilder.append(entry.getDataSourceItemsReceived());
            stringBuilder.append("\", \"AsynchronousCommand\" : \"");
            stringBuilder.append(entry.isAsynchronousCommand());
            stringBuilder.append("\", \"CommandId\" : \"");
            stringBuilder.append(escapeJson(entry.getCommandId()));
            stringBuilder.append("\", \"ParentCommandId\" : \"");
            stringBuilder.append(escapeJson(entry.getParentCommandId()));
            stringBuilder.append("\", \"RemoteLoginMethod\" : \"");
            stringBuilder.append(escapeJson(entry.getRemoteLoginMethod()));
            stringBuilder.append("\", \"FacadeImageFormatSent\" : \"");
            stringBuilder.append(escapeJson(entry.getFacadeImageFormatSent()));
            stringBuilder.append("\", \"FacadeImageQualitySent\" : \"");
            stringBuilder.append(escapeJson(entry.getFacadeImageQualitySent()));
            stringBuilder.append("\", \"DataSourceImageFormatReceived\" : \"");
            stringBuilder.append(escapeJson(entry.getDataSourceImageFormatReceived()));
            stringBuilder.append("\", \"DataSourceImageQualityReceived\" : \"");
            stringBuilder.append(escapeJson(entry.getDataSourceImageQualityReceived()));
            stringBuilder.append("\", \"ClientVersion\" : \"");
            stringBuilder.append(escapeJson(entry.getClientVersion()));
            stringBuilder.append("\", \"DataSourceMethod\" : \"");
            stringBuilder.append(escapeJson(entry.getDataSourceMethod()));
            stringBuilder.append("\", \"DataSourceVersion\" : \"");
            stringBuilder.append(escapeJson(entry.getDataSourceVersion()));
            stringBuilder.append("\", \"DebugInformation\" : \"");
            stringBuilder.append(escapeJson(entry.getDebugInformation()));
            stringBuilder.append("\", \"DataSourceResponseServer\" : \"");
            stringBuilder.append(escapeJson(entry.getDataSourceResponseServer()));
            stringBuilder.append("\", \"ThreadId\" : \"");
            stringBuilder.append(escapeJson(entry.getThreadId()));
            stringBuilder.append("\", \"VixSiteNumber\" : \"");
            stringBuilder.append(escapeJson(entry.getVixSiteNumber()));
            stringBuilder.append("\", \"RequestingVixSiteNumber\" : \"");
            stringBuilder.append(escapeJson(entry.getRequestingVixSiteNumber()));
            stringBuilder.append("\", \"SecurityTokenApplicationName\" : \"");
            stringBuilder.append(escapeJson(entry.getSecurityTokenApplicationName()));
            stringBuilder.append("\"}");

            ++entryIndex;
        }

        private String escapeJson(String value) {
            if (value == null) {
                return "null";
            }

            StringBuilder stringBuilder = new StringBuilder(value.length());
            for (int i = 0; i < value.length(); ++i) {
                if (value.charAt(i) == '"') {
                    stringBuilder.append("\\");
                } else if (value.charAt(i) == '\\') {
                    stringBuilder.append("\\\\");
                } else if (value.charAt(i) == '/') {
                    stringBuilder.append("\\/");
                } else if (value.charAt(i) == '\b') {
                    stringBuilder.append("\\b");
                } else if (value.charAt(i) == '\f') {
                    stringBuilder.append("\\f");
                } else if (value.charAt(i) == '\n') {
                    stringBuilder.append("\\n");
                } else if (value.charAt(i) == '\r') {
                    stringBuilder.append("\\r");
                } else if (value.charAt(i) == '\t') {
                    stringBuilder.append("\\t");
                } else if ((value.charAt(i) < 32) || (value.charAt(i) > 126)) {
                    stringBuilder.append("?");
                } else {
                    stringBuilder.append(value.charAt(i));
                }
            }

            return stringBuilder.toString();
        }
    }
}
