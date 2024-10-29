using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Text.RegularExpressions;
using gov.va.med.imaging.exchange.VixInstaller.business;
using System.DirectoryServices;
using System.DirectoryServices.ActiveDirectory;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class ServiceAccountDialog : Form
    {
        private static readonly String TOMCAT_SERVICE_ACCOUNT_NAME = "apachetomcat";
        
        public ServiceAccountDialog()
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

        private String AccountName
        {
            get 
            {
                string account = Username;
                if (string.IsNullOrEmpty(account))
                {
                    return string.Empty;
                }
                else
                {
                    
                    string[] domainAccount = account.Split(new [] {'\\'} );
                    if (domainAccount.Length > 1)
                    {
                        return domainAccount[1];
                    }
                    else
                    {
                        return account;
                    }
                }
            }
        }

        private String AccountDomain
        {
            get
            {
                string account = Username;
                if (string.IsNullOrEmpty(account))
                {
                    return string.Empty;
                }
                else
                {

                    string[] domainAccount = account.Split(new[] { '\\' });
                    if (domainAccount.Length > 1)
                    {
                        if (domainAccount[0].Equals("."))
                        {
                            return GetDefaultDomain();
                        }
                        else
                        {
                            return domainAccount[0];
                        }
                    }
                    else
                    {
                        return GetDefaultDomain();
                    }
                }
            }
        }

        private string GetDefaultDomain()
        {
            try
            {
                Domain computerDomain = Domain.GetComputerDomain();
                return computerDomain.Name;
            }
            catch (Exception)
            {
                return Environment.UserDomainName;
            }
        }
        
        private void ServiceAccountDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.ClearErrors();
            
            if (this.DialogResult == DialogResult.OK)
            {
                if (this.Username.Length == 0)
                {
                    this.errorProvider.SetError(this.textBoxUsername, "You must provide a username.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
                else if (!this.Username.ToLower().Equals(TOMCAT_SERVICE_ACCOUNT_NAME)) 
                    //If not apachetomcat, user must exist
                {
                    if (!this.UserNameExist())
                    {
                        this.errorProvider.SetError(this.textBoxUsername, "Username doesn't exist.");
                        this.labelErrorInfo.Visible = true;
                        e.Cancel = true;
                    }
                }
                else if (this.textBoxPassword.Text.Length == 0)
                {
                    this.errorProvider.SetError(this.textBoxPassword, "You must provide a password.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
                else if (this.textBoxPassword.Text.Length < 14)
                {
                    this.errorProvider.SetError(this.textBoxPassword, "Password must be at least 14 characters in length.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
                else if (!Regex.IsMatch(this.textBoxPassword.Text, "[A-Z]")) // check for the capital char
                {
                    this.errorProvider.SetError(this.textBoxPassword, "Password must contain at least one capital letter.");
                    this.labelErrorInfo.Visible = true;
                    e.Cancel = true;
                }
                else if (!Regex.IsMatch(this.textBoxPassword.Text, "[0-9]")) // check for the number char
                {
                    this.errorProvider.SetError(this.textBoxPassword, "Password must contain at least one number character.");
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
        private void ServiceAccountDialog_Load(object sender, EventArgs e)
        {
            this.textBoxUsername.Text = TomcatFacade.ServiceAccountUsername;
            this.textBoxPassword.Text = "";
            this.textBoxConfirmPassword.Text = "";
            this.ClearErrors();
        }

        private void ClearErrors()
        {
            this.labelErrorInfo.Visible = false;
            this.errorProvider.Clear();
        }

        private void buttonCheckName_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(AccountName))
            {
                MessageBox.Show("Please enter username to check");
            }
            else if (UserNameExist())
            {
                MessageBox.Show(this.AccountName + " exists in " + AccountDomain);
            }
            else
            {
                MessageBox.Show(this.AccountName + " does not exist in " + AccountDomain);
            }
        }

        private bool UserNameExist()
        {
            string path = String.Format("WinNT://{0}/{1},user", this.AccountDomain, this.AccountName);

            try
            {
                DirectoryEntry.Exists(path);
                return true;
            }
            catch (Exception)
            {
                // For WinNT provider DirectoryEntry.Exists throws an exception
                // instead of returning false so we need to trap it.
                return false;
            }
        }

        private void buttonOK_Click(object sender, EventArgs e)
        {

        }
    }

}