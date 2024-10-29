namespace VIX.Viewer.Service.Client.Test
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
            this.CacheDisplayContextButton = new System.Windows.Forms.Button();
            this.DisplayContextStatusTextBox = new System.Windows.Forms.TextBox();
            this.CancelCacheDisplayContextButton = new System.Windows.Forms.Button();
            this.ServerSettingsPropertyGrid = new System.Windows.Forms.PropertyGrid();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.TestDataComboBox1 = new System.Windows.Forms.ComboBox();
            this.CreateDicomDirButton = new System.Windows.Forms.Button();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.TestDataComboBox2 = new System.Windows.Forms.ComboBox();
            this.LoadStudyTestDataButton = new System.Windows.Forms.Button();
            this.LoadPatientTestDataButton = new System.Windows.Forms.Button();
            this.StudyQueryButton = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.StudyQueryPropertyGrid = new System.Windows.Forms.PropertyGrid();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.QueryResultsListView = new System.Windows.Forms.ListView();
            this.columnHeader1 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader3 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader2 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader4 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.flowLayoutPanel2 = new System.Windows.Forms.FlowLayoutPanel();
            this.CancelCreateDicomDirButton = new System.Windows.Forms.Button();
            this.groupBox3.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            this.flowLayoutPanel1.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.flowLayoutPanel2.SuspendLayout();
            this.SuspendLayout();
            // 
            // CacheDisplayContextButton
            // 
            this.CacheDisplayContextButton.Location = new System.Drawing.Point(8, 8);
            this.CacheDisplayContextButton.Name = "CacheDisplayContextButton";
            this.CacheDisplayContextButton.Size = new System.Drawing.Size(353, 47);
            this.CacheDisplayContextButton.TabIndex = 2;
            this.CacheDisplayContextButton.Text = "Cache Display Context";
            this.CacheDisplayContextButton.UseMnemonic = false;
            this.CacheDisplayContextButton.UseVisualStyleBackColor = true;
            this.CacheDisplayContextButton.Click += new System.EventHandler(this.CacheDisplayContextButton_Click);
            // 
            // DisplayContextStatusTextBox
            // 
            this.DisplayContextStatusTextBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.DisplayContextStatusTextBox.Location = new System.Drawing.Point(18, 1344);
            this.DisplayContextStatusTextBox.Multiline = true;
            this.DisplayContextStatusTextBox.Name = "DisplayContextStatusTextBox";
            this.DisplayContextStatusTextBox.ReadOnly = true;
            this.DisplayContextStatusTextBox.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.DisplayContextStatusTextBox.Size = new System.Drawing.Size(2187, 143);
            this.DisplayContextStatusTextBox.TabIndex = 3;
            // 
            // CancelCacheDisplayContextButton
            // 
            this.CancelCacheDisplayContextButton.Enabled = false;
            this.flowLayoutPanel2.SetFlowBreak(this.CancelCacheDisplayContextButton, true);
            this.CancelCacheDisplayContextButton.Location = new System.Drawing.Point(367, 8);
            this.CancelCacheDisplayContextButton.Name = "CancelCacheDisplayContextButton";
            this.CancelCacheDisplayContextButton.Size = new System.Drawing.Size(192, 47);
            this.CancelCacheDisplayContextButton.TabIndex = 4;
            this.CancelCacheDisplayContextButton.Text = "Cancel";
            this.CancelCacheDisplayContextButton.UseVisualStyleBackColor = true;
            this.CancelCacheDisplayContextButton.Click += new System.EventHandler(this.CancelCacheDisplayContextButton_Click);
            // 
            // ServerSettingsPropertyGrid
            // 
            this.ServerSettingsPropertyGrid.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.ServerSettingsPropertyGrid.HelpVisible = false;
            this.ServerSettingsPropertyGrid.Location = new System.Drawing.Point(19, 94);
            this.ServerSettingsPropertyGrid.Name = "ServerSettingsPropertyGrid";
            this.ServerSettingsPropertyGrid.PropertySort = System.Windows.Forms.PropertySort.Categorized;
            this.ServerSettingsPropertyGrid.Size = new System.Drawing.Size(2149, 245);
            this.ServerSettingsPropertyGrid.TabIndex = 0;
            this.ServerSettingsPropertyGrid.ToolbarVisible = false;
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.TestDataComboBox1);
            this.groupBox3.Controls.Add(this.ServerSettingsPropertyGrid);
            this.groupBox3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox3.Location = new System.Drawing.Point(18, 18);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(2187, 362);
            this.groupBox3.TabIndex = 1;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Server Settings";
            // 
            // TestDataComboBox1
            // 
            this.TestDataComboBox1.FormattingEnabled = true;
            this.TestDataComboBox1.Location = new System.Drawing.Point(19, 40);
            this.TestDataComboBox1.Name = "TestDataComboBox1";
            this.TestDataComboBox1.Size = new System.Drawing.Size(828, 41);
            this.TestDataComboBox1.TabIndex = 2;
            // 
            // CreateDicomDirButton
            // 
            this.CreateDicomDirButton.Location = new System.Drawing.Point(8, 61);
            this.CreateDicomDirButton.Name = "CreateDicomDirButton";
            this.CreateDicomDirButton.Size = new System.Drawing.Size(353, 53);
            this.CreateDicomDirButton.TabIndex = 5;
            this.CreateDicomDirButton.Text = "Create DicomDir";
            this.CreateDicomDirButton.UseVisualStyleBackColor = true;
            this.CreateDicomDirButton.Click += new System.EventHandler(this.CreateDicomDirButton_Click);
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 1;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel2, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.groupBox3, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.DisplayContextStatusTextBox, 0, 2);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.Padding = new System.Windows.Forms.Padding(15);
            this.tableLayoutPanel1.RowCount = 3;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 25F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 65F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 10F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(2223, 1505);
            this.tableLayoutPanel1.TabIndex = 7;
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.ColumnCount = 2;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 31.81818F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 68.18182F));
            this.tableLayoutPanel2.Controls.Add(this.flowLayoutPanel1, 0, 1);
            this.tableLayoutPanel2.Controls.Add(this.groupBox1, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.groupBox4, 1, 0);
            this.tableLayoutPanel2.Controls.Add(this.flowLayoutPanel2, 1, 1);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(18, 386);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 2;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 180F));
            this.tableLayoutPanel2.Size = new System.Drawing.Size(2187, 952);
            this.tableLayoutPanel2.TabIndex = 8;
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.Controls.Add(this.TestDataComboBox2);
            this.flowLayoutPanel1.Controls.Add(this.LoadStudyTestDataButton);
            this.flowLayoutPanel1.Controls.Add(this.LoadPatientTestDataButton);
            this.flowLayoutPanel1.Controls.Add(this.StudyQueryButton);
            this.flowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(3, 775);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Padding = new System.Windows.Forms.Padding(5);
            this.flowLayoutPanel1.Size = new System.Drawing.Size(689, 174);
            this.flowLayoutPanel1.TabIndex = 4;
            // 
            // TestDataComboBox2
            // 
            this.TestDataComboBox2.FormattingEnabled = true;
            this.TestDataComboBox2.Location = new System.Drawing.Point(8, 8);
            this.TestDataComboBox2.Name = "TestDataComboBox2";
            this.TestDataComboBox2.Size = new System.Drawing.Size(666, 41);
            this.TestDataComboBox2.TabIndex = 5;
            // 
            // LoadStudyTestDataButton
            // 
            this.LoadStudyTestDataButton.Location = new System.Drawing.Point(8, 55);
            this.LoadStudyTestDataButton.Name = "LoadStudyTestDataButton";
            this.LoadStudyTestDataButton.Size = new System.Drawing.Size(388, 47);
            this.LoadStudyTestDataButton.TabIndex = 4;
            this.LoadStudyTestDataButton.Text = "Load Study Test Data";
            this.LoadStudyTestDataButton.UseVisualStyleBackColor = true;
            this.LoadStudyTestDataButton.Click += new System.EventHandler(this.LoadStudyTestDataButton_Click);
            // 
            // LoadPatientTestDataButton
            // 
            this.LoadPatientTestDataButton.Location = new System.Drawing.Point(8, 108);
            this.LoadPatientTestDataButton.Name = "LoadPatientTestDataButton";
            this.LoadPatientTestDataButton.Size = new System.Drawing.Size(388, 47);
            this.LoadPatientTestDataButton.TabIndex = 3;
            this.LoadPatientTestDataButton.Text = "Load Patient Test Data";
            this.LoadPatientTestDataButton.UseVisualStyleBackColor = true;
            this.LoadPatientTestDataButton.Click += new System.EventHandler(this.LoadPatientTestDataButton_Click);
            // 
            // StudyQueryButton
            // 
            this.StudyQueryButton.Location = new System.Drawing.Point(8, 161);
            this.StudyQueryButton.Name = "StudyQueryButton";
            this.StudyQueryButton.Size = new System.Drawing.Size(388, 47);
            this.StudyQueryButton.TabIndex = 2;
            this.StudyQueryButton.Text = "Study Query";
            this.StudyQueryButton.UseMnemonic = false;
            this.StudyQueryButton.UseVisualStyleBackColor = true;
            this.StudyQueryButton.Click += new System.EventHandler(this.StudyQueryButton_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.StudyQueryPropertyGrid);
            this.groupBox1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox1.Location = new System.Drawing.Point(3, 3);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(15);
            this.groupBox1.Size = new System.Drawing.Size(689, 766);
            this.groupBox1.TabIndex = 2;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Query Parameters";
            // 
            // StudyQueryPropertyGrid
            // 
            this.StudyQueryPropertyGrid.Dock = System.Windows.Forms.DockStyle.Fill;
            this.StudyQueryPropertyGrid.HelpVisible = false;
            this.StudyQueryPropertyGrid.Location = new System.Drawing.Point(15, 48);
            this.StudyQueryPropertyGrid.Name = "StudyQueryPropertyGrid";
            this.StudyQueryPropertyGrid.PropertySort = System.Windows.Forms.PropertySort.NoSort;
            this.StudyQueryPropertyGrid.Size = new System.Drawing.Size(659, 703);
            this.StudyQueryPropertyGrid.TabIndex = 2;
            this.StudyQueryPropertyGrid.ToolbarVisible = false;
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.QueryResultsListView);
            this.groupBox4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox4.Location = new System.Drawing.Point(698, 3);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Padding = new System.Windows.Forms.Padding(15);
            this.groupBox4.Size = new System.Drawing.Size(1486, 766);
            this.groupBox4.TabIndex = 3;
            this.groupBox4.TabStop = false;
            this.groupBox4.Text = "Query Results";
            // 
            // QueryResultsListView
            // 
            this.QueryResultsListView.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader1,
            this.columnHeader3,
            this.columnHeader2,
            this.columnHeader4});
            this.QueryResultsListView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.QueryResultsListView.FullRowSelect = true;
            this.QueryResultsListView.HideSelection = false;
            this.QueryResultsListView.Location = new System.Drawing.Point(15, 48);
            this.QueryResultsListView.Name = "QueryResultsListView";
            this.QueryResultsListView.Size = new System.Drawing.Size(1456, 703);
            this.QueryResultsListView.TabIndex = 0;
            this.QueryResultsListView.UseCompatibleStateImageBehavior = false;
            this.QueryResultsListView.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "Context Id";
            this.columnHeader1.Width = 197;
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "Description";
            this.columnHeader3.Width = 514;
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "Images";
            this.columnHeader2.Width = 112;
            // 
            // columnHeader4
            // 
            this.columnHeader4.Text = "Status";
            this.columnHeader4.Width = 671;
            // 
            // flowLayoutPanel2
            // 
            this.flowLayoutPanel2.Controls.Add(this.CacheDisplayContextButton);
            this.flowLayoutPanel2.Controls.Add(this.CancelCacheDisplayContextButton);
            this.flowLayoutPanel2.Controls.Add(this.CreateDicomDirButton);
            this.flowLayoutPanel2.Controls.Add(this.CancelCreateDicomDirButton);
            this.flowLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.flowLayoutPanel2.Location = new System.Drawing.Point(698, 775);
            this.flowLayoutPanel2.Name = "flowLayoutPanel2";
            this.flowLayoutPanel2.Padding = new System.Windows.Forms.Padding(5);
            this.flowLayoutPanel2.Size = new System.Drawing.Size(1486, 174);
            this.flowLayoutPanel2.TabIndex = 6;
            // 
            // CancelCreateDicomDirButton
            // 
            this.CancelCreateDicomDirButton.Enabled = false;
            this.CancelCreateDicomDirButton.Location = new System.Drawing.Point(367, 61);
            this.CancelCreateDicomDirButton.Name = "CancelCreateDicomDirButton";
            this.CancelCreateDicomDirButton.Size = new System.Drawing.Size(192, 53);
            this.CancelCreateDicomDirButton.TabIndex = 6;
            this.CancelCreateDicomDirButton.Text = "Cancel";
            this.CancelCreateDicomDirButton.UseVisualStyleBackColor = true;
            this.CancelCreateDicomDirButton.Click += new System.EventHandler(this.CancelCreateDicomDirButton_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(240F, 240F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.ClientSize = new System.Drawing.Size(2223, 1505);
            this.Controls.Add(this.tableLayoutPanel1);
            this.Name = "Form1";
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Show;
            this.Text = "Viewer Service Client Test App";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.groupBox3.ResumeLayout(false);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.tableLayoutPanel2.ResumeLayout(false);
            this.flowLayoutPanel1.ResumeLayout(false);
            this.groupBox1.ResumeLayout(false);
            this.groupBox4.ResumeLayout(false);
            this.flowLayoutPanel2.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button CacheDisplayContextButton;
        private System.Windows.Forms.TextBox DisplayContextStatusTextBox;
        private System.Windows.Forms.Button CancelCacheDisplayContextButton;
        private System.Windows.Forms.PropertyGrid ServerSettingsPropertyGrid;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.Button CreateDicomDirButton;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.PropertyGrid StudyQueryPropertyGrid;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel2;
        private System.Windows.Forms.Button StudyQueryButton;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.ListView QueryResultsListView;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.ColumnHeader columnHeader3;
        private System.Windows.Forms.ColumnHeader columnHeader4;
        private System.Windows.Forms.Button LoadStudyTestDataButton;
        private System.Windows.Forms.Button LoadPatientTestDataButton;
        private System.Windows.Forms.ComboBox TestDataComboBox1;
        private System.Windows.Forms.ComboBox TestDataComboBox2;
        private System.Windows.Forms.Button CancelCreateDicomDirButton;
    }
}

