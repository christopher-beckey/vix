package gov.va.med.imaging.transactionlogger.datasource;

import gov.va.med.imaging.ImagingMBean;
import gov.va.med.imaging.access.TransactionLogEntry;
import gov.va.med.imaging.access.TransactionLogWriter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.AbstractLocalDataSource;
import gov.va.med.imaging.datasource.TransactionLoggerDataSourceSpi;
import gov.va.med.imaging.exchange.enums.DatasourceProtocol;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.transactionlogger.configuration.TransactionLoggerJdbcSourceProviderConfiguration;
import gov.va.med.imaging.transactions.TransactionLogQuery;
import gov.va.med.imaging.transactions.TransactionLogQueryOrder;
import gov.va.med.imaging.transactions.TransactionLogQueryParameter;
import gov.va.med.imaging.transactions.TransactionLogQueryParameterType;
import gov.va.med.logging.Logger;
import org.sqlite.SQLiteConfig;

import javax.management.MBeanServer;
import javax.management.ObjectName;
import java.lang.management.ManagementFactory;
import java.sql.*;
import java.util.*;
import java.util.Date;

public class TransactionLoggerJdbcSourceService extends AbstractLocalDataSource implements TransactionLoggerDataSourceSpi {
    private static final String CHECK_TABLE_STATEMENT = "SELECT NAME FROM SQLITE_SCHEMA WHERE NAME = 'TRANSACTION_LOG_ENTRIES'";
    private static final String CREATE_TABLE_STATEMENT = "CREATE TABLE TRANSACTION_LOG_ENTRIES (Identifier INTEGER PRIMARY KEY, StartTime INTEGER, ElapsedTime INTEGER, PatientIcn TEXT, QueryType TEXT, QueryFilter TEXT, CommandClassName TEXT, ItemCount INTEGER, FacadeBytesSent INTEGER, FacadeBytesReceived INTEGER, DataSourceBytesSent INTEGER, DataSourceBytesReceived INTEGER, Quality TEXT, MachineName TEXT, RequestingSite TEXT, OriginatingHost TEXT, User TEXT, TransactionId TEXT, Urn TEXT, ErrorMessage TEXT, Modality TEXT, PurposeOfUse TEXT, DatasourceProtocol TEXT, CacheHit INTEGER, ResponseCode TEXT, ExceptionClassName TEXT, RealmSiteNumber TEXT, TimeToFirstByte INTEGER, VixSoftwareVersion TEXT, RespondingSite TEXT, DataSourceItemsReceived INTEGER, AsynchronousCommand INTEGER, CommandId TEXT, ParentCommandId TEXT, RemoteLoginMethod TEXT, FacadeImageFormatSent TEXT, FacadeImageQualitySent TEXT, DataSourceImageFormatReceived TEXT, DataSourceImageQualityReceived TEXT, ClientVersion TEXT, DataSourceMethod TEXT, DataSourceVersion TEXT, DebugInformation TEXT, DataSourceResponseServer TEXT, ThreadId TEXT, VixSiteNumber TEXT, RequestingVixSiteNumber TEXT, SecurityTokenApplicationName TEXT)";
    private static final String INSERT_ENTRY_STATEMENT = "INSERT INTO TRANSACTION_LOG_ENTRIES (StartTime, ElapsedTime, PatientIcn, QueryType, QueryFilter, CommandClassName, ItemCount, FacadeBytesSent, FacadeBytesReceived, DataSourceBytesSent, DataSourceBytesReceived, Quality, MachineName, RequestingSite, OriginatingHost, User, TransactionId, Urn, ErrorMessage, Modality, PurposeOfUse, DatasourceProtocol, CacheHit, ResponseCode, ExceptionClassName, RealmSiteNumber, TimeToFirstByte, VixSoftwareVersion, RespondingSite, DataSourceItemsReceived, AsynchronousCommand, CommandId, ParentCommandId, RemoteLoginMethod, FacadeImageFormatSent, FacadeImageQualitySent, DataSourceImageFormatReceived, DataSourceImageQualityReceived, ClientVersion, DataSourceMethod, DataSourceVersion, DebugInformation, DataSourceResponseServer, ThreadId, VixSiteNumber, RequestingVixSiteNumber, SecurityTokenApplicationName) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_ALL_STATEMENT = "SELECT Identifier, StartTime, ElapsedTime, PatientIcn, QueryType, QueryFilter, CommandClassName, ItemCount, FacadeBytesSent, FacadeBytesReceived, DataSourceBytesSent, DataSourceBytesReceived, Quality, MachineName, RequestingSite, OriginatingHost, User, TransactionId, Urn, ErrorMessage, Modality, PurposeOfUse, DatasourceProtocol, CacheHit, ResponseCode, ExceptionClassName, RealmSiteNumber, TimeToFirstByte, VixSoftwareVersion, RespondingSite, DataSourceItemsReceived, AsynchronousCommand, CommandId, ParentCommandId, RemoteLoginMethod, FacadeImageFormatSent, FacadeImageQualitySent, DataSourceImageFormatReceived, DataSourceImageQualityReceived, ClientVersion, DataSourceMethod, DataSourceVersion, DebugInformation, DataSourceResponseServer, ThreadId, VixSiteNumber, RequestingVixSiteNumber, SecurityTokenApplicationName FROM TRANSACTION_LOG_ENTRIES";
    private static final String SELECT_COUNT_STATEMENT = "SELECT COUNT(*) FROM TRANSACTION_LOG_ENTRIES WHERE StartTime >= ? AND StartTime <= ?";
    private static final String DELETE_STATEMENT = "DELETE FROM TRANSACTION_LOG_ENTRIES WHERE StartTime <= ?";
    private static final String VACUUM_STATEMENT = "VACUUM";
    private static final String[] BOOLEAN_FIELDS = {"AsynchronousCommand", "CacheHit"};
    private static final String[] INT_FIELDS = {"DataSourceItemsReceived", "ItemCount"};
    private static final String[] LONG_FIELDS = {"DataSourceBytesReceived", "DataSourceBytesSent", "ElapsedTime", "FacadeBytesReceived", "FacadeBytesSent", "StartTime", "TimeToFirstByte"};

