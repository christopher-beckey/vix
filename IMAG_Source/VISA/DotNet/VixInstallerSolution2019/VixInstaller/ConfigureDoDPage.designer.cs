namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class ConfigureDoDPage
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
            this.errorProvider = new gov.va.med.imaging.exchange.VixInstaller.ui.ErrorProviderFixed(this.components);
            this.buttonConfirm = new System.Windows.Forms.Button();
            this.labelErrorInfo = new System.Windows.Forms.Label();
            this.buttonVCPlusPlus2008Runtime = new System.Windows.Forms.Button();
            this.labelVCPlusPlus2008Runtime = new System.Windows.Forms.Label();
            this.tabPageStation200 = new System.Windows.Forms.TabPage();
            this.textBoxStation200UserName = new System.Windows.Forms.TextBox();
            this.label15 = new System.Windows.Forms.Label();
            this.tabControlXca = new System.Windows.Forms.TabControl();
            this.DoDtabControl = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.textBoxRequestSource = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.textBoxLoinc = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.textBoxProvider = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.textBoxDoDConnectorPort = new System.Windows.Forms.TextBox();
            this.label14 = new System.Windows.Forms.Label();
            this.textBoxDoDConnectorHost = new System.Windows.Forms.TextBox();
            this.label13 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).BeginInit();
            this.tabPageStation200.SuspendLayout();
            this.tabControlXca.SuspendLayout();
            this.DoDtabControl.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.SuspendLayout();
            // 
            // errorProvider
            // 
            this.errorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink;
            this.errorProvider.ContainerControl = this;
            // 
            // buttonConfirm
            // 
            this.buttonConfirm.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonConfirm.Location = new System.Drawing.Point(512, 325);
            this.buttonConfirm.Name = "buttonConfirm";
            this.buttonConfirm.Size = new System.Drawing.Size(87, 28);
            this.buttonConfirm.TabIndex = 6;
            this.buttonConfirm.Text = "&Confirm";
            this.buttonConfirm.UseVisualStyleBackColor = true;
            this.buttonConfirm.Click += new System.EventHandler(this.buttonConfirm_Click);
            // 
            // labelErrorInfo
            // 
            this.labelErrorInfo.AutoSize = true;
            this.labelErrorInfo.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelErrorInfo.Location = new System.Drawing.Point(4, 333);
            this.labelErrorInfo.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.labelErrorInfo.Name = "labelErrorInfo";
            this.labelErrorInfo.Size = new System.Drawing.Size(296, 20);
            this.labelErrorInfo.TabIndex = 11;
            this.labelErrorInfo.Text = "Mouse over the icon to view error.";
            this.labelErrorInfo.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.labelErrorInfo.Visible = false;
            // 
            // buttonVCPlusPlus2008Runtime
            // 
            this.buttonVCPlusPlus2008Runtime.Enabled = false;
            this.buttonVCPlusPlus2008Runtime.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonVCPlusPlus2008Runtime.Location = new System.Drawing.Point(11, 260);
            this.buttonVCPlusPlus2008Runtime.Name = "buttonVCPlusPlus2008Runtime";
            this.buttonVCPlusPlus2008Runtime.Size = new System.Drawing.Size(87, 28);
            this.buttonVCPlusPlus2008Runtime.TabIndex = 9;
            this.buttonVCPlusPlus2008Runtime.TabStop = false;
            this.buttonVCPlusPlus2008Runtime.Text = "&Install";
            this.buttonVCPlusPlus2008Runtime.UseVisualStyleBackColor = true;
            this.buttonVCPlusPlus2008Runtime.Click += new System.EventHandler(this.buttonVCPlusPlus2008Runtime_Click);
            // 
            // labelVCPlusPlus2008Runtime
            // 
            this.labelVCPlusPlus2008Runtime.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.labelVCPlusPlus2008Runtime.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelVCPlusPlus2008Runtime.Location = new System.Drawing.Point(119, 265);
            this.labelVCPlusPlus2008Runtime.Name = "labelVCPlusPlus2008Runtime";
            this.labelVCPlusPlus2008Runtime.Size = new System.Drawing.Size(360, 23);
            this.labelVCPlusPlus2008Runtime.TabIndex = 30;
            this.labelVCPlusPlus2008Runtime.Text = "The Visual Studio 2008 VC++ runtime is installed.";
            // 
            // tabPageStation200
            // 
            this.tabPageStation200.Controls.Add(this.textBoxStation200UserName);
            this.tabPageStation200.Controls.Add(this.label15);
            this.tabPageStation200.Location = new System.Drawing.Point(4, 29);
            this.tabPageStation200.Name = "tabPageStation200";
            this.tabPageStation200.Size = new System.Drawing.Size(640, 34);
            this.tabPageStation200.TabIndex = 3;
            this.tabPageStation200.Text = "Station 200 Configuration";
            this.tabPageStation200.UseVisualStyleBackColor = true;
            // 
            // textBoxStation200UserName
            // 
            this.textBoxStation200UserName.Location = new System.Drawing.Point(119, 7);
            this.textBoxStation200UserName.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxStation200UserName.Name = "textBoxStation200UserName";
            this.textBoxStation200UserName.Size = new System.Drawing.Size(132, 26);
            this.textBoxStation200UserName.TabIndex = 0;
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Location = new System.Drawing.Point(13, 10);
            this.label15.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(91, 20);
            this.label15.TabIndex = 18;
            this.label15.Text = "Username:";
            this.label15.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // tabControlXca
            // 
            this.tabControlXca.Controls.Add(this.tabPageStation200);
            this.tabControlXca.Location = new System.Drawing.Point(0, 73);
            this.tabControlXca.Name = "tabControlXca";
            this.tabControlXca.SelectedIndex = 0;
            this.tabControlXca.Size = new System.Drawing.Size(648, 67);
            this.tabControlXca.TabIndex = 7;
            this.tabControlXca.TabStop = false;
            // 
            // DoDtabControl
            // 
            this.DoDtabControl.Controls.Add(this.tabPage1);
            this.DoDtabControl.Location = new System.Drawing.Point(0, 142);
            this.DoDtabControl.Name = "DoDtabControl";
            this.DoDtabControl.SelectedIndex = 0;
            this.DoDtabControl.Size = new System.Drawing.Size(648, 110);
            this.DoDtabControl.TabIndex = 8;
            this.DoDtabControl.TabStop = false;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.textBoxRequestSource);
            this.tabPage1.Controls.Add(this.label4);
            this.tabPage1.Controls.Add(this.textBoxLoinc);
            this.tabPage1.Controls.Add(this.label3);
            this.tabPage1.Controls.Add(this.textBoxProvider);
            this.tabPage1.Controls.Add(this.label2);
            this.tabPage1.Controls.Add(this.textBoxDoDConnectorPort);
            this.tabPage1.Controls.Add(this.label14);
            this.tabPage1.Controls.Add(this.textBoxDoDConnectorHost);
            this.tabPage1.Controls.Add(this.label13);
            this.tabPage1.Location = new System.Drawing.Point(4, 29);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Size = new System.Drawing.Size(640, 77);
            this.tabPage1.TabIndex = 3;
            this.tabPage1.Text = "DoD Connector";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // textBoxRequestSource
            // 
            this.textBoxRequestSource.Location = new System.Drawing.Point(276, 41);
            this.textBoxRequestSource.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxRequestSource.Name = "textBoxRequestSource";
            this.textBoxRequestSource.Size = new System.Drawing.Size(158, 26);
            this.textBoxRequestSource.TabIndex = 4;
            this.textBoxRequestSource.Text = "VADAS";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(143, 44);
            this.label4.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(129, 20);
            this.label4.TabIndex = 17;
            this.label4.Text = "Request Source";
            this.label4.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxLoinc
            // 
            this.textBoxLoinc.Location = new System.Drawing.Point(508, 40);
            this.textBoxLoinc.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxLoinc.Name = "textBoxLoinc";
            this.textBoxLoinc.Size = new System.Drawing.Size(115, 26);
            this.textBoxLoinc.TabIndex = 5;
            this.textBoxLoinc.Text = "34794-8";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(442, 43);
            this.label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(60, 20);
            this.label3.TabIndex = 15;
            this.label3.Text = "LOINC";
            this.label3.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxProvider
            // 
            this.textBoxProvider.Location = new System.Drawing.Point(508, 10);
            this.textBoxProvider.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.textBoxProvider.Name = "textBoxProvider";
            this.textBoxProvider.Size = new System.Drawing.Size(115, 26);
            this.textBoxProvider.TabIndex = 3;
            this.textBoxProvider.Text = "123";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(429, 10);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(71, 20);
            this.label2.TabIndex = 13;
            this.label2.Text = "Provider";
            this.label2.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxDoDConnectorPort
            // 
            this.textBoxDoDConnectorPort.Location = new System.Drawing.Point(57, 43);
            this.textBoxDoDConnectorPort.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxDoDConnectorPort.Name = "textBoxDoDConnectorPort";
            this.textBoxDoDConnectorPort.Size = new System.Drawing.Size(78, 26);
            this.textBoxDoDConnectorPort.TabIndex = 2;
            this.textBoxDoDConnectorPort.Text = "443";
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Location = new System.Drawing.Point(9, 44);
            this.label14.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(40, 20);
            this.label14.TabIndex = 11;
            this.label14.Text = "Port";
            this.label14.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxDoDConnectorHost
            // 
            this.textBoxDoDConnectorHost.Location = new System.Drawing.Point(56, 10);
            this.textBoxDoDConnectorHost.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.textBoxDoDConnectorHost.Name = "textBoxDoDConnectorHost";
            this.textBoxDoDConnectorHost.Size = new System.Drawing.Size(326, 26);
            this.textBoxDoDConnectorHost.TabIndex = 1;
            this.textBoxDoDConnectorHost.Text = "das.va.gov";
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Location = new System.Drawing.Point(8, 13);
            this.label13.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(45, 20);
            this.label13.TabIndex = 9;
            this.label13.Text = "Host";
            this.label13.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // ConfigureDoDPage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 20F);
            this.Controls.Add(this.DoDtabControl);
            this.Controls.Add(this.labelVCPlusPlus2008Runtime);
            this.Controls.Add(this.buttonVCPlusPlus2008Runtime);
            this.Controls.Add(this.tabControlXca);
            this.Controls.Add(this.labelErrorInfo);
            this.Controls.Add(this.buttonConfirm);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Name = "ConfigureDoDPage";
            this.Size = new System.Drawing.Size(662, 367);
            this.Controls.SetChildIndex(this.buttonConfirm, 0);
            this.Controls.SetChildIndex(this.labelErrorInfo, 0);
            this.Controls.SetChildIndex(this.tabControlXca, 0);
            this.Controls.SetChildIndex(this.buttonVCPlusPlus2008Runtime, 0);
            this.Controls.SetChildIndex(this.labelVCPlusPlus2008Runtime, 0);
            this.Controls.SetChildIndex(this.DoDtabControl, 0);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).EndInit();
            this.tabPageStation200.ResumeLayout(false);
            this.tabPageStation200.PerformLayout();
            this.tabControlXca.ResumeLayout(false);
            this.DoDtabControl.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private ErrorProviderFixed errorProvider;
        private System.Windows.Forms.Button buttonConfirm;
        private System.Windows.Forms.Label labelErrorInfo;
        private System.Windows.Forms.Label labelVCPlusPlus2008Runtime;
        private System.Windows.Forms.Button buttonVCPlusPlus2008Runtime;
        private System.Windows.Forms.TabControl tabControlXca;
        private System.Windows.Forms.TabPage tabPageStation200;
        private System.Windows.Forms.TextBox textBoxStation200UserName;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.TabControl DoDtabControl;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TextBox textBoxRequestSource;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox textBoxLoinc;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox textBoxProvider;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox textBoxDoDConnectorPort;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.TextBox textBoxDoDConnectorHost;
        private System.Windows.Forms.Label label13;
    }
}
