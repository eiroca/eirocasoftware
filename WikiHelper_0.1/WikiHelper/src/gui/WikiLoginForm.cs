/**
 * (C) 2006-2009 eIrOcA (eNrIcO Croce & sImOnA Burzio)
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later
 * version.
 */
using System;
using System.Windows.Forms;
using WikiHelper.lib.WikiMedia;

namespace WikiHelper.gui {

  public partial class WikiLoginForm : Form {
  
    WikiMedia wiki;

    public WikiLoginForm(WikiMedia wiki, string username, string password) {
      //
      // The InitializeComponent() call is required for Windows Forms designer support.
      //
      InitializeComponent();
      this.wiki = wiki;
      if (username!=null) { 
        iUsername.Text= username; 
      }
      if (password!=null) { 
        iPassword.Text= password; 
      }
    }
    
  }
  
}
