namespace DesktopUserControls
{
    partial class TransactionLogViewer
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
            this.components = new System.ComponentModel.Container();
            this.dgvEntries = new System.Windows.Forms.DataGridView();
            this.contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.displayTransactionDetailsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.lblTransactionID = new System.Windows.Forms.Label();
            this.lblDateRange = new System.Windows.Forms.Label();
            this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripSeparator();
            this.copyTransactionToClipboardToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            ((System.ComponentModel.ISupportInitialize)(this.dgvEntries)).BeginInit();
            this.contextMenuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // dgvEntries
            // 
            this.dgvEntries.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.dgvEntries.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvEntries.ContextMenuStrip = this.contextMenuStrip1;
            this.dgvEntries.Location = new System.Drawing.Point(3, 26);
            this.dgvEntries.Name = "dgvEntries";
            this.dgvEntries.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvEntries.Size = new System.Drawing.Size(567, 308);
            this.dgvEntries.TabIndex = 11;
            // 
            // contextMenuStrip1
            // 
            this.contextMenuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.displayTransactionDetailsToolStripMenuItem,
            this.toolStripMenuItem1,
            this.copyTransactionToClipboardToolStripMenuItem});
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new System.Drawing.Size(237, 76);
            // 
            // displayTransactionDetailsToolStripMenuItem
            // 
            this.displayTransactionDetailsToolStripMenuItem.Name = "displayTransactionDetailsToolStripMenuItem";
            this.displayTransactionDetailsToolStripMenuItem.Size = new System.Drawing.Size(236, 22);
            this.displayTransactionDetailsToolStripMenuItem.Text = "Display Transaction Details";
            this.displayTransactionDetailsToolStripMenuItem.Click += new System.EventHandler(this.displayTransactionDetailsToolStripMenuItem_Click);
            // 
            // lblTransactionID
            // 
            this.lblTransactionID.Location = new System.Drawing.Point(3, 0);
            this.lblTransactionID.Name = "lblTransactionID";
            this.lblTransactionID.Size = new System.Drawing.Size(276, 23);
            this.lblTransactionID.TabIndex = 12;
            this.lblTransactionID.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // lblDateRange
            // 
            this.lblDateRange.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.lblDateRange.Location = new System.Drawing.Point(336, 0);
            this.lblDateRange.Name = "lblDateRange";
            this.lblDateRange.Size = new System.Drawing.Size(234, 23);
            this.lblDateRange.TabIndex = 13;
            this.lblDateRange.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // toolStripMenuItem1
            // 
            this.toolStripMenuItem1.Name = "toolStripMenuItem1";
            this.toolStripMenuItem1.Size = new System.Drawing.Size(233, 6);
            // 
            // copyTransactionToClipboardToolStripMenuItem
            // 
            this.copyTransactionToClipboardToolStripMenuItem.Name = "copyTransactionToClipboardToolStripMenuItem";
            this.copyTransactionToClipboardToolStripMenuItem.Size = new System.Drawing.Size(236, 22);
            this.copyTransactionToClipboardToolStripMenuItem.Text = "Copy Transaction to Clipboard";
            this.copyTransactionToClipboardToolStripMenuItem.Click += new System.EventHandler(this.copyTransactionToClipboardToolStripMenuItem_Click);
            // 
            // TransactionLogViewer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.lblDateRange);
            this.Controls.Add(this.lblTransactionID);
            this.Controls.Add(this.dgvEntries);
            this.Name = "TransactionLogViewer";
            this.Size = new System.Drawing.Size(573, 337);
            ((System.ComponentModel.ISupportInitialize)(this.dgvEntries)).EndInit();
            this.contextMenuStrip1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvEntries;
        private System.Windows.Forms.Label lblTransactionID;
        private System.Windows.Forms.Label lblDateRange;
        private System.Windows.Forms.ContextMenuStrip contextMenuStrip1;
        private System.Windows.Forms.ToolStripMenuItem displayTransactionDetailsToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem copyTransactionToClipboardToolStripMenuItem;
    }
}
