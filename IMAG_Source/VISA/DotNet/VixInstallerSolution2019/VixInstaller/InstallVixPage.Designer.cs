namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class InstallVixPage
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
            this.textBoxInfo = new System.Windows.Forms.TextBox();
            this.buttonInstall = new System.Windows.Forms.Button();
            this.buttonConfigBiaCredentials = new System.Windows.Forms.Button();
            this.checkBoxConfig = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // textBoxInfo
            // 
            this.textBoxInfo.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.textBoxInfo.Location = new System.Drawing.Point(16, 126);
            this.textBoxInfo.Multiline = true;
            this.textBoxInfo.Name = "textBoxInfo";
            this.textBoxInfo.ReadOnly = true;
            this.textBoxInfo.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBoxInfo.Size = new System.Drawing.Size(647, 232);
            this.textBoxInfo.TabIndex = 0;
            this.textBoxInfo.TabStop = false;
            // 
            // buttonInstall
            // 
            this.buttonInstall.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonInstall.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonInstall.Location = new System.Drawing.Point(565, 364);
            this.buttonInstall.Name = "buttonInstall";
            this.buttonInstall.Size = new System.Drawing.Size(98, 28);
            this.buttonInstall.TabIndex = 1;
            this.buttonInstall.Text = "Install";
            this.buttonInstall.UseVisualStyleBackColor = true;
            this.buttonInstall.Click += new System.EventHandler(this.buttonInstall_Click);
            // 
            // buttonConfigBiaCredentials
            // 
            this.buttonConfigBiaCredentials.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonConfigBiaCredentials.Font = new System.Drawing.Font("Microsoft Sans Serif", 7.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonConfigBiaCredentials.Location = new System.Drawing.Point(396, 364);
            this.buttonConfigBiaCredentials.Name = "buttonConfigBiaCredentials";
            this.buttonConfigBiaCredentials.Size = new System.Drawing.Size(163, 28);
            this.buttonConfigBiaCredentials.TabIndex = 5;
            this.buttonConfigBiaCredentials.Text = "Set BIA Credentials";
            this.buttonConfigBiaCredentials.UseVisualStyleBackColor = true;
            this.buttonConfigBiaCredentials.Visible = false;
            this.buttonConfigBiaCredentials.Click += new System.EventHandler(this.buttonConfigBiaCredentials_Click);
            // 
            // checkBoxConfig
            // 
            this.checkBoxConfig.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.checkBoxConfig.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.checkBoxConfig.Location = new System.Drawing.Point(16, 361);
            this.checkBoxConfig.Name = "checkBoxConfig";
            this.checkBoxConfig.Size = new System.Drawing.Size(374, 47);
            this.checkBoxConfig.TabIndex = 6;
            this.checkBoxConfig.Text = "Update server.xml as if new installation";
            this.checkBoxConfig.UseVisualStyleBackColor = true;
            this.checkBoxConfig.Visible = false;
            this.checkBoxConfig.CheckedChanged += new System.EventHandler(this.checkBoxConfig_CheckedChanged);
            // 
            // InstallVixPage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(12F, 25F);
            this.Controls.Add(this.checkBoxConfig);
            this.Controls.Add(this.buttonConfigBiaCredentials);
            this.Controls.Add(this.buttonInstall);
            this.Controls.Add(this.textBoxInfo);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Name = "InstallVixPage";
            this.Size = new System.Drawing.Size(677, 400);
            this.Controls.SetChildIndex(this.textBoxInfo, 0);
            this.Controls.SetChildIndex(this.buttonInstall, 0);
            this.Controls.SetChildIndex(this.buttonConfigBiaCredentials, 0);
            this.Controls.SetChildIndex(this.checkBoxConfig, 0);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textBoxInfo;
        private System.Windows.Forms.Button buttonInstall;
        private System.Windows.Forms.Button buttonConfigBiaCredentials;
        private System.Windows.Forms.CheckBox checkBoxConfig;
    }
}
