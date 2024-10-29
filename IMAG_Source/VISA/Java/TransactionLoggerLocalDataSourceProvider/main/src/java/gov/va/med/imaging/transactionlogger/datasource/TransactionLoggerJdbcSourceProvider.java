package gov.va.med.imaging.transactionlogger.datasource;

import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.ProviderService;
import gov.va.med.imaging.datasource.TransactionLoggerDataSourceSpi;
import gov.va.med.imaging.transactionlogger.configuration.TransactionLoggerJdbcSourceProviderConfiguration;
import gov.va.med.logging.Logger;

import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

public class TransactionLoggerJdbcSourceProvider extends Provider {
    private static final String PROVIDER_NAME = "TransactionLoggerJdbcSource";
    private static final double PROVIDER_VERSION = 1.0d;
    private static final String PROVIDER_INFO = "Implements: \nTransactionLoggerJdbc SPI \nbacked by a JDBC-accessed Database.";

    private static final Logger LOGGER = Logger.getLogger(TransactionLoggerJdbcSourceProvider.class);
    private final SortedSet<ProviderService> services;
    private static TransactionLoggerJdbcSourceProviderConfiguration transactionLoggerConfiguration;

    public TransactionLoggerJdbcSourceProvider() {
        this(PROVIDER_NAME, PROVIDER_VERSION, PROVIDER_INFO);
    }

    public TransactionLoggerJdbcSourceProvider(TransactionLoggerJdbcSourceProviderConfiguration loggerConfiguration) {
        this();
        transactionLoggerConfiguration = loggerConfiguration;
    }

    public TransactionLoggerJdbcSourceProvider(String name, double version, String info) {
        super(name, version, info);
        services = new TreeSet<ProviderService>();
        services.add(new ProviderService(this, TransactionLoggerDataSourceSpi.class, (byte) 0, TransactionLoggerJdbcSourceService.class));

        synchronized(TransactionLoggerJdbcSourceProvider.class) {
            try {
                if (transactionLoggerConfiguration == null) {
                    transactionLoggerConfiguration = (TransactionLoggerJdbcSourceProviderConfiguration) loadConfiguration();
                }
            } catch(Exception e) {
                LOGGER.error("Unable to load configuration because the configuration file is invalid; creating default", e);
                transactionLoggerConfiguration = TransactionLoggerJdbcSourceProviderConfiguration.createDefaultConfiguration();
            }
        }
    }

    @Override
    public SortedSet<ProviderService> getServices() {
        return Collections.unmodifiableSortedSet(services);
    }

    public static TransactionLoggerJdbcSourceProviderConfiguration getTransactionLoggerConfiguration() {
        return transactionLoggerConfiguration;
    }

    @Override
    public void storeConfiguration() {
        storeConfiguration(getTransactionLoggerConfiguration());
    }

    public static void main(String [] args)
    {
        System.out.println("Creating TransactionLoggerJdbcSourceProvider configuration file");
        TransactionLoggerJdbcSourceProviderConfiguration loggerConfiguration = null;

        if (args.length == 4) {
            int retentionPeriod = Integer.parseInt(args[0]);
            boolean useSharedCache = Boolean.parseBoolean(args[1]);
            String synchronousMode = args[2];
            String journalMode = args[3];

            System.out.println("Creating configuration file from parameters");
            loggerConfiguration = new TransactionLoggerJdbcSourceProviderConfiguration();
            loggerConfiguration.setRetentionPeriodDays(retentionPeriod);
            loggerConfiguration.setUseSharedCache(useSharedCache);
            loggerConfiguration.setSynchronousMode(synchronousMode);
            loggerConfiguration.setJournalMode(journalMode);
        } else {
            System.out.println("Creating default configuration.");
            System.out.println("Available parameters are: <retention period days> <use shared cache> <synchronous mode> <journal mode>");
            loggerConfiguration = TransactionLoggerJdbcSourceProviderConfiguration.createDefaultConfiguration();
        }

        TransactionLoggerJdbcSourceProvider provider = new TransactionLoggerJdbcSourceProvider(loggerConfiguration);
        provider.storeConfiguration();

        System.out.println("Configuration file saved to '" + provider.getConfigurationFileName() + "'.");
    }
}
