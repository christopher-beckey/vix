using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class BiaCredentialsDialog : Form
    {
        public BiaCredentialsDialog()
        {
            InitializeComponent();
        }

        public String Password
        {
            get { return this.textBoxPassword.Text; }
        }

        public String Username
        {
            get { return this.textBoxUsername.Text; }
        }

        private void BiaCredentialsDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.labelErrorInfo.Visible = false;
            this.errorProvider.Clear();

            if (this.DialogResult == DialogResult.OK)
            {

                if (this.textBoxUsername.Text.Length == 0)
                {
                    this.errorProvider.SetError(this.textBoxPassword, "You must provide a username.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
                
                if (this.textBoxPassword.Text.Length == 0)
                {
                    this.errorProvider.SetError(this.textBoxPassword, "You must provide a password.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }

                if (this.textBoxConfirmPassword.Text.Length == 0)
                {
                    this.errorProvider.SetError(this.textBoxConfirmPassword, "You must provide a password.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
                else if (this.textBoxPassword.Text != this.textBoxConfirmPassword.Text)
                {
                    this.errorProvider.SetError(this.textBoxConfirmPassword, "Passwords do not match. Please re-type.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
            }
        }

        private void BiaCredentialsDialog_Load(object sender, EventArgs e)
        {
            this.textBoxUsername.Text = "";
            this.textBoxPassword.Text = "";
            this.textBoxConfirmPassword.Text = "";
            this.labelErrorInfo.Visible = false;
            this.errorProvider.Clear();
        }

    }
}