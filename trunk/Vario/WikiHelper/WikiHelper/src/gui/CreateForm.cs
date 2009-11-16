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

namespace WikiHelper.gui {

  public partial class CreateForm : Form {
    
    WikiConf conf;
    
    public CreateForm(WikiConf conf) {
      InitializeComponent();
      this.conf = conf;
      LoadData();
    }
    
    void LoadData() {
      string[] template = File.ReadAllLines(conf.newPage_Template, Encoding.UTF8);
      string[] lines = File.ReadAllLines(conf.newPage_List, Encoding.UTF8);
      lbTemplate.Items.AddRange(template);
      lbPages.Items.AddRange(lines);
    }

  }
  
}
