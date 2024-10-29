using Hydra.Security;
using System;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

using HC = Hydra.Common;

namespace SCIP_Tool
{
    public partial class FormValidateUrl: Form
    {
        public FormValidateUrl()
        {
            InitializeComponent();
            this.StartPosition = FormStartPosition.CenterScreen;
            ResetLabelInfo();
            tbUrl.Enabled = true;
            ButtonClose.Enabled = true;
        }

        #region Form Controls

        private void FormValidateUrl_Load(object sender, EventArgs e)
        {
        }

        private void ButtonGo_Click(object sender, EventArgs e)
        {
            lblInfo.Text = "";

            if (string.IsNullOrWhiteSpace(tbUrl.Text))
            {
                UIError("ERROR:  Please enter a URL, or use the example.");
                return;
            }
            string validUrl = "";
            string testUrl = tbUrl.Text;
            try
            {
                validUrl = SecurityUtil.GetValidUrl(testUrl);
                if (string.IsNullOrWhiteSpace(validUrl))
                    validUrl = "INVALID!";
                if (validUrl == testUrl)
                    validUrl = "VALID.";
            }
            catch (Exception ex)
            {
                UIError(ex.ToString());
            }
            tbOutput.Text = validUrl;
        }

        private void ButtonClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void ButtonUseTokenExample_Click(object sender, EventArgs e)
        {
            tbUrl.Text = $"https://{HC.Util.GetFqdn()}:343/vix/api/images?Format=Abstract&ImageUid=35b94cb7-2144-42a1-86ee-7db846766048&SecurityToken=MjAyMy0wNi0wNlQwNDowMDowMC4wMDAwMDAwWnw0emZHTTUzOGE2QWcwZmRzRTZOX3ptVlVod2U4VGVlRV9RWkoyUWUzWVNKY21MVkUyNmphRjdoUUdaQXNJdFFZLXEzMmw1WU82YWRwLWo5VVR1MXhSTTJvWFVZOThNRHphMTk4TldzSGlLUWJ2ejJkLURKemVsWnRZRV9Ma3FILTQyQXgzQkxWV3lHTUhTUlhYV2M9fDIwMDk1fDAyYjkzMmE3LWUyNDAtNDBmYi04NzQ1LWNjZmRlMDgyYWQ1Nnx0bDhxc2JWaElvd2ZPQ29rQ0IzdnZWY2liNFZrWjB2QXRnR0oyREZDcnlhVFA2MjFndFVmbWxjZ2pGRHhhUTE1UDB4L2VQdDhWTlJZRDYxQkxhL1d5M1Vqc2REZjdGZmJoRHU3UDJZOWo5OD0%3D&RequestId=1685971349807&ts=1685971350631";
        }

        private void button1_Click(object sender, EventArgs e)
        {
            tbUrl.Text = $"https://vaec.silver.cvx.va.gov:343/vix/api/images?Format=Frame&ImageUid=3c7c69e6-89b1-410d-95cd-f608c048d0b3&FrameNumber=0&Transform=Jpeg&SecurityToken=foo&RequestId=1689781930828&excludeImageInfo=false&ts=1689781930829";
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
    }
}
