
namespace DesktopCommon
{
    partial class frmOptions
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
            this.label2 = new System.Windows.Forms.Label();
            this.txtAccessCode = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.txtVerifyCode = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.txtLogFileFolderPath = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.txtSiteService = new System.Windows.Forms.TextBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.rbTab = new System.Windows.Forms.RadioButton();
            this.rbComma = new System.Windows.Forms.RadioButton();
            this.panel1 = new System.Windows.Forms.Panel();
            this.btnCancel = new System.Windows.Forms.Button();
            this.btnSaveAndClose = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(16, 14);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(70, 13);
            this.label2.TabIndex = 7;
            this.label2.Text = "Access Code";
            // 
            // txtAccessCode
            // 
            this.txtAccessCode.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtAccessCode.Location = new System.Drawing.Point(16, 31);
            this.txtAccessCode.Name = "txtAccessCode";
            this.txtAccessCode.Size = new System.Drawing.Size(232, 20);
            this.txtAccessCode.TabIndex = 6;
            this.txtAccessCode.MouseHover += new System.EventHandler(this.txtAccessCode_MouseHover);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(265, 14);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(61, 13);
            this.label1.TabIndex = 9;
            this.label1.Text = "Verify Code";
            // 
            // txtVerifyCode
            // 
            this.txtVerifyCode.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtVerifyCode.Location = new System.Drawing.Point(265, 31);
            this.txtVerifyCode.Name = "txtVerifyCode";
            this.txtVerifyCode.Size = new System.Drawing.Size(296, 20);
            this.txtVerifyCode.TabIndex = 8;
            this.txtVerifyCode.MouseHover += new System.EventHandler(this.txtVerifyCode_MouseHover);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(13, 76);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(169, 13);
            this.label3.TabIndex = 11;
            this.label3.Text = "Downloaded Log Files Folder Path";
            // 
            // txtLogFileFolderPath
            // 
            this.txtLogFileFolderPath.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtLogFileFolderPath.Location = new System.Drawing.Point(13, 93);
            this.txtLogFileFolderPath.Name = "txtLogFileFolderPath";
            this.txtLogFileFolderPath.Size = new System.Drawing.Size(548, 20);
            this.txtLogFileFolderPath.TabIndex = 10;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(13, 139);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(64, 13);
            this.label4.TabIndex = 13;
            this.label4.Text = "Site Service";
            // 
            // txtSiteService
            // 
            this.txtSiteService.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.txtSiteService.Location = new System.Drawing.Point(13, 156);
            this.txtSiteService.Name = "txtSiteService";
            this.txtSiteService.Size = new System.Drawing.Size(548, 20);
            this.txtSiteService.TabIndex = 12;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.rbTab);
            this.groupBox1.Controls.Add(this.rbComma);
            this.groupBox1.Location = new System.Drawing.Point(584, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(119, 77);
            this.groupBox1.TabIndex = 14;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Default Delimiter";
            // 
            // rbTab
            // 
            this.rbTab.AutoSize = true;
            this.rbTab.Location = new System.Drawing.Point(7, 47);
            this.rbTab.Name = "rbTab";
            this.rbTab.Size = new System.Drawing.Size(51, 20);
            this.rbTab.TabIndex = 1;
            this.rbTab.TabStop = true;
            this.rbTab.Text = "Tab";
            this.rbTab.UseVisualStyleBackColor = true;
            // 
            // rbComma
            // 
            this.rbComma.AutoSize = true;
            this.rbComma.Location = new System.Drawing.Point(7, 20);
            this.rbComma.Name = "rbComma";
            this.rbComma.Size = new System.Drawing.Size(67, 20);
            this.rbComma.TabIndex = 0;
            this.rbComma.TabStop = true;
            this.rbComma.Text = "Comma";
            this.rbComma.UseVisualStyleBackColor = true;
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.btnCancel);
            this.panel1.Controls.Add(this.btnSaveAndClose);
            this.panel1.Controls.Add(this.groupBox1);
            this.panel1.Controls.Add(this.txtAccessCode);
            this.panel1.Controls.Add(this.label4);
            this.panel1.Controls.Add(this.label2);
            this.panel1.Controls.Add(this.txtSiteService);
            this.panel1.Controls.Add(this.txtVerifyCode);
            this.panel1.Controls.Add(this.label3);
            this.panel1.Controls.Add(this.label1);
            this.panel1.Controls.Add(this.txtLogFileFolderPath);
            this.panel1.Location = new System.Drawing.Point(12, 12);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(718, 249);
            this.panel1.TabIndex = 15;
            // 
            // btnCancel
            // 
            this.btnCancel.Location = new System.Drawing.Point(375, 200);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(103, 33);
            this.btnCancel.TabIndex = 16;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnSaveAndClose
            // 
            this.btnSaveAndClose.Location = new System.Drawing.Point(246, 200);
            this.btnSaveAndClose.Name = "btnSaveAndClose";
            this.btnSaveAndClose.Size = new System.Drawing.Size(103, 33);
            this.btnSaveAndClose.TabIndex = 15;
            this.btnSaveAndClose.Text = "Save and Close";
            this.btnSaveAndClose.UseVisualStyleBackColor = true;
            this.btnSaveAndClose.Click += new System.EventHandler(this.btnSaveAndClose_Click);
            // 
            // frmOptions
            // 
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
            this.ClientSize = new System.Drawing.Size(742, 273);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmOptions";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Options";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtAccessCode;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtVerifyCode;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtLogFileFolderPath;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtSiteService;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.RadioButton rbTab;
        private System.Windows.Forms.RadioButton rbComma;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.Button btnSaveAndClose;
    }
}