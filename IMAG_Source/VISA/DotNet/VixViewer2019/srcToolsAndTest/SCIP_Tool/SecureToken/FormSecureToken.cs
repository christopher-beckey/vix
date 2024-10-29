using Hydra.Security;
using System;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace SCIP_Tool
{
    public partial class FormSecureToken: Form
    {
        private SecurityToken _securityToken;

        public FormSecureToken()
        {
            InitializeComponent();
            //this.Width = 675;
            //this.Height = 411;
            this.StartPosition = FormStartPosition.CenterScreen;
            ResetLabelInfo();
            tbToken.Enabled = true;
            ButtonClose.Enabled = true;
        }

        #region Form Controls

        private void FormSecureToken_Load(object sender, EventArgs e)
        {
        }

        private void ButtonGo_Click(object sender, EventArgs e)
        {
            lblInfo.Text = "";

            if (string.IsNullOrWhiteSpace(tbToken.Text))
            {
                UIError("ERROR:  Please enter a security token, or use the example.");
                return;
            }
            int len = tbToken.Text.Length;
            if ((len % 4) != 0)
            {
                UIError(string.Format($"ERROR: The token's length is {len}. It must be evenly divisible by 4."));
                return;
            }
            string base64String = tbToken.Text;
            if (base64String.Contains("%"))
                base64String = System.Net.WebUtility.UrlDecode(base64String);
            if (base64String.Contains("-") || base64String.Contains("_"))
                base64String = base64String.Replace('-', '+').Replace('_', '/'); //modified - see 
            //TODO temp if (!Hydra.IX.Common.SecurityToken.TryParse(tbToken.Text, out _securityToken))
            if (!SecurityToken.TryParse(base64String, out _securityToken))
            {
                try
                {
                    byte[] byteArray = Convert.FromBase64String(base64String);
                    string result = System.Text.Encoding.UTF8.GetString(byteArray);
                    //TODO-now what!?!
                    UIError("ERROR:  The security token has an invalid format. Error code: 1001.");
                }
                catch (Exception ex)
                {
                    var msg = ex.Message;
                    UIError($"ERROR:  The security token has an invalid format. Error code: 1002. {msg}");
                }
                return;
            }
            tbOutput.Text = SecurityTokenToText();
        }

        private void ButtonClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void ButtonUseTokenExample_Click(object sender, EventArgs e)
        {
            tbToken.Text = SecurityUtil.ExampleVVToken;
        }

        #endregion Form Controls

        private void ResetLabelInfo()
        {
            this.lblInfo.Text = "";
            this.lblInfo.ForeColor = Color.Black;
        }

        private void UIError(string msg)
        {
            this.lblInfo.Text = msg;
            this.lblInfo.ForeColor = Color.Red;
        }

        private string SecurityTokenToText()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("Expired? ");
            if (_securityToken.IsExpired)
                sb.Append("Yes  ");
            else
                sb.Append("No  ");
            sb.Append("Expiry: ");
            sb.Append(_securityToken.TimeExpiry.ToString("MM/dd/yyyy hh:mm tt"));
            sb.Append(Environment.NewLine);
            sb.Append("UserId: ");
            if (string.IsNullOrWhiteSpace(_securityToken.UserId))
                sb.Append("Unknown");
            else
                sb.Append(_securityToken.UserId);
            sb.Append(Environment.NewLine);
            //sb.Append("TokenId: ");
            //if (string.IsNullOrWhiteSpace(_securityToken.TokenId))
            //sb.Append("Unknown");
            //else
            //    sb.Append(_securityToken.TokenId);
            //sb.Append(Environment.NewLine);
            //sb.Append("Signature: ");
            //if (string.IsNullOrWhiteSpace(_securityToken.Signature))
            //sb.Append("Unknown");
            //else
            //    sb.Append(_securityToken.Signature);
            //sb.Append(Environment.NewLine);
            sb.Append("Java security token: ");
            if (string.IsNullOrWhiteSpace(_securityToken.Data))
            {
                sb.Append("Unknown");
                sb.Append(Environment.NewLine);
            }
            else
            {
                sb.Append(_securityToken.Data);
                sb.Append(Environment.NewLine);
                sb.Append("  FIELDS (Decrypted from Java security token)");
                sb.Append(Environment.NewLine);
                string fields = Common.DecryptJavaString(_securityToken.Data);
                string[] f = fields.Split(new string[] { "||" }, StringSplitOptions.None);
                string nl = Environment.NewLine;
                //fullName||duz||ssn||siteName||siteNumber||brokerSecurityToken||accessCode||verifyCode||securityTokenApplicationName||...?...||JavaTokenExpiration
                if (f.Length >= 1) sb.Append($"    fullName; {f[0]}{nl}");
                if (f.Length >= 2) sb.Append($"    duz: {f[1]}{nl}");
                if (f.Length >= 3) sb.Append($"    ssn: {f[2]}{nl}");
                if (f.Length >= 4) sb.Append($"    siteName: {f[3]}{nl}");
                if (f.Length >= 5) sb.Append($"    siteNumber: {f[4]}{nl}");
                if (f.Length >= 6) sb.Append($"    brokerSecurityToken (BSE): {f[5]}{nl}");
                if (f.Length >= 7) sb.Append($"    accessCode: {f[6]}{nl}");
                if (f.Length >= 8) sb.Append($"    verifyCode: {f[7]}{nl}");
                if (f.Length >= 9) sb.Append($"    securityTokenApplicationName: {f[8]}{nl}");
                if (f.Length >= 10)
                {
                    var dt = DateTimeOffset.FromUnixTimeMilliseconds(long.Parse(f[9])).UtcDateTime;
                    sb.Append($"    javaSecurityTokenExpiration: {dt}{nl}");
                }
            }
            return sb.ToString();
            }
    }
}
