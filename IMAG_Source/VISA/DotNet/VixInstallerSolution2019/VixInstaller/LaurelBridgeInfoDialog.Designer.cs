namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class LaurelBridgeInfoDialog
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
            this.label4 = new System.Windows.Forms.Label();
            this.textBoxLicenseFile = new System.Windows.Forms.TextBox();
            this.buttonLicenseFile = new System.Windows.Forms.Button();
            this.openLicenseFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.buttonOK = new System.Windows.Forms.Button();
            this.buttonCancel = new System.Windows.Forms.Button();
            this.labelErrorInfo = new System.Windows.Forms.Label();
            this.errorProvider = new gov.va.med.imaging.exchange.VixInstaller.ui.ErrorProviderFixed(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).BeginInit();
            this.SuspendLayout();
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(31, 9);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(379, 16);
            this.label4.TabIndex = 0;
            this.label4.Text = "Select the Laurel Bridge License file for this computer.";
            this.label4.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxLicenseFile
            // 
            this.textBoxLicenseFile.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.textBoxLicenseFile.BackColor = System.Drawing.SystemColors.Control;
            this.textBoxLicenseFile.Location = new System.Drawing.Point(65, 39);
            this.textBoxLicenseFile.MinimumSize = new System.Drawing.Size(339, 22);
            this.textBoxLicenseFile.Multiline = true;
            this.textBoxLicenseFile.Name = "textBoxLicenseFile";
            this.textBoxLicenseFile.ReadOnly = true;
            this.textBoxLicenseFile.Size = new System.Drawing.Size(356, 80);
            this.textBoxLicenseFile.TabIndex = 0;
            this.textBoxLicenseFile.TabStop = false;
            // 
            // buttonLicenseFile
            // 
            this.buttonLicenseFile.Location = new System.Drawing.Point(4, 39);
            this.buttonLicenseFile.Name = "buttonLicenseFile";
            this.buttonLicenseFile.Size = new System.Drawing.Size(55, 23);
            this.buttonLicenseFile.TabIndex = 1;
            this.buttonLicenseFile.Text = "Select";
            this.buttonLicenseFile.UseVisualStyleBackColor = true;
            this.buttonLicenseFile.Click += new System.EventHandler(this.buttonLicenseFile_Click);
            // 
            // openLicenseFileDialog
            // 
            this.openLicenseFileDialog.InitialDirectory = "C:\\";
            this.openLicenseFileDialog.RestoreDirectory = true;
            this.openLicenseFileDialog.SupportMultiDottedExtensions = true;
            this.openLicenseFileDialog.Title = "Select the Laurel Bridge License file";
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
            this.labelErrorInfo.Size = new System.Drawing.Size(240, 16);
            this.labelErrorInfo.TabIndex = 0;
            this.labelErrorInfo.Text = "Mouse over the icon to view error.";
            this.labelErrorInfo.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.labelErrorInfo.Visible = false;
            // 
            // errorProvider
            // 
            this.errorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink;
            this.errorProvider.ContainerControl = this;
            // 
            // LaurelBridgeInfoDialog
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
            this.Controls.Add(this.buttonLicenseFile);
            this.Controls.Add(this.textBoxLicenseFile);
            this.Controls.Add(this.label4);
            this.MinimumSize = new System.Drawing.Size(447, 143);
            this.Name = "LaurelBridgeInfoDialog";
            this.Text = "Laurel Bridge DICOM Toolkit Setup";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.LaurelBridgeInfoDialog_FormClosing);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox textBoxLicenseFile;
        private System.Windows.Forms.Button buttonLicenseFile;
        private System.Windows.Forms.OpenFileDialog openLicenseFileDialog;
        private System.Windows.Forms.Button buttonOK;
        private System.Windows.Forms.Button buttonCancel;
        private System.Windows.Forms.Label labelErrorInfo;
        private ErrorProviderFixed errorProvider;
    }
}