using DesktopCommon;
using TransactionLog;

namespace TransactionEntryTracer
{
    public class SearchedTransaction
    {
        public bool Searched { get; set; }
        public VaSite Site { get; private set; }
        public TransactionLogEntry Transaction { get; private set; }

        public SearchedTransaction(TransactionLogEntry transaction, VaSite site)
        {
            this.Transaction = transaction;
            this.Searched = false;
            this.Site = site;
        }
    }
}
