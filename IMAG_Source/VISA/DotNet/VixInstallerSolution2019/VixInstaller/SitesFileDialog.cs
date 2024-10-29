using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using gov.va.med.imaging.exchange.VixInstaller.business;
using System.IO;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class SitesFileDialog : Form
    {
        public String SitesFile
        {
            get { return this.textBoxSitesFile.Text; }
        }

        public SitesFileDialog()
        {
            InitializeComponent();
        }

        private void ClearErrors()
        {
            this.labelErrorInfo.Visible = false;
            this.errorProvider.Clear();
        }

        private void buttonSitesFile_Click(object sender, EventArgs e)
        {
            DialogResult result = this.openSitesFileDialog.ShowDialog();
            if (result == DialogResult.OK)
            {
                this.textBoxSitesFile.Text = this.openSitesFileDialog.FileName;
                this.ClearErrors();
            }
        }

        private void SitesFileDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.ClearErrors();

            if (this.DialogResult == DialogResult.OK) // OK button pressed
            {
                if (this.textBoxSitesFile.Text.Length == 0)
                {
                    this.errorProvider.SetError(this.textBoxSitesFile, "You must select the sites file.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
                else
                {
                    string vixConfigDir = VixFacade.GetVixConfigurationDirectory();
                    if (vixConfigDir != null)
                    {
                        string sourceFilespec = this.textBoxSitesFile.Text;
                        string targetFilespec = Path.Combine(vixConfigDir, "VhaSites.xml");
                        if (sourceFilespec.ToUpper() == targetFilespec.ToUpper())
                        {
                            this.errorProvider.SetError(this.textBoxSitesFile, "Source filespec cannot equal target filespec.");
                            this.labelErrorInfo.Visible = true;
                            e.Cancel = true;
                        }
                    }
                }
            }
        }
    }
}