namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class InteriorWizardPage
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
            this.textBoxInteriorHeader = new System.Windows.Forms.TextBox();
            this.panelInteriorPageHeader = new System.Windows.Forms.Panel();
            this.textBoxInteriorSubHeader = new System.Windows.Forms.TextBox();
            this.panelInteriorPageHeader.SuspendLayout();
            this.SuspendLayout();
            // 
            // textBoxInteriorHeader
            // 
            this.textBoxInteriorHeader.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.textBoxInteriorHeader.BackColor = System.Drawing.Color.White;
            this.textBoxInteriorHeader.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.textBoxInteriorHeader.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBoxInteriorHeader.Location = new System.Drawing.Point(16, 6);
            this.textBoxInteriorHeader.Multiline = true;
            this.textBoxInteriorHeader.Name = "textBoxInteriorHeader";
            this.textBoxInteriorHeader.ReadOnly = true;
            this.textBoxInteriorHeader.Size = new System.Drawing.Size(614, 20);
            this.textBoxInteriorHeader.TabIndex = 0;
            this.textBoxInteriorHeader.TabStop = false;
            // 
            // panelInteriorPageHeader
            // 
            this.panelInteriorPageHeader.BackColor = System.Drawing.Color.White;
            this.panelInteriorPageHeader.Controls.Add(this.textBoxInteriorSubHeader);
            this.panelInteriorPageHeader.Controls.Add(this.textBoxInteriorHeader);
            this.panelInteriorPageHeader.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelInteriorPageHeader.Location = new System.Drawing.Point(0, 0);
            this.panelInteriorPageHeader.Margin = new System.Windows.Forms.Padding(0);
            this.panelInteriorPageHeader.Name = "panelInteriorPageHeader";
            this.panelInteriorPageHeader.Size = new System.Drawing.Size(633, 70);
            this.panelInteriorPageHeader.TabIndex = 0;
            // 
            // textBoxInteriorSubHeader
            // 
            this.textBoxInteriorSubHeader.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.textBoxInteriorSubHeader.BackColor = System.Drawing.Color.White;
            this.textBoxInteriorSubHeader.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.textBoxInteriorSubHeader.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBoxInteriorSubHeader.Location = new System.Drawing.Point(16, 34);
            this.textBoxInteriorSubHeader.Multiline = true;
            this.textBoxInteriorSubHeader.Name = "textBoxInteriorSubHeader";
            this.textBoxInteriorSubHeader.ReadOnly = true;
            this.textBoxInteriorSubHeader.Size = new System.Drawing.Size(590, 33);
            this.textBoxInteriorSubHeader.TabIndex = 0;
            this.textBoxInteriorSubHeader.TabStop = false;
            // 
            // InteriorWizardPage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.panelInteriorPageHeader);
            this.Margin = new System.Windows.Forms.Padding(0);
            this.Name = "InteriorWizardPage";
            this.Size = new System.Drawing.Size(633, 376);
            this.panelInteriorPageHeader.ResumeLayout(false);
            this.panelInteriorPageHeader.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panelInteriorPageHeader;
        private System.Windows.Forms.TextBox textBoxInteriorHeader;
        private System.Windows.Forms.TextBox textBoxInteriorSubHeader;
    }
}
