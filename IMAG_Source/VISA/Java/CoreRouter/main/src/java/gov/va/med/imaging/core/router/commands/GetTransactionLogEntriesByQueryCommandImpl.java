package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.access.TransactionLogWriter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.transactions.TransactionLogQuery;

public class GetTransactionLogEntriesByQueryCommandImpl extends AbstractCommandImpl<Void> {
    private final TransactionLogWriter transactionLogWriter;
    private final TransactionLogQuery transactionLogQuery;

    public GetTransactionLogEntriesByQueryCommandImpl(TransactionLogWriter transactionLogWriter, TransactionLogQuery transactionLogQuery) {
        this.transactionLogWriter = transactionLogWriter;
        this.transactionLogQuery = transactionLogQuery;
    }

    @Override
    public Void callSynchronouslyInTransactionContext() throws MethodException, ConnectionException {
        getCommandContext().getTransactionLoggerService().getLogEntries(transactionLogWriter, transactionLogQuery);

        return null;
    }

    @Override
    public boolean equals(Object obj) {
        return false;
    }

    @Override
    protected String parameterToString() {
        return "GetTransactionLogEntriesByQueryCommandImpl: parameters unavailable";
    }
}
