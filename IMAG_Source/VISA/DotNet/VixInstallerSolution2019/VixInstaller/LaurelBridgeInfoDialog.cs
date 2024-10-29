using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class LaurelBridgeInfoDialog : Form
    {
        public String LicensePath
        {
            get { return this.textBoxLicenseFile.Text; }
        }

        public LaurelBridgeInfoDialog()
        {
            InitializeComponent();
        }

        private void LaurelBridgeInfoDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.ClearErrors();

            if (this.DialogResult == DialogResult.OK)
            {
                if (this.textBoxLicenseFile.Text.Length == 0)
                {
                    this.errorProvider.SetError(this.textBoxLicenseFile, "You must select the License file.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
            }
        }

        private void buttonLicenseFile_Click(object sender, EventArgs e)
        {
            DialogResult result = this.openLicenseFileDialog.ShowDialog();
            if (result == DialogResult.OK)
            {
                this.textBoxLicenseFile.Text = this.openLicenseFileDialog.FileName;
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