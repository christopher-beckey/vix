namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class ConfigureMusePage
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
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.textBoxMuseSiteNum = new System.Windows.Forms.TextBox();
            this.textBoxMuseHost = new System.Windows.Forms.TextBox();
            this.textBoxMuseConfirmPassword = new System.Windows.Forms.TextBox();
            this.textBoxMusePassword = new System.Windows.Forms.TextBox();
            this.textBoxMuseUsername = new System.Windows.Forms.TextBox();
            this.textBoxMusePort = new System.Windows.Forms.TextBox();
            this.comboBoxMuseProtocol = new System.Windows.Forms.ComboBox();
            this.labelMuseSiteNum = new System.Windows.Forms.Label();
            this.labelMuseHost = new System.Windows.Forms.Label();
            this.labelMuseUsername = new System.Windows.Forms.Label();
            this.labelMusePassword = new System.Windows.Forms.Label();
            this.labelMuseConfirmPassword = new System.Windows.Forms.Label();
            this.labelMusePort = new System.Windows.Forms.Label();
            this.labelMuseProtocol = new System.Windows.Forms.Label();
            this.checkBoxMuse = new System.Windows.Forms.CheckBox();
            this.buttonShowHide = new System.Windows.Forms.Button();
            this.labelErrorInfo = new System.Windows.Forms.Label();
            this.buttonConfirm = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).BeginInit();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // errorProvider
            // 
            this.errorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink;
            this.errorProvider.ContainerControl = this;
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.textBoxMuseSiteNum);
            this.groupBox2.Controls.Add(this.textBoxMuseHost);
            this.groupBox2.Controls.Add(this.textBoxMuseConfirmPassword);
            this.groupBox2.Controls.Add(this.textBoxMusePassword);
            this.groupBox2.Controls.Add(this.textBoxMuseUsername);
            this.groupBox2.Controls.Add(this.textBoxMusePort);
            this.groupBox2.Controls.Add(this.comboBoxMuseProtocol);
            this.groupBox2.Controls.Add(this.labelMuseSiteNum);
            this.groupBox2.Controls.Add(this.labelMuseHost);
            this.groupBox2.Controls.Add(this.labelMuseUsername);
            this.groupBox2.Controls.Add(this.labelMusePassword);
            this.groupBox2.Controls.Add(this.labelMuseConfirmPassword);
            this.groupBox2.Controls.Add(this.labelMusePort);
            this.groupBox2.Controls.Add(this.labelMuseProtocol);
            this.groupBox2.Location = new System.Drawing.Point(8, 108);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(425, 228);
            this.groupBox2.TabIndex = 1;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Specify the MUSE or MUSE NX configuration";
            // 
            // textBoxMuseSiteNum
            // 
            this.textBoxMuseSiteNum.Location = new System.Drawing.Point(175, 21);
            this.textBoxMuseSiteNum.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxMuseSiteNum.MaxLength = 1;
            this.textBoxMuseSiteNum.Name = "textBoxMuseSiteNum";
            this.textBoxMuseSiteNum.Size = new System.Drawing.Size(204, 22);
            this.textBoxMuseSiteNum.TabIndex = 1;
            this.textBoxMuseSiteNum.TextChanged += new System.EventHandler(this.textBoxMuseSiteNum_TextChanged);
            this.textBoxMuseSiteNum.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.textBoxMuseSiteNum_KeyPress);
            // 
            // textBoxMuseHost
            // 
            this.textBoxMuseHost.Location = new System.Drawing.Point(175, 51);
            this.textBoxMuseHost.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxMuseHost.Name = "textBoxMuseHost";
            this.textBoxMuseHost.Size = new System.Drawing.Size(204, 22);
            this.textBoxMuseHost.TabIndex = 2;
            this.textBoxMuseHost.TextChanged += new System.EventHandler(this.textBoxMuseHost_TextChanged);
            // 
            // textBoxMuseConfirmPassword
            // 
            this.textBoxMuseConfirmPassword.Location = new System.Drawing.Point(174, 141);
            this.textBoxMuseConfirmPassword.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxMuseConfirmPassword.Name = "textBoxMuseConfirmPassword";
            this.textBoxMuseConfirmPassword.Size = new System.Drawing.Size(203, 22);
            this.textBoxMuseConfirmPassword.TabIndex = 5;
            this.textBoxMuseConfirmPassword.UseSystemPasswordChar = true;
            this.textBoxMuseConfirmPassword.TextChanged += new System.EventHandler(this.textBoxMuseConfirmPassword_TextChanged);
            // 
            // textBoxMusePassword
            // 
            this.textBoxMusePassword.Location = new System.Drawing.Point(174, 111);
            this.textBoxMusePassword.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxMusePassword.Name = "textBoxMusePassword";
            this.textBoxMusePassword.Size = new System.Drawing.Size(204, 22);
            this.textBoxMusePassword.TabIndex = 4;
            this.textBoxMusePassword.UseSystemPasswordChar = true;
            this.textBoxMusePassword.TextChanged += new System.EventHandler(this.textBoxMusePassword_TextChanged);
            // 
            // textBoxMuseUsername
            // 
            this.textBoxMuseUsername.Location = new System.Drawing.Point(175, 81);
            this.textBoxMuseUsername.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxMuseUsername.Name = "textBoxMuseUsername";
            this.textBoxMuseUsername.Size = new System.Drawing.Size(203, 22);
            this.textBoxMuseUsername.TabIndex = 3;
            this.textBoxMuseUsername.UseSystemPasswordChar = true;
            this.textBoxMuseUsername.TextChanged += new System.EventHandler(this.textBoxMuseUsername_TextChanged);
            // 
            // textBoxMusePort
            // 
            this.textBoxMusePort.Location = new System.Drawing.Point(174, 170);
            this.textBoxMusePort.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxMusePort.Name = "textBoxMusePort";
            this.textBoxMusePort.Size = new System.Drawing.Size(203, 22);
            this.textBoxMusePort.TabIndex = 6;
            this.textBoxMusePort.TextChanged += new System.EventHandler(this.textBoxMusePort_TextChanged);
            this.textBoxMusePort.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.textBoxMusePort_KeyPress);
            // 
            // comboBoxMuseProtocol
            // 
            this.comboBoxMuseProtocol.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxMuseProtocol.FormattingEnabled = true;
            this.comboBoxMuseProtocol.Items.AddRange(new object[] {
            "http",
            "https"});
            this.comboBoxMuseProtocol.Location = new System.Drawing.Point(174, 199);
            this.comboBoxMuseProtocol.Name = "comboBoxMuseProtocol";
            this.comboBoxMuseProtocol.Size = new System.Drawing.Size(203, 24);
            this.comboBoxMuseProtocol.TabIndex = 7;
            this.comboBoxMuseProtocol.SelectedIndexChanged += new System.EventHandler(this.comboBoxMuseProtocol_SelectedIndexChanged);
            // 
            // labelMuseSiteNum
            // 
            this.labelMuseSiteNum.AutoSize = true;
            this.labelMuseSiteNum.Location = new System.Drawing.Point(39, 24);
            this.labelMuseSiteNum.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.labelMuseSiteNum.Name = "labelMuseSiteNum";
            this.labelMuseSiteNum.Size = new System.Drawing.Size(127, 16);
            this.labelMuseSiteNum.TabIndex = 0;
            this.labelMuseSiteNum.Text = "MUSE Site Number:";
            this.labelMuseSiteNum.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // labelMuseHost
            // 
            this.labelMuseHost.AutoSize = true;
            this.labelMuseHost.Location = new System.Drawing.Point(43, 53);
            this.labelMuseHost.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.labelMuseHost.Name = "labelMuseHost";
            this.labelMuseHost.Size = new System.Drawing.Size(124, 16);
            this.labelMuseHost.TabIndex = 0;
            this.labelMuseHost.Text = "MUSE Server Host:";
            this.labelMuseHost.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // labelMuseUsername
            // 
            this.labelMuseUsername.AutoSize = true;
            this.labelMuseUsername.Location = new System.Drawing.Point(51, 84);
            this.labelMuseUsername.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.labelMuseUsername.Name = "labelMuseUsername";
            this.labelMuseUsername.Size = new System.Drawing.Size(116, 16);
            this.labelMuseUsername.TabIndex = 0;
            this.labelMuseUsername.Text = "MUSE Username:";
            this.labelMuseUsername.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // labelMusePassword
            // 
            this.labelMusePassword.AutoSize = true;
            this.labelMusePassword.Location = new System.Drawing.Point(53, 114);
            this.labelMusePassword.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.labelMusePassword.Name = "labelMusePassword";
            this.labelMusePassword.Size = new System.Drawing.Size(113, 16);
            this.labelMusePassword.TabIndex = 0;
            this.labelMusePassword.Text = "MUSE Password:";
            this.labelMusePassword.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // labelMuseConfirmPassword
            // 
            this.labelMuseConfirmPassword.AutoSize = true;
            this.labelMuseConfirmPassword.Location = new System.Drawing.Point(8, 144);
            this.labelMuseConfirmPassword.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.labelMuseConfirmPassword.Name = "labelMuseConfirmPassword";
            this.labelMuseConfirmPassword.Size = new System.Drawing.Size(161, 16);
            this.labelMuseConfirmPassword.TabIndex = 0;
            this.labelMuseConfirmPassword.Text = "Confirm MUSE Password:";
            this.labelMuseConfirmPassword.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // labelMusePort
            // 
            this.labelMusePort.AutoSize = true;
            this.labelMusePort.Location = new System.Drawing.Point(87, 173);
            this.labelMusePort.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.labelMusePort.Name = "labelMusePort";
            this.labelMusePort.Size = new System.Drawing.Size(80, 16);
            this.labelMusePort.TabIndex = 0;
            this.labelMusePort.Text = "MUSE Port:";
            this.labelMusePort.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // labelMuseProtocol
            // 
            this.labelMuseProtocol.AutoSize = true;
            this.labelMuseProtocol.Location = new System.Drawing.Point(64, 202);
            this.labelMuseProtocol.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.labelMuseProtocol.Name = "labelMuseProtocol";
            this.labelMuseProtocol.Size = new System.Drawing.Size(103, 16);
            this.labelMuseProtocol.TabIndex = 0;
            this.labelMuseProtocol.Text = "MUSE Protocol:";
            this.labelMuseProtocol.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // checkBoxMuse
            // 
            this.checkBoxMuse.AutoSize = true;
            this.checkBoxMuse.Location = new System.Drawing.Point(13, 82);
            this.checkBoxMuse.Name = "checkBoxMuse";
            this.checkBoxMuse.Size = new System.Drawing.Size(196, 20);
            this.checkBoxMuse.TabIndex = 1;
            this.checkBoxMuse.Text = "Enable and configure MUSE or MUSE NX";
            this.checkBoxMuse.UseVisualStyleBackColor = true;
            this.checkBoxMuse.CheckedChanged += new System.EventHandler(this.checkBoxMuse_CheckedChanged);
            // 
            // buttonShowHide
            // 
            this.buttonShowHide.Enabled = false;
            this.buttonShowHide.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonShowHide.Location = new System.Drawing.Point(455, 236);
            this.buttonShowHide.Name = "buttonShowHide";
            this.buttonShowHide.Size = new System.Drawing.Size(75, 25);
            this.buttonShowHide.TabIndex = 7;
            this.buttonShowHide.Text = "Show";
            this.buttonShowHide.UseVisualStyleBackColor = true;
            this.buttonShowHide.Click += new System.EventHandler(this.buttonShowHide_Click);
            // 
            // labelErrorInfo
            // 
            this.labelErrorInfo.AutoSize = true;
            this.labelErrorInfo.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelErrorInfo.Location = new System.Drawing.Point(10, 339);
            this.labelErrorInfo.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.labelErrorInfo.Name = "labelErrorInfo";
            this.labelErrorInfo.Size = new System.Drawing.Size(240, 16);
            this.labelErrorInfo.TabIndex = 0;
            this.labelErrorInfo.Text = "Mouse over the icon to view error.";
            this.labelErrorInfo.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.labelErrorInfo.Visible = false;
            // 
            // buttonConfirm
            // 
            this.buttonConfirm.Enabled = false;
            this.buttonConfirm.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonConfirm.Location = new System.Drawing.Point(455, 303);
            this.buttonConfirm.Name = "buttonConfirm";
            this.buttonConfirm.Size = new System.Drawing.Size(87, 28);
            this.buttonConfirm.TabIndex = 8;
            this.buttonConfirm.Text = "&Confirm";
            this.buttonConfirm.UseVisualStyleBackColor = true;
            this.buttonConfirm.Click += new System.EventHandler(this.buttonConfirm_Click);
            // 
            // ConfigureMusePage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.Controls.Add(this.labelErrorInfo);
            this.Controls.Add(this.buttonConfirm);
            this.Controls.Add(this.buttonShowHide);
            this.Controls.Add(this.checkBoxMuse);
            this.Controls.Add(this.groupBox2);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Name = "ConfigureMusePage";
            this.Size = new System.Drawing.Size(680, 403);
            this.Controls.SetChildIndex(this.groupBox2, 0);
            this.Controls.SetChildIndex(this.checkBoxMuse, 0);
            this.Controls.SetChildIndex(this.buttonShowHide, 0);
            this.Controls.SetChildIndex(this.buttonConfirm, 0);
            this.Controls.SetChildIndex(this.labelErrorInfo, 0);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).EndInit();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private ErrorProviderFixed errorProvider;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.CheckBox checkBoxMuse;
        private System.Windows.Forms.Label labelMuseSiteNum;
        private System.Windows.Forms.Label labelMuseHost;
        private System.Windows.Forms.Label labelMuseUsername;
        private System.Windows.Forms.Label labelMusePassword;
        private System.Windows.Forms.Label labelMuseConfirmPassword;
        private System.Windows.Forms.Label labelMusePort;
        private System.Windows.Forms.Label labelMuseProtocol;
        private System.Windows.Forms.TextBox textBoxMuseSiteNum;
        private System.Windows.Forms.TextBox textBoxMuseHost;
        private System.Windows.Forms.TextBox textBoxMuseUsername;
        private System.Windows.Forms.TextBox textBoxMusePassword;
        private System.Windows.Forms.TextBox textBoxMuseConfirmPassword;
        private System.Windows.Forms.TextBox textBoxMusePort;
        private System.Windows.Forms.ComboBox comboBoxMuseProtocol;
        private System.Windows.Forms.Button buttonShowHide;
        private System.Windows.Forms.Button buttonConfirm;
        private System.Windows.Forms.Label labelErrorInfo;
    }
}
