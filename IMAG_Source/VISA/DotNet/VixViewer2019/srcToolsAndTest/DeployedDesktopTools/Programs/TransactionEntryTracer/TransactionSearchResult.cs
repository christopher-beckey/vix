using DesktopCommon;
using System.Collections.Generic;
using TransactionLog;

namespace TransactionEntryTracer
{
    public class TransactionSearchResult
    {
        public List<SearchedTransaction> Transactions { get; private set; }
        public List<VaSite> SearchedSites { get; private set; }

        public TransactionSearchResult()
        {
            Transactions = new List<SearchedTransaction>();
            SearchedSites = new List<VaSite>();
        }

        public bool IsSiteSearched(VaSite site)
        {
            foreach (VaSite searchedSite in SearchedSites)
            {
                if (site.SiteNumber == searchedSite.SiteNumber)
                    return true;
            }
            return false;
        }

        public void AddUnsearchedTransactions(List<TransactionLogEntry> transactions, VaSite site)
        {
            foreach (TransactionLogEntry transaction in transactions)
            {
                AddUnsearchedTransaction(transaction, site);
            }
        }

        public void AddUnsearchedTransaction(TransactionLogEntry transaction, VaSite site)
        {
            Transactions.Add(new SearchedTransaction(transaction, site));
        }
    }
}
