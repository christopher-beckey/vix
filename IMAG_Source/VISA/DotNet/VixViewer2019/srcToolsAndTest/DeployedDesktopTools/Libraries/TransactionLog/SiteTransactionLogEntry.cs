using DesktopCommon;

namespace TransactionLog
{
    public class SiteTransactionLogEntry
    {
        public TransactionLogEntry TransactionLogEntry { get; private set; }
        public VaSite VASite { get; private set; }

        public SiteTransactionLogEntry(TransactionLogEntry transactionLogEntry, VaSite site)
        {
            this.TransactionLogEntry = transactionLogEntry;
            this.VASite = site;
        }
    }
}
