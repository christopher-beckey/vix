namespace ImageVistAWorker
{
    partial class Form1
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
            this.label1 = new System.Windows.Forms.Label();
            this.btnFolderBrowse = new System.Windows.Forms.Button();
            this.txtInputFolder = new System.Windows.Forms.TextBox();
            this.flowLayoutPanel3 = new System.Windows.Forms.FlowLayoutPanel();
            this.lblInfo = new System.Windows.Forms.Label();
            this.btnCancel = new System.Windows.Forms.Button();
            this.btnRun = new System.Windows.Forms.Button();
            this.btnBrowseVVConfigFile = new System.Windows.Forms.Button();
            this.txtVixViewerConfigFile = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.flowLayoutPanel3.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(13, 13);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(204, 17);
            this.label1.TabIndex = 0;
            this.label1.Text = "VixCache (Tomcat) Folder Path";
            // 
            // btnFolderBrowse
            // 
            this.btnFolderBrowse.Location = new System.Drawing.Point(677, 30);
            this.btnFolderBrowse.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btnFolderBrowse.Name = "btnFolderBrowse";
            this.btnFolderBrowse.Size = new System.Drawing.Size(33, 26);
            this.btnFolderBrowse.TabIndex = 17;
            this.btnFolderBrowse.Text = "...";
            this.btnFolderBrowse.UseVisualStyleBackColor = true;
            this.btnFolderBrowse.Click += new System.EventHandler(this.btnFolderBrowse_Click);
            // 
            // txtInputFolder
            // 
            this.txtInputFolder.Location = new System.Drawing.Point(16, 32);
            this.txtInputFolder.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.txtInputFolder.Name = "txtInputFolder";
            this.txtInputFolder.Size = new System.Drawing.Size(655, 22);
            this.txtInputFolder.TabIndex = 16;
            this.txtInputFolder.Text = "C:\\232Logs\\72877612\\72877612";
            // 
            // flowLayoutPanel3
            // 
            this.flowLayoutPanel3.Controls.Add(this.lblInfo);
            this.flowLayoutPanel3.Location = new System.Drawing.Point(16, 177);
            this.flowLayoutPanel3.Margin = new System.Windows.Forms.Padding(1);
            this.flowLayoutPanel3.Name = "flowLayoutPanel3";
            this.flowLayoutPanel3.Size = new System.Drawing.Size(774, 52);
            this.flowLayoutPanel3.TabIndex = 18;
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
            // btnCancel
            // 
            this.btnCancel.Location = new System.Drawing.Point(400, 119);
            this.btnCancel.Margin = new System.Windows.Forms.Padding(1);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(77, 36);
            this.btnCancel.TabIndex = 25;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnRun
            // 
            this.btnRun.Location = new System.Drawing.Point(290, 119);
            this.btnRun.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btnRun.Name = "btnRun";
            this.btnRun.Size = new System.Drawing.Size(77, 36);
            this.btnRun.TabIndex = 24;
            this.btnRun.Tag = "";
            this.btnRun.Text = "Run";
            this.btnRun.UseVisualStyleBackColor = true;
            this.btnRun.Click += new System.EventHandler(this.btnRun_Click);
            // 
            // btnBrowseVVConfigFile
            // 
            this.btnBrowseVVConfigFile.Location = new System.Drawing.Point(677, 77);
            this.btnBrowseVVConfigFile.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.btnBrowseVVConfigFile.Name = "btnBrowseVVConfigFile";
            this.btnBrowseVVConfigFile.Size = new System.Drawing.Size(33, 26);
            this.btnBrowseVVConfigFile.TabIndex = 28;
            this.btnBrowseVVConfigFile.Text = "...";
            this.btnBrowseVVConfigFile.UseVisualStyleBackColor = true;
            this.btnBrowseVVConfigFile.Click += new System.EventHandler(this.btnBrowseVVConfigFile_Click);
            // 
            // txtVixViewerConfigFile
            // 
            this.txtVixViewerConfigFile.Location = new System.Drawing.Point(16, 79);
            this.txtVixViewerConfigFile.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.txtVixViewerConfigFile.Name = "txtVixViewerConfigFile";
            this.txtVixViewerConfigFile.Size = new System.Drawing.Size(655, 22);
            this.txtVixViewerConfigFile.TabIndex = 27;
            this.txtVixViewerConfigFile.Text = "C:\\s\\_vv\\VIX.Viewer.Service\\VIX.Viewer.config";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(13, 60);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(178, 17);
            this.label2.TabIndex = 26;
            this.label2.Text = "VIX Viewer Config File Path";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 249);
            this.Controls.Add(this.btnBrowseVVConfigFile);
            this.Controls.Add(this.txtVixViewerConfigFile);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnRun);
            this.Controls.Add(this.flowLayoutPanel3);
            this.Controls.Add(this.btnFolderBrowse);
            this.Controls.Add(this.txtInputFolder);
            this.Controls.Add(this.label1);
            this.Name = "Form1";
            this.Text = "VIX Viewer VistA Worker Test";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.flowLayoutPanel3.ResumeLayout(false);
            this.flowLayoutPanel3.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button btnFolderBrowse;
        private System.Windows.Forms.TextBox txtInputFolder;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel3;
        private System.Windows.Forms.Label lblInfo;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.Button btnRun;
        private System.Windows.Forms.Button btnBrowseVVConfigFile;
        private System.Windows.Forms.TextBox txtVixViewerConfigFile;
        private System.Windows.Forms.Label label2;
    }
}

