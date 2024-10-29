namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class NewInstallWelcomePage
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

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.textBoxWelcomeText = new System.Windows.Forms.TextBox();
            this.textBoxWelcomeHeader = new System.Windows.Forms.TextBox();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // pictureBox1
            // 
            this.pictureBox1.BackColor = System.Drawing.Color.White;
            this.pictureBox1.Dock = System.Windows.Forms.DockStyle.Left;
            this.pictureBox1.Location = new System.Drawing.Point(0, 0);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(164, 502);
            this.pictureBox1.TabIndex = 0;
            this.pictureBox1.TabStop = false;
            // 
            // textBoxWelcomeText
            // 
            this.textBoxWelcomeText.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.textBoxWelcomeText.BackColor = System.Drawing.Color.White;
            this.textBoxWelcomeText.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.textBoxWelcomeText.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBoxWelcomeText.Location = new System.Drawing.Point(164, 71);
            this.textBoxWelcomeText.Multiline = true;
            this.textBoxWelcomeText.Name = "textBoxWelcomeText";
            this.textBoxWelcomeText.ReadOnly = true;
            this.textBoxWelcomeText.Size = new System.Drawing.Size(876, 419);
            this.textBoxWelcomeText.TabIndex = 0;
            this.textBoxWelcomeText.TabStop = false;
            // 
            // textBoxWelcomeHeader
            // 
            this.textBoxWelcomeHeader.BackColor = System.Drawing.Color.White;
            this.textBoxWelcomeHeader.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.textBoxWelcomeHeader.Dock = System.Windows.Forms.DockStyle.Top;
            this.textBoxWelcomeHeader.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBoxWelcomeHeader.Location = new System.Drawing.Point(164, 0);
            this.textBoxWelcomeHeader.Multiline = true;
            this.textBoxWelcomeHeader.Name = "textBoxWelcomeHeader";
            this.textBoxWelcomeHeader.ReadOnly = true;
            this.textBoxWelcomeHeader.Size = new System.Drawing.Size(879, 62);
            this.textBoxWelcomeHeader.TabIndex = 0;
            this.textBoxWelcomeHeader.TabStop = false;
            // 
            // NewInstallWelcomePage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(17F, 33F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.textBoxWelcomeHeader);
            this.Controls.Add(this.textBoxWelcomeText);
            this.Controls.Add(this.pictureBox1);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 21.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Margin = new System.Windows.Forms.Padding(5);
            this.Name = "NewInstallWelcomePage";
            this.Size = new System.Drawing.Size(1043, 502);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.TextBox textBoxWelcomeText;
        private System.Windows.Forms.TextBox textBoxWelcomeHeader;
    }
}
