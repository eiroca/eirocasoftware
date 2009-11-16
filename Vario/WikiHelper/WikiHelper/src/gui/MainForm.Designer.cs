/**
 * (C) 2006-2009 eIrOcA (eNrIcO Croce & sImOnA Burzio)
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later
 * version.
 */
namespace WikiHelper.gui {

  partial class MainForm {
    /// <summary>
    /// Designer variable used to keep track of non-visual components.
    /// </summary>
    private System.ComponentModel.IContainer components = null;
    
    /// <summary>
    /// Disposes resources used by the form.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
    {
      if (disposing) {
        if (components != null) {
          components.Dispose();
        }
      }
      base.Dispose(disposing);
    }
    
    /// <summary>
    /// This method is required for Windows Forms designer support.
    /// Do not change the method contents inside the source code editor. The Forms designer might
    /// not be able to load this method if it was changed manually.
    /// </summary>
    private void InitializeComponent()
    {
    	this.meOut = new System.Windows.Forms.RichTextBox();
    	this.menuStrip1 = new System.Windows.Forms.MenuStrip();
    	this.fileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
    	this.buildPagesToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
    	this.toolStripMenuItem2 = new System.Windows.Forms.ToolStripMenuItem();
    	this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
    	this.miExportPage = new System.Windows.Forms.ToolStripMenuItem();
    	this.exportCategoryToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
    	this.miAddressBook = new System.Windows.Forms.ToolStripMenuItem();
    	this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripSeparator();
    	this.closeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
    	this.menuStrip1.SuspendLayout();
    	this.SuspendLayout();
    	// 
    	// meOut
    	// 
    	this.meOut.Dock = System.Windows.Forms.DockStyle.Fill;
    	this.meOut.Location = new System.Drawing.Point(0, 24);
    	this.meOut.Name = "meOut";
    	this.meOut.Size = new System.Drawing.Size(747, 360);
    	this.meOut.TabIndex = 2;
    	this.meOut.Text = "";
    	// 
    	// menuStrip1
    	// 
    	this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
    	    	    	this.fileToolStripMenuItem});
    	this.menuStrip1.Location = new System.Drawing.Point(0, 0);
    	this.menuStrip1.Name = "menuStrip1";
    	this.menuStrip1.Size = new System.Drawing.Size(747, 24);
    	this.menuStrip1.TabIndex = 3;
    	this.menuStrip1.Text = "menuStrip1";
    	// 
    	// fileToolStripMenuItem
    	// 
    	this.fileToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
    	    	    	this.buildPagesToolStripMenuItem1,
    	    	    	this.toolStripMenuItem2,
    	    	    	this.toolStripSeparator1,
    	    	    	this.miExportPage,
    	    	    	this.exportCategoryToolStripMenuItem,
    	    	    	this.miAddressBook,
    	    	    	this.toolStripMenuItem1,
    	    	    	this.closeToolStripMenuItem});
    	this.fileToolStripMenuItem.Name = "fileToolStripMenuItem";
    	this.fileToolStripMenuItem.Size = new System.Drawing.Size(35, 20);
    	this.fileToolStripMenuItem.Text = "&File";
    	// 
    	// buildPagesToolStripMenuItem1
    	// 
    	this.buildPagesToolStripMenuItem1.Name = "buildPagesToolStripMenuItem1";
    	this.buildPagesToolStripMenuItem1.Size = new System.Drawing.Size(185, 22);
    	this.buildPagesToolStripMenuItem1.Text = "Build Pages";
    	this.buildPagesToolStripMenuItem1.Click += new System.EventHandler(this.BuildPagesToolStripMenuItem1Click);
    	// 
    	// toolStripMenuItem2
    	// 
    	this.toolStripMenuItem2.Name = "toolStripMenuItem2";
    	this.toolStripMenuItem2.Size = new System.Drawing.Size(185, 22);
    	this.toolStripMenuItem2.Text = "Replace";
    	this.toolStripMenuItem2.Click += new System.EventHandler(this.ToolStripMenuItem2Click);
    	// 
    	// toolStripSeparator1
    	// 
    	this.toolStripSeparator1.Name = "toolStripSeparator1";
    	this.toolStripSeparator1.Size = new System.Drawing.Size(182, 6);
    	// 
    	// miExportPage
    	// 
    	this.miExportPage.Name = "miExportPage";
    	this.miExportPage.Size = new System.Drawing.Size(185, 22);
    	this.miExportPage.Text = "Export page(s)";
    	this.miExportPage.Click += new System.EventHandler(this.MiExportPageClick);
    	// 
    	// exportCategoryToolStripMenuItem
    	// 
    	this.exportCategoryToolStripMenuItem.Name = "exportCategoryToolStripMenuItem";
    	this.exportCategoryToolStripMenuItem.Size = new System.Drawing.Size(185, 22);
    	this.exportCategoryToolStripMenuItem.Text = "Export Category...";
    	this.exportCategoryToolStripMenuItem.Click += new System.EventHandler(this.ExportCategoryToolStripMenuItemClick);
    	// 
    	// miAddressBook
    	// 
    	this.miAddressBook.Name = "miAddressBook";
    	this.miAddressBook.Size = new System.Drawing.Size(185, 22);
    	this.miAddressBook.Text = "Address Book Export";
    	this.miAddressBook.Click += new System.EventHandler(this.MiAddressBookClick);
    	// 
    	// toolStripMenuItem1
    	// 
    	this.toolStripMenuItem1.Name = "toolStripMenuItem1";
    	this.toolStripMenuItem1.Size = new System.Drawing.Size(182, 6);
    	// 
    	// closeToolStripMenuItem
    	// 
    	this.closeToolStripMenuItem.Name = "closeToolStripMenuItem";
    	this.closeToolStripMenuItem.Size = new System.Drawing.Size(185, 22);
    	this.closeToolStripMenuItem.Text = "&Close";
    	this.closeToolStripMenuItem.Click += new System.EventHandler(this.CloseToolStripMenuItemClick);
    	// 
    	// MainForm
    	// 
    	this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
    	this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
    	this.ClientSize = new System.Drawing.Size(747, 384);
    	this.Controls.Add(this.meOut);
    	this.Controls.Add(this.menuStrip1);
    	this.MainMenuStrip = this.menuStrip1;
    	this.Name = "MainForm";
    	this.Text = "WikiHelper";
    	this.menuStrip1.ResumeLayout(false);
    	this.menuStrip1.PerformLayout();
    	this.ResumeLayout(false);
    	this.PerformLayout();
    }
    private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
    private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem2;
    private System.Windows.Forms.ToolStripMenuItem miExportPage;
    private System.Windows.Forms.ToolStripMenuItem miAddressBook;
    private System.Windows.Forms.ToolStripMenuItem buildPagesToolStripMenuItem1;
    private System.Windows.Forms.ToolStripSeparator toolStripMenuItem1;
    private System.Windows.Forms.ToolStripMenuItem exportCategoryToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem closeToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem fileToolStripMenuItem;
    private System.Windows.Forms.MenuStrip menuStrip1;
    private System.Windows.Forms.RichTextBox meOut;
       
  }
  
}
