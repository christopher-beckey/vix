using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Windows.Forms;
using gov.va.med.imaging.exchange.VixInstaller.business;


namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class FederationInfoDialog : Form
    {
        public String CertificatePath
        {
            get { return this.textBoxCertificateFile.Text; }
        }

        public FederationInfoDialog()
        {
            InitializeComponent();
            string defaultFederationZip = Path.Combine(Application.StartupPath, @"federation.zip");
            if (File.Exists(defaultFederationZip))
            {
                this.textBoxCertificateFile.Text = defaultFederationZip;
            }
        }

        private void FederationInfoDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.ClearErrors();

            if (this.DialogResult == DialogResult.OK)
            {
                if (this.textBoxCertificateFile.Text.Length == 0)
                {
                    this.errorProvider.SetError(this.textBoxCertificateFile, "You must select the Certificate file.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
                else
                {
                    if (VixFacade.IsFederationCertificateValid(this.CertificatePath) == false)
                    {
                        this.errorProvider.SetError(this.textBoxCertificateFile, "The zip file you have selected does not contain the proper VIX certificate files.");
                        this.labelErrorInfo.Visible = true;
                        e.Cancel = true;
                    }
                }
            }
        }

        private void buttonCertificateFile_Click(object sender, EventArgs e)
        {
            DialogResult result = this.openCertificateFileDialog.ShowDialog();
            if (result == DialogResult.OK)
            {
                this.textBoxCertificateFile.Text = this.openCertificateFileDialog.FileName;
                this.ClearErrors();
            }
        }

        private void ClearErrors()
        {
            this.labelErrorInfo.Visible = false;
            this.errorProvider.Clear();
        }

    }
}