namespace IGToolkit
{
    partial class GearControl
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(GearControl));
            this.axIGPageViewCtl1 = new AxGearVIEWLib.AxIGPageViewCtl();
            this.lblZoom = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.axIGPageViewCtl1)).BeginInit();
            this.SuspendLayout();
            // 
            // axIGPageViewCtl1
            // 
            this.axIGPageViewCtl1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.axIGPageViewCtl1.Location = new System.Drawing.Point(3, 3);
            this.axIGPageViewCtl1.Name = "axIGPageViewCtl1";
            this.axIGPageViewCtl1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axIGPageViewCtl1.OcxState")));
            this.axIGPageViewCtl1.Size = new System.Drawing.Size(352, 314);
            this.axIGPageViewCtl1.TabIndex = 3;
            this.axIGPageViewCtl1.MouseDownEvent += new AxGearVIEWLib._IIGPageViewCtlEvents_MouseDownEventHandler(this.axIGPageViewCtl1_MouseDownEvent);
            this.axIGPageViewCtl1.MouseUpEvent += new AxGearVIEWLib._IIGPageViewCtlEvents_MouseUpEventHandler(this.axIGPageViewCtl1_MouseUpEvent);
            this.axIGPageViewCtl1.MouseMoveEvent += new AxGearVIEWLib._IIGPageViewCtlEvents_MouseMoveEventHandler(this.axIGPageViewCtl1_MouseMoveEvent);
            // 
            // lblZoom
            // 
            this.lblZoom.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.lblZoom.AutoSize = true;
            this.lblZoom.BackColor = System.Drawing.Color.Black;
            this.lblZoom.ForeColor = System.Drawing.Color.White;
            this.lblZoom.Location = new System.Drawing.Point(3, 283);
            this.lblZoom.Name = "lblZoom";
            this.lblZoom.Size = new System.Drawing.Size(0, 13);
            this.lblZoom.TabIndex = 4;
            // 
            // GearControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.lblZoom);
            this.Controls.Add(this.axIGPageViewCtl1);
            this.Name = "GearControl";
            this.Size = new System.Drawing.Size(398, 320);
            this.Load += new System.EventHandler(this.GearControl_Load);
            ((System.ComponentModel.ISupportInitialize)(this.axIGPageViewCtl1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private AxGearVIEWLib.AxIGPageViewCtl axIGPageViewCtl1;
        private System.Windows.Forms.Label lblZoom;

    }
}
