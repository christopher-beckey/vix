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
    public partial class CertFileSaveDialog : Form
    {
        public String CertFile
        {
            get { return this.textBoxCert.Text; }
        }

        public CertFileSaveDialog()
        {
            InitializeComponent();
        }

        private void ClearErrors()
        {
            this.labelErrorInfo.Visible = false;
            this.errorProvider.Clear();
        }

        private void CertFileDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.ClearErrors();

            if (this.DialogResult == DialogResult.OK) // OK button pressed
            {
                if (this.textBoxCert.Text.Length == 0)
                {
                    this.errorProvider.SetError(this.textBoxCert, "You must select the certificate file.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
            }
        }

        private void buttonCertFile_Click(object sender, EventArgs e)
        {
            DialogResult result = this.saveCertFileDialog.ShowDialog();
            if (result == DialogResult.OK)
            {
                this.textBoxCert.Text = this.saveCertFileDialog.FileName;
                this.ClearErrors();
            }

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        public void setTitle(string title, string tip)
        {
            Text = title;
            labelTip.Text = tip;
        }


        public void setFilter(string filter)
        {
            this.saveCertFileDialog.Filter = filter;
        }
    }
}