using Hydra.Security;
using System;
using System.Windows.Forms;

namespace SCIP_Tool
{
    public partial class PasswordForm : Form
    {
        private readonly string TheCorrectDecryptedPwd;

        public PasswordForm(string theCorrectDecryptedPwd)
        {
            InitializeComponent();
            TheCorrectDecryptedPwd = theCorrectDecryptedPwd;
            Width = 350;
            Height = 170;
            StartPosition = FormStartPosition.CenterScreen;
            TxtPassword.Height = 30;
            LblPlainText.Visible = false;
        }

        private void BtnCancel_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.Cancel;
            Close();
        }

        private void BtnOK_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrWhiteSpace(TxtPassword.Text.Trim()))
            {
                if (TxtPassword.Text.Trim() == TheCorrectDecryptedPwd)
                {
                    DialogResult = DialogResult.OK;
                    Close();
                }
                else
                {
                    MessageBox.Show("Invalid password.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    TxtPassword.Text = "";
                }
            }
        }

        private void BtnShow_Click(object sender, EventArgs e)
        {
            if (BtnShow.Text == "Show")
            {
                LblPlainText.Text = TxtPassword.Text.Trim();
                LblPlainText.Visible = true;
                BtnShow.Text = "Hide";
            }
            else
            {
                LblPlainText.Visible = false;
                BtnShow.Text = "Show";
            }
        }
    }
}
