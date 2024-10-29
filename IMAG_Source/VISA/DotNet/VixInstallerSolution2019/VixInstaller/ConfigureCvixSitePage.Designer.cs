namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class ConfigureCvixSitePage
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
            this.buttonLookup = new System.Windows.Forms.Button();
            this.textBoxVistaServerPort = new System.Windows.Forms.TextBox();
            this.textBoxVistaServerName = new System.Windows.Forms.TextBox();
            this.labelVistaServerName = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.labelVixServerName = new System.Windows.Forms.Label();
            this.textBoxVixServerName = new System.Windows.Forms.TextBox();
            this.textBoxVixServerPort = new System.Windows.Forms.TextBox();
            this.errorProvider = new gov.va.med.imaging.exchange.VixInstaller.ui.ErrorProviderFixed(this.components);
            this.textBoxSiteNumber = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.textBoxSitesFile = new System.Windows.Forms.TextBox();
            this.buttonSelectSitesFile = new System.Windows.Forms.Button();
            this.textBoxSiteServiceUrl = new System.Windows.Forms.TextBox();
            this.groupBoxSiteServiceUri = new System.Windows.Forms.GroupBox();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).BeginInit();
            this.groupBoxSiteServiceUri.SuspendLayout();
            this.SuspendLayout();
            // 
            // buttonLookup
            // 
            this.buttonLookup.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonLookup.Location = new System.Drawing.Point(232, 162);
            this.buttonLookup.Name = "buttonLookup";
            this.buttonLookup.Size = new System.Drawing.Size(209, 28);
            this.buttonLookup.TabIndex = 5;
            this.buttonLookup.Text = "Lookup Server Addresses";
            this.buttonLookup.UseVisualStyleBackColor = true;
            this.buttonLookup.Click += new System.EventHandler(this.buttonLookup_Click);
            // 
            // textBoxVistaServerPort
            // 
            this.textBoxVistaServerPort.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxVistaServerPort.Location = new System.Drawing.Point(565, 196);
            this.textBoxVistaServerPort.Name = "textBoxVistaServerPort";
            this.textBoxVistaServerPort.ReadOnly = true;
            this.textBoxVistaServerPort.Size = new System.Drawing.Size(62, 30);
            this.textBoxVistaServerPort.TabIndex = 7;
            this.textBoxVistaServerPort.TabStop = false;
            // 
            // textBoxVistaServerName
            // 
            this.textBoxVistaServerName.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxVistaServerName.Location = new System.Drawing.Point(160, 196);
            this.textBoxVistaServerName.Name = "textBoxVistaServerName";
            this.textBoxVistaServerName.ReadOnly = true;
            this.textBoxVistaServerName.Size = new System.Drawing.Size(399, 30);
            this.textBoxVistaServerName.TabIndex = 6;
            this.textBoxVistaServerName.TabStop = false;
            // 
            // labelVistaServerName
            // 
            this.labelVistaServerName.Location = new System.Drawing.Point(17, 199);
            this.labelVistaServerName.Name = "labelVistaServerName";
            this.labelVistaServerName.Size = new System.Drawing.Size(137, 16);
            this.labelVistaServerName.TabIndex = 0;
            this.labelVistaServerName.Text = "VistA Server Name:";
            this.labelVistaServerName.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(23, 167);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(131, 16);
            this.label1.TabIndex = 0;
            this.label1.Text = "Site Number";
            this.label1.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // labelVixServerName
            // 
            this.labelVixServerName.Location = new System.Drawing.Point(17, 228);
            this.labelVixServerName.Name = "labelVixServerName";
            this.labelVixServerName.Size = new System.Drawing.Size(137, 22);
            this.labelVixServerName.TabIndex = 0;
            this.labelVixServerName.Text = "VIX Server Name:";
            this.labelVixServerName.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxVixServerName
            // 
            this.textBoxVixServerName.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxVixServerName.Location = new System.Drawing.Point(160, 228);
            this.textBoxVixServerName.Name = "textBoxVixServerName";
            this.textBoxVixServerName.ReadOnly = true;
            this.textBoxVixServerName.Size = new System.Drawing.Size(399, 30);
            this.textBoxVixServerName.TabIndex = 8;
            this.textBoxVixServerName.TabStop = false;
            this.textBoxVixServerName.TextChanged += new System.EventHandler(this.textBoxVixServerName_TextChanged);
            // 
            // textBoxVixServerPort
            // 
            this.textBoxVixServerPort.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxVixServerPort.Location = new System.Drawing.Point(565, 228);
            this.textBoxVixServerPort.Name = "textBoxVixServerPort";
            this.textBoxVixServerPort.ReadOnly = true;
            this.textBoxVixServerPort.Size = new System.Drawing.Size(62, 30);
            this.textBoxVixServerPort.TabIndex = 9;
            this.textBoxVixServerPort.TabStop = false;
            // 
            // errorProvider
            // 
            this.errorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink;
            this.errorProvider.ContainerControl = this;
            // 
            // textBoxSiteNumber
            // 
            this.textBoxSiteNumber.BackColor = System.Drawing.SystemColors.Window;
            this.textBoxSiteNumber.Location = new System.Drawing.Point(160, 164);
            this.textBoxSiteNumber.Name = "textBoxSiteNumber";
            this.textBoxSiteNumber.Size = new System.Drawing.Size(62, 30);
            this.textBoxSiteNumber.TabIndex = 4;
            this.textBoxSiteNumber.TextChanged += new System.EventHandler(this.textBoxSiteNumber_TextChanged);
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(33, 133);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(122, 19);
            this.label2.TabIndex = 8;
            this.label2.Text = "Sites File";
            this.label2.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxSitesFile
            // 
            this.textBoxSitesFile.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxSitesFile.Location = new System.Drawing.Point(161, 130);
            this.textBoxSitesFile.Name = "textBoxSitesFile";
            this.textBoxSitesFile.ReadOnly = true;
            this.textBoxSitesFile.Size = new System.Drawing.Size(214, 30);
            this.textBoxSitesFile.TabIndex = 10;
            // 
            // buttonSelectSitesFile
            // 
            this.buttonSelectSitesFile.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonSelectSitesFile.Location = new System.Drawing.Point(381, 128);
            this.buttonSelectSitesFile.Name = "buttonSelectSitesFile";
            this.buttonSelectSitesFile.Size = new System.Drawing.Size(69, 28);
            this.buttonSelectSitesFile.TabIndex = 11;
            this.buttonSelectSitesFile.Text = "Select";
            this.buttonSelectSitesFile.UseVisualStyleBackColor = true;
            this.buttonSelectSitesFile.Click += new System.EventHandler(this.buttonSelectSitesFile_Click);
            // 
            // textBoxSiteServiceUrl
            // 
            this.textBoxSiteServiceUrl.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.textBoxSiteServiceUrl.Location = new System.Drawing.Point(6, 25);
            this.textBoxSiteServiceUrl.Name = "textBoxSiteServiceUrl";
            this.textBoxSiteServiceUrl.Size = new System.Drawing.Size(847, 30);
            this.textBoxSiteServiceUrl.TabIndex = 0;
            this.textBoxSiteServiceUrl.Text = "http://siteserver.vista.med.va.gov/VistaWebSvcs/ImagingExchangeSiteService.asmx";
            // 
            // groupBoxSiteServiceUri
            // 
            this.groupBoxSiteServiceUri.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBoxSiteServiceUri.Controls.Add(this.textBoxSiteServiceUrl);
            this.groupBoxSiteServiceUri.Location = new System.Drawing.Point(38, 73);
            this.groupBoxSiteServiceUri.Name = "groupBoxSiteServiceUri";
            this.groupBoxSiteServiceUri.Size = new System.Drawing.Size(872, 58);
            this.groupBoxSiteServiceUri.TabIndex = 3;
            this.groupBoxSiteServiceUri.TabStop = false;
            this.groupBoxSiteServiceUri.Text = "Site Service URL";
            this.groupBoxSiteServiceUri.Visible = false;
            // 
            // ConfigureCvixSitePage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(12F, 25F);
            this.Controls.Add(this.buttonSelectSitesFile);
            this.Controls.Add(this.textBoxSitesFile);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.textBoxSiteNumber);
            this.Controls.Add(this.textBoxVixServerPort);
            this.Controls.Add(this.textBoxVixServerName);
            this.Controls.Add(this.labelVixServerName);
            this.Controls.Add(this.groupBoxSiteServiceUri);
            this.Controls.Add(this.buttonLookup);
            this.Controls.Add(this.textBoxVistaServerPort);
            this.Controls.Add(this.textBoxVistaServerName);
            this.Controls.Add(this.labelVistaServerName);
            this.Controls.Add(this.label1);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Name = "ConfigureCvixSitePage";
            this.Size = new System.Drawing.Size(904, 353);
            this.Tag = " ";
            this.Controls.SetChildIndex(this.label1, 0);
            this.Controls.SetChildIndex(this.labelVistaServerName, 0);
            this.Controls.SetChildIndex(this.textBoxVistaServerName, 0);
            this.Controls.SetChildIndex(this.textBoxVistaServerPort, 0);
            this.Controls.SetChildIndex(this.buttonLookup, 0);
            this.Controls.SetChildIndex(this.groupBoxSiteServiceUri, 0);
            this.Controls.SetChildIndex(this.labelVixServerName, 0);
            this.Controls.SetChildIndex(this.textBoxVixServerName, 0);
            this.Controls.SetChildIndex(this.textBoxVixServerPort, 0);
            this.Controls.SetChildIndex(this.textBoxSiteNumber, 0);
            this.Controls.SetChildIndex(this.label2, 0);
            this.Controls.SetChildIndex(this.textBoxSitesFile, 0);
            this.Controls.SetChildIndex(this.buttonSelectSitesFile, 0);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).EndInit();
            this.groupBoxSiteServiceUri.ResumeLayout(false);
            this.groupBoxSiteServiceUri.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBoxVistaServerName;
        private System.Windows.Forms.Label labelVistaServerName;
        private System.Windows.Forms.TextBox textBoxVistaServerPort;
        private System.Windows.Forms.Button buttonLookup;
        private System.Windows.Forms.Label labelVixServerName;
        private System.Windows.Forms.TextBox textBoxVixServerPort;
        private System.Windows.Forms.TextBox textBoxVixServerName;
        private ErrorProviderFixed errorProvider;
        private System.Windows.Forms.TextBox textBoxSiteNumber;
        private System.Windows.Forms.TextBox textBoxSitesFile;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button buttonSelectSitesFile;
        private System.Windows.Forms.GroupBox groupBoxSiteServiceUri;
        private System.Windows.Forms.TextBox textBoxSiteServiceUrl;
    }
}
