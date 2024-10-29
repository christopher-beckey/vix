namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class ConfigureVixCachePage
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
            this.errorProvider1 = new gov.va.med.imaging.exchange.VixInstaller.ui.ErrorProviderFixed(this.components);
            this.groupBoxConfigDir = new System.Windows.Forms.GroupBox();
            this.buttonCreateConfigDir = new System.Windows.Forms.Button();
            this.textBoxLocalConfigDir = new System.Windows.Forms.TextBox();
            this.comboBoxConfigDrive = new System.Windows.Forms.ComboBox();
            this.groupBoxLocalCacheDir = new System.Windows.Forms.GroupBox();
            this.labelCacheSpaceAvailable = new System.Windows.Forms.Label();
            this.textBoxCacheSpaceAvailable = new System.Windows.Forms.TextBox();
            this.buttonCacheDir = new System.Windows.Forms.Button();
            this.textBoxLocalCacheDir = new System.Windows.Forms.TextBox();
            this.comboBoxCacheDrive = new System.Windows.Forms.ComboBox();
            this.groupBoxArchivedLogsDir = new System.Windows.Forms.GroupBox();
            this.labelArchivedLogsSpaceAvailable = new System.Windows.Forms.Label();
            this.textBoxArchivedLogsSpaceAvailable = new System.Windows.Forms.TextBox();
            this.buttonArchivedLogsDir = new System.Windows.Forms.Button();
            this.textBoxLocalArchivedLogsDir = new System.Windows.Forms.TextBox();
            this.comboBoxArchivedLogsDrive = new System.Windows.Forms.ComboBox();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).BeginInit();
            this.groupBoxConfigDir.SuspendLayout();
            this.groupBoxLocalCacheDir.SuspendLayout();
            this.groupBoxArchivedLogsDir.SuspendLayout();
            this.SuspendLayout();
            // 
            // errorProvider1
            // 
            this.errorProvider1.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink;
            this.errorProvider1.ContainerControl = this;
            // 
            // groupBoxConfigDir
            // 
            this.groupBoxConfigDir.Controls.Add(this.buttonCreateConfigDir);
            this.groupBoxConfigDir.Controls.Add(this.textBoxLocalConfigDir);
            this.groupBoxConfigDir.Controls.Add(this.comboBoxConfigDrive);
            this.groupBoxConfigDir.Location = new System.Drawing.Point(11, 77);
            this.groupBoxConfigDir.Name = "groupBoxConfigDir";
            this.groupBoxConfigDir.Size = new System.Drawing.Size(610, 57);
            this.groupBoxConfigDir.TabIndex = 1;
            this.groupBoxConfigDir.TabStop = false;
            // 
            // buttonCreateConfigDir
            // 
            this.buttonCreateConfigDir.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonCreateConfigDir.Location = new System.Drawing.Point(497, 23);
            this.buttonCreateConfigDir.Name = "buttonCreateConfigDir";
            this.buttonCreateConfigDir.Size = new System.Drawing.Size(89, 28);
            this.buttonCreateConfigDir.TabIndex = 4;
            this.buttonCreateConfigDir.Text = "&Create";
            this.buttonCreateConfigDir.UseVisualStyleBackColor = true;
            this.buttonCreateConfigDir.Click += new System.EventHandler(this.buttonCreateConfigDir_Click);
            // 
            // textBoxLocalConfigDir
            // 
            this.textBoxLocalConfigDir.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxLocalConfigDir.Location = new System.Drawing.Point(297, 25);
            this.textBoxLocalConfigDir.Multiline = true;
            this.textBoxLocalConfigDir.Name = "textBoxLocalConfigDir";
            this.textBoxLocalConfigDir.ReadOnly = true;
            this.textBoxLocalConfigDir.Size = new System.Drawing.Size(182, 26);
            this.textBoxLocalConfigDir.TabIndex = 3;
            this.textBoxLocalConfigDir.TabStop = false;
            this.textBoxLocalConfigDir.TextChanged += new System.EventHandler(this.textBoxLocalConfigDir_TextChanged);
            // 
            // comboBoxConfigDrive
            // 
            this.comboBoxConfigDrive.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxConfigDrive.FormattingEnabled = true;
            this.comboBoxConfigDrive.Location = new System.Drawing.Point(34, 25);
            this.comboBoxConfigDrive.Name = "comboBoxConfigDrive";
            this.comboBoxConfigDrive.Size = new System.Drawing.Size(239, 24);
            this.comboBoxConfigDrive.TabIndex = 2;
            this.comboBoxConfigDrive.SelectedIndexChanged += new System.EventHandler(this.comboBoxConfigDrive_SelectedIndexChanged);
            // 
            // groupBoxLocalCacheDir
            // 
            this.groupBoxLocalCacheDir.Controls.Add(this.labelCacheSpaceAvailable);
            this.groupBoxLocalCacheDir.Controls.Add(this.textBoxCacheSpaceAvailable);
            this.groupBoxLocalCacheDir.Controls.Add(this.buttonCacheDir);
            this.groupBoxLocalCacheDir.Controls.Add(this.textBoxLocalCacheDir);
            this.groupBoxLocalCacheDir.Controls.Add(this.comboBoxCacheDrive);
            this.groupBoxLocalCacheDir.Location = new System.Drawing.Point(11, 142);
            this.groupBoxLocalCacheDir.Name = "groupBoxLocalCacheDir";
            this.groupBoxLocalCacheDir.Size = new System.Drawing.Size(610, 88);
            this.groupBoxLocalCacheDir.TabIndex = 5;
            this.groupBoxLocalCacheDir.TabStop = false;
            // 
            // labelCacheSpaceAvailable
            // 
            this.labelCacheSpaceAvailable.Location = new System.Drawing.Point(27, 61);
            this.labelCacheSpaceAvailable.Name = "labelCacheSpaceAvailable";
            this.labelCacheSpaceAvailable.Size = new System.Drawing.Size(327, 21);
            this.labelCacheSpaceAvailable.TabIndex = 9;
            this.labelCacheSpaceAvailable.Text = "Space Available on selected drive (GB)";
            // 
            // textBoxCacheSpaceAvailable
            // 
            this.textBoxCacheSpaceAvailable.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxCacheSpaceAvailable.Location = new System.Drawing.Point(363, 57);
            this.textBoxCacheSpaceAvailable.Multiline = true;
            this.textBoxCacheSpaceAvailable.Name = "textBoxCacheSpaceAvailable";
            this.textBoxCacheSpaceAvailable.ReadOnly = true;
            this.textBoxCacheSpaceAvailable.Size = new System.Drawing.Size(116, 25);
            this.textBoxCacheSpaceAvailable.TabIndex = 10;
            this.textBoxCacheSpaceAvailable.TabStop = false;
            // 
            // buttonCacheDir
            // 
            this.buttonCacheDir.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonCacheDir.Location = new System.Drawing.Point(497, 27);
            this.buttonCacheDir.Name = "buttonCacheDir";
            this.buttonCacheDir.Size = new System.Drawing.Size(89, 27);
            this.buttonCacheDir.TabIndex = 8;
            this.buttonCacheDir.Text = "&Create";
            this.buttonCacheDir.UseVisualStyleBackColor = true;
            this.buttonCacheDir.Click += new System.EventHandler(this.buttonCacheDir_Click);
            // 
            // textBoxLocalCacheDir
            // 
            this.textBoxLocalCacheDir.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxLocalCacheDir.Location = new System.Drawing.Point(297, 25);
            this.textBoxLocalCacheDir.Multiline = true;
            this.textBoxLocalCacheDir.Name = "textBoxLocalCacheDir";
            this.textBoxLocalCacheDir.ReadOnly = true;
            this.textBoxLocalCacheDir.Size = new System.Drawing.Size(182, 25);
            this.textBoxLocalCacheDir.TabIndex = 7;
            this.textBoxLocalCacheDir.TabStop = false;
            this.textBoxLocalCacheDir.TextChanged += new System.EventHandler(this.textBoxLocalCacheDir_TextChanged);
            // 
            // comboBoxCacheDrive
            // 
            this.comboBoxCacheDrive.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxCacheDrive.FormattingEnabled = true;
            this.comboBoxCacheDrive.Location = new System.Drawing.Point(33, 25);
            this.comboBoxCacheDrive.Name = "comboBoxCacheDrive";
            this.comboBoxCacheDrive.Size = new System.Drawing.Size(239, 24);
            this.comboBoxCacheDrive.TabIndex = 6;
            this.comboBoxCacheDrive.SelectedIndexChanged += new System.EventHandler(this.comboBoxCacheDrive_SelectedIndexChanged);
            // 
            // groupBoxArchivedLogsDir
            // 
            this.groupBoxArchivedLogsDir.Controls.Add(this.labelArchivedLogsSpaceAvailable);
            this.groupBoxArchivedLogsDir.Controls.Add(this.textBoxArchivedLogsSpaceAvailable);
            this.groupBoxArchivedLogsDir.Controls.Add(this.buttonArchivedLogsDir);
            this.groupBoxArchivedLogsDir.Controls.Add(this.textBoxLocalArchivedLogsDir);
            this.groupBoxArchivedLogsDir.Controls.Add(this.comboBoxArchivedLogsDrive);
            this.groupBoxArchivedLogsDir.Location = new System.Drawing.Point(11, 237);
            this.groupBoxArchivedLogsDir.Name = "groupBoxArchivedLogsDir";
            this.groupBoxArchivedLogsDir.Size = new System.Drawing.Size(610, 92);
            this.groupBoxArchivedLogsDir.TabIndex = 11;
            this.groupBoxArchivedLogsDir.TabStop = false;
            // 
            // labelArchivedLogsSpaceAvailable
            // 
            this.labelArchivedLogsSpaceAvailable.Location = new System.Drawing.Point(30, 58);
            this.labelArchivedLogsSpaceAvailable.Name = "labelArchivedLogsSpaceAvailable";
            this.labelArchivedLogsSpaceAvailable.Size = new System.Drawing.Size(327, 21);
            this.labelArchivedLogsSpaceAvailable.TabIndex = 15;
            this.labelArchivedLogsSpaceAvailable.Text = "Space Available on selected drive (GB)";
            // 
            // textBoxArchivedLogsSpaceAvailable
            // 
            this.textBoxArchivedLogsSpaceAvailable.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxArchivedLogsSpaceAvailable.Location = new System.Drawing.Point(363, 54);
            this.textBoxArchivedLogsSpaceAvailable.Multiline = true;
            this.textBoxArchivedLogsSpaceAvailable.Name = "textBoxArchivedLogsSpaceAvailable";
            this.textBoxArchivedLogsSpaceAvailable.ReadOnly = true;
            this.textBoxArchivedLogsSpaceAvailable.Size = new System.Drawing.Size(116, 25);
            this.textBoxArchivedLogsSpaceAvailable.TabIndex = 16;
            this.textBoxArchivedLogsSpaceAvailable.TabStop = false;
            // 
            // buttonArchivedLogsDir
            // 
            this.buttonArchivedLogsDir.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonArchivedLogsDir.Location = new System.Drawing.Point(497, 26);
            this.buttonArchivedLogsDir.Name = "buttonArchivedLogsDir";
            this.buttonArchivedLogsDir.Size = new System.Drawing.Size(89, 27);
            this.buttonArchivedLogsDir.TabIndex = 14;
            this.buttonArchivedLogsDir.Text = "&Create";
            this.buttonArchivedLogsDir.UseVisualStyleBackColor = true;
            this.buttonArchivedLogsDir.Click += new System.EventHandler(this.buttonArchivedLogsDir_Click);
            // 
            // textBoxLocalArchivedLogsDir
            // 
            this.textBoxLocalArchivedLogsDir.BackColor = System.Drawing.SystemColors.ControlLight;
            this.textBoxLocalArchivedLogsDir.Location = new System.Drawing.Point(297, 23);
            this.textBoxLocalArchivedLogsDir.Multiline = true;
            this.textBoxLocalArchivedLogsDir.Name = "textBoxLocalArchivedLogsDir";
            this.textBoxLocalArchivedLogsDir.ReadOnly = true;
            this.textBoxLocalArchivedLogsDir.Size = new System.Drawing.Size(182, 25);
            this.textBoxLocalArchivedLogsDir.TabIndex = 13;
            this.textBoxLocalArchivedLogsDir.TabStop = false;
            this.textBoxLocalArchivedLogsDir.TextChanged += new System.EventHandler(this.textBoxLocalArchivedLogsDir_TextChanged);
            // 
            // comboBoxArchivedLogsDrive
            // 
            this.comboBoxArchivedLogsDrive.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxArchivedLogsDrive.FormattingEnabled = true;
            this.comboBoxArchivedLogsDrive.Location = new System.Drawing.Point(33, 24);
            this.comboBoxArchivedLogsDrive.Name = "comboBoxArchivedLogsDrive";
            this.comboBoxArchivedLogsDrive.Size = new System.Drawing.Size(239, 24);
            this.comboBoxArchivedLogsDrive.TabIndex = 12;
            this.comboBoxArchivedLogsDrive.SelectedIndexChanged += new System.EventHandler(this.comboBoxArchivedLogsDrive_SelectedIndexChanged);
            // 
            // ConfigureVixCachePage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.Controls.Add(this.groupBoxArchivedLogsDir);
            this.Controls.Add(this.groupBoxLocalCacheDir);
            this.Controls.Add(this.groupBoxConfigDir);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Name = "ConfigureVixCachePage";
            this.Size = new System.Drawing.Size(629, 404);
            this.Controls.SetChildIndex(this.groupBoxConfigDir, 0);
            this.Controls.SetChildIndex(this.groupBoxLocalCacheDir, 0);
            this.Controls.SetChildIndex(this.groupBoxArchivedLogsDir, 0);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).EndInit();
            this.groupBoxConfigDir.ResumeLayout(false);
            this.groupBoxConfigDir.PerformLayout();
            this.groupBoxLocalCacheDir.ResumeLayout(false);
            this.groupBoxLocalCacheDir.PerformLayout();
            this.groupBoxArchivedLogsDir.ResumeLayout(false);
            this.groupBoxArchivedLogsDir.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private ErrorProviderFixed errorProvider1;
        private System.Windows.Forms.GroupBox groupBoxLocalCacheDir;
        private System.Windows.Forms.GroupBox groupBoxArchivedLogsDir;
        public System.Windows.Forms.TextBox textBoxCacheSpaceAvailable;
        private System.Windows.Forms.Label labelArchivedLogsSpaceAvailable;
        private System.Windows.Forms.Button buttonCacheDir;
        public System.Windows.Forms.TextBox textBoxLocalCacheDir;
        private System.Windows.Forms.ComboBox comboBoxCacheDrive;
        private System.Windows.Forms.ComboBox comboBoxArchivedLogsDrive;
        private System.Windows.Forms.GroupBox groupBoxConfigDir;
        private System.Windows.Forms.Button buttonCreateConfigDir;
        public System.Windows.Forms.TextBox textBoxLocalConfigDir;
        private System.Windows.Forms.ComboBox comboBoxConfigDrive;
        private System.Windows.Forms.Button buttonArchivedLogsDir;
        public System.Windows.Forms.TextBox textBoxLocalArchivedLogsDir;
        public System.Windows.Forms.TextBox textBoxArchivedLogsSpaceAvailable;
        private System.Windows.Forms.Label labelCacheSpaceAvailable;
    }
}
