namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class SitesFileDialog
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
            this.textBoxSitesFile = new System.Windows.Forms.TextBox();
            this.buttonSitesFile = new System.Windows.Forms.Button();
            this.openSitesFileDialog = new System.Windows.Forms.OpenFileDialog();
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
            this.label4.Size = new System.Drawing.Size(295, 16);
            this.label4.TabIndex = 0;
            this.label4.Text = "Select the sites file (usually VhaSites.xml)";
            this.label4.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxSitesFile
            // 
            this.textBoxSitesFile.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.textBoxSitesFile.BackColor = System.Drawing.SystemColors.Control;
            this.textBoxSitesFile.Location = new System.Drawing.Point(65, 39);
            this.textBoxSitesFile.MinimumSize = new System.Drawing.Size(339, 22);
            this.textBoxSitesFile.Multiline = true;
            this.textBoxSitesFile.Name = "textBoxSitesFile";
            this.textBoxSitesFile.ReadOnly = true;
            this.textBoxSitesFile.Size = new System.Drawing.Size(356, 80);
            this.textBoxSitesFile.TabIndex = 0;
            this.textBoxSitesFile.TabStop = false;
            // 
            // buttonSitesFile
            // 
            this.buttonSitesFile.Location = new System.Drawing.Point(4, 39);
            this.buttonSitesFile.Name = "buttonSitesFile";
            this.buttonSitesFile.Size = new System.Drawing.Size(55, 23);
            this.buttonSitesFile.TabIndex = 1;
            this.buttonSitesFile.Text = "Select";
            this.buttonSitesFile.UseVisualStyleBackColor = true;
            this.buttonSitesFile.Click += new System.EventHandler(this.buttonSitesFile_Click);
            // 
            // openSitesFileDialog
            // 
            this.openSitesFileDialog.InitialDirectory = "C:\\";
            this.openSitesFileDialog.RestoreDirectory = true;
            this.openSitesFileDialog.SupportMultiDottedExtensions = true;
            this.openSitesFileDialog.Title = "Select Site Service data file";
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
            // SitesFileDialog
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
            this.Controls.Add(this.buttonSitesFile);
            this.Controls.Add(this.textBoxSitesFile);
            this.Controls.Add(this.label4);
            this.MinimumSize = new System.Drawing.Size(447, 143);
            this.Name = "SitesFileDialog";
            this.Text = "Select Site Service data file";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.SitesFileDialog_FormClosing);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox textBoxSitesFile;
        private System.Windows.Forms.Button buttonSitesFile;
        private System.Windows.Forms.OpenFileDialog openSitesFileDialog;
        private System.Windows.Forms.Button buttonOK;
        private System.Windows.Forms.Button buttonCancel;
        private System.Windows.Forms.Label labelErrorInfo;
        private ErrorProviderFixed errorProvider;
    }
}