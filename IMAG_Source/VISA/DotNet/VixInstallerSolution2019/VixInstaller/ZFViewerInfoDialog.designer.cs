namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class ZFViewerInfoDialog
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
            this.ConfigureViewerButton = new System.Windows.Forms.Button();
            this.SaveConfigurationButton = new System.Windows.Forms.Button();
            this.configControl1 = new Vix.Viewer.Install.ConfigControl();
            this.buttonOK = new System.Windows.Forms.Button();
            this.buttonCancel = new System.Windows.Forms.Button();
            this.labelErrorInfo = new System.Windows.Forms.Label();
            this.errorProvider = new gov.va.med.imaging.exchange.VixInstaller.ui.ErrorProviderFixed(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).BeginInit();
            this.SuspendLayout();
            // 
            // ConfigureViewerButton
            // 
            this.ConfigureViewerButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.ConfigureViewerButton.Location = new System.Drawing.Point(41, 605);
            this.ConfigureViewerButton.Name = "ConfigureViewerButton";
            this.ConfigureViewerButton.Size = new System.Drawing.Size(191, 50);
            this.ConfigureViewerButton.TabIndex = 1;
            this.ConfigureViewerButton.Text = "Configure Viewer/Render";
            this.ConfigureViewerButton.UseVisualStyleBackColor = true;
            this.ConfigureViewerButton.Click += new System.EventHandler(this.ConfigureViewerButton_Click);
            // 
            // SaveConfigurationButton
            // 
            this.SaveConfigurationButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.SaveConfigurationButton.AutoSize = true;
            this.SaveConfigurationButton.Enabled = false;
            this.SaveConfigurationButton.Location = new System.Drawing.Point(793, 101);
            this.SaveConfigurationButton.Name = "SaveConfigurationButton";
            this.SaveConfigurationButton.Size = new System.Drawing.Size(138, 28);
            this.SaveConfigurationButton.TabIndex = 7;
            this.SaveConfigurationButton.Text = "Save Configuration";
            this.SaveConfigurationButton.UseVisualStyleBackColor = true;
            this.SaveConfigurationButton.Click += new System.EventHandler(this.SaveConfigurationButton_Click);
            // 
            // configControl1
            // 
            this.configControl1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.configControl1.Location = new System.Drawing.Point(41, 51);
            this.configControl1.Name = "configControl1";
            this.configControl1.Size = new System.Drawing.Size(746, 514);
            this.configControl1.TabIndex = 0;
            this.configControl1.Load += new System.EventHandler(this.configControl1_Load);
            // 
            // buttonOK
            // 
            this.buttonOK.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonOK.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.buttonOK.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonOK.Location = new System.Drawing.Point(793, 609);
            this.buttonOK.Name = "buttonOK";
            this.buttonOK.Size = new System.Drawing.Size(75, 28);
            this.buttonOK.TabIndex = 10;
            this.buttonOK.Text = "OK";
            this.buttonOK.UseVisualStyleBackColor = true;
            // 
            // buttonCancel
            // 
            this.buttonCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.buttonCancel.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonCancel.Location = new System.Drawing.Point(885, 609);
            this.buttonCancel.Name = "buttonCancel";
            this.buttonCancel.Size = new System.Drawing.Size(75, 28);
            this.buttonCancel.TabIndex = 11;
            this.buttonCancel.Text = "Cancel";
            this.buttonCancel.UseVisualStyleBackColor = true;
            // 
            // labelErrorInfo
            // 
            this.labelErrorInfo.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.labelErrorInfo.AutoSize = true;
            this.labelErrorInfo.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelErrorInfo.Location = new System.Drawing.Point(12, 658);
            this.labelErrorInfo.Name = "labelErrorInfo";
            this.labelErrorInfo.Size = new System.Drawing.Size(296, 20);
            this.labelErrorInfo.TabIndex = 13;
            this.labelErrorInfo.Text = "Mouse over the icon to view error.";
            this.labelErrorInfo.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.labelErrorInfo.Visible = false;
            // 
            // errorProvider
            // 
            this.errorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink;
            this.errorProvider.ContainerControl = this;
            // 
            // ZFViewerInfoDialog
            // 
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
            this.ClientSize = new System.Drawing.Size(1028, 687);
            this.Controls.Add(this.labelErrorInfo);
            this.Controls.Add(this.buttonCancel);
            this.Controls.Add(this.buttonOK);
            this.Controls.Add(this.SaveConfigurationButton);
            this.Controls.Add(this.ConfigureViewerButton);
            this.Controls.Add(this.configControl1);
            this.Name = "ZFViewerInfoDialog";
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Show;
            this.Text = "VIX Viewer/Render Info Dialog";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.ZFViewerInfoDialog_FormClosing);
            this.Load += new System.EventHandler(this.ZFViewerInfoDialog_Load);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Vix.Viewer.Install.ConfigControl configControl1;
        private System.Windows.Forms.Button ConfigureViewerButton;
        //private System.Windows.Forms.Button InitializeRenderButton;
        //private FolderSelectDialog folderSelectDialog;
        private System.Windows.Forms.Button SaveConfigurationButton;
        private System.Windows.Forms.Button buttonOK;
        private System.Windows.Forms.Button buttonCancel;
        private System.Windows.Forms.Label labelErrorInfo;
        private ErrorProviderFixed errorProvider;

    }
}

