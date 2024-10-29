using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using gov.va.med.imaging.exchange.VixInstaller.business;


namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class XcaInfoDialog : Form
    {
        public String CertificatePath
        {
            get { return this.textBoxCertificateFile.Text; }
        }

        public XcaInfoDialog()
        {
            InitializeComponent();
        }

        private void XcaInfoDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.ClearErrors();

            if (this.DialogResult == DialogResult.OK)
            {
                if (this.textBoxCertificateFile.Text.Length == 0)
                {
                    this.errorProvider.SetError(this.textBoxCertificateFile, "You must select the file which contains the XCA keystore and truststore.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
                else
                {
                    if (VixFacade.IsXcaCertificateValid(this.CertificatePath) == false)
                    {
                        this.errorProvider.SetError(this.textBoxCertificateFile, "The zip file you have selected does not contain the proper XCA keystore and truststore.");
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