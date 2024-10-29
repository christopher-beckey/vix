namespace MavenBuilder2
{
    partial class frmMain
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
            this.components = new System.ComponentModel.Container();
            this.cxProjects = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.buildToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.deployToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.buildAndDeployToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.buildToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.deployCheckedToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.buildAndDeployToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.toolStripStatusLabel1 = new System.Windows.Forms.ToolStripStatusLabel();
            this.tslActionCount = new System.Windows.Forms.ToolStripStatusLabel();
            this.btnUncheckAll = new System.Windows.Forms.Button();
            this.chkRunUnitTests = new System.Windows.Forms.CheckBox();
            this.btnBuildChecked = new System.Windows.Forms.Button();
            this.btnDeployChecked = new System.Windows.Forms.Button();
            this.tcMain = new System.Windows.Forms.TabControl();
            this.tpConfiguration = new System.Windows.Forms.TabPage();
            this.label6 = new System.Windows.Forms.Label();
            this.txtJreLibExtDir = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.txtMavenHome = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.txtMavenRepository = new System.Windows.Forms.TextBox();
            this.btnLoadProjects = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.txtTomcatDir = new System.Windows.Forms.TextBox();
            this.txtEclipseWorkspace = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.txtVIXBuildManifest = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.tpBuild = new System.Windows.Forms.TabPage();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tpProjects = new System.Windows.Forms.TabPage();
            this.lstProjects = new System.Windows.Forms.ListView();
            this.chBuildOrder = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.chProjectName = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.chProjectType = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.chMavenJarLastModified = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.chTomcatLastModified = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.btnCheckAll = new System.Windows.Forms.Button();
            this.tpOutput = new System.Windows.Forms.TabPage();
            this.txtOutput = new System.Windows.Forms.RichTextBox();
            this.cxOutput = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.clearToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.fileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.openToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.exitToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.helpToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aboutToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
            this.chkUseBuildProject = new System.Windows.Forms.CheckBox();
            this.cxProjects.SuspendLayout();
            this.statusStrip1.SuspendLayout();
            this.tcMain.SuspendLayout();
            this.tpConfiguration.SuspendLayout();
            this.tpBuild.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tpProjects.SuspendLayout();
            this.tpOutput.SuspendLayout();
            this.cxOutput.SuspendLayout();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // cxProjects
            // 
            this.cxProjects.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.buildToolStripMenuItem1,
            this.deployToolStripMenuItem,
            this.buildAndDeployToolStripMenuItem1,
            this.toolStripSeparator1,
            this.buildToolStripMenuItem,
            this.deployCheckedToolStripMenuItem,
            this.buildAndDeployToolStripMenuItem});
            this.cxProjects.Name = "cxProjects";
            this.cxProjects.Size = new System.Drawing.Size(198, 142);
            // 
            // buildToolStripMenuItem1
            // 
            this.buildToolStripMenuItem1.Name = "buildToolStripMenuItem1";
            this.buildToolStripMenuItem1.Size = new System.Drawing.Size(197, 22);
            this.buildToolStripMenuItem1.Text = "Build";
            this.buildToolStripMenuItem1.Click += new System.EventHandler(this.buildToolStripMenuItem1_Click);
            // 
            // deployToolStripMenuItem
            // 
            this.deployToolStripMenuItem.Name = "deployToolStripMenuItem";
            this.deployToolStripMenuItem.Size = new System.Drawing.Size(197, 22);
            this.deployToolStripMenuItem.Text = "Deploy";
            this.deployToolStripMenuItem.Click += new System.EventHandler(this.deployToolStripMenuItem_Click);
            // 
            // buildAndDeployToolStripMenuItem1
            // 
            this.buildAndDeployToolStripMenuItem1.Name = "buildAndDeployToolStripMenuItem1";
            this.buildAndDeployToolStripMenuItem1.Size = new System.Drawing.Size(197, 22);
            this.buildAndDeployToolStripMenuItem1.Text = "Build and Deploy";
            this.buildAndDeployToolStripMenuItem1.Click += new System.EventHandler(this.buildAndDeployToolStripMenuItem1_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(194, 6);
            // 
            // buildToolStripMenuItem
            // 
            this.buildToolStripMenuItem.Name = "buildToolStripMenuItem";
            this.buildToolStripMenuItem.Size = new System.Drawing.Size(197, 22);
            this.buildToolStripMenuItem.Text = "Build Checked";
            this.buildToolStripMenuItem.Click += new System.EventHandler(this.buildToolStripMenuItem_Click);
            // 
            // deployCheckedToolStripMenuItem
            // 
            this.deployCheckedToolStripMenuItem.Name = "deployCheckedToolStripMenuItem";
            this.deployCheckedToolStripMenuItem.Size = new System.Drawing.Size(197, 22);
            this.deployCheckedToolStripMenuItem.Text = "Deploy Checked";
            this.deployCheckedToolStripMenuItem.Click += new System.EventHandler(this.deployCheckedToolStripMenuItem_Click);
            // 
            // buildAndDeployToolStripMenuItem
            // 
            this.buildAndDeployToolStripMenuItem.Name = "buildAndDeployToolStripMenuItem";
            this.buildAndDeployToolStripMenuItem.Size = new System.Drawing.Size(197, 22);
            this.buildAndDeployToolStripMenuItem.Text = "Build and Deploy Checked";
            this.buildAndDeployToolStripMenuItem.Click += new System.EventHandler(this.buildAndDeployToolStripMenuItem_Click);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripStatusLabel1,
            this.tslActionCount});
            this.statusStrip1.Location = new System.Drawing.Point(0, 504);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(829, 22);
            this.statusStrip1.TabIndex = 8;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // toolStripStatusLabel1
            // 
            this.toolStripStatusLabel1.Name = "toolStripStatusLabel1";
            this.toolStripStatusLabel1.Size = new System.Drawing.Size(754, 17);
            this.toolStripStatusLabel1.Spring = true;
            this.toolStripStatusLabel1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // tslActionCount
            // 
            this.tslActionCount.AutoSize = false;
            this.tslActionCount.Name = "tslActionCount";
            this.tslActionCount.Size = new System.Drawing.Size(60, 17);
            // 
            // btnUncheckAll
            // 
            this.btnUncheckAll.Location = new System.Drawing.Point(81, 0);
            this.btnUncheckAll.Name = "btnUncheckAll";
            this.btnUncheckAll.Size = new System.Drawing.Size(75, 23);
            this.btnUncheckAll.TabIndex = 11;
            this.btnUncheckAll.Text = "Uncheck All";
            this.btnUncheckAll.UseVisualStyleBackColor = true;
            this.btnUncheckAll.Click += new System.EventHandler(this.btnUncheckAll_Click);
            // 
            // chkRunUnitTests
            // 
            this.chkRunUnitTests.AutoSize = true;
            this.chkRunUnitTests.Location = new System.Drawing.Point(162, 4);
            this.chkRunUnitTests.Name = "chkRunUnitTests";
            this.chkRunUnitTests.Size = new System.Drawing.Size(97, 17);
            this.chkRunUnitTests.TabIndex = 12;
            this.chkRunUnitTests.Text = "Run Unit Tests";
            this.chkRunUnitTests.UseVisualStyleBackColor = true;
            // 
            // btnBuildChecked
            // 
            this.btnBuildChecked.Location = new System.Drawing.Point(265, 0);
            this.btnBuildChecked.Name = "btnBuildChecked";
            this.btnBuildChecked.Size = new System.Drawing.Size(87, 23);
            this.btnBuildChecked.TabIndex = 13;
            this.btnBuildChecked.Text = "Build Checked";
            this.btnBuildChecked.UseVisualStyleBackColor = true;
            this.btnBuildChecked.Click += new System.EventHandler(this.btnBuildChecked_Click);
            // 
            // btnDeployChecked
            // 
            this.btnDeployChecked.Location = new System.Drawing.Point(358, 0);
            this.btnDeployChecked.Name = "btnDeployChecked";
            this.btnDeployChecked.Size = new System.Drawing.Size(97, 23);
            this.btnDeployChecked.TabIndex = 14;
            this.btnDeployChecked.Text = "Deploy Checked";
            this.btnDeployChecked.UseVisualStyleBackColor = true;
            this.btnDeployChecked.Click += new System.EventHandler(this.btnDeployChecked_Click);
            // 
            // tcMain
            // 
            this.tcMain.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.tcMain.Controls.Add(this.tpConfiguration);
            this.tcMain.Controls.Add(this.tpBuild);
            this.tcMain.Location = new System.Drawing.Point(12, 27);
            this.tcMain.Name = "tcMain";
            this.tcMain.SelectedIndex = 0;
            this.tcMain.Size = new System.Drawing.Size(805, 474);
            this.tcMain.TabIndex = 19;
            this.tcMain.SelectedIndexChanged += new System.EventHandler(this.tcMain_SelectedIndexChanged);
            // 
            // tpConfiguration
            // 
            this.tpConfiguration.Controls.Add(this.chkUseBuildProject);
            this.tpConfiguration.Controls.Add(this.label6);
            this.tpConfiguration.Controls.Add(this.txtJreLibExtDir);
            this.tpConfiguration.Controls.Add(this.label5);
            this.tpConfiguration.Controls.Add(this.txtMavenHome);
            this.tpConfiguration.Controls.Add(this.label4);
            this.tpConfiguration.Controls.Add(this.txtMavenRepository);
            this.tpConfiguration.Controls.Add(this.btnLoadProjects);
            this.tpConfiguration.Controls.Add(this.label3);
            this.tpConfiguration.Controls.Add(this.txtTomcatDir);
            this.tpConfiguration.Controls.Add(this.txtEclipseWorkspace);
            this.tpConfiguration.Controls.Add(this.label2);
            this.tpConfiguration.Controls.Add(this.txtVIXBuildManifest);
            this.tpConfiguration.Controls.Add(this.label1);
            this.tpConfiguration.Location = new System.Drawing.Point(4, 22);
            this.tpConfiguration.Name = "tpConfiguration";
            this.tpConfiguration.Padding = new System.Windows.Forms.Padding(3);
            this.tpConfiguration.Size = new System.Drawing.Size(797, 448);
            this.tpConfiguration.TabIndex = 0;
            this.tpConfiguration.Text = "Configuration";
            this.tpConfiguration.UseVisualStyleBackColor = true;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(33, 139);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(81, 13);
            this.label6.TabIndex = 31;
            this.label6.Text = "JRE Lib Ext Dir:";
            // 
            // txtJreLibExtDir
            // 
            this.txtJreLibExtDir.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtJreLibExtDir.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend;
            this.txtJreLibExtDir.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.FileSystemDirectories;
            this.txtJreLibExtDir.Location = new System.Drawing.Point(121, 136);
            this.txtJreLibExtDir.Name = "txtJreLibExtDir";
            this.txtJreLibExtDir.Size = new System.Drawing.Size(670, 20);
            this.txtJreLibExtDir.TabIndex = 30;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(35, 113);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(80, 13);
            this.label5.TabIndex = 29;
            this.label5.Text = "Maven2 Home:";
            // 
            // txtMavenHome
            // 
            this.txtMavenHome.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtMavenHome.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend;
            this.txtMavenHome.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.FileSystemDirectories;
            this.txtMavenHome.Location = new System.Drawing.Point(121, 110);
            this.txtMavenHome.Name = "txtMavenHome";
            this.txtMavenHome.Size = new System.Drawing.Size(670, 20);
            this.txtMavenHome.TabIndex = 25;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 87);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(102, 13);
            this.label4.TabIndex = 28;
            this.label4.Text = "Maven2 Repository:";
            // 
            // txtMavenRepository
            // 
            this.txtMavenRepository.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtMavenRepository.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend;
            this.txtMavenRepository.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.FileSystemDirectories;
            this.txtMavenRepository.Location = new System.Drawing.Point(121, 84);
            this.txtMavenRepository.Name = "txtMavenRepository";
            this.txtMavenRepository.Size = new System.Drawing.Size(670, 20);
            this.txtMavenRepository.TabIndex = 24;
            // 
            // btnLoadProjects
            // 
            this.btnLoadProjects.Location = new System.Drawing.Point(121, 185);
            this.btnLoadProjects.Name = "btnLoadProjects";
            this.btnLoadProjects.Size = new System.Drawing.Size(88, 23);
            this.btnLoadProjects.TabIndex = 27;
            this.btnLoadProjects.Text = "Load Projects";
            this.btnLoadProjects.UseVisualStyleBackColor = true;
            this.btnLoadProjects.Click += new System.EventHandler(this.btnLoadProjects_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(52, 61);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(62, 13);
            this.label3.TabIndex = 26;
            this.label3.Text = "Tomcat Dir:";
            // 
            // txtTomcatDir
            // 
            this.txtTomcatDir.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtTomcatDir.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend;
            this.txtTomcatDir.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.FileSystemDirectories;
            this.txtTomcatDir.Location = new System.Drawing.Point(121, 58);
            this.txtTomcatDir.Name = "txtTomcatDir";
            this.txtTomcatDir.Size = new System.Drawing.Size(670, 20);
            this.txtTomcatDir.TabIndex = 23;
            // 
            // txtEclipseWorkspace
            // 
            this.txtEclipseWorkspace.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtEclipseWorkspace.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend;
            this.txtEclipseWorkspace.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.FileSystemDirectories;
            this.txtEclipseWorkspace.Location = new System.Drawing.Point(121, 32);
            this.txtEclipseWorkspace.Name = "txtEclipseWorkspace";
            this.txtEclipseWorkspace.Size = new System.Drawing.Size(670, 20);
            this.txtEclipseWorkspace.TabIndex = 21;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(13, 35);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(102, 13);
            this.label2.TabIndex = 22;
            this.label2.Text = "Eclipse Workspace:";
            // 
            // txtVIXBuildManifest
            // 
            this.txtVIXBuildManifest.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtVIXBuildManifest.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.SuggestAppend;
            this.txtVIXBuildManifest.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.FileSystem;
            this.txtVIXBuildManifest.Location = new System.Drawing.Point(121, 6);
            this.txtVIXBuildManifest.Name = "txtVIXBuildManifest";
            this.txtVIXBuildManifest.Size = new System.Drawing.Size(670, 20);
            this.txtVIXBuildManifest.TabIndex = 20;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(19, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(96, 13);
            this.label1.TabIndex = 19;
            this.label1.Text = "VIX Build Manifest:";
            // 
            // tpBuild
            // 
            this.tpBuild.Controls.Add(this.tabControl1);
            this.tpBuild.Location = new System.Drawing.Point(4, 22);
            this.tpBuild.Name = "tpBuild";
            this.tpBuild.Padding = new System.Windows.Forms.Padding(3);
            this.tpBuild.Size = new System.Drawing.Size(797, 448);
            this.tpBuild.TabIndex = 1;
            this.tpBuild.Text = "Build";
            this.tpBuild.UseVisualStyleBackColor = true;
            // 
            // tabControl1
            // 
            this.tabControl1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.tabControl1.Controls.Add(this.tpProjects);
            this.tabControl1.Controls.Add(this.tpOutput);
            this.tabControl1.Location = new System.Drawing.Point(0, 0);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(797, 448);
            this.tabControl1.TabIndex = 14;
            // 
            // tpProjects
            // 
            this.tpProjects.Controls.Add(this.lstProjects);
            this.tpProjects.Controls.Add(this.btnDeployChecked);
            this.tpProjects.Controls.Add(this.btnBuildChecked);
            this.tpProjects.Controls.Add(this.chkRunUnitTests);
            this.tpProjects.Controls.Add(this.btnUncheckAll);
            this.tpProjects.Controls.Add(this.btnCheckAll);
            this.tpProjects.Location = new System.Drawing.Point(4, 22);
            this.tpProjects.Name = "tpProjects";
            this.tpProjects.Padding = new System.Windows.Forms.Padding(3);
            this.tpProjects.Size = new System.Drawing.Size(789, 422);
            this.tpProjects.TabIndex = 0;
            this.tpProjects.Text = "Projects";
            this.tpProjects.UseVisualStyleBackColor = true;
            // 
            // lstProjects
            // 
            this.lstProjects.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.lstProjects.CheckBoxes = true;
            this.lstProjects.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.chBuildOrder,
            this.chProjectName,
            this.chProjectType,
            this.chMavenJarLastModified,
            this.chTomcatLastModified});
            this.lstProjects.ContextMenuStrip = this.cxProjects;
            this.lstProjects.FullRowSelect = true;
            this.lstProjects.HideSelection = false;
            this.lstProjects.Location = new System.Drawing.Point(0, 29);
            this.lstProjects.Name = "lstProjects";
            this.lstProjects.Size = new System.Drawing.Size(789, 393);
            this.lstProjects.TabIndex = 0;
            this.lstProjects.UseCompatibleStateImageBehavior = false;
            this.lstProjects.View = System.Windows.Forms.View.Details;
            // 
            // chBuildOrder
            // 
            this.chBuildOrder.Text = "";
            this.chBuildOrder.Width = 45;
            // 
            // chProjectName
            // 
            this.chProjectName.Text = "Project";
            this.chProjectName.Width = 300;
            // 
            // chProjectType
            // 
            this.chProjectType.Text = "Project Type";
            this.chProjectType.Width = 100;
            // 
            // chMavenJarLastModified
            // 
            this.chMavenJarLastModified.Text = "Maven Last Modified";
            this.chMavenJarLastModified.Width = 150;
            // 
            // chTomcatLastModified
            // 
            this.chTomcatLastModified.Text = "Tomcat Last Modified";
            this.chTomcatLastModified.Width = 150;
            // 
            // btnCheckAll
            // 
            this.btnCheckAll.Location = new System.Drawing.Point(0, 0);
            this.btnCheckAll.Name = "btnCheckAll";
            this.btnCheckAll.Size = new System.Drawing.Size(75, 23);
            this.btnCheckAll.TabIndex = 11;
            this.btnCheckAll.Text = "Check All";
            this.btnCheckAll.UseVisualStyleBackColor = true;
            this.btnCheckAll.Click += new System.EventHandler(this.btnCheckAll_Click);
            // 
            // tpOutput
            // 
            this.tpOutput.Controls.Add(this.txtOutput);
            this.tpOutput.Location = new System.Drawing.Point(4, 22);
            this.tpOutput.Name = "tpOutput";
            this.tpOutput.Padding = new System.Windows.Forms.Padding(3);
            this.tpOutput.Size = new System.Drawing.Size(789, 422);
            this.tpOutput.TabIndex = 1;
            this.tpOutput.Text = "Output";
            this.tpOutput.UseVisualStyleBackColor = true;
            // 
            // txtOutput
            // 
            this.txtOutput.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtOutput.ContextMenuStrip = this.cxOutput;
            this.txtOutput.Location = new System.Drawing.Point(0, 0);
            this.txtOutput.Name = "txtOutput";
            this.txtOutput.ReadOnly = true;
            this.txtOutput.Size = new System.Drawing.Size(789, 422);
            this.txtOutput.TabIndex = 0;
            this.txtOutput.Text = "";
            // 
            // cxOutput
            // 
            this.cxOutput.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.clearToolStripMenuItem});
            this.cxOutput.Name = "cxOutput";
            this.cxOutput.Size = new System.Drawing.Size(100, 26);
            // 
            // clearToolStripMenuItem
            // 
            this.clearToolStripMenuItem.Name = "clearToolStripMenuItem";
            this.clearToolStripMenuItem.Size = new System.Drawing.Size(99, 22);
            this.clearToolStripMenuItem.Text = "Clear";
            this.clearToolStripMenuItem.Click += new System.EventHandler(this.clearToolStripMenuItem_Click);
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.fileToolStripMenuItem,
            this.helpToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(829, 24);
            this.menuStrip1.TabIndex = 20;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // fileToolStripMenuItem
            // 
            this.fileToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.openToolStripMenuItem,
            this.saveToolStripMenuItem,
            this.toolStripSeparator2,
            this.exitToolStripMenuItem});
            this.fileToolStripMenuItem.Name = "fileToolStripMenuItem";
            this.fileToolStripMenuItem.Size = new System.Drawing.Size(35, 20);
            this.fileToolStripMenuItem.Text = "File";
            // 
            // openToolStripMenuItem
            // 
            this.openToolStripMenuItem.Name = "openToolStripMenuItem";
            this.openToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.openToolStripMenuItem.Text = "Open";
            this.openToolStripMenuItem.Click += new System.EventHandler(this.openToolStripMenuItem_Click);
            // 
            // saveToolStripMenuItem
            // 
            this.saveToolStripMenuItem.Name = "saveToolStripMenuItem";
            this.saveToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.saveToolStripMenuItem.Text = "Save";
            this.saveToolStripMenuItem.Click += new System.EventHandler(this.saveToolStripMenuItem_Click);
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(149, 6);
            // 
            // exitToolStripMenuItem
            // 
            this.exitToolStripMenuItem.Name = "exitToolStripMenuItem";
            this.exitToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.exitToolStripMenuItem.Text = "E&xit";
            this.exitToolStripMenuItem.Click += new System.EventHandler(this.exitToolStripMenuItem_Click);
            // 
            // helpToolStripMenuItem
            // 
            this.helpToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.aboutToolStripMenuItem});
            this.helpToolStripMenuItem.Name = "helpToolStripMenuItem";
            this.helpToolStripMenuItem.Size = new System.Drawing.Size(40, 20);
            this.helpToolStripMenuItem.Text = "Help";
            // 
            // aboutToolStripMenuItem
            // 
            this.aboutToolStripMenuItem.Name = "aboutToolStripMenuItem";
            this.aboutToolStripMenuItem.Size = new System.Drawing.Size(114, 22);
            this.aboutToolStripMenuItem.Text = "&About";
            this.aboutToolStripMenuItem.Click += new System.EventHandler(this.aboutToolStripMenuItem_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // chkUseBuildProject
            // 
            this.chkUseBuildProject.AutoSize = true;
            this.chkUseBuildProject.Location = new System.Drawing.Point(121, 162);
            this.chkUseBuildProject.Name = "chkUseBuildProject";
            this.chkUseBuildProject.Size = new System.Drawing.Size(107, 17);
            this.chkUseBuildProject.TabIndex = 32;
            this.chkUseBuildProject.Text = "Use Build Project";
            this.chkUseBuildProject.UseVisualStyleBackColor = true;
            // 
            // frmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(829, 526);
            this.Controls.Add(this.tcMain);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "frmMain";
            this.Text = "Maven Builder 2";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.frmMain_FormClosing);
            this.Load += new System.EventHandler(this.frmMain_Load);
            this.cxProjects.ResumeLayout(false);
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.tcMain.ResumeLayout(false);
            this.tpConfiguration.ResumeLayout(false);
            this.tpConfiguration.PerformLayout();
            this.tpBuild.ResumeLayout(false);
            this.tabControl1.ResumeLayout(false);
            this.tpProjects.ResumeLayout(false);
            this.tpProjects.PerformLayout();
            this.tpOutput.ResumeLayout(false);
            this.cxOutput.ResumeLayout(false);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel1;
        private System.Windows.Forms.ContextMenuStrip cxProjects;
        private System.Windows.Forms.ToolStripMenuItem buildToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem buildAndDeployToolStripMenuItem;
        private System.Windows.Forms.ToolStripStatusLabel tslActionCount;
        private System.Windows.Forms.Button btnUncheckAll;
        private System.Windows.Forms.CheckBox chkRunUnitTests;
        private System.Windows.Forms.ToolStripMenuItem buildToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem buildAndDeployToolStripMenuItem1;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.Button btnBuildChecked;
        private System.Windows.Forms.Button btnDeployChecked;
        private System.Windows.Forms.TabControl tcMain;
        private System.Windows.Forms.TabPage tpConfiguration;
        private System.Windows.Forms.TabPage tpBuild;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox txtMavenHome;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtMavenRepository;
        private System.Windows.Forms.Button btnLoadProjects;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtTomcatDir;
        private System.Windows.Forms.TextBox txtEclipseWorkspace;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtVIXBuildManifest;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tpProjects;
        private System.Windows.Forms.ListView lstProjects;
        private System.Windows.Forms.ColumnHeader chBuildOrder;
        private System.Windows.Forms.ColumnHeader chProjectName;
        private System.Windows.Forms.ColumnHeader chProjectType;
        private System.Windows.Forms.ColumnHeader chMavenJarLastModified;
        private System.Windows.Forms.ColumnHeader chTomcatLastModified;
        private System.Windows.Forms.TabPage tpOutput;
        private System.Windows.Forms.RichTextBox txtOutput;
        private System.Windows.Forms.Button btnCheckAll;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox txtJreLibExtDir;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem fileToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem openToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem saveToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
        private System.Windows.Forms.ToolStripMenuItem exitToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem helpToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aboutToolStripMenuItem;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.SaveFileDialog saveFileDialog1;
        private System.Windows.Forms.ToolStripMenuItem deployToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem deployCheckedToolStripMenuItem;
        private System.Windows.Forms.ContextMenuStrip cxOutput;
        private System.Windows.Forms.ToolStripMenuItem clearToolStripMenuItem;
        private System.Windows.Forms.CheckBox chkUseBuildProject;
    }
}