    private static final Logger LOGGER = Logger.getLogger(TransactionLoggerJdbcSourceService.class);
    private static final Object SYNC_OBJECT = new Object();
    private static TransactionLoggerStatistics transactionLoggerStatistics = null;

    private boolean checkedTables = false;
    private String jdbcUrl;

    public TransactionLoggerJdbcSourceService() {
        // Initialize by running purge
        try {
            purgeLogEntries(getConfiguration().getRetentionPeriodDays());
        } catch (Exception e) {
            LOGGER.error("Error purging transaction logs on startup", e);
        }
    }

    private void checkTables() throws ConnectionException {
        synchronized (SYNC_OBJECT) {
            if (checkedTables) {
                return;
            }

            // Check transaction statistics
            if (transactionLoggerStatistics == null) {
                // Create new statistics object
                transactionLoggerStatistics = new TransactionLoggerStatistics();

                // Register MBean
                try {
                    MBeanServer mBeanServer = ManagementFactory.getPlatformMBeanServer();
                    Hashtable<String, String> mBeanProperties = new Hashtable<String, String>();
                    mBeanProperties.put("type", "TransactionLogDatabase");
                    mBeanProperties.put("name", "Statistics");
                    mBeanServer.registerMBean(transactionLoggerStatistics, new ObjectName(ImagingMBean.VIX_MBEAN_DOMAIN_NAME, mBeanProperties));
                } catch (Exception e) {
                    LOGGER.warn("[TransactionLoggerJdbcSourceService] - Error registering MBean for transaction logging", e);
                }
            }

            try {
                // Configure the JDBC URL
                String vixTxDbPath = System.getenv("vixtxdb");
                if (vixTxDbPath == null) {
                    vixTxDbPath = "C:/VixTxDb";
                } else {
                    vixTxDbPath = vixTxDbPath.replace("\\", "/");
                    if (vixTxDbPath.endsWith("/")) {
                        vixTxDbPath = vixTxDbPath.substring(0, vixTxDbPath.length() - 1);
                    }
                }
                jdbcUrl = "jdbc:sqlite:" + vixTxDbPath + "/vixtx.db";

                // Check if the table exists
                boolean foundTable = executeQuery(CHECK_TABLE_STATEMENT, new ResultSetHandler<Boolean>() {
                    @Override
                    public Boolean handleResultSet(ResultSet resultSet) throws SQLException {
                        while (resultSet.next()) {
                            if ("TRANSACTION_LOG_ENTRIES".equalsIgnoreCase(resultSet.getString(1))) {
                                return true;
                            }
                        }

                        return false;
                    }
                });

                // Create it
                if (!(foundTable)) {
                    executeQuery(CREATE_TABLE_STATEMENT, null);
                }

                checkedTables = true;
            } catch (Exception e) {
                LOGGER.error("[TransactionLoggerJdbcSourceService] - Error while checking tables", e);
                throw new ConnectionException("Error while checking tables", e);
            }
        }
    }

