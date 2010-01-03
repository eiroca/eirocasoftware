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
  
    public string wikiURL;
    public string wikiDomain;
    public string wikiDefCategory;

    public string pptTemplate;
    public string extractors;

    public string loginConf;

    public string newPage_Template;
    public string newPage_List;
    public string replace_List;

    public string[] categories;
    
    private System.Collections.Specialized.NameValueCollection settings;
    
    private string Get(string key) {
      string val = settings[key];
      return (val!=null? val.ToString() : null);
    }
    
    public WikiConf() {
      settings = ConfigurationManager.AppSettings;
    
      wikiURL = Get("wikiURL");
      wikiDomain = Get("wikiDomain");
      wikiDefCategory = Get("wikiDefCategory");
      
      pptTemplate = Get("PPT_Template");
      extractors = Get("extractors");
      
      loginConf = Get("loginConf");
      
      newPage_Template = Get("newPage_Template");
      newPage_List = Get("newPage_List");

      replace_List = Get("replace_List");

      string cat = Get("categories");
      categories = (cat!=null? cat.Split(',') : new string[0]);
      for (int i=0; i<categories.Length; i++) {
        categories[i] = categories[i].Trim();
      }
    }
    
  }
  
}
