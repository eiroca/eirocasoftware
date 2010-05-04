/**
 * (C) 2006-2009 eIrOcA (eNrIcO Croce & sImOnA Burzio)
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later
 * version.
 */
using System;
using System.IO;
using System.Text;
using System.Windows.Forms;

using WikiHelper.lib.WikiMedia;

namespace WikiHelper.gui {

  /// <summary>
  /// Description of MainForm.
  /// </summary>
  public partial class MainForm : Form  {

    WikiMedia wiki;
    bool loggedIn = false;
    WikiConf conf;

    public delegate void Export(WikiMedia.ExportNotify notify);

    public MainForm(WikiMedia wiki, WikiConf conf) {
      this.wiki = wiki;
      this.conf = conf;
      InitializeComponent();
    }

    bool Login() {
      if (conf.useLogin) {
        if (!loggedIn) {
          try {
            if (WikiTools.wikiConf.wikiDomain == null) {
              loggedIn = true;
              wiki.LogIn();
            }
            else {
              if (WikiTools.wikiLoginForm.ShowDialog() == DialogResult.OK) {
                string oldText = this.Text;
                this.Text = "WAITING ...";
                Application.DoEvents();
                wiki.LogIn();
                loggedIn = true;
                this.Text = oldText;
              }
            }
          }
          catch {
          }
        }
      }
      else {
        loggedIn = true;
        wiki.username=null;
        wiki.password=null;
        wiki.LogIn();
      }
      return loggedIn;
    }

    void Do(Export action) {
      if (!Login()) {
        return;
      }
      meOut.Clear();
      action(Print);
    }

    public void Print(string msg) {
      meOut.Text += msg + "\t";
      Application.DoEvents();
    }

    void ExportForm(IExporter exporter) {
      if (!Login()) {
        return;
      }
      meOut.Clear();
      if (exporter.Setup()) {
        exporter.Export(Print);
      }
    }

    void CloseClick(object sender, EventArgs e) {
      Close();
    }

    void BuildPagesClick(object sender, EventArgs e) {
      if (!Login()) {
        return;
      }
      meOut.Clear();
      if (WikiTools.createForm.ShowDialog() == DialogResult.OK) {
        string template = File.ReadAllText(conf.newPage_Template, Encoding.UTF8);
        string[] lines = File.ReadAllLines(conf.newPage_List, Encoding.UTF8);
        wiki.CreatePages(template, lines, Print);
      }
    }

    void ExportCategoryClick(object sender, EventArgs e) {
      ExportForm(WikiTools.categoryExport);
    }

    void ExportAddressBookClick(object sender, System.EventArgs e) {
      ExportForm(WikiTools.addressBookExport);
    }

    void ExportPageClick(object sender, EventArgs e) {
      ExportForm(WikiTools.pageExport);
    }

    void ReplacesClick(object sender, EventArgs e) {
      if (!Login()) {
        return;
      }
      meOut.Clear();
      if (WikiTools.replaceForm.ShowDialog() == DialogResult.OK) {
        string[,] replaces = WikiTools.replaceForm.GetReplaces();
        string category = WikiTools.replaceForm.GetCategory();
        if ((category!=null) && (replaces!=null)) {
          wiki.Replace(category, replaces, Print);
        }
      }
    }

    void ConfigurazioneClick(object sender, EventArgs e) {
      DotBits.Configuration.ConfigEditor c = new  DotBits.Configuration.ConfigEditor();
      c.
      c.ShowDialog(this);
    }
    
  }

}