    @Override
    public void writeLogEntry(TransactionLogEntry entry) throws MethodException, ConnectionException {
        checkTables();
        executeQuery(INSERT_ENTRY_STATEMENT, null, entry.getStartTime(), entry.getElapsedTime(), entry.getPatientIcn(), entry.getQueryType(), entry.getQueryFilter(), entry.getCommandClassName(), entry.getItemCount(), entry.getFacadeBytesSent(), entry.getFacadeBytesReceived(), entry.getDataSourceBytesSent(), entry.getDataSourceBytesReceived(), entry.getQuality(), entry.getMachineName(), entry.getRequestingSite(), entry.getOriginatingHost(), entry.getUser(), entry.getTransactionId(), entry.getUrn(), entry.getErrorMessage(), entry.getModality(), entry.getPurposeOfUse(), entry.getDatasourceProtocol(), entry.isCacheHit(), entry.getResponseCode(), entry.getExceptionClassName(), entry.getRealmSiteNumber(), entry.getTimeToFirstByte(), entry.getVixSoftwareVersion(), entry.getRespondingSite(), entry.getDataSourceItemsReceived(), entry.isAsynchronousCommand(), entry.getCommandId(), entry.getParentCommandId(), entry.getRemoteLoginMethod(), entry.getFacadeImageFormatSent(), entry.getFacadeImageQualitySent(), entry.getDataSourceImageFormatReceived(), entry.getDataSourceImageQualityReceived(), entry.getClientVersion(), entry.getDataSourceMethod(), entry.getDataSourceVersion(), entry.getDebugInformation(), entry.getDataSourceResponseServer(), entry.getThreadId(), entry.getVixSiteNumber(), entry.getRequestingVixSiteNumber(), entry.getSecurityTokenApplicationName());

        // Increment transactions written
        transactionLoggerStatistics.incrementTransactionWritten();
    }

    @Override
    public void getAllLogEntries(TransactionLogWriter writer) throws MethodException, ConnectionException {
        checkTables();
        executeQuery(SELECT_ALL_STATEMENT, new TransactionWriterHandler(writer));
    }

    @Override
    public void getLogEntries(TransactionLogWriter writer, Date startDate, Date endDate, ImageQuality imageQuality, String user, String modality, DatasourceProtocol datasourceProtocol, String errorMessage, String imageUrn, String transactionId, Boolean forward, Integer startIndex, Integer endIndex) throws MethodException, ConnectionException {
        checkTables();

        List<Object> parameters = new ArrayList<>(12);
        List<String> clauses = new ArrayList<>(12);

        // Build various parameter clauses for the WHERE block
        if (startDate != null) {
            clauses.add(" StartTime >= ?");
            parameters.add(startDate.getTime());
        }
        if (endDate != null) {
            clauses.add(" StartTime <= ?");
            parameters.add(endDate.getTime());
        }
        if (imageQuality != null) {
            clauses.add(" Quality = ?");
            parameters.add(imageQuality.toString().toUpperCase(Locale.ENGLISH));
        }
        if (user != null) {
            clauses.add(" User = ?");
            parameters.add(user);
        }
        if (modality != null) {
            clauses.add(" Modality LIKE ?");
            parameters.add("%" + modality + "%");
        }
        if (datasourceProtocol != null) {
            clauses.add(" DatasourceProtocol = ?");
            parameters.add(datasourceProtocol.toString().toUpperCase(Locale.ENGLISH));
        }
        if (errorMessage != null) {
            clauses.add(" ErrorMessage LIKE ?");
            parameters.add("%" + errorMessage + "%");
        }
        if (imageUrn != null) {
            clauses.add(" ImageUrn LIKE ?");
            parameters.add("%" + imageUrn + "%");
        }
        if (transactionId != null) {
            clauses.add(" TransactionId LIKE ?");
            parameters.add("%" + transactionId + "%");
        }

        // Build query
        StringBuilder queryBuilder = new StringBuilder();
        queryBuilder.append(SELECT_ALL_STATEMENT);

        // Append WHERE clause
        if (clauses.size() > 0) {
            queryBuilder.append(" WHERE");
            boolean first = true;
            for (String clause : clauses) {
                if (first) {
                    first = false;
                } else {
                    queryBuilder.append(" AND");
                }

                queryBuilder.append(clause);
            }
        }

        // Append ORDER BY
        queryBuilder.append(" ORDER BY Identifier");
        if (forward) {
            queryBuilder.append(" ASC");
        } else {
            queryBuilder.append(" DESC");
        }

        // Append limit, offset
        if ((startIndex != null) && (endIndex != null)) {
            queryBuilder.append(" LIMIT " + (endIndex - startIndex) + " OFFSET " + startIndex);
        }

        executeQuery(queryBuilder.toString(), new TransactionWriterHandler(writer), parameters.toArray());
    }

