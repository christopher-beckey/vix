namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class CertFileSaveDialog
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
            this.components = new System.ComponentModel.Container();
            this.labelTip = new System.Windows.Forms.Label();
            this.textBoxCert = new System.Windows.Forms.TextBox();
            this.buttonCertFile = new System.Windows.Forms.Button();
            this.buttonOK = new System.Windows.Forms.Button();
            this.buttonCancel = new System.Windows.Forms.Button();
            this.labelErrorInfo = new System.Windows.Forms.Label();
            this.saveCertFileDialog = new System.Windows.Forms.SaveFileDialog();
            this.errorProvider = new gov.va.med.imaging.exchange.VixInstaller.ui.ErrorProviderFixed(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).BeginInit();
            this.SuspendLayout();
            // 
            // labelTip
            // 
            this.labelTip.AutoSize = true;
            this.labelTip.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelTip.Location = new System.Drawing.Point(31, 9);
            this.labelTip.Name = "labelTip";
            this.labelTip.Size = new System.Drawing.Size(262, 20);
            this.labelTip.TabIndex = 0;
            this.labelTip.Text = "Select/Enter the JKS filename";
            this.labelTip.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.labelTip.Click += new System.EventHandler(this.label4_Click);
            // 
            // textBoxCert
            // 
            this.textBoxCert.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.textBoxCert.BackColor = System.Drawing.SystemColors.Control;
            this.textBoxCert.Location = new System.Drawing.Point(65, 39);
            this.textBoxCert.MinimumSize = new System.Drawing.Size(339, 22);
            this.textBoxCert.Multiline = true;
            this.textBoxCert.Name = "textBoxCert";
            this.textBoxCert.ReadOnly = true;
            this.textBoxCert.Size = new System.Drawing.Size(356, 80);
            this.textBoxCert.TabIndex = 0;
            this.textBoxCert.TabStop = false;
            // 
            // buttonCertFile
            // 
            this.buttonCertFile.Location = new System.Drawing.Point(4, 39);
            this.buttonCertFile.Name = "buttonCertFile";
            this.buttonCertFile.Size = new System.Drawing.Size(55, 23);
            this.buttonCertFile.TabIndex = 1;
            this.buttonCertFile.Text = "Select";
            this.buttonCertFile.UseVisualStyleBackColor = true;
            this.buttonCertFile.Click += new System.EventHandler(this.buttonCertFile_Click);
            // 
            // buttonOK
            // 
            this.buttonOK.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonOK.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.buttonOK.Location = new System.Drawing.Point(265, 125);
            this.buttonOK.Name = "buttonOK";
            this.buttonOK.Size = new System.Drawing.Size(75, 23);
            this.buttonOK.TabIndex = 2;
            this.buttonOK.Text = "OK";
            this.buttonOK.UseVisualStyleBackColor = true;
            // 
            // buttonCancel
            // 
            this.buttonCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.buttonCancel.Location = new System.Drawing.Point(346, 125);
            this.buttonCancel.Name = "buttonCancel";
            this.buttonCancel.Size = new System.Drawing.Size(75, 23);
            this.buttonCancel.TabIndex = 3;
            this.buttonCancel.Text = "Cancel";
            this.buttonCancel.UseVisualStyleBackColor = true;
            // 
            // labelErrorInfo
            // 
            this.labelErrorInfo.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.labelErrorInfo.AutoSize = true;
            this.labelErrorInfo.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelErrorInfo.Location = new System.Drawing.Point(1, 132);
            this.labelErrorInfo.Name = "labelErrorInfo";
            this.labelErrorInfo.Size = new System.Drawing.Size(296, 20);
            this.labelErrorInfo.TabIndex = 0;
            this.labelErrorInfo.Text = "Mouse over the icon to view error.";
            this.labelErrorInfo.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.labelErrorInfo.Visible = false;
            // 
            // saveCertFileDialog
            // 
            this.saveCertFileDialog.Filter = "Java Key Store files (*.jks)|*.jks|All files (*.*)|*.*\"";
            this.saveCertFileDialog.RestoreDirectory = true;
            this.saveCertFileDialog.Title = "Select/Enter JKS file";
            // 
            // errorProvider
            // 
            this.errorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink;
            this.errorProvider.ContainerControl = this;
            // 
            // CertFileSaveDialog
            // 
            this.AcceptButton = this.buttonOK;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.buttonCancel;
            this.ClientSize = new System.Drawing.Size(456, 160);
            this.ControlBox = false;
            this.Controls.Add(this.labelErrorInfo);
            this.Controls.Add(this.buttonOK);
            this.Controls.Add(this.buttonCancel);
            this.Controls.Add(this.buttonCertFile);
            this.Controls.Add(this.textBoxCert);
            this.Controls.Add(this.labelTip);
            this.MinimumSize = new System.Drawing.Size(447, 143);
            this.Name = "CertFileSaveDialog";
            this.Text = "Select JKS file";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.CertFileDialog_FormClosing);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label labelTip;
        private System.Windows.Forms.TextBox textBoxCert;
        private System.Windows.Forms.Button buttonCertFile;
        private System.Windows.Forms.Button buttonOK;
        private System.Windows.Forms.Button buttonCancel;
        private System.Windows.Forms.Label labelErrorInfo;
        private ErrorProviderFixed errorProvider;
        private System.Windows.Forms.SaveFileDialog saveCertFileDialog;
    }
}