namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    partial class WizardForm
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
            this.panelWizardPageContainer = new System.Windows.Forms.Panel();
            this.buttonCancel = new System.Windows.Forms.Button();
            this.buttonNext = new System.Windows.Forms.Button();
            this.buttonBack = new System.Windows.Forms.Button();
            this.labelDevMode = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // panelWizardPageContainer
            // 
            this.panelWizardPageContainer.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.panelWizardPageContainer.BackColor = System.Drawing.SystemColors.ControlLight;
            this.panelWizardPageContainer.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.panelWizardPageContainer.Location = new System.Drawing.Point(0, 0);
            this.panelWizardPageContainer.Name = "panelWizardPageContainer";
            this.panelWizardPageContainer.Size = new System.Drawing.Size(640, 421);
            this.panelWizardPageContainer.TabIndex = 0;
            // 
            // buttonCancel
            // 
            this.buttonCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonCancel.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.buttonCancel.Location = new System.Drawing.Point(549, 439);
            this.buttonCancel.Name = "buttonCancel";
            this.buttonCancel.Size = new System.Drawing.Size(75, 23);
            this.buttonCancel.TabIndex = 3;
            this.buttonCancel.Text = "Cancel";
            this.buttonCancel.Click += new System.EventHandler(this.buttonCancel_Click);
            // 
            // buttonNext
            // 
            this.buttonNext.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonNext.Enabled = false;
            this.buttonNext.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.buttonNext.Location = new System.Drawing.Point(444, 439);
            this.buttonNext.Name = "buttonNext";
            this.buttonNext.Size = new System.Drawing.Size(75, 23);
            this.buttonNext.TabIndex = 2;
            this.buttonNext.Text = "&Next >";
            this.buttonNext.Click += new System.EventHandler(this.buttonNext_Click);
            // 
            // buttonBack
            // 
            this.buttonBack.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonBack.Enabled = false;
            this.buttonBack.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.buttonBack.Location = new System.Drawing.Point(367, 439);
            this.buttonBack.Name = "buttonBack";
            this.buttonBack.Size = new System.Drawing.Size(75, 23);
            this.buttonBack.TabIndex = 1;
            this.buttonBack.Text = "< &Back";
            this.buttonBack.Click += new System.EventHandler(this.buttonBack_Click);
            // 
            // labelDevMode
            // 
            this.labelDevMode.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.labelDevMode.Location = new System.Drawing.Point(-2, 416);
            this.labelDevMode.Name = "labelDevMode";
            this.labelDevMode.Size = new System.Drawing.Size(25, 22);
            this.labelDevMode.TabIndex = 0;
            this.labelDevMode.Text = " ";
            this.labelDevMode.Click += new System.EventHandler(this.labelDevMode_Click);
            // 
            // WizardForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(639, 491);
            this.ControlBox = false;
            this.Controls.Add(this.labelDevMode);
            this.Controls.Add(this.buttonCancel);
            this.Controls.Add(this.buttonNext);
            this.Controls.Add(this.buttonBack);
            this.Controls.Add(this.panelWizardPageContainer);
            this.MinimumSize = new System.Drawing.Size(646, 424);
            this.Name = "WizardForm";
            this.Text = "Service Installation Wizard";
            this.Load += new System.EventHandler(this.WizardForm_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panelWizardPageContainer;
        private System.Windows.Forms.Button buttonCancel;
        private System.Windows.Forms.Button buttonNext;
        private System.Windows.Forms.Button buttonBack;
        private System.Windows.Forms.Label labelDevMode;
    }
}