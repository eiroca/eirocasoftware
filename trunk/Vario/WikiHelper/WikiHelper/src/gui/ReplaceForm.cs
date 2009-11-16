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

  public partial class ReplaceForm : Form {
  
    WikiConf conf;
    
    public ReplaceForm(WikiConf conf) {
      InitializeComponent();
      this.conf = conf;
      SetCategories(conf.categories);
      LoadData();
      Update(-1);
    }
    
    void LoadData() {
      char[] sep = {'\t'};
      lbFrom.Items.Clear();
      lbTo.Items.Clear();
      string[] lines = File.ReadAllLines(conf.replace_List, Encoding.UTF8);
      string[] val = null;
      foreach (string l in lines) {
        val = l.Split(sep);
        if (val.Length==2) {
          lbFrom.Items.Add(val[0]);
          lbTo.Items.Add(val[1]);
        }
      }
    }
    
    void Update(int index) {
    	lbFrom.SelectedIndex = index;
    	lbTo.SelectedIndex = index;
    	if (index>=0) {
    	  iFrom.Text = lbFrom.Items[index].ToString();
      	iTo.Text = lbTo.Items[index].ToString();
      	bDelete.Enabled = true;
      	bReplace.Enabled = true;
    	}
    	else {
      	bDelete.Enabled = false;
      	bReplace.Enabled = false;
    	}
    }
    
    void LbToSelectedIndexChanged(object sender, EventArgs e) {
      Update(lbTo.SelectedIndex);
    }
        
    void LbFromSelectedIndexChanged(object sender, EventArgs e) {
      Update(lbFrom.SelectedIndex);
    }
    
    void BDeleteClick(object sender, EventArgs e) {
      int index = lbTo.SelectedIndex;
      if (index>=0) {
        lbTo.Items.RemoveAt(index);
        lbFrom.Items.RemoveAt(index);
        if (index >= lbTo.Items.Count) {
          index = lbTo.Items.Count-1;
        }
        Update(index);
      }
    }
    
    void BReplaceClick(object sender, EventArgs e){
      int index = lbTo.SelectedIndex;
      if (index>=0) {
        string from = iFrom.Text;
        string to = iTo.Text;
        lbTo.Items[index] = to;
        lbFrom.Items[index] = from;
      }
   	}
    
    void BAddClick(object sender, EventArgs e) {
      lbTo.Items.Add(iTo.Text);
      lbFrom.Items.Add(iFrom.Text);
      Update(lbTo.Items.Count-1);
    }
    
    public string[,] GetReplaces() {
      string[,] replaces = null;
      int cnt = lbTo.Items.Count;
      if (cnt>0) {
        replaces = new string[cnt, 2];
        for (int i=0; i<cnt; i++) {
          replaces[i, 0] = lbFrom.Items[i].ToString();
          replaces[i, 1] = lbTo.Items[i].ToString();
        }
      }
      return replaces;
    }
    
    public string GetCategory() {
      string cat = iCategory.Text.Trim();
      return (String.IsNullOrEmpty(cat) ? null : cat);
    }
   
    public void SetCategories(string[] categories) {
      iCategory.Items.Clear();
      iCategory.Items.AddRange(categories);
    }

  }
  
}
