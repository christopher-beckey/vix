using Hydra.Globals;
using Hydra.Security;
using Hydra.VistA;
using System;
using System.Drawing;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Windows.Forms;

namespace SCIP_Tool
{
    public partial class FormMain : Form
    {
        private readonly bool OkToContinue = true;
        private readonly string TEXT_REQUIRED = "Please enter Text for Encryption/Decryption";
        private readonly string TEXT_REQUIRED2 = "Please enter Text for Base64";
        private readonly string vixViewerConfigPath;

        private void FormMain_Load(object sender, EventArgs e)
        {
            if (OkToContinue)
            {
                using (PasswordForm frm = new PasswordForm(Config.VixUtilPassword))
                {
                    DialogResult result = frm.ShowDialog(this); //waits here until the form closes (but still loaded in memory)
                    if (result != DialogResult.OK)
                    {
                        Environment.Exit(2); //the user cancelled
                    }
                    //all is well, no-op (continues to normal MainForm operations)
                }
            }
        }

        public FormMain()
        {
            InitializeComponent();
            Width = 675;
            Height = 451;
            StartPosition = FormStartPosition.CenterScreen;
            ResetLabelInfo();
            radioVixViewer.Checked = true;
            radioVixViewerBase64.Checked = true;
            string statusMsg = "";
            try
            {
                //VAI-780: For Debug config, assume local dev machine (src or ..). For Release config, assume deployed machine (program files).
#if DEBUG
                vixViewerConfigPath = @"..\..\..\..\..\src\VIX.Viewer.Service\VIX.Viewer.config"; //what happens when we are running in Visual Studio
                if (!File.Exists(Path.GetFullPath(vixViewerConfigPath)))
                    vixViewerConfigPath = @"..\VIX.Viewer.config"; //in case someone copied the Debug SCIP_Tool bin folder to VIX.Viewer.Service $(TargetDir)
#else
                vixViewerConfigPath =  @"C:\Program Files\VistA\Imaging\Vix.Config\Vix.Viewer.config";
#endif
                VistAConfigurationSection.Initialize(Path.GetFullPath(vixViewerConfigPath));
                VixServiceUtil.Initialize(); //VAI-848/VAI-903: Refactoring
                if (string.IsNullOrWhiteSpace(Config.VixUtilPassword))
                    statusMsg = "File read or decryption failure.";
            }
            catch (Exception ex)
            {
                statusMsg = ex.ToString();
            }
            if (!string.IsNullOrWhiteSpace(statusMsg))
            {
                MessageBox.Show($"Unable to get UtilPwd from VIX.Viewer.config file.{Environment.NewLine}{Environment.NewLine}{vixViewerConfigPath}{Environment.NewLine}{statusMsg}");
                OkToContinue = false;
                Close();
            }
        }

        private void ButtonEncrypt_Click(object sender, EventArgs e)
        {
            ResetLabelInfo();
            if (string.IsNullOrWhiteSpace(txtText.Text))
                UIError(TEXT_REQUIRED);
            else
            {
                //We no longer use 3DES, and we use AES, both from .NET and Java
                if (radioVixViewer.Checked)
                    txtText.Text = CryptoUtil.EncryptAES(txtText.Text);
                else
                {
                    string result = SecurityUtil.FromVixJava("encrypt", txtText.Text, out string errorMessage); //VAI-903
                    if (string.IsNullOrWhiteSpace(result))
                        txtText.Text = errorMessage;
                    else
                        txtText.Text = result;
                }
            }
        }


        //Mimicing code from IMAG_Source\VISA\Java\ImagingCommon\main\src\java\gov\va\med\imaging\encryption\AesEncryption.java
        private string EncryptFromJava<TSymmetricAlgorithm>(string seed, string input) where TSymmetricAlgorithm : SymmetricAlgorithm, new()
        {
            var pwdBytes = Encoding.UTF8.GetBytes(seed);
            using (TSymmetricAlgorithm sa = new TSymmetricAlgorithm())
            {
                ICryptoTransform saEnc = sa.CreateEncryptor(pwdBytes, pwdBytes);

                var encBytes = Encoding.UTF8.GetBytes(input);

                var resultBytes = saEnc.TransformFinalBlock(encBytes, 0, encBytes.Length);

                return Convert.ToBase64String(resultBytes);
            }
        }