    @Override
    public void getLogEntries(TransactionLogWriter writer, String fieldName, String fieldValue) throws MethodException, ConnectionException {
        checkTables();

        // TODO: May not be currently used
    }

    @Override
    public void purgeLogEntries(Integer maxDaysAllowed) throws MethodException, ConnectionException {
        checkTables();

        LOGGER.info("[TransactionLoggerJdbcSourceService] - Purging old transaction log entries");
        executeQuery(DELETE_STATEMENT, null, new Date().getTime() - (maxDaysAllowed * (86400L * 1000L)));

        LOGGER.info("[TransactionLoggerJdbcSourceService] - Running \"vacuum\" to compact purged database");
        executeQuery(VACUUM_STATEMENT, null);

        LOGGER.info("[TransactionLoggerJdbcSourceService] - Finished purging old transaction log entries");
    }

    /**
     * Invoked by VixLog.jsp to get a count of transactions within the provided date range
     *
     * @param fromDate The starting date (inclusive)
     * @param toDate The ending date (inclusive)
     * @return The number of transaction entries with a StartTime between the provided dates
     * @throws MethodException In the event of any non-JDBC related exceptions
     * @throws ConnectionException In the event of any JDBC-related exceptions
     */
    public int getCountByDateRange(Date fromDate, Date toDate) throws MethodException, ConnectionException {
        checkTables();

        return executeQuery(SELECT_COUNT_STATEMENT, new ResultSetHandler<Integer>() {
            @Override
            public Integer handleResultSet(ResultSet resultSet) throws SQLException {
                return resultSet.getInt(1);
            }
        }, fromDate.getTime(), toDate.getTime());
    }

    private <T> T executeQuery(String statement, ResultSetHandler<T> resultSetHandler, Object... parameters) throws MethodException, ConnectionException {
        T result = null;
        Connection jdbcConnection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        try {
            // Configure Sqlite
            SQLiteConfig config = new SQLiteConfig();

            // Check configuration
            if (getConfiguration() == null) {
                throw new MethodException("No TransactionLoggerJdbcSourceProviderConfiguration available; please ensure the configuration file is present and correct");
            }

            // Set synchronous mode
            String synchronousMode = getConfiguration().getSynchronousMode();
            if ((synchronousMode == null) || ("NORMAL".equalsIgnoreCase(synchronousMode))) {
                config.setSynchronous(SQLiteConfig.SynchronousMode.NORMAL);
            } else if ("OFF".equalsIgnoreCase(synchronousMode)) {
                config.setSynchronous(SQLiteConfig.SynchronousMode.OFF);
            } else if ("FULL".equalsIgnoreCase(synchronousMode)) {
                config.setSynchronous(SQLiteConfig.SynchronousMode.FULL);
            } else {
                config.setSynchronous(SQLiteConfig.SynchronousMode.NORMAL);
            }

            // Set journal mode
            String journalMode = getConfiguration().getJournalMode();
            if ((journalMode == null) || ("WAL".equalsIgnoreCase(journalMode))) {
                config.setJournalMode(SQLiteConfig.JournalMode.WAL);
            } else if ("DELETE".equalsIgnoreCase(journalMode)) {
                config.setJournalMode(SQLiteConfig.JournalMode.DELETE);
            } else if ("OFF".equalsIgnoreCase(journalMode)) {
                config.setJournalMode(SQLiteConfig.JournalMode.OFF);
            } else if ("MEMORY".equalsIgnoreCase(journalMode)) {
                config.setJournalMode(SQLiteConfig.JournalMode.MEMORY);
            } else if ("PERSIST".equalsIgnoreCase(journalMode)) {
                config.setJournalMode(SQLiteConfig.JournalMode.PERSIST);
            } else if ("TRUNCATE".equalsIgnoreCase(journalMode)) {
                config.setJournalMode(SQLiteConfig.JournalMode.TRUNCATE);
            } else {
                config.setJournalMode(SQLiteConfig.JournalMode.WAL);
            }

            // Set shared cache
            config.setSharedCache(getConfiguration().getUseSharedCache());

            // Get a connection
            try {
                jdbcConnection = DriverManager.getConnection(jdbcUrl, config.toProperties());
            } catch (SQLException e) {
                throw new SQLException("Error establishing JDBC connection", e);
            }

            // Prepare statement
            try {
                preparedStatement = jdbcConnection.prepareStatement(statement);
            } catch (SQLException e) {
                throw new SQLException("Error preparing statement", e);
            }

            // Set parameters
            try {
                for (int i = 0; i < parameters.length; ++i) {
                    preparedStatement.setObject(i + 1, parameters[i]);
                }
            } catch (SQLException e) {
                throw new SQLException("Error setting statement parameters", e);
            }

            // Execute the statement (presence of ResultSetHandler indicates query versus update)
            try {
                if (resultSetHandler == null) {
                    preparedStatement.executeUpdate();
                } else {
                    resultSet = preparedStatement.executeQuery();
                    result = resultSetHandler.handleResultSet(resultSet);

                    // Log transactions queried
                    try {
                        transactionLoggerStatistics.incrementTransactionsQueried();
                    } catch (Throwable t) {
                        // Ignore
                    }
                }
            } catch (SQLException e) {
                throw new SQLException("Error executing statement", e);
            }
        } catch (Exception e) {
            // Increment read / write error based on resultSetHandler
            try {
                if (resultSetHandler == null) {
                    transactionLoggerStatistics.incrementTransactionWriteErrors();
                } else {
                    transactionLoggerStatistics.incrementTransactionReadErrors();
                }
            } catch (Throwable t) {
                // Ignore
            }

            LOGGER.error("[TransactionLoggerJdbcSourceService] - Error while interacting with JDBC source", e);
            throw new ConnectionException("Error while interacting with JDBC source", e);
        } finally {
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (Exception e) {
                    // Ignore
                }
            }

            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (Exception e) {
                    // Ignore
                }
            }

