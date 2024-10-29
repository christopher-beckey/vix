namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class UndeployVixPage
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
            this.buttonUninstallViXWebApps = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // textBoxInfo
            // 
            this.textBoxInfo.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.textBoxInfo.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBoxInfo.Location = new System.Drawing.Point(21, 90);
            this.textBoxInfo.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxInfo.Multiline = true;
            this.textBoxInfo.Name = "textBoxInfo";
            this.textBoxInfo.ReadOnly = true;
            this.textBoxInfo.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBoxInfo.Size = new System.Drawing.Size(801, 266);
            this.textBoxInfo.TabIndex = 1;
            this.textBoxInfo.TabStop = false;
            // 
            // buttonUninstallViXWebApps
            // 
            this.buttonUninstallViXWebApps.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonUninstallViXWebApps.Location = new System.Drawing.Point(591, 364);
            this.buttonUninstallViXWebApps.Margin = new System.Windows.Forms.Padding(4);
            this.buttonUninstallViXWebApps.Name = "buttonUninstallViXWebApps";
            this.buttonUninstallViXWebApps.Size = new System.Drawing.Size(230, 28);
            this.buttonUninstallViXWebApps.TabIndex = 2;
            this.buttonUninstallViXWebApps.Text = "Uninstall version";
            this.buttonUninstallViXWebApps.UseVisualStyleBackColor = true;
            this.buttonUninstallViXWebApps.Click += new System.EventHandler(this.buttonUninstallViXWebApps_Click);
            // 
            // UndeployVixPage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.Controls.Add(this.buttonUninstallViXWebApps);
            this.Controls.Add(this.textBoxInfo);
            this.Name = "UndeployVixPage";
            this.Controls.SetChildIndex(this.textBoxInfo, 0);
            this.Controls.SetChildIndex(this.buttonUninstallViXWebApps, 0);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textBoxInfo;
        private System.Windows.Forms.Button buttonUninstallViXWebApps;
    }
}