        private void ButtonDecrypt_Click(object sender, EventArgs e)
        {
            ResetLabelInfo();
            if (string.IsNullOrWhiteSpace(txtText.Text))
                UIError(TEXT_REQUIRED);
            else
            {
                try
                {
                    //We no longer use 3DES, and we use AES, both from .NET and Java
                    if (radioVixViewer.Checked)
                        txtText.Text = CryptoUtil.DecryptAES(txtText.Text);
                    else
                    {
                        txtText.Text = Common.DecryptJavaString(txtText.Text);
                    }
                }
                catch (Exception ex)
                {
                    UIError(ex.InnerException.ToString());
                }
            }
        }

        private void ResetLabelInfo()
        {
            lblInfo.Text = "";
            lblInfo.ForeColor = Color.Black;
        }

        private void UIError(string msg)
        {
            lblInfo.Text = msg;
            lblInfo.ForeColor = Color.Red;
        }

        private void ButtonDebug_Click(object sender, EventArgs e)
        {
            MessageBox.Show(string.Format("Width = {0}, Height = {1}", Width, Height));
        }

        //private void buttonTiff_Click(object sender, EventArgs e)
        //{
        //    var form = new FormTiff();
        //    form.ShowDialog();
        //}

        private void ButtonSecureToken_Click(object sender, EventArgs e)
        {
            var form = new FormSecureToken();
            form.ShowDialog();
        }

        private void ButtonToken2_Click(object sender, EventArgs e)
        {
            var form = new FormToken2();
            form.ShowDialog();
        }

        //private void ButtonDicom_Click(object sender, EventArgs e)
        //{
        //    var form = new SCIP_Tool.Dicom.FormDicom();
        //    form.ShowDialog();
        //}

        private void ButtonImageProcessor_Click(object sender, EventArgs e)
        {
            var form = new SCIP_Tool.FormImage();
            form.ShowDialog();
        }

        private void ButtonVistAWorker_Click(object sender, EventArgs e)
        {
            var form = new ImageVistAWorker.Form1();
            form.ShowDialog();
        }

        private void ButtonDicomTools_Click(object sender, EventArgs e)
        {
            var form = new SCIP_Tool.FormDicom();
            form.ShowDialog();
        }

        private void ButtonRename_Click(object sender, EventArgs e)
        {
            var form = new SCIP_Tool.FormRenamer();
            form.ShowDialog();
        }

        private void ButtonParseStudyResponse_Click(object sender, EventArgs e)
        {
            var form = new SCIP_Tool.FormStudy();
            form.ShowDialog();
        }

        private void buttonReformatLogs_Click(object sender, EventArgs e)
        {
            var form = new SCIP_Tool.FormReformatLogs();
            form.ShowDialog();
        }

        private void ButtonEncodeB64_Click(object sender, EventArgs e)
        {
            ResetLabelInfo();
            if (string.IsNullOrWhiteSpace(txtBase64.Text))
                UIError(TEXT_REQUIRED2);
            else
            {
                txtBase64.Text = Util.Base64Encode(txtBase64.Text);
            }
        }

        private void ButtonDecodeB64_Click(object sender, EventArgs e)
        {
            ResetLabelInfo();
            if (string.IsNullOrWhiteSpace(txtBase64.Text))
                UIError(TEXT_REQUIRED2);
            else
            {

                if (radioVixViewerBase64.Checked)
                {
                    var base64EncodedBytes = System.Convert.FromBase64String(txtBase64.Text);
                    txtBase64.Text = System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
                }
                else
                {
                    string base64String = SecurityUtil.DecodeEncodedBase64(txtBase64.Text);
                    var base64EncodedBytes = System.Convert.FromBase64String(base64String);
                    txtBase64.Text = System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
                }
            }
        }

        private void ButtonUrlEncode_Click(object sender, EventArgs e)
        {
            ResetLabelInfo();
            if (string.IsNullOrWhiteSpace(txtUrlEncode.Text))
                UIError(TEXT_REQUIRED2);
            else
            {
                txtUrlEncode.Text = HttpUtility.UrlEncode(txtUrlEncode.Text);
            }
        }

        private void ButtonUrlDecode_Click(object sender, EventArgs e)
        {
            ResetLabelInfo();
            if (string.IsNullOrWhiteSpace(txtUrlEncode.Text))
                UIError(TEXT_REQUIRED2);
            else
            {
                txtUrlEncode.Text = HttpUtility.UrlDecode(txtUrlEncode.Text);
            }
        }

        private void BtnExit_Click(object sender, EventArgs e)
        {
            Environment.Exit(0);
        }

        private void buttonValidateUrl_Click(object sender, EventArgs e)
        {
            var form = new SCIP_Tool.FormValidateUrl();
            form.ShowDialog();
        }
    }
}
