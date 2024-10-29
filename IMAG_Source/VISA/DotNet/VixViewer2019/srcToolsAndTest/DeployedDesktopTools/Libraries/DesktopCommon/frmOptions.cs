using Hydra.Security;
using System;
using System.Windows.Forms;

namespace DesktopCommon
{
    public partial class frmOptions : Form
    {
        public frmOptions()
        {
            InitializeComponent();
            this.ControlBox = false; // Hide the "X" to close the form
            txtAccessCode.Text = Utils.AccessCodeEncrypted;
            txtVerifyCode.Text = Utils.VerifyCodeEncrypted;
            txtLogFileFolderPath.Text = Utils.LogDir;
            txtSiteService.Text = Utils.SiteService;
            if (Utils.Delimiter == "Tab")
            {
                rbTab.Checked = true;
                rbComma.Checked = false;
            }
            else
            {
                rbTab.Checked = false;
                rbComma.Checked = true;
            }
        }

        private void btnSaveAndClose_Click(object sender, EventArgs e)
        {
            if (!CryptoUtil.IsEncrypted(txtAccessCode.Text))
                txtAccessCode.Text = CryptoUtil.EncryptAES(txtAccessCode.Text);
            if (!CryptoUtil.IsEncrypted(txtVerifyCode.Text))
                txtVerifyCode.Text = CryptoUtil.EncryptAES(txtVerifyCode.Text);

            Utils.AccessCodeEncrypted = txtAccessCode.Text;
            Utils.VerifyCodeEncrypted = txtVerifyCode.Text;
            Utils.SiteService = txtSiteService.Text;
            if (rbTab.Checked)
                Utils.Delimiter = "Tab";
            else
                Utils.Delimiter = "Comma";
            Utils.LogDir = txtLogFileFolderPath.Text;
            Utils.WriteConfig();
            Close();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void txtAccessCode_MouseHover(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtAccessCode.Text))
                return;
            TextBox TB = (TextBox)sender;
            int VisibleTime = 3000;  //milliseconds
            string decrypted = CryptoUtil.DecryptAES(txtAccessCode.Text);
            ToolTip tt = new ToolTip();
            tt.Show(decrypted, TB, 10, 10, VisibleTime);
        }

        private void txtVerifyCode_MouseHover(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtVerifyCode.Text))
                return;
            TextBox TB = (TextBox)sender;
            int VisibleTime = 3000;  //milliseconds
            string decrypted = CryptoUtil.DecryptAES(txtVerifyCode.Text);
            ToolTip tt = new ToolTip();
            tt.Show(decrypted, TB, 10, 10, VisibleTime);
        }
    }
}
