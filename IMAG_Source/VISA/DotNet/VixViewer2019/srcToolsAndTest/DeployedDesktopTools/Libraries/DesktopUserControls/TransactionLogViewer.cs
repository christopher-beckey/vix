using DesktopCommon;
using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using TransactionLog;

namespace DesktopUserControls
{
    public partial class TransactionLogViewer : UserControl
    {
        public TransactionLogViewer()
        {
            InitializeComponent();
        }

        public void DisplayTransactionLogEntries(string transactionId, DateTime fromDate, DateTime toDate, VaSite site, List<TransactionLogEntry> entries)
        {
            lblTransactionID.Text = transactionId + " from " + site.ToString();
            lblDateRange.Text = fromDate.ToString(Utils.DateFormat) + " to " + toDate.ToString(Utils.DateFormat);
            foreach (TransactionLogEntry entry in entries)
            {
                DisplayEntry(new SiteTransactionLogEntry(entry, site));
            }
        }

        public void DisplayTransactionLogEntries(string transactionId, DateTime date, VaSite site, List<TransactionLogEntry> entries)
        {
            lblTransactionID.Text = transactionId;
            lblDateRange.Text = date.ToString(Utils.DateFormat);
            foreach (TransactionLogEntry entry in entries)
            {
                DisplayEntry(new SiteTransactionLogEntry(entry, site));
            }
        }

        public void Clear()
        {
            dgvEntries.Rows.Clear();
            dgvEntries.Columns.Clear();
            lblDateRange.Text = "";
            lblTransactionID.Text = "";
        }

        private void DisplayEntry(SiteTransactionLogEntry siteTransactionLogEntry)
        {
            DataGridViewRow row = new DataGridViewRow();

            if (dgvEntries.Rows.Count <= 0)
            {
                // create columns
                dgvEntries.Columns.Add(createColumn("Site"));
                foreach (string key in siteTransactionLogEntry.TransactionLogEntry.Values.Keys)
                {
                    dgvEntries.Columns.Add(createColumn(key));
                }
            }
            //dgvEntries.Rows.Add(row);
            row.CreateCells(dgvEntries);
            row.Cells[0].Value = siteTransactionLogEntry.VASite.SiteName;
            row.Tag = siteTransactionLogEntry;

            int i = 1;
            foreach (string key in siteTransactionLogEntry.TransactionLogEntry.Values.Keys)
            {
                row.Cells[i].Value = siteTransactionLogEntry.TransactionLogEntry.Values[key];
                i++;
            }
            dgvEntries.Rows.Add(row);
        }

        private DataGridViewColumn createColumn(string key)
        {
            DataGridViewColumn col = new DataGridViewColumn();
            DataGridViewCell cell = new DataGridViewTextBoxCell();
            col.CellTemplate = cell;
            col.Name = key;
            col.HeaderText = key;
            return col;
        }

        private void displayTransactionDetailsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SiteTransactionLogEntry siteTransactionLogEntry = GetSelectedLogEntry();
            if (siteTransactionLogEntry != null)
            {
                TransactionLogUrlHelper.LaunchTransactionViewer(siteTransactionLogEntry);
            }
        }

        private SiteTransactionLogEntry GetSelectedLogEntry()
        {
            if (dgvEntries.SelectedRows[0].Tag != null)
            {
                SiteTransactionLogEntry siteTransactionLogEntry = (SiteTransactionLogEntry)dgvEntries.SelectedRows[0].Tag;
                return siteTransactionLogEntry;
            }
            return null;
        }

        private void copyTransactionToClipboardToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SiteTransactionLogEntry siteTransactionLogEntry = GetSelectedLogEntry();
            if (siteTransactionLogEntry != null)
            {
                StringBuilder sb = new StringBuilder();

                Dictionary<string, string> values = siteTransactionLogEntry.TransactionLogEntry.Values;
                foreach (string key in values.Keys)
                {
                    sb.AppendLine(key + "=" + values[key]);
                }

                Clipboard.SetText(sb.ToString());
                
            }
        }
    }
}
