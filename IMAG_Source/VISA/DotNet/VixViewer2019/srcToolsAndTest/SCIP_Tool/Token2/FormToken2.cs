using System;
using System.Drawing;
using System.IO;
using System.Net;
//TODO using System.Net.Http;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Windows.Forms;

namespace SCIP_Tool
{
    public partial class FormToken2 : Form
    {
        //private string cerFilePath = "";
        private string certNumber = "9b17e392840a9dde4eaa48625a07ffa08a22de17";
        //private readonly string logFilePath = "";
        //private readonly StringBuilder sb = new StringBuilder();

        public FormToken2()
        {
            InitializeComponent();
            ResetLabelInfo();
            TextCertNumber.Text = certNumber;
            TextUserId.Text = "Testing";
            TextAppName.Text = "iMedConsentWeb";
            string hostName = System.Net.Dns.GetHostEntry("").HostName;
            TextURL.Text = string.Format("https://{0}:7344/vix/viewer/token2", hostName);
            //ButtonCerFileBrowse.Top = txtCertNumber.Top;
        }

        #region Form Controls

        private void ButtonClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void TextCertNumber_TextChanged(object sender, EventArgs e)
        {
            certNumber = TextCertNumber.Text;
            //CheckAndSetCerFile(txtCerFilePath.Text);
        }

        private void ButtonSendToken2_Click(object sender, EventArgs e)
        {
            //if (string.IsNullOrWhiteSpace(cerFilePath))
            //{
            //    UIError("Please enter or browse to a .cer file");
            //}
            if (string.IsNullOrWhiteSpace(certNumber))
            {
                UIError("Please enter a certifcate number");
            }
            else
            {
                ResetLabelInfo();
                try
                {
                    TextOutput.Text = "Sending request, please wait ...";

                    ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
                    //ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls13;

                    // Create a web request that points to our SSL-enabled client certificate required web site
                    HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(TextURL.Text);
                    //request.ContentType = "text/json";
                    request.Method = WebRequestMethods.Http.Get;
                    //request.Accept = "application/json; charset=utf-8";
                    request.KeepAlive = true;
                    request.ProtocolVersion = HttpVersion.Version10;
                    request.ServicePoint.ConnectionLimit = 24;
                    request.ContentLength = 0;

                    // Get a handle to the local certificate stores. "My" is the "Personal" store.  Search for our certificate.
                    X509Store store = new X509Store(StoreName.My, StoreLocation.LocalMachine);
                    store.Open(OpenFlags.ReadOnly);
                    X509Certificate2Collection collection = store.Certificates.Find(X509FindType.FindByThumbprint, TextCertNumber.Text, true);
                    request.ClientCertificates = collection;
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    request.Headers.Add("userid", TextUserId.Text);
                    request.Headers.Add("appname", TextAppName.Text);

                    string resp;
                    using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                    {
                        using (Stream stream = response.GetResponseStream())
                        {
                            using (StreamReader sr = new StreamReader(stream))
                            {
                                resp = sr.ReadToEnd();
                            }
                        }
                    }

                    TextOutput.Text = resp;
                }
                catch (Exception ex)
                {
                    //UIError(ex.ToString());
                    TextOutput.Text = ex.ToString();
                }
                ButtonClose.Enabled = true;
                ButtonClear.Enabled = true;
            }
        }

        //private void ButtonCerFileBrowse_Click(object sender, EventArgs e)
        //{
        //    OpenFileDialog ofd = new OpenFileDialog();
        //    ofd.Filter = "All files(*.*) | *.*";
        //    ofd.FilterIndex = 1;
        //    ofd.Multiselect = false;

        //    if (ofd.ShowDialog() == DialogResult.OK)
        //    {
        //        CheckAndSetCerFile(ofd.FileName);
        //    }
        //}

        private void ButtonCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void ButtonClear_Click(object sender, EventArgs e)
        {
            TextOutput.Text = "";
        }
        #endregion Form Controls

        //private void LogTheLine(string theLine)
        //{
        //    if (!File.Exists(logFilePath))
        //    {
        //        using (StreamWriter sw = File.CreateText(logFilePath))
        //        {
        //            sw.WriteLine(DateTime.Now.ToString("yyyyddMHHmmss") + "\t" + theLine.TrimEnd('\r', '\n'));
        //        }
        //    }
        //    else
        //    {
        //        using (StreamWriter sw = File.AppendText(logFilePath))
        //        {
        //            sw.WriteLine(DateTime.Now.ToString("yyyyddMHHmmss") + "\t" + theLine.TrimEnd('\r', '\n'));
        //        }
        //    }
        //}

        private void ResetLabelInfo()
        {
            this.LabelInfo.Text = "";
            this.LabelInfo.ForeColor = Color.Black;
        }

        private void UIError(string msg)
        {
            this.LabelInfo.Text = msg;
            this.LabelInfo.ForeColor = Color.Red;
        }

        //private void CheckAndSetCerFile(string filePath)
        //{
        //    if (File.Exists(filePath))
        //    {
        //        cerFilePath = filePath;
        //        txtCertNumber.Text = filePath;
        //    }
        //    else
        //    {
        //        UIError(string.Format($"{filePath} does not exist"));
        //    }
        //}
    }
}
