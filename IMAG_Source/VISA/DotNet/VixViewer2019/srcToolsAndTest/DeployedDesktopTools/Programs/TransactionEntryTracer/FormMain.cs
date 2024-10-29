using DesktopCommon;
using SiteService;
using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using TransactionLog;

namespace TransactionEntryTracer
{
    public partial class FormMain : Form
    {
        private TransactionSearchResult SearchResults;
        private List<VaSite> VaSites;

        public FormMain()
        {
            InitializeComponent();
            Icon = Properties.Resources.Track;
        }

        private void frmMain_Load(object sender, EventArgs e)
        {
            try
            {
                Utils.InitializeConfig();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), "Exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            tmrStart.Enabled = true;
        }

        private void tmrStart_Tick(object sender, EventArgs e)
        {
            tmrStart.Enabled = false;
            btnFindAssociatedTransactions.Enabled = false;
            LoadSites();
        }

        private void LoadSites()
        {
            try
            {
                Cursor.Current = Cursors.WaitCursor;
                StatusMessage("Loading sites", false);
                SiteServiceHelper siteServiceHelper = new SiteServiceHelper(Utils.SiteService);
                VaSites = siteServiceHelper.GetVaSites(true);
                foreach (VaSite site in VaSites)
                {
                    if(site.HasVix) //CVIX has VIX
                    {
                        cboSites.Items.Add(site);
                    }
                }
                StatusMessage($"Loaded {VaSites.Count} sites", false);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), "Exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                Cursor.Current = Cursors.Default;
            }
        }

        private void StatusMessage(string msg, bool error)
        {
            tsStatus.Text = msg;
            Application.DoEvents();
        }

        private void btnSearchTransaction_Click(object sender, EventArgs e)
        {
            if (cboSites.SelectedItem != null)
            {
                string errorMsg;
                VaSite site = (VaSite)cboSites.SelectedItem;
                if (!Utils.SetVixJavaSecurityToken(site.VixHost, site.VixPort, out errorMsg))
                {
                    MessageBox.Show(errorMsg, "Exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                else
                {
                    int count = InitialSearchTransaction(site, txtTransactionId.Text.Trim(), dtFrom.Value);
                    if (count == 0)
                    {
                        // -1 means error
                        MessageBox.Show("No transactions found that match the Transaction ID.");
                    }
                    else
                    {
                        btnFindAssociatedTransactions.Enabled = true;
                        if (chkAutoFindAssociatedTransactions.Checked)
                            FindAssociatedTransactions();
                    }
                }
            }
            else
            {
                MessageBox.Show("Please select a Start Site.");
            }
        }

        private int InitialSearchTransaction(VaSite site, string transactionId, DateTime date)
        {
            SearchResults = new TransactionSearchResult();
            transactionLogViewer1.Clear();
            return SearchTransaction(site, transactionId, date);
        }

        private int SearchTransaction(VaSite site, string transactionId, DateTime date)
        {
            try
            {
                Cursor.Current = Cursors.WaitCursor;
                StatusMessage("Searching for transaction '" + transactionId + "' from site '" + site.Name + "'.", false);
                SearchResults.SearchedSites.Add(site);
                List<TransactionLogEntry> transactions = TransactionLogDownloader.GetTransaction(site.VixHost, site.VixPort, site.SiteNumber, transactionId, date, date);
                SearchResults.AddUnsearchedTransactions(transactions, site);

                transactionLogViewer1.DisplayTransactionLogEntries(transactionId, date, site, transactions);
                return transactions.Count;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), "Exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return -1;
            }
            finally
            {
                Cursor.Current = Cursors.Default;
            }
        }

        private void btnFindAssociatedTransactions_Click(object sender, EventArgs e)
        {
            FindAssociatedTransactions();
        }

        private void FindAssociatedTransactions()
        {
            StatusMessage("Searching for associated transactions.", false);
            btnFindAssociatedTransactions.Enabled = false;
            List<SearchedTransaction> tempTransactions = new List<SearchedTransaction>();
            tempTransactions.AddRange(SearchResults.Transactions);

            foreach (SearchedTransaction searchTransaction in tempTransactions)
            {
                if (!searchTransaction.Searched)
                {
                    //
                    FindAssociatedTransactions(searchTransaction.Transaction);
                    searchTransaction.Searched = true;
                }
            }
            StatusMessage("Done searching for associated transactions.", false);
        }

        private void FindAssociatedTransactions(TransactionLogEntry transaction)
        {
            /**
             * 4 possible cases (well really 6):
             * Transaction originated on a VIX to get data from another VIX
                * use Responding Site, it will start with 1.3.6.1.4.1.3768,XXX meaning VA site, just use site number portion
             * Transaction originated on a VIX to respond to another VIX
                *  use Requesting VIX Site Number to find requesting VIX
             * Transaction originated on a VIX to get data from a CVIX
                *  use Responding Site, it will contain 2.16.840.1.113883.3.42.10012.100001.207,200 which means it is DoD data so look at Data Source Response Server for specific node of CVIX
             * Transaction originated on a CVIX to response to a VIX
                *  Requesting VIX Site Number to find requesting VIX
             * 
             * (not handling requests that originated on the CVIX to get data from a VIX - probably can't trace those both directions)
             * 
             * 
             */

            VaSite site = null;
            if (!String.IsNullOrEmpty(transaction.RespondingSite))
            {
                string number = transaction.RespondingSite;
                if (number.StartsWith("1.3.6.1.4.1.3768,"))
                {
                    number = number.Substring(17);
                    site = FindSiteByNumber(number);
                }
                else
                {
                    // response didn't come from VA which mean it went through the CVIX, use the Data Source Response Server for the specific node
                    if (!string.IsNullOrEmpty(transaction.DataSourceResponseServer))
                    {
                        site = FindSiteByHostname(transaction.DataSourceResponseServer);
                    }
                }
            }
            // if we didn't find a site or it was already searched, look elsewhere
            if (site == null || IsSiteSearched(site))
            {
                if (transaction.Values.ContainsKey("Requesting VIX Site Number"))
                {
                    string requestingVixSiteNumber = transaction.Values["Requesting VIX Site Number"];
                    if (!String.IsNullOrEmpty(requestingVixSiteNumber))
                    {
                        site = FindSiteByNumber(requestingVixSiteNumber);
                    }
                }
            }


            if ((site != null) && (!IsSiteSearched(site)))
            {
                SearchTransaction(site, txtTransactionId.Text.Trim(), dtFrom.Value);
            }
        }

        private bool IsSiteSearched(VaSite site)
        {
            return SearchResults.IsSiteSearched(site);
        }

        private VaSite FindSiteByNumber(string siteNumber)
        {
            /*
            string number = siteNumber;
            if (number.StartsWith("1.3.6.1.4.1.3768,"))
            {
                number = number.Substring(17);
            }
            */
            foreach (VaSite site in VaSites)
            {
                if (site.SiteNumber == siteNumber)
                    return site;
            }
            return null;
        }

        private VaSite FindSiteByHostname(string hostname)
        {
            foreach (VaSite site in VaSites)
            {
                if (site.VisaHost.ToLower().StartsWith(hostname.ToLower()))
                    return site;
            }
            return null;
        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void aboutToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ShowAboutDialog();
        }

        private void ShowAboutDialog()
        {
            StringBuilder msg = new StringBuilder();
            msg.AppendLine("Transaction Entry Tracer");
            msg.AppendLine("Version: " + Application.ProductVersion);

            MessageBox.Show(msg.ToString(), "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void optionsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Utils.EditConfig();
        }
    }
}
