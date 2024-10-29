namespace SCIP_Tool
{
    partial class FormMain
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.ButtonUrlDecode = new System.Windows.Forms.Button();
            this.ButtonUrlEncode = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.txtUrlEncode = new System.Windows.Forms.TextBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.radioVixBase64 = new System.Windows.Forms.RadioButton();
            this.radioVixViewerBase64 = new System.Windows.Forms.RadioButton();
            this.ButtonDecodeB64 = new System.Windows.Forms.Button();
            this.ButtonEncodeB64 = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.txtBase64 = new System.Windows.Forms.TextBox();
            this.buttonReformatLogs = new System.Windows.Forms.Button();
            this.ButtonParseStudyResponse = new System.Windows.Forms.Button();
            this.ButtonRename = new System.Windows.Forms.Button();
            this.ButtonDicomTools = new System.Windows.Forms.Button();
            this.ButtonVistAWorker = new System.Windows.Forms.Button();
            this.ButtonImageProcessor = new System.Windows.Forms.Button();
            this.ButtonToken2 = new System.Windows.Forms.Button();
            this.ButtonSecureToken = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.radioVix = new System.Windows.Forms.RadioButton();
            this.radioVixViewer = new System.Windows.Forms.RadioButton();
            this.ButtonDecrypt = new System.Windows.Forms.Button();
            this.ButtonEncrypt = new System.Windows.Forms.Button();
            this.lblCryptoText = new System.Windows.Forms.Label();
            this.txtText = new System.Windows.Forms.TextBox();
            this.rbTiffToPdf = new System.Windows.Forms.RadioButton();
            this.rbTiffToJpeg = new System.Windows.Forms.RadioButton();
            this.lblTiffOutput = new System.Windows.Forms.Label();
            this.ButtonConvertTiff = new System.Windows.Forms.Button();
            this.ButtonTiffFolderBrowse = new System.Windows.Forms.Button();
            this.lblTiffFolder = new System.Windows.Forms.Label();
            this.txtTiffFolder = new System.Windows.Forms.TextBox();
            this.lblInfo = new System.Windows.Forms.Label();
            this.ButtonDebug = new System.Windows.Forms.Button();
            this.BtnExit = new System.Windows.Forms.Button();
            this.buttonValidateUrl = new System.Windows.Forms.Button();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Location = new System.Drawing.Point(8, 53);
            this.tabControl1.Margin = new System.Windows.Forms.Padding(2);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(640, 509);
            this.tabControl1.TabIndex = 0;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.buttonValidateUrl);
            this.tabPage1.Controls.Add(this.groupBox3);
            this.tabPage1.Controls.Add(this.groupBox2);
            this.tabPage1.Controls.Add(this.buttonReformatLogs);
            this.tabPage1.Controls.Add(this.ButtonParseStudyResponse);
            this.tabPage1.Controls.Add(this.ButtonRename);
            this.tabPage1.Controls.Add(this.ButtonDicomTools);
            this.tabPage1.Controls.Add(this.ButtonVistAWorker);
            this.tabPage1.Controls.Add(this.ButtonImageProcessor);
            this.tabPage1.Controls.Add(this.ButtonToken2);
            this.tabPage1.Controls.Add(this.ButtonSecureToken);
            this.tabPage1.Controls.Add(this.groupBox1);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Margin = new System.Windows.Forms.Padding(2);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(2);
            this.tabPage1.Size = new System.Drawing.Size(632, 483);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "VIX";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.ButtonUrlDecode);
            this.groupBox3.Controls.Add(this.ButtonUrlEncode);
            this.groupBox3.Controls.Add(this.label2);
            this.groupBox3.Controls.Add(this.txtUrlEncode);
            this.groupBox3.Location = new System.Drawing.Point(6, 359);
            this.groupBox3.Margin = new System.Windows.Forms.Padding(2);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Padding = new System.Windows.Forms.Padding(2);
            this.groupBox3.Size = new System.Drawing.Size(606, 119);
            this.groupBox3.TabIndex = 22;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "UrlEncode";
            // 
            // ButtonUrlDecode
            // 
            this.ButtonUrlDecode.Location = new System.Drawing.Point(355, 72);
            this.ButtonUrlDecode.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonUrlDecode.Name = "ButtonUrlDecode";
            this.ButtonUrlDecode.Size = new System.Drawing.Size(126, 27);
            this.ButtonUrlDecode.TabIndex = 11;
            this.ButtonUrlDecode.Text = "Decode";
            this.ButtonUrlDecode.UseVisualStyleBackColor = true;
            this.ButtonUrlDecode.Click += new System.EventHandler(this.ButtonUrlDecode_Click);
            // 
            // ButtonUrlEncode
            // 
            this.ButtonUrlEncode.Location = new System.Drawing.Point(124, 72);
            this.ButtonUrlEncode.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonUrlEncode.Name = "ButtonUrlEncode";
            this.ButtonUrlEncode.Size = new System.Drawing.Size(126, 27);
            this.ButtonUrlEncode.TabIndex = 10;
            this.ButtonUrlEncode.Text = "Encode";
            this.ButtonUrlEncode.UseVisualStyleBackColor = true;
            this.ButtonUrlEncode.Click += new System.EventHandler(this.ButtonUrlEncode_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(10, 24);
            this.label2.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(28, 13);
            this.label2.TabIndex = 9;
            this.label2.Text = "Text";
            // 
            // txtUrlEncode
            // 
            this.txtUrlEncode.Location = new System.Drawing.Point(10, 39);
            this.txtUrlEncode.Margin = new System.Windows.Forms.Padding(2);
            this.txtUrlEncode.Name = "txtUrlEncode";
            this.txtUrlEncode.Size = new System.Drawing.Size(584, 20);
            this.txtUrlEncode.TabIndex = 8;
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.radioVixBase64);
            this.groupBox2.Controls.Add(this.radioVixViewerBase64);
            this.groupBox2.Controls.Add(this.ButtonDecodeB64);
            this.groupBox2.Controls.Add(this.ButtonEncodeB64);
            this.groupBox2.Controls.Add(this.label1);
            this.groupBox2.Controls.Add(this.txtBase64);
            this.groupBox2.Location = new System.Drawing.Point(6, 237);
            this.groupBox2.Margin = new System.Windows.Forms.Padding(2);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Padding = new System.Windows.Forms.Padding(2);
            this.groupBox2.Size = new System.Drawing.Size(606, 119);
            this.groupBox2.TabIndex = 21;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Base64";
            // 
            // radioVixBase64
            // 
            this.radioVixBase64.AutoSize = true;
            this.radioVixBase64.Location = new System.Drawing.Point(10, 82);
            this.radioVixBase64.Margin = new System.Windows.Forms.Padding(2);
            this.radioVixBase64.Name = "radioVixBase64";
            this.radioVixBase64.Size = new System.Drawing.Size(55, 20);
            this.radioVixBase64.TabIndex = 14;
            this.radioVixBase64.TabStop = true;
            this.radioVixBase64.Text = "Java";
            this.radioVixBase64.UseVisualStyleBackColor = true;
            // 
            // radioVixViewerBase64
            // 
            this.radioVixViewerBase64.AutoSize = true;
            this.radioVixViewerBase64.Location = new System.Drawing.Point(10, 61);
            this.radioVixViewerBase64.Margin = new System.Windows.Forms.Padding(2);
            this.radioVixViewerBase64.Name = "radioVixViewerBase64";
            this.radioVixViewerBase64.Size = new System.Drawing.Size(57, 20);
            this.radioVixViewerBase64.TabIndex = 13;
            this.radioVixViewerBase64.TabStop = true;
            this.radioVixViewerBase64.Text = ".NET";
            this.radioVixViewerBase64.UseVisualStyleBackColor = true;
            // 
            // ButtonDecodeB64
            // 
            this.ButtonDecodeB64.Location = new System.Drawing.Point(355, 72);
            this.ButtonDecodeB64.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonDecodeB64.Name = "ButtonDecodeB64";
            this.ButtonDecodeB64.Size = new System.Drawing.Size(126, 27);
            this.ButtonDecodeB64.TabIndex = 11;
            this.ButtonDecodeB64.Text = "Decode";
            this.ButtonDecodeB64.UseVisualStyleBackColor = true;
            this.ButtonDecodeB64.Click += new System.EventHandler(this.ButtonDecodeB64_Click);
            // 
            // ButtonEncodeB64
            // 
            this.ButtonEncodeB64.Location = new System.Drawing.Point(124, 72);
            this.ButtonEncodeB64.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonEncodeB64.Name = "ButtonEncodeB64";
            this.ButtonEncodeB64.Size = new System.Drawing.Size(126, 27);
            this.ButtonEncodeB64.TabIndex = 10;
            this.ButtonEncodeB64.Text = "Encode";
            this.ButtonEncodeB64.UseVisualStyleBackColor = true;
            this.ButtonEncodeB64.Click += new System.EventHandler(this.ButtonEncodeB64_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(10, 24);
            this.label1.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(28, 13);
            this.label1.TabIndex = 9;
            this.label1.Text = "Text";
            // 
            // txtBase64
            // 
            this.txtBase64.Location = new System.Drawing.Point(10, 39);
            this.txtBase64.Margin = new System.Windows.Forms.Padding(2);
            this.txtBase64.Name = "txtBase64";
            this.txtBase64.Size = new System.Drawing.Size(584, 20);
            this.txtBase64.TabIndex = 8;
            // 
            // buttonReformatLogs
            // 
            this.buttonReformatLogs.Location = new System.Drawing.Point(18, 56);
            this.buttonReformatLogs.Margin = new System.Windows.Forms.Padding(2);
            this.buttonReformatLogs.Name = "buttonReformatLogs";
            this.buttonReformatLogs.Size = new System.Drawing.Size(80, 37);
            this.buttonReformatLogs.TabIndex = 20;
            this.buttonReformatLogs.Text = "Reformat Log Files";
            this.buttonReformatLogs.UseVisualStyleBackColor = true;
            this.buttonReformatLogs.Click += new System.EventHandler(this.buttonReformatLogs_Click);
            // 
            // ButtonParseStudyResponse
            // 
            this.ButtonParseStudyResponse.Location = new System.Drawing.Point(531, 10);
            this.ButtonParseStudyResponse.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonParseStudyResponse.Name = "ButtonParseStudyResponse";
            this.ButtonParseStudyResponse.Size = new System.Drawing.Size(80, 37);
            this.ButtonParseStudyResponse.TabIndex = 19;
            this.ButtonParseStudyResponse.Text = "Parse Study Response";
            this.ButtonParseStudyResponse.UseVisualStyleBackColor = true;
            this.ButtonParseStudyResponse.Click += new System.EventHandler(this.ButtonParseStudyResponse_Click);
            // 
            // ButtonRename
            // 
            this.ButtonRename.Location = new System.Drawing.Point(104, 10);
            this.ButtonRename.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonRename.Name = "ButtonRename";
            this.ButtonRename.Size = new System.Drawing.Size(80, 37);
            this.ButtonRename.TabIndex = 18;
            this.ButtonRename.Text = "Rename Files";
            this.ButtonRename.UseVisualStyleBackColor = true;
            this.ButtonRename.Click += new System.EventHandler(this.ButtonRename_Click);
            // 
            // ButtonDicomTools
            // 
            this.ButtonDicomTools.Location = new System.Drawing.Point(274, 10);
            this.ButtonDicomTools.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonDicomTools.Name = "ButtonDicomTools";
            this.ButtonDicomTools.Size = new System.Drawing.Size(80, 37);
            this.ButtonDicomTools.TabIndex = 17;
            this.ButtonDicomTools.Text = "DICOM Tools";
            this.ButtonDicomTools.UseVisualStyleBackColor = true;
            this.ButtonDicomTools.Click += new System.EventHandler(this.ButtonDicomTools_Click);
            // 
            // ButtonVistAWorker
            // 
            this.ButtonVistAWorker.Location = new System.Drawing.Point(189, 10);
            this.ButtonVistAWorker.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonVistAWorker.Name = "ButtonVistAWorker";
            this.ButtonVistAWorker.Size = new System.Drawing.Size(80, 37);
            this.ButtonVistAWorker.TabIndex = 16;
            this.ButtonVistAWorker.Text = "Local Image VistAWorker";
            this.ButtonVistAWorker.UseVisualStyleBackColor = true;
            this.ButtonVistAWorker.Click += new System.EventHandler(this.ButtonVistAWorker_Click);
            // 
            // ButtonImageProcessor
            // 
            this.ButtonImageProcessor.Location = new System.Drawing.Point(18, 10);
            this.ButtonImageProcessor.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonImageProcessor.Name = "ButtonImageProcessor";
            this.ButtonImageProcessor.Size = new System.Drawing.Size(80, 37);
            this.ButtonImageProcessor.TabIndex = 15;
            this.ButtonImageProcessor.Text = "Local Image Processor";
            this.ButtonImageProcessor.UseVisualStyleBackColor = true;
            this.ButtonImageProcessor.Click += new System.EventHandler(this.ButtonImageProcessor_Click);
            // 
            // ButtonToken2
            // 
            this.ButtonToken2.Location = new System.Drawing.Point(446, 10);
            this.ButtonToken2.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonToken2.Name = "ButtonToken2";
            this.ButtonToken2.Size = new System.Drawing.Size(80, 37);
            this.ButtonToken2.TabIndex = 13;
            this.ButtonToken2.Text = "Token2 (WIP)";
            this.ButtonToken2.UseVisualStyleBackColor = true;
            this.ButtonToken2.Click += new System.EventHandler(this.ButtonToken2_Click);
            // 
            // ButtonSecureToken
            // 
            this.ButtonSecureToken.Location = new System.Drawing.Point(360, 10);
            this.ButtonSecureToken.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonSecureToken.Name = "ButtonSecureToken";
            this.ButtonSecureToken.Size = new System.Drawing.Size(80, 37);
            this.ButtonSecureToken.TabIndex = 12;
            this.ButtonSecureToken.Text = "Security Token";
            this.ButtonSecureToken.UseVisualStyleBackColor = true;
            this.ButtonSecureToken.Click += new System.EventHandler(this.ButtonSecureToken_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.radioVix);
            this.groupBox1.Controls.Add(this.radioVixViewer);
            this.groupBox1.Controls.Add(this.ButtonDecrypt);
            this.groupBox1.Controls.Add(this.ButtonEncrypt);
            this.groupBox1.Controls.Add(this.lblCryptoText);
            this.groupBox1.Controls.Add(this.txtText);
            this.groupBox1.Location = new System.Drawing.Point(6, 106);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(2);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(2);
            this.groupBox1.Size = new System.Drawing.Size(606, 114);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Encryption";
            // 
            // radioVix
            // 
            this.radioVix.AutoSize = true;
            this.radioVix.Location = new System.Drawing.Point(10, 82);
            this.radioVix.Margin = new System.Windows.Forms.Padding(2);
            this.radioVix.Name = "radioVix";
            this.radioVix.Size = new System.Drawing.Size(55, 20);
            this.radioVix.TabIndex = 13;
            this.radioVix.Text = "Java";
            this.radioVix.UseVisualStyleBackColor = true;
            // 
            // radioVixViewer
            // 
            this.radioVixViewer.AutoSize = true;
            this.radioVixViewer.Checked = true;
            this.radioVixViewer.Location = new System.Drawing.Point(10, 62);
            this.radioVixViewer.Margin = new System.Windows.Forms.Padding(2);
            this.radioVixViewer.Name = "radioVixViewer";
            this.radioVixViewer.Size = new System.Drawing.Size(57, 20);
            this.radioVixViewer.TabIndex = 12;
            this.radioVixViewer.TabStop = true;
            this.radioVixViewer.Text = ".NET";
            this.radioVixViewer.UseVisualStyleBackColor = true;
            // 
            // ButtonDecrypt
            // 
            this.ButtonDecrypt.Location = new System.Drawing.Point(355, 72);
            this.ButtonDecrypt.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonDecrypt.Name = "ButtonDecrypt";
            this.ButtonDecrypt.Size = new System.Drawing.Size(126, 27);
            this.ButtonDecrypt.TabIndex = 11;
            this.ButtonDecrypt.Text = "Decrypt";
            this.ButtonDecrypt.UseVisualStyleBackColor = true;
            this.ButtonDecrypt.Click += new System.EventHandler(this.ButtonDecrypt_Click);
            // 
            // ButtonEncrypt
            // 
            this.ButtonEncrypt.Location = new System.Drawing.Point(124, 72);
            this.ButtonEncrypt.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonEncrypt.Name = "ButtonEncrypt";
            this.ButtonEncrypt.Size = new System.Drawing.Size(126, 27);
            this.ButtonEncrypt.TabIndex = 10;
            this.ButtonEncrypt.Text = "Encrypt";
            this.ButtonEncrypt.UseVisualStyleBackColor = true;
            this.ButtonEncrypt.Click += new System.EventHandler(this.ButtonEncrypt_Click);
            // 
            // lblCryptoText
            // 
            this.lblCryptoText.AutoSize = true;
            this.lblCryptoText.Location = new System.Drawing.Point(10, 24);
            this.lblCryptoText.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.lblCryptoText.Name = "lblCryptoText";
            this.lblCryptoText.Size = new System.Drawing.Size(28, 13);
            this.lblCryptoText.TabIndex = 9;
            this.lblCryptoText.Text = "Text";
            // 
            // txtText
            // 
            this.txtText.Location = new System.Drawing.Point(10, 39);
            this.txtText.Margin = new System.Windows.Forms.Padding(2);
            this.txtText.Name = "txtText";
            this.txtText.Size = new System.Drawing.Size(584, 20);
            this.txtText.TabIndex = 8;
            // 
            // rbTiffToPdf
            // 
            this.rbTiffToPdf.Location = new System.Drawing.Point(0, 0);
            this.rbTiffToPdf.Name = "rbTiffToPdf";
            this.rbTiffToPdf.Size = new System.Drawing.Size(104, 24);
            this.rbTiffToPdf.TabIndex = 0;
            // 
            // rbTiffToJpeg
            // 
            this.rbTiffToJpeg.Location = new System.Drawing.Point(0, 0);
            this.rbTiffToJpeg.Name = "rbTiffToJpeg";
            this.rbTiffToJpeg.Size = new System.Drawing.Size(104, 24);
            this.rbTiffToJpeg.TabIndex = 0;
            // 
            // lblTiffOutput
            // 
            this.lblTiffOutput.Location = new System.Drawing.Point(0, 0);
            this.lblTiffOutput.Name = "lblTiffOutput";
            this.lblTiffOutput.Size = new System.Drawing.Size(100, 23);
            this.lblTiffOutput.TabIndex = 0;
            // 
            // ButtonConvertTiff
            // 
            this.ButtonConvertTiff.Location = new System.Drawing.Point(0, 0);
            this.ButtonConvertTiff.Name = "ButtonConvertTiff";
            this.ButtonConvertTiff.Size = new System.Drawing.Size(75, 23);
            this.ButtonConvertTiff.TabIndex = 0;
            // 
            // ButtonTiffFolderBrowse
            // 
            this.ButtonTiffFolderBrowse.Location = new System.Drawing.Point(0, 0);
            this.ButtonTiffFolderBrowse.Name = "ButtonTiffFolderBrowse";
            this.ButtonTiffFolderBrowse.Size = new System.Drawing.Size(75, 23);
            this.ButtonTiffFolderBrowse.TabIndex = 0;
            // 
            // lblTiffFolder
            // 
            this.lblTiffFolder.Location = new System.Drawing.Point(0, 0);
            this.lblTiffFolder.Name = "lblTiffFolder";
            this.lblTiffFolder.Size = new System.Drawing.Size(100, 23);
            this.lblTiffFolder.TabIndex = 0;
            // 
            // txtTiffFolder
            // 
            this.txtTiffFolder.Location = new System.Drawing.Point(0, 0);
            this.txtTiffFolder.Name = "txtTiffFolder";
            this.txtTiffFolder.Size = new System.Drawing.Size(100, 20);
            this.txtTiffFolder.TabIndex = 0;
            // 
            // lblInfo
            // 
            this.lblInfo.Location = new System.Drawing.Point(14, 9);
            this.lblInfo.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.lblInfo.Name = "lblInfo";
            this.lblInfo.Size = new System.Drawing.Size(631, 42);
            this.lblInfo.TabIndex = 1;
            this.lblInfo.Text = "Info";
            // 
            // ButtonDebug
            // 
            this.ButtonDebug.Location = new System.Drawing.Point(44, 2);
            this.ButtonDebug.Margin = new System.Windows.Forms.Padding(2);
            this.ButtonDebug.Name = "ButtonDebug";
            this.ButtonDebug.Size = new System.Drawing.Size(35, 27);
            this.ButtonDebug.TabIndex = 14;
            this.ButtonDebug.Tag = "";
            this.ButtonDebug.Text = "dbg";
            this.ButtonDebug.UseVisualStyleBackColor = true;
            this.ButtonDebug.Visible = false;
            this.ButtonDebug.Click += new System.EventHandler(this.ButtonDebug_Click);
            // 
            // BtnExit
            // 
            this.BtnExit.Location = new System.Drawing.Point(583, 9);
            this.BtnExit.Margin = new System.Windows.Forms.Padding(1);
            this.BtnExit.Name = "BtnExit";
            this.BtnExit.Size = new System.Drawing.Size(58, 29);
            this.BtnExit.TabIndex = 15;
            this.BtnExit.Text = "Exit";
            this.BtnExit.UseVisualStyleBackColor = true;
            this.BtnExit.Click += new System.EventHandler(this.BtnExit_Click);
            // 
            // buttonValidateUrl
            // 
            this.buttonValidateUrl.Location = new System.Drawing.Point(102, 56);
            this.buttonValidateUrl.Margin = new System.Windows.Forms.Padding(2);
            this.buttonValidateUrl.Name = "buttonValidateUrl";
            this.buttonValidateUrl.Size = new System.Drawing.Size(80, 37);
            this.buttonValidateUrl.TabIndex = 23;
            this.buttonValidateUrl.Text = "Validate URL";
            this.buttonValidateUrl.UseVisualStyleBackColor = true;
            this.buttonValidateUrl.Click += new System.EventHandler(this.buttonValidateUrl_Click);
            // 
            // FormMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.ClientSize = new System.Drawing.Size(658, 571);
            this.ControlBox = false;
            this.Controls.Add(this.BtnExit);
            this.Controls.Add(this.ButtonDebug);
            this.Controls.Add(this.lblInfo);
            this.Controls.Add(this.tabControl1);
            this.Margin = new System.Windows.Forms.Padding(2);
            this.Name = "FormMain";
            this.Text = "SCIP_Tool";
            this.Load += new System.EventHandler(this.FormMain_Load);
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button ButtonDecrypt;
        private System.Windows.Forms.Button ButtonEncrypt;
        private System.Windows.Forms.Label lblCryptoText;
        private System.Windows.Forms.TextBox txtText;
        private System.Windows.Forms.Label lblInfo;
        private System.Windows.Forms.Label lblTiffFolder;
        private System.Windows.Forms.TextBox txtTiffFolder;
        private System.Windows.Forms.Button ButtonConvertTiff;
        private System.Windows.Forms.Button ButtonTiffFolderBrowse;
        private System.Windows.Forms.Label lblTiffOutput;
        private System.Windows.Forms.RadioButton rbTiffToPdf;
        private System.Windows.Forms.RadioButton rbTiffToJpeg;
        private System.Windows.Forms.Button ButtonDebug;
        private System.Windows.Forms.Button ButtonSecureToken;
        private System.Windows.Forms.Button ButtonToken2;
        private System.Windows.Forms.Button ButtonImageProcessor;
        private System.Windows.Forms.Button ButtonVistAWorker;
        private System.Windows.Forms.Button ButtonDicomTools;
        private System.Windows.Forms.Button ButtonRename;
        private System.Windows.Forms.Button ButtonParseStudyResponse;
        private System.Windows.Forms.Button buttonReformatLogs;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.Button ButtonDecodeB64;
        private System.Windows.Forms.Button ButtonEncodeB64;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtBase64;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.Button ButtonUrlDecode;
        private System.Windows.Forms.Button ButtonUrlEncode;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtUrlEncode;
        private System.Windows.Forms.RadioButton radioVix;
        private System.Windows.Forms.RadioButton radioVixViewer;
        private System.Windows.Forms.RadioButton radioVixBase64;
        private System.Windows.Forms.RadioButton radioVixViewerBase64;
        private System.Windows.Forms.Button BtnExit;
        private System.Windows.Forms.Button buttonValidateUrl;
    }
}

