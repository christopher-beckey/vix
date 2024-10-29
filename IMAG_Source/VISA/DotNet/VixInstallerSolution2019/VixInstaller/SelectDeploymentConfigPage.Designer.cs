namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class SelectDeploymentConfigPage
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
            this.groupBoxDeployConfig = new System.Windows.Forms.GroupBox();
            this.textBoxDeployDescription = new System.Windows.Forms.TextBox();
            this.listBoxDeployConfig = new System.Windows.Forms.ListBox();
            this.folderBrowserDialog = new System.Windows.Forms.FolderBrowserDialog();
            this.errorProvider = new gov.va.med.imaging.exchange.VixInstaller.ui.ErrorProviderFixed(this.components);
            this.groupBoxDeployConfig.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).BeginInit();
            this.SuspendLayout();
            // 
            // groupBoxDeployConfig
            // 
            this.groupBoxDeployConfig.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBoxDeployConfig.Controls.Add(this.textBoxDeployDescription);
            this.groupBoxDeployConfig.Controls.Add(this.listBoxDeployConfig);
            this.groupBoxDeployConfig.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBoxDeployConfig.Location = new System.Drawing.Point(21, 110);
            this.groupBoxDeployConfig.Name = "groupBoxDeployConfig";
            this.groupBoxDeployConfig.Size = new System.Drawing.Size(802, 284);
            this.groupBoxDeployConfig.TabIndex = 1;
            this.groupBoxDeployConfig.TabStop = false;
            this.groupBoxDeployConfig.Text = "Select VIX Deployment Configuration";
            // 
            // textBoxDeployDescription
            // 
            this.textBoxDeployDescription.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.textBoxDeployDescription.BackColor = System.Drawing.SystemColors.Control;
            this.textBoxDeployDescription.Location = new System.Drawing.Point(367, 30);
            this.textBoxDeployDescription.Multiline = true;
            this.textBoxDeployDescription.Name = "textBoxDeployDescription";
            this.textBoxDeployDescription.Size = new System.Drawing.Size(420, 238);
            this.textBoxDeployDescription.TabIndex = 1;
            this.textBoxDeployDescription.TabStop = false;
            // 
            // listBoxDeployConfig
            // 
            this.listBoxDeployConfig.FormattingEnabled = true;
            this.listBoxDeployConfig.ItemHeight = 20;
            this.listBoxDeployConfig.Location = new System.Drawing.Point(6, 30);
            this.listBoxDeployConfig.Name = "listBoxDeployConfig";
            this.listBoxDeployConfig.Size = new System.Drawing.Size(345, 104);
            this.listBoxDeployConfig.TabIndex = 0;
            this.listBoxDeployConfig.SelectedIndexChanged += new System.EventHandler(this.listBoxDeployConfig_SelectedIndexChanged);
            // 
            // errorProvider
            // 
            this.errorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink;
            this.errorProvider.ContainerControl = this;
            // 
            // SelectDeploymentConfigPage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.Controls.Add(this.groupBoxDeployConfig);
            this.Name = "SelectDeploymentConfigPage";
            this.Controls.SetChildIndex(this.groupBoxDeployConfig, 0);
            this.groupBoxDeployConfig.ResumeLayout(false);
            this.groupBoxDeployConfig.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBoxDeployConfig;
        private System.Windows.Forms.ListBox listBoxDeployConfig;
        private System.Windows.Forms.TextBox textBoxDeployDescription;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog;
        private ErrorProviderFixed errorProvider;

    }
}