            if (jdbcConnection != null) {
                try {
                    jdbcConnection.close();
                } catch (Exception e) {
                    // Ignore
                }
            }
        }

        return result;
    }

    private static BasicTransactionLogEntry convertLogEntry(ResultSet resultSet) throws SQLException {
        return new BasicTransactionLogEntry(resultSet.getLong(2), resultSet.getLong(3), resultSet.getString(4), resultSet.getString(5), resultSet.getString(6), resultSet.getString(7), resultSet.getInt(8), resultSet.getLong(9), resultSet.getLong(10), resultSet.getLong(11), resultSet.getLong(12), resultSet.getString(13), resultSet.getString(14), resultSet.getString(15), resultSet.getString(16), resultSet.getString(17), resultSet.getString(18), resultSet.getString(19), resultSet.getString(20), resultSet.getString(21), resultSet.getString(22), resultSet.getString(23), resultSet.getBoolean(24), resultSet.getString(25), resultSet.getString(26), resultSet.getString(27), resultSet.getLong(28), resultSet.getString(29), resultSet.getString(30), resultSet.getInt(31), resultSet.getBoolean(32), resultSet.getString(33), resultSet.getString(34), resultSet.getString(35), resultSet.getString(36), resultSet.getString(37), resultSet.getString(38), resultSet.getString(39), resultSet.getString(40), resultSet.getString(41), resultSet.getString(42), resultSet.getString(43), resultSet.getString(44), resultSet.getString(45), resultSet.getString(46), resultSet.getString(47), resultSet.getString(48));
    }

    private interface ResultSetHandler<T> {
        T handleResultSet(ResultSet resultSet) throws SQLException;
    }

    private static class TransactionWriterHandler implements ResultSetHandler<Object> {
        private final TransactionLogWriter transactionLogWriter;

        public TransactionWriterHandler(TransactionLogWriter transactionLogWriter) {
            this.transactionLogWriter = transactionLogWriter;
        }

        @Override
        public Object handleResultSet(ResultSet resultSet) throws SQLException {
            while (resultSet.next()) {
                try {
                    transactionLogWriter.writeTransactionLogEntry(convertLogEntry(resultSet));
                } catch (MethodException e) {
                    throw new SQLException("Internal exception handling transaction log entry", e);
                }
            }

            return null;
        }
    }

    private TransactionLoggerJdbcSourceProviderConfiguration getConfiguration() {
        return TransactionLoggerJdbcSourceProvider.getTransactionLoggerConfiguration();
    }

    @Override
    public void getLogEntries(TransactionLogWriter writer, TransactionLogQuery query) throws MethodException, ConnectionException {
        StringBuilder stringBuilder = new StringBuilder();

        // Create list to store parameters in
        List<Object> parameterValues = new ArrayList<>(query.getQueryParameters().size());

        // Build basic select
        stringBuilder.append("SELECT * FROM TRANSACTION_LOG_ENTRIES");

        // Add where clauses
        if (query.getQueryParameters().size() > 0) {
            stringBuilder.append(" WHERE");
            boolean first = true;
            for (TransactionLogQueryParameter queryParameter : query.getQueryParameters()) {
                // Validate the query parameter name
                isFieldAllowed(queryParameter.getName());

                // Skip do-not-use entries
                if (TransactionLogQueryParameterType.DO_NOT_USE == queryParameter.getType()) {
                    continue;
                }

                // Append "and"
                if (first) {
                    first = false;
                } else {
                    stringBuilder.append(" AND");
                }

                // Append the validated name
                stringBuilder.append(" ");
                stringBuilder.append(queryParameter.getName());

                // Append the operation
                if (TransactionLogQueryParameterType.EQUAL_TO == queryParameter.getType()) {
                    stringBuilder.append(" = ?");
                } else if (TransactionLogQueryParameterType.NOT_EQUAL_TO == queryParameter.getType()) {
                    stringBuilder.append(" <> ?");
                } else if (TransactionLogQueryParameterType.LESS_THAN == queryParameter.getType()) {
                    stringBuilder.append(" < ?");
                } else if (TransactionLogQueryParameterType.LESS_THAN_OR_EQUAL_TO == queryParameter.getType()) {
                    stringBuilder.append(" <= ?");
                } else if (TransactionLogQueryParameterType.GREATER_THAN == queryParameter.getType()) {
                    stringBuilder.append(" > ?");
                } else if (TransactionLogQueryParameterType.GREATER_THAN_OR_EQUAL_TO == queryParameter.getType()) {
                    stringBuilder.append(" >= ?");
                } else if (TransactionLogQueryParameterType.LIKE == queryParameter.getType()) {
                    stringBuilder.append(" LIKE ?");
                }

                // Convert the parameter type based on the field and add it
                try {
                    if (inArray(BOOLEAN_FIELDS, queryParameter.getName())) {
                        parameterValues.add(Boolean.parseBoolean(queryParameter.getValue()));
                    } else if (inArray(INT_FIELDS, queryParameter.getName())) {
                        parameterValues.add(Integer.parseInt(queryParameter.getValue()));
                    } else if (inArray(LONG_FIELDS, queryParameter.getName())) {
                        parameterValues.add(Long.parseLong(queryParameter.getValue()));
                    } else {
                        parameterValues.add(queryParameter.getValue());
                    }
                } catch (Exception e) {
                    throw new MethodException("Error setting query parameter", e);
                }
            }
        }

        // Add order clauses
        if (query.getOrderParameters().size() > 0) {
            stringBuilder.append(" ORDER BY ");

            // Add order clause
            boolean first = true;
            for (TransactionLogQueryOrder orderParameter : query.getOrderParameters()) {
                // Validate the query order name
                isFieldAllowed(orderParameter.getName());

                if (first) {
                    first = false;
                } else {
                    stringBuilder.append(", ");
                }

                stringBuilder.append(orderParameter.getName());
                if (orderParameter.isAscending()) {
                    stringBuilder.append(" ASC");
                } else {
                    stringBuilder.append(" DESC");
                }
            }
        }

        // Limit the rows returned
        if (query.getRowLimit() != -1) {
            stringBuilder.append(" LIMIT ").append(query.getRowLimit());
        }

        // Build and log the query
        String queryString = stringBuilder.toString();
        LOGGER.info("[TransactionLoggerJdbcSourceService] - Querying transaction log entry database with query: {}", queryString);

        // Execute the query
        executeQuery(queryString, new TransactionWriterHandler(writer), parameterValues.toArray());
    }

    private static void isFieldAllowed(String fieldName) throws MethodException {
        if (! (inArray(TransactionLogQuery.ALLOWED_FIELDS, fieldName))) {
            throw new MethodException("Provided field name is not allowed; please try one of: " + Arrays.toString(TransactionLogQuery.ALLOWED_FIELDS));
        }
    }

    private static boolean inArray(String[] array, String value) {
        for (String entry : array) {
            if (entry.equalsIgnoreCase(value)) {
                return true;
            }
        }

        return false;
    }
}
