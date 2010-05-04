/**
 * (C) 2006-2009 eIrOcA (eNrIcO Croce & sImOnA Burzio)
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later
 * version.
 */
using System;
using System.Configuration;
using System.Collections;
using System.Collections.Specialized;

namespace WikiHelper {

  public class WikiConf {

    public bool useLogin {
      get {
        string useLoginStr = Get("useLogin");
        return (String.IsNullOrEmpty(useLoginStr)? false : (!useLoginStr.Equals("0")? true: false));
      }
    }
  
    public string wikiURL {
      get {
        return  Get("wikiURL");
      }
    }
    
    public string wikiDomain {
      get {
       return Get("wikiDomain");
      }
    }
    
    public string wikiDefCategory {
      get {
        return Get("wikiDefCategory");
      }
    }
    
    public string pptTemplate {
      get {
        return Get("PPT_Template");
      }
    }
    
    public string extractors {
      get {
        return Get("extractors");
      }
    }
    
    public string loginConf {
      get {
        return Get("loginConf");
      }
    }
    
    public string newPage_Template {
      get {
        return Get("newPage_Template");
      }
    }
    
    public string newPage_List {
      get {
        return Get("newPage_List");
      }
    }
    
    public string replace_List {
      get {
        return Get("replace_List");
      }
    }

    public string[] categories {
      get {
        string cat = Get("categories");
        string[] cats = (String.IsNullOrEmpty(cat)? new string[0] : cat.Split(','));
        for (int i=0; i<cats.Length; i++) {
          cats[i] = cats[i].Trim();
        }
        return cats;
      }
    }
    
    private System.Collections.Specialized.NameValueCollection settings;
    
    private string Get(string key) {
      string val = settings[key];
      if (String.IsNullOrEmpty(val)) {
        val = null;
      }
      return val;
    }
    
    public WikiConf() {
      settings = ConfigurationManager.AppSettings;
    }
    
  }
  
}
