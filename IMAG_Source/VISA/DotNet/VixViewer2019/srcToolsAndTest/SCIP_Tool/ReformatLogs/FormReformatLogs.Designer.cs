namespace SCIP_Tool
{
    partial class FormReformatLogs
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
            this.ButtonReformat = new System.Windows.Forms.Button();
            this.ButtonFolderBrowse = new System.Windows.Forms.Button();
            this.TextInputFolder = new System.Windows.Forms.TextBox();
            this.LabelFolder = new System.Windows.Forms.Label();
            this.ButtonCancel = new System.Windows.Forms.Button();
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
            this.flowLayoutPanel1.Location = new System.Drawing.Point(11, 6);
            this.flowLayoutPanel1.Margin = new System.Windows.Forms.Padding(1);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(999, 477);
            this.flowLayoutPanel1.TabIndex = 0;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.ButtonReformat);
            this.groupBox1.Controls.Add(this.ButtonFolderBrowse);
            this.groupBox1.Controls.Add(this.TextInputFolder);
            this.groupBox1.Controls.Add(this.LabelFolder);
            this.groupBox1.Controls.Add(this.ButtonCancel);
            this.groupBox1.Location = new System.Drawing.Point(1, 1);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(1, 1, 1, 5);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(1);
            this.groupBox1.Size = new System.Drawing.Size(985, 69);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            // 
            // ButtonReformat
            // 
            this.ButtonReformat.Location = new System.Drawing.Point(814, 18);
            this.ButtonReformat.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.ButtonReformat.Name = "ButtonReformat";
            this.ButtonReformat.Size = new System.Drawing.Size(77, 36);
            this.ButtonReformat.TabIndex = 28;
            this.ButtonReformat.Tag = "";
            this.ButtonReformat.Text = "Reformat";
            this.ButtonReformat.UseVisualStyleBackColor = true;
            this.ButtonReformat.Click += new System.EventHandler(this.ButtonReformat_Click);
            // 
            // ButtonFolderBrowse
            // 
            this.ButtonFolderBrowse.Location = new System.Drawing.Point(549, 23);
            this.ButtonFolderBrowse.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.ButtonFolderBrowse.Name = "ButtonFolderBrowse";
            this.ButtonFolderBrowse.Size = new System.Drawing.Size(33, 26);
            this.ButtonFolderBrowse.TabIndex = 26;
            this.ButtonFolderBrowse.Text = "...";
            this.ButtonFolderBrowse.UseVisualStyleBackColor = true;
            this.ButtonFolderBrowse.Click += new System.EventHandler(this.ButtonFolderBrowse_Click);
            // 
            // TextInputFolder
            // 
            this.TextInputFolder.Location = new System.Drawing.Point(14, 25);
            this.TextInputFolder.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.TextInputFolder.Name = "TextInputFolder";
            this.TextInputFolder.Size = new System.Drawing.Size(529, 22);
            this.TextInputFolder.TabIndex = 25;
            this.TextInputFolder.TextChanged += new System.EventHandler(this.TextInputFolder_TextChanged);
            // 
            // LabelFolder
            // 
            this.LabelFolder.AutoSize = true;
            this.LabelFolder.Location = new System.Drawing.Point(11, 9);
            this.LabelFolder.Name = "LabelFolder";
            this.LabelFolder.Size = new System.Drawing.Size(210, 17);
            this.LabelFolder.TabIndex = 24;
            this.LabelFolder.Text = "Folder we will copy and reformat";
            // 
            // ButtonCancel
            // 
            this.ButtonCancel.Location = new System.Drawing.Point(906, 18);
            this.ButtonCancel.Margin = new System.Windows.Forms.Padding(1);
            this.ButtonCancel.Name = "ButtonCancel";
            this.ButtonCancel.Size = new System.Drawing.Size(77, 36);
            this.ButtonCancel.TabIndex = 21;
            this.ButtonCancel.Text = "Cancel";
            this.ButtonCancel.UseVisualStyleBackColor = true;
            this.ButtonCancel.Click += new System.EventHandler(this.ButtonCancel_Click);
            // 
            // tbOutput
            // 
            this.tbOutput.Location = new System.Drawing.Point(1, 76);
            this.tbOutput.Margin = new System.Windows.Forms.Padding(1);
            this.tbOutput.Multiline = true;
            this.tbOutput.Name = "tbOutput";
            this.tbOutput.ReadOnly = true;
            this.tbOutput.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.tbOutput.Size = new System.Drawing.Size(981, 316);
            this.tbOutput.TabIndex = 3;
            // 
            // flowLayoutPanel2
            // 
            this.flowLayoutPanel2.Controls.Add(this.ButtonClose);
            this.flowLayoutPanel2.Location = new System.Drawing.Point(888, 423);
            this.flowLayoutPanel2.Margin = new System.Windows.Forms.Padding(1);
            this.flowLayoutPanel2.Name = "flowLayoutPanel2";
            this.flowLayoutPanel2.Size = new System.Drawing.Size(122, 55);
            this.flowLayoutPanel2.TabIndex = 3;
            // 
            // ButtonClose
            // 
            this.ButtonClose.Enabled = false;
            this.ButtonClose.Location = new System.Drawing.Point(1, 1);
            this.ButtonClose.Margin = new System.Windows.Forms.Padding(1);
            this.ButtonClose.Name = "ButtonClose";
            this.ButtonClose.Size = new System.Drawing.Size(108, 37);
            this.ButtonClose.TabIndex = 3;
            this.ButtonClose.Text = "Close";
            this.ButtonClose.UseVisualStyleBackColor = true;
            this.ButtonClose.Click += new System.EventHandler(this.ButtonClose_Click);
            // 
            // flowLayoutPanel3
            // 
            this.flowLayoutPanel3.Controls.Add(this.lblInfo);
            this.flowLayoutPanel3.Location = new System.Drawing.Point(11, 423);
            this.flowLayoutPanel3.Margin = new System.Windows.Forms.Padding(1);
            this.flowLayoutPanel3.Name = "flowLayoutPanel3";
            this.flowLayoutPanel3.Size = new System.Drawing.Size(859, 52);
            this.flowLayoutPanel3.TabIndex = 4;
            // 
            // lblInfo
            // 
            this.lblInfo.AutoSize = true;
            this.lblInfo.Location = new System.Drawing.Point(1, 0);
            this.lblInfo.Margin = new System.Windows.Forms.Padding(1, 0, 1, 0);
            this.lblInfo.Name = "lblInfo";
            this.lblInfo.Size = new System.Drawing.Size(45, 17);
            this.lblInfo.TabIndex = 0;
            this.lblInfo.Text = "lblInfo";
            // 
            // FormReformatLogs
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.ClientSize = new System.Drawing.Size(1036, 485);
            this.ControlBox = false;
            this.Controls.Add(this.flowLayoutPanel3);
            this.Controls.Add(this.flowLayoutPanel2);
            this.Controls.Add(this.flowLayoutPanel1);
            this.Margin = new System.Windows.Forms.Padding(1);
            this.Name = "FormReformatLogs";
            this.Text = "Reformat Logs for Comparison";
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
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel3;
        private System.Windows.Forms.Label lblInfo;
        private System.Windows.Forms.TextBox tbOutput;
        private System.Windows.Forms.Button ButtonCancel;
        private System.Windows.Forms.Button ButtonFolderBrowse;
        private System.Windows.Forms.TextBox TextInputFolder;
        private System.Windows.Forms.Label LabelFolder;
        private System.Windows.Forms.Button ButtonReformat;
    }
}