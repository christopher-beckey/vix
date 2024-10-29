namespace SCIP_Tool
{
    partial class FormImage
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
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.tbRuns = new System.Windows.Forms.TextBox();
            this.ButtonCancel = new System.Windows.Forms.Button();
            this.lblRuns = new System.Windows.Forms.Label();
            this.ButtonConvert = new System.Windows.Forms.Button();
            this.ButtonFolderBrowse = new System.Windows.Forms.Button();
            this.TextInputFolder = new System.Windows.Forms.TextBox();
            this.lblJpegFolder = new System.Windows.Forms.Label();
            this.tbOutput = new System.Windows.Forms.TextBox();
            this.flowLayoutPanel2 = new System.Windows.Forms.FlowLayoutPanel();
            this.ButtonClose = new System.Windows.Forms.Button();
            this.flowLayoutPanel3 = new System.Windows.Forms.FlowLayoutPanel();
            this.lblInfo = new System.Windows.Forms.Label();
            this.flowLayoutPanel1.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.flowLayoutPanel2.SuspendLayout();
            this.flowLayoutPanel3.SuspendLayout();
            this.SuspendLayout();
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.AutoSize = true;
            this.flowLayoutPanel1.Controls.Add(this.groupBox1);
            this.flowLayoutPanel1.Controls.Add(this.tbOutput);
            this.flowLayoutPanel1.FlowDirection = System.Windows.Forms.FlowDirection.TopDown;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(8, 5);
            this.flowLayoutPanel1.Margin = new System.Windows.Forms.Padding(1);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(749, 332);
            this.flowLayoutPanel1.TabIndex = 0;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.tbRuns);
            this.groupBox1.Controls.Add(this.ButtonCancel);
            this.groupBox1.Controls.Add(this.lblRuns);
            this.groupBox1.Controls.Add(this.ButtonConvert);
            this.groupBox1.Controls.Add(this.ButtonFolderBrowse);
            this.groupBox1.Controls.Add(this.TextInputFolder);
            this.groupBox1.Controls.Add(this.lblJpegFolder);
            this.groupBox1.Location = new System.Drawing.Point(1, 1);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(1, 1, 1, 4);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(1);
            this.groupBox1.Size = new System.Drawing.Size(739, 64);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            // 
            // tbRuns
            // 
            this.tbRuns.Location = new System.Drawing.Point(312, 20);
            this.tbRuns.Margin = new System.Windows.Forms.Padding(2, 2, 2, 2);
            this.tbRuns.Name = "tbRuns";
            this.tbRuns.Size = new System.Drawing.Size(38, 20);
            this.tbRuns.TabIndex = 22;
            this.tbRuns.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // ButtonCancel
            // 
            this.ButtonCancel.Location = new System.Drawing.Point(680, 9);
            this.ButtonCancel.Margin = new System.Windows.Forms.Padding(1);
            this.ButtonCancel.Name = "ButtonCancel";
            this.ButtonCancel.Size = new System.Drawing.Size(58, 29);
            this.ButtonCancel.TabIndex = 21;
            this.ButtonCancel.Text = "Cancel";
            this.ButtonCancel.UseVisualStyleBackColor = true;
            this.ButtonCancel.Click += new System.EventHandler(this.ButtonCancel_Click);
            // 
            // lblRuns
            // 
            this.lblRuns.AutoSize = true;
            this.lblRuns.Location = new System.Drawing.Point(312, 7);
            this.lblRuns.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.lblRuns.Name = "lblRuns";
            this.lblRuns.Size = new System.Drawing.Size(32, 13);
            this.lblRuns.TabIndex = 18;
            this.lblRuns.Text = "Runs";
            // 
            // ButtonConvert
            // 
            this.ButtonConvert.Location = new System.Drawing.Point(594, 11);
            this.ButtonConvert.Margin = new System.Windows.Forms.Padding(2, 2, 2, 2);
            this.ButtonConvert.Name = "ButtonConvert";
            this.ButtonConvert.Size = new System.Drawing.Size(74, 27);
            this.ButtonConvert.TabIndex = 17;
            this.ButtonConvert.Tag = "";
            this.ButtonConvert.Text = "Convert";
            this.ButtonConvert.UseVisualStyleBackColor = true;
            this.ButtonConvert.Click += new System.EventHandler(this.ButtonConvert_Click);
            // 
            // ButtonFolderBrowse
            // 
            this.ButtonFolderBrowse.Location = new System.Drawing.Point(273, 17);
            this.ButtonFolderBrowse.Margin = new System.Windows.Forms.Padding(2, 2, 2, 2);
            this.ButtonFolderBrowse.Name = "ButtonFolderBrowse";
            this.ButtonFolderBrowse.Size = new System.Drawing.Size(25, 21);
            this.ButtonFolderBrowse.TabIndex = 15;
            this.ButtonFolderBrowse.Text = "...";
            this.ButtonFolderBrowse.UseVisualStyleBackColor = true;
            this.ButtonFolderBrowse.Click += new System.EventHandler(this.ButtonFolderBrowse_Click);
            // 
            // TextInputFolder
            // 
            this.TextInputFolder.Location = new System.Drawing.Point(9, 20);
            this.TextInputFolder.Margin = new System.Windows.Forms.Padding(2, 2, 2, 2);
            this.TextInputFolder.Name = "TextInputFolder";
            this.TextInputFolder.Size = new System.Drawing.Size(258, 20);
            this.TextInputFolder.TabIndex = 14;
            this.TextInputFolder.TextChanged += new System.EventHandler(this.TextFolder_TextChanged);
            // 
            // lblJpegFolder
            // 
            this.lblJpegFolder.AutoSize = true;
            this.lblJpegFolder.Location = new System.Drawing.Point(7, 7);
            this.lblJpegFolder.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.lblJpegFolder.Name = "lblJpegFolder";
            this.lblJpegFolder.Size = new System.Drawing.Size(63, 13);
            this.lblJpegFolder.TabIndex = 13;
            this.lblJpegFolder.Text = "Input Folder";
            // 
            // tbOutput
            // 
            this.tbOutput.Location = new System.Drawing.Point(1, 70);
            this.tbOutput.Margin = new System.Windows.Forms.Padding(1);
            this.tbOutput.Multiline = true;
            this.tbOutput.Name = "tbOutput";
            this.tbOutput.ReadOnly = true;
            this.tbOutput.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.tbOutput.Size = new System.Drawing.Size(737, 258);
            this.tbOutput.TabIndex = 3;
            // 
            // flowLayoutPanel2
            // 
            this.flowLayoutPanel2.Controls.Add(this.ButtonClose);
            this.flowLayoutPanel2.Location = new System.Drawing.Point(666, 344);
            this.flowLayoutPanel2.Margin = new System.Windows.Forms.Padding(1);
            this.flowLayoutPanel2.Name = "flowLayoutPanel2";
            this.flowLayoutPanel2.Size = new System.Drawing.Size(92, 45);
            this.flowLayoutPanel2.TabIndex = 3;
            // 
            // ButtonClose
            // 
            this.ButtonClose.Enabled = false;
            this.ButtonClose.Location = new System.Drawing.Point(1, 1);
            this.ButtonClose.Margin = new System.Windows.Forms.Padding(1);
            this.ButtonClose.Name = "ButtonClose";
            this.ButtonClose.Size = new System.Drawing.Size(81, 30);
            this.ButtonClose.TabIndex = 3;
            this.ButtonClose.Text = "Close";
            this.ButtonClose.UseVisualStyleBackColor = true;
            this.ButtonClose.Click += new System.EventHandler(this.ButtonClose_Click);
            // 
            // flowLayoutPanel3
            // 
            this.flowLayoutPanel3.Controls.Add(this.lblInfo);
            this.flowLayoutPanel3.Location = new System.Drawing.Point(8, 344);
            this.flowLayoutPanel3.Margin = new System.Windows.Forms.Padding(1);
            this.flowLayoutPanel3.Name = "flowLayoutPanel3";
            this.flowLayoutPanel3.Size = new System.Drawing.Size(644, 42);
            this.flowLayoutPanel3.TabIndex = 4;
            // 
            // lblInfo
            // 
            this.lblInfo.AutoSize = true;
            this.lblInfo.Location = new System.Drawing.Point(1, 0);
            this.lblInfo.Margin = new System.Windows.Forms.Padding(1, 0, 1, 0);
            this.lblInfo.Name = "lblInfo";
            this.lblInfo.Size = new System.Drawing.Size(35, 13);
            this.lblInfo.TabIndex = 0;
            this.lblInfo.Text = "lblInfo";
            // 
            // FormImage
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.ClientSize = new System.Drawing.Size(777, 394);
            this.ControlBox = false;
            this.Controls.Add(this.flowLayoutPanel3);
            this.Controls.Add(this.flowLayoutPanel2);
            this.Controls.Add(this.flowLayoutPanel1);
            this.Margin = new System.Windows.Forms.Padding(1);
            this.Name = "FormImage";
            this.Text = "Image Conversion";
            this.flowLayoutPanel1.ResumeLayout(false);
            this.flowLayoutPanel1.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.flowLayoutPanel2.ResumeLayout(false);
            this.flowLayoutPanel3.ResumeLayout(false);
            this.flowLayoutPanel3.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel2;
        private System.Windows.Forms.Button ButtonClose;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.TextBox TextInputFolder;
        private System.Windows.Forms.Label lblJpegFolder;
        private System.Windows.Forms.Button ButtonFolderBrowse;
        private System.Windows.Forms.Label lblRuns;
        private System.Windows.Forms.Button ButtonConvert;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel3;
        private System.Windows.Forms.Label lblInfo;
        private System.Windows.Forms.TextBox tbOutput;
        private System.Windows.Forms.Button ButtonCancel;
        private System.Windows.Forms.TextBox tbRuns;
    }
}