namespace SCIP_Tool
{
    partial class FormRenamer
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
            this.TextStartFileNumber = new System.Windows.Forms.TextBox();
            this.LabelDicomFile = new System.Windows.Forms.Label();
            this.ButtonRename = new System.Windows.Forms.Button();
            this.ButtonFolderBrowse = new System.Windows.Forms.Button();
            this.TextInputFolder = new System.Windows.Forms.TextBox();
            this.LabelDicomFolder = new System.Windows.Forms.Label();
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
            this.groupBox1.Controls.Add(this.TextStartFileNumber);
            this.groupBox1.Controls.Add(this.LabelDicomFile);
            this.groupBox1.Controls.Add(this.ButtonRename);
            this.groupBox1.Controls.Add(this.ButtonFolderBrowse);
            this.groupBox1.Controls.Add(this.TextInputFolder);
            this.groupBox1.Controls.Add(this.LabelDicomFolder);
            this.groupBox1.Controls.Add(this.ButtonCancel);
            this.groupBox1.Location = new System.Drawing.Point(1, 1);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(1, 1, 1, 5);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(1);
            this.groupBox1.Size = new System.Drawing.Size(985, 69);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            // 
            // TextStartFileNumber
            // 
            this.TextStartFileNumber.Location = new System.Drawing.Point(622, 27);
            this.TextStartFileNumber.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.TextStartFileNumber.Name = "TextStartFileNumber";
            this.TextStartFileNumber.Size = new System.Drawing.Size(155, 22);
            this.TextStartFileNumber.TabIndex = 30;
            this.TextStartFileNumber.TextChanged += new System.EventHandler(this.TextStartFileNumber_TextChanged);
            // 
            // LabelDicomFile
            // 
            this.LabelDicomFile.AutoSize = true;
            this.LabelDicomFile.Location = new System.Drawing.Point(619, 11);
            this.LabelDicomFile.Name = "LabelDicomFile";
            this.LabelDicomFile.Size = new System.Drawing.Size(158, 17);
            this.LabelDicomFile.TabIndex = 29;
            this.LabelDicomFile.Text = "File number to start with";
            // 
            // ButtonRename
            // 
            this.ButtonRename.Location = new System.Drawing.Point(814, 18);
            this.ButtonRename.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.ButtonRename.Name = "ButtonRename";
            this.ButtonRename.Size = new System.Drawing.Size(77, 36);
            this.ButtonRename.TabIndex = 28;
            this.ButtonRename.Tag = "";
            this.ButtonRename.Text = "Rename";
            this.ButtonRename.UseVisualStyleBackColor = true;
            this.ButtonRename.Click += new System.EventHandler(this.ButtonRename_Click);
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
            // LabelDicomFolder
            // 
            this.LabelDicomFolder.AutoSize = true;
            this.LabelDicomFolder.Location = new System.Drawing.Point(11, 9);
            this.LabelDicomFolder.Name = "LabelDicomFolder";
            this.LabelDicomFolder.Size = new System.Drawing.Size(238, 17);
            this.LabelDicomFolder.TabIndex = 24;
            this.LabelDicomFolder.Text = "Folder where we will rename the files";
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
            // FormRenamer
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
            this.Name = "FormRenamer";
            this.Text = "Rename Files";
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
        private System.Windows.Forms.Label LabelDicomFolder;
        private System.Windows.Forms.Button ButtonRename;
        private System.Windows.Forms.TextBox TextStartFileNumber;
        private System.Windows.Forms.Label LabelDicomFile;
    }
}