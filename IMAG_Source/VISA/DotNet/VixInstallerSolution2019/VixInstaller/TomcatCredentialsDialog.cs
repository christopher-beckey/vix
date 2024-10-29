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
    public partial class VixCredentialsDialog : Form
    {
        public VixCredentialsDialog()
        {
            InitializeComponent();
        }

        public String Password
        {
            get { return this.textBoxPassword.Text; }
        }

        //public String Username
        //{
        //    get { return this.textBoxUsername.Text; }
        //}

        private bool ValidatePassword(TextBox textBoxPassword)
        {
            string errmsg = string.Empty;
            bool isValid = TomcatFacade.ValidatePassword(textBoxPassword.Text, out errmsg);
            if (!isValid)
            {
                this.errorProvider.SetError(textBoxPassword, errmsg);
                this.labelErrorInfo.Visible = true;
            }
            return isValid;
        }

        private bool ValidatePasswordString(String password)
        {
            bool isValid = true;
            for (int i = 0; i < password.Length; i++)
            {
                if (char.IsLetter(password, i) == false && char.IsDigit(password, i) == false)
                {
                    isValid = false;
                    break;
                }
            }
            return isValid;
        }

        private void TomcatCredentialsDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.labelErrorInfo.Visible = false;
            this.errorProvider.Clear();
            if (this.DialogResult == DialogResult.OK)
            {
                if (this.textBoxPassword.Text.Length == 0)
                {
                    this.errorProvider.SetError(this.textBoxPassword, "You must provide a password.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
                else if (ValidatePasswordString(this.textBoxPassword.Text) == false)
                {
                    this.errorProvider.SetError(this.textBoxPassword, "Password may only use alphanumeric characters (a-z, A-Z, and 0-9).");
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

        /// <summary>
        /// Clear out any previous passwords. This is necessary to avoid the error provider displaying
        /// any previous errors in the event of the user canceling then re-displaying the form.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TomcatCredentialsDialog_Load(object sender, EventArgs e)
        {
            this.textBoxPassword.Text = "";
            this.textBoxConfirmPassword.Text = "";
            this.labelErrorInfo.Visible = false;
            this.errorProvider.Clear();
        }
    }
}