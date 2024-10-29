namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class ConfigureDicomPage
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
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.label2 = new System.Windows.Forms.Label();
            this.textBoxDicomGatewayPort = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.textBoxDicomGatewayServer = new System.Windows.Forms.TextBox();
            this.errorProvider = new gov.va.med.imaging.exchange.VixInstaller.ui.ErrorProviderFixed(this.components);
            this.buttonConfirm = new System.Windows.Forms.Button();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.textBoxConfirmPassword = new System.Windows.Forms.TextBox();
            this.textBoxPassword = new System.Windows.Forms.TextBox();
            this.textBoxUsername = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.labelErrorInfo = new System.Windows.Forms.Label();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.checkBoxIconGenerationEnabled = new System.Windows.Forms.CheckBox();
            this.checkBoxArchiveEnabled = new System.Windows.Forms.CheckBox();
            this.checkBoxDicomListenerEnabled = new System.Windows.Forms.CheckBox();
            this.label7 = new System.Windows.Forms.Label();
            this.textBoxNotificationEmailAddresses = new System.Windows.Forms.TextBox();
            this.groupBox1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).BeginInit();
            this.groupBox2.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.textBoxDicomGatewayPort);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Controls.Add(this.textBoxDicomGatewayServer);
            this.groupBox1.Location = new System.Drawing.Point(8, 84);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(619, 56);
            this.groupBox1.TabIndex = 1;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Specify the DICOM Image Gateway ";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(375, 25);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(108, 16);
            this.label2.TabIndex = 0;
            this.label2.Text = "Designated Port:";
            this.label2.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxDicomGatewayPort
            // 
            this.textBoxDicomGatewayPort.Location = new System.Drawing.Point(489, 21);
            this.textBoxDicomGatewayPort.Name = "textBoxDicomGatewayPort";
            this.textBoxDicomGatewayPort.ReadOnly = true;
            this.textBoxDicomGatewayPort.Size = new System.Drawing.Size(81, 22);
            this.textBoxDicomGatewayPort.TabIndex = 0;
            this.textBoxDicomGatewayPort.TextChanged += new System.EventHandler(this.textBoxDicomGatewayPort_TextChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(65, 25);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(51, 16);
            this.label1.TabIndex = 0;
            this.label1.Text = "Server:";
            this.label1.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxDicomGatewayServer
            // 
            this.textBoxDicomGatewayServer.Location = new System.Drawing.Point(122, 22);
            this.textBoxDicomGatewayServer.Name = "textBoxDicomGatewayServer";
            this.textBoxDicomGatewayServer.Size = new System.Drawing.Size(203, 22);
            this.textBoxDicomGatewayServer.TabIndex = 1;
            this.textBoxDicomGatewayServer.TextChanged += new System.EventHandler(this.textBoxDicomGatewayServer_TextChanged);
            // 
            // errorProvider
            // 
            this.errorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink;
            this.errorProvider.ContainerControl = this;
            // 
            // buttonConfirm
            // 
            this.buttonConfirm.Enabled = false;
            this.buttonConfirm.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonConfirm.Location = new System.Drawing.Point(540, 309);
            this.buttonConfirm.Name = "buttonConfirm";
            this.buttonConfirm.Size = new System.Drawing.Size(87, 28);
            this.buttonConfirm.TabIndex = 3;
            this.buttonConfirm.Text = "&Confirm";
            this.buttonConfirm.UseVisualStyleBackColor = true;
            this.buttonConfirm.Click += new System.EventHandler(this.buttonConfirm_Click);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.textBoxConfirmPassword);
            this.groupBox2.Controls.Add(this.textBoxPassword);
            this.groupBox2.Controls.Add(this.textBoxUsername);
            this.groupBox2.Controls.Add(this.label3);
            this.groupBox2.Controls.Add(this.label4);
            this.groupBox2.Controls.Add(this.label5);
            this.groupBox2.Location = new System.Drawing.Point(8, 147);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(363, 121);
            this.groupBox2.TabIndex = 2;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Specify the DICOM Gateway service account";
            // 
            // textBoxConfirmPassword
            // 
            this.textBoxConfirmPassword.Location = new System.Drawing.Point(122, 84);
            this.textBoxConfirmPassword.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxConfirmPassword.Name = "textBoxConfirmPassword";
            this.textBoxConfirmPassword.Size = new System.Drawing.Size(203, 22);
            this.textBoxConfirmPassword.TabIndex = 3;
            this.textBoxConfirmPassword.UseSystemPasswordChar = true;
            this.textBoxConfirmPassword.TextChanged += new System.EventHandler(this.textBoxConfirmPassword_TextChanged);
            // 
            // textBoxPassword
            // 
            this.textBoxPassword.Location = new System.Drawing.Point(121, 54);
            this.textBoxPassword.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxPassword.Name = "textBoxPassword";
            this.textBoxPassword.Size = new System.Drawing.Size(204, 22);
            this.textBoxPassword.TabIndex = 2;
            this.textBoxPassword.UseSystemPasswordChar = true;
            this.textBoxPassword.TextChanged += new System.EventHandler(this.textBoxPassword_TextChanged);
            // 
            // textBoxUsername
            // 
            this.textBoxUsername.Location = new System.Drawing.Point(122, 24);
            this.textBoxUsername.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxUsername.Name = "textBoxUsername";
            this.textBoxUsername.Size = new System.Drawing.Size(203, 22);
            this.textBoxUsername.TabIndex = 1;
            this.textBoxUsername.UseSystemPasswordChar = true;
            this.textBoxUsername.TextChanged += new System.EventHandler(this.textBoxUsername_TextChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 87);
            this.label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(93, 16);
            this.label3.TabIndex = 0;
            this.label3.Text = "Confirm Verify:";
            this.label3.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(59, 57);
            this.label4.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(45, 16);
            this.label4.TabIndex = 0;
            this.label4.Text = "Verify:";
            this.label4.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(49, 27);
            this.label5.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(56, 16);
            this.label5.TabIndex = 0;
            this.label5.Text = "Access:";
            this.label5.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // labelErrorInfo
            // 
            this.labelErrorInfo.AutoSize = true;
            this.labelErrorInfo.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelErrorInfo.Location = new System.Drawing.Point(13, 315);
            this.labelErrorInfo.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.labelErrorInfo.Name = "labelErrorInfo";
            this.labelErrorInfo.Size = new System.Drawing.Size(240, 16);
            this.labelErrorInfo.TabIndex = 0;
            this.labelErrorInfo.Text = "Mouse over the icon to view error.";
            this.labelErrorInfo.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.labelErrorInfo.Visible = false;
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.checkBoxIconGenerationEnabled);
            this.groupBox3.Controls.Add(this.checkBoxArchiveEnabled);
            this.groupBox3.Controls.Add(this.checkBoxDicomListenerEnabled);
            this.groupBox3.Location = new System.Drawing.Point(380, 147);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(247, 121);
            this.groupBox3.TabIndex = 4;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Configure Services";
            // 
            // checkBoxIconGenerationEnabled
            // 
            this.checkBoxIconGenerationEnabled.AutoSize = true;
            this.checkBoxIconGenerationEnabled.Location = new System.Drawing.Point(6, 87);
            this.checkBoxIconGenerationEnabled.Name = "checkBoxIconGenerationEnabled";
            this.checkBoxIconGenerationEnabled.Size = new System.Drawing.Size(172, 17);
            this.checkBoxIconGenerationEnabled.TabIndex = 2;
            this.checkBoxIconGenerationEnabled.Text = "Thumbnail Processing Enabled";
            this.checkBoxIconGenerationEnabled.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            this.checkBoxIconGenerationEnabled.UseVisualStyleBackColor = true;
            this.checkBoxIconGenerationEnabled.CheckedChanged += new System.EventHandler(this.checkBoxIconGenerationEnabled_CheckedChanged);
            // 
            // checkBoxArchiveEnabled
            // 
            this.checkBoxArchiveEnabled.AutoSize = true;
            this.checkBoxArchiveEnabled.Location = new System.Drawing.Point(6, 57);
            this.checkBoxArchiveEnabled.Name = "checkBoxArchiveEnabled";
            this.checkBoxArchiveEnabled.Size = new System.Drawing.Size(104, 17);
            this.checkBoxArchiveEnabled.TabIndex = 1;
            this.checkBoxArchiveEnabled.Text = "Archive Enabled";
            this.checkBoxArchiveEnabled.UseVisualStyleBackColor = true;
            this.checkBoxArchiveEnabled.CheckedChanged += new System.EventHandler(this.checkBoxArchiveEnabled_CheckedChanged);
            // 
            // checkBoxDicomListenerEnabled
            // 
            this.checkBoxDicomListenerEnabled.AutoSize = true;
            this.checkBoxDicomListenerEnabled.Location = new System.Drawing.Point(6, 26);
            this.checkBoxDicomListenerEnabled.Name = "checkBoxDicomListenerEnabled";
            this.checkBoxDicomListenerEnabled.Size = new System.Drawing.Size(143, 17);
            this.checkBoxDicomListenerEnabled.TabIndex = 0;
            this.checkBoxDicomListenerEnabled.Text = "DICOM Listener Enabled";
            this.checkBoxDicomListenerEnabled.UseVisualStyleBackColor = true;
            this.checkBoxDicomListenerEnabled.CheckedChanged += new System.EventHandler(this.checkBoxDicomListenerEnabled_CheckedChanged);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(19, 281);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(166, 16);
            this.label7.TabIndex = 0;
            this.label7.Text = "Send email notifications to:";
            this.label7.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // textBoxNotificationEmailAddresses
            // 
            this.textBoxNotificationEmailAddresses.Location = new System.Drawing.Point(191, 278);
            this.textBoxNotificationEmailAddresses.Name = "textBoxNotificationEmailAddresses";
            this.textBoxNotificationEmailAddresses.Size = new System.Drawing.Size(387, 22);
            this.textBoxNotificationEmailAddresses.TabIndex = 1;
            this.textBoxNotificationEmailAddresses.TextChanged += new System.EventHandler(this.textBoxNotificationEmailAddresses_TextChanged);
            // 
            // ConfigureDicomPage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.textBoxNotificationEmailAddresses);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.labelErrorInfo);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.buttonConfirm);
            this.Controls.Add(this.groupBox1);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Name = "ConfigureDicomPage";
            this.Size = new System.Drawing.Size(680, 403);
            this.Controls.SetChildIndex(this.groupBox1, 0);
            this.Controls.SetChildIndex(this.buttonConfirm, 0);
            this.Controls.SetChildIndex(this.groupBox2, 0);
            this.Controls.SetChildIndex(this.labelErrorInfo, 0);
            this.Controls.SetChildIndex(this.groupBox3, 0);
            this.Controls.SetChildIndex(this.textBoxNotificationEmailAddresses, 0);
            this.Controls.SetChildIndex(this.label7, 0);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).EndInit();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox1;
        private ErrorProviderFixed errorProvider;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox textBoxDicomGatewayPort;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBoxDicomGatewayServer;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.Button buttonConfirm;
        private System.Windows.Forms.TextBox textBoxConfirmPassword;
        private System.Windows.Forms.TextBox textBoxPassword;
        private System.Windows.Forms.TextBox textBoxUsername;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label labelErrorInfo;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.CheckBox checkBoxDicomListenerEnabled;
        private System.Windows.Forms.CheckBox checkBoxIconGenerationEnabled;
        private System.Windows.Forms.CheckBox checkBoxArchiveEnabled;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox textBoxNotificationEmailAddresses;
    }
}
