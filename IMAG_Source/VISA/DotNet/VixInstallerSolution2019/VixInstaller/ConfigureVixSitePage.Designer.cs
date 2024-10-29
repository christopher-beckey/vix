namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class ConfigureVixSitePage
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
            this.labelVistaServerPort = new System.Windows.Forms.Label();
            this.textBoxVistaServerPort = new System.Windows.Forms.TextBox();
            this.textBoxVistaServerName = new System.Windows.Forms.TextBox();
            this.labelVistaServerName = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.textBoxSiteServiceUrl = new System.Windows.Forms.TextBox();
            this.groupBoxSiteServiceUri = new System.Windows.Forms.GroupBox();
            this.labelVixServerName = new System.Windows.Forms.Label();
            this.textBoxVixServerName = new System.Windows.Forms.TextBox();
            this.labelVixServerPort = new System.Windows.Forms.Label();
            this.textBoxVixServerPort = new System.Windows.Forms.TextBox();
            this.errorProvider = new gov.va.med.imaging.exchange.VixInstaller.ui.ErrorProviderFixed(this.components);
            this.textBoxSiteNumber = new System.Windows.Forms.TextBox();
            this.groupBoxSiteServiceUri.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).BeginInit();
            this.SuspendLayout();
            // 
            // buttonLookup
            // 
            this.buttonLookup.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonLookup.Location = new System.Drawing.Point(237, 159);
            this.buttonLookup.Name = "buttonLookup";
            this.buttonLookup.Size = new System.Drawing.Size(220, 28);
            this.buttonLookup.TabIndex = 3;
            this.buttonLookup.Text = "Lookup Server Addresses";
            this.buttonLookup.UseVisualStyleBackColor = true;
            this.buttonLookup.Click += new System.EventHandler(this.buttonLookup_Click);
            // 
            // labelVistaServerPort
            // 
            this.labelVistaServerPort.Location = new System.Drawing.Point(13, 228);
            this.labelVistaServerPort.Name = "labelVistaServerPort";
            this.labelVistaServerPort.Size = new System.Drawing.Size(137, 16);
            this.labelVistaServerPort.TabIndex = 0;
            this.labelVistaServerPort.Text = "VistA Server Port:";
            this.labelVistaServerPort.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxVistaServerPort
            // 
            this.textBoxVistaServerPort.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxVistaServerPort.Location = new System.Drawing.Point(156, 225);
            this.textBoxVistaServerPort.Name = "textBoxVistaServerPort";
            this.textBoxVistaServerPort.ReadOnly = true;
            this.textBoxVistaServerPort.Size = new System.Drawing.Size(62, 22);
            this.textBoxVistaServerPort.TabIndex = 5;
            this.textBoxVistaServerPort.TabStop = false;
            // 
            // textBoxVistaServerName
            // 
            this.textBoxVistaServerName.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxVistaServerName.Location = new System.Drawing.Point(156, 193);
            this.textBoxVistaServerName.Name = "textBoxVistaServerName";
            this.textBoxVistaServerName.ReadOnly = true;
            this.textBoxVistaServerName.Size = new System.Drawing.Size(305, 22);
            this.textBoxVistaServerName.TabIndex = 4;
            this.textBoxVistaServerName.TabStop = false;
            // 
            // labelVistaServerName
            // 
            this.labelVistaServerName.Location = new System.Drawing.Point(13, 196);
            this.labelVistaServerName.Name = "labelVistaServerName";
            this.labelVistaServerName.Size = new System.Drawing.Size(137, 16);
            this.labelVistaServerName.TabIndex = 0;
            this.labelVistaServerName.Text = "VistA Server Name:";
            this.labelVistaServerName.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(19, 164);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(131, 16);
            this.label1.TabIndex = 0;
            this.label1.Text = "Site Number:";
            this.label1.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxSiteServiceUrl
            // 
            this.textBoxSiteServiceUrl.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.textBoxSiteServiceUrl.Location = new System.Drawing.Point(6, 25);
            this.textBoxSiteServiceUrl.Name = "textBoxSiteServiceUrl";
            this.textBoxSiteServiceUrl.Size = new System.Drawing.Size(906, 22);
            this.textBoxSiteServiceUrl.TabIndex = 0;
            this.textBoxSiteServiceUrl.Text = "http://siteserver.vista.med.va.gov/VistaWebSvcs/ImagingExchangeSiteService.asmx";
            // 
            // groupBoxSiteServiceUri
            // 
            this.groupBoxSiteServiceUri.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBoxSiteServiceUri.Controls.Add(this.textBoxSiteServiceUrl);
            this.groupBoxSiteServiceUri.Location = new System.Drawing.Point(17, 93);
            this.groupBoxSiteServiceUri.Name = "groupBoxSiteServiceUri";
            this.groupBoxSiteServiceUri.Size = new System.Drawing.Size(918, 58);
            this.groupBoxSiteServiceUri.TabIndex = 1;
            this.groupBoxSiteServiceUri.TabStop = false;
            this.groupBoxSiteServiceUri.Text = "Site Service URL";
            // 
            // labelVixServerName
            // 
            this.labelVixServerName.Location = new System.Drawing.Point(13, 260);
            this.labelVixServerName.Name = "labelVixServerName";
            this.labelVixServerName.Size = new System.Drawing.Size(137, 16);
            this.labelVixServerName.TabIndex = 0;
            this.labelVixServerName.Text = "VIX Server Name:";
            this.labelVixServerName.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxVixServerName
            // 
            this.textBoxVixServerName.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxVixServerName.Location = new System.Drawing.Point(156, 257);
            this.textBoxVixServerName.Name = "textBoxVixServerName";
            this.textBoxVixServerName.ReadOnly = true;
            this.textBoxVixServerName.Size = new System.Drawing.Size(305, 22);
            this.textBoxVixServerName.TabIndex = 6;
            this.textBoxVixServerName.TabStop = false;
            // 
            // labelVixServerPort
            // 
            this.labelVixServerPort.Location = new System.Drawing.Point(13, 292);
            this.labelVixServerPort.Name = "labelVixServerPort";
            this.labelVixServerPort.Size = new System.Drawing.Size(137, 16);
            this.labelVixServerPort.TabIndex = 0;
            this.labelVixServerPort.Text = "VIX Server Port:";
            this.labelVixServerPort.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxVixServerPort
            // 
            this.textBoxVixServerPort.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxVixServerPort.Location = new System.Drawing.Point(156, 289);
            this.textBoxVixServerPort.Name = "textBoxVixServerPort";
            this.textBoxVixServerPort.ReadOnly = true;
            this.textBoxVixServerPort.Size = new System.Drawing.Size(62, 22);
            this.textBoxVixServerPort.TabIndex = 7;
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
            this.textBoxSiteNumber.Location = new System.Drawing.Point(156, 161);
            this.textBoxSiteNumber.Name = "textBoxSiteNumber";
            this.textBoxSiteNumber.Size = new System.Drawing.Size(62, 22);
            this.textBoxSiteNumber.TabIndex = 2;
            this.textBoxSiteNumber.TextChanged += new System.EventHandler(this.textBoxSiteNumber_TextChanged);
            // 
            // ConfigureVixSitePage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.Controls.Add(this.textBoxSiteNumber);
            this.Controls.Add(this.textBoxVixServerPort);
            this.Controls.Add(this.labelVixServerPort);
            this.Controls.Add(this.textBoxVixServerName);
            this.Controls.Add(this.labelVixServerName);
            this.Controls.Add(this.groupBoxSiteServiceUri);
            this.Controls.Add(this.buttonLookup);
            this.Controls.Add(this.labelVistaServerPort);
            this.Controls.Add(this.textBoxVistaServerPort);
            this.Controls.Add(this.textBoxVistaServerName);
            this.Controls.Add(this.labelVistaServerName);
            this.Controls.Add(this.label1);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Name = "ConfigureVixSitePage";
            this.Size = new System.Drawing.Size(950, 369);
            this.Tag = " ";
            this.Controls.SetChildIndex(this.label1, 0);
            this.Controls.SetChildIndex(this.labelVistaServerName, 0);
            this.Controls.SetChildIndex(this.textBoxVistaServerName, 0);
            this.Controls.SetChildIndex(this.textBoxVistaServerPort, 0);
            this.Controls.SetChildIndex(this.labelVistaServerPort, 0);
            this.Controls.SetChildIndex(this.buttonLookup, 0);
            this.Controls.SetChildIndex(this.groupBoxSiteServiceUri, 0);
            this.Controls.SetChildIndex(this.labelVixServerName, 0);
            this.Controls.SetChildIndex(this.textBoxVixServerName, 0);
            this.Controls.SetChildIndex(this.labelVixServerPort, 0);
            this.Controls.SetChildIndex(this.textBoxVixServerPort, 0);
            this.Controls.SetChildIndex(this.textBoxSiteNumber, 0);
            this.groupBoxSiteServiceUri.ResumeLayout(false);
            this.groupBoxSiteServiceUri.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textBoxSiteServiceUrl;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBoxVistaServerName;
        private System.Windows.Forms.Label labelVistaServerName;
        private System.Windows.Forms.Label labelVistaServerPort;
        private System.Windows.Forms.TextBox textBoxVistaServerPort;
        private System.Windows.Forms.Button buttonLookup;
        private System.Windows.Forms.GroupBox groupBoxSiteServiceUri;
        private System.Windows.Forms.Label labelVixServerName;
        private System.Windows.Forms.TextBox textBoxVixServerPort;
        private System.Windows.Forms.Label labelVixServerPort;
        private System.Windows.Forms.TextBox textBoxVixServerName;
        private ErrorProviderFixed errorProvider;
        private System.Windows.Forms.TextBox textBoxSiteNumber;

    }
}
