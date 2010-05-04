/**
 * (C) 2006-2009 eIrOcA (eNrIcO Croce & sImOnA Burzio)
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later
 * version.
 */
using System;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text.RegularExpressions;

using DotNetWikiBot;

namespace WikiHelper.lib.WikiMedia {

  /// <summary>
  /// Description of WikiMedia.
  /// </summary>
  public class WikiMedia {
  
    public delegate void ExportNotify(string msg);

    public string username;
    public string password;
   
    public string WikiURL;
    public string WikiDomain;
    
    public Site site;
    public string defCategory;
    
    public WikiMedia(string WikiURL, string WikiDomain, string aDefCategory) {
      this.WikiURL = WikiURL;
      this.WikiDomain = WikiDomain;
  	  // System.Net.ServicePointManager.CertificatePolicy = new MyPolicy();
      System.Net.ServicePointManager.ServerCertificateValidationCallback += delegate(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) {
         return true;
      };
  	  defCategory = aDefCategory;
    }
    
    public void LogIn() {
      if (username!=null) {
        site = new Site(WikiURL, username, password, WikiDomain);
      }
      else {
        site = new Site(WikiURL, null, null);
      }
    }

    public Page GetPage(string title) {
      return new Page(site, title);
    }
    
    public PageList GetPages(string category) {
  		PageList pl = new PageList(site);
  		pl.FillAllFromCategoryEx(category);
  		return pl;
    }
    
    public string GetPageName(string name) {
      if (name.IndexOf(':')==-1) {
        name = defCategory +":"+name;
      }
      return name;
    }

    public void CreatePages(string template, string[] lines, WikiMedia.ExportNotify notify) {
      char[] sep = {'\t'};
      string[] val = null;
      for (int i=0; i<lines.Length; i++) {
        string[] fld = lines[i].Split(sep);
        val = new string[fld.Length];
        string pageName = GetPageName(fld[0].Trim());
        string msg = pageName;
        if (!string.IsNullOrEmpty(pageName)) {
          int cnt = fld.Length;
          for (int j=0; j<val.Length; j++) {
            string vl = null;
            if (j<fld.Length) {
              vl = fld[j];
            }
            if (vl==null) {
              vl = "";
            }
            val[j] = vl;
          }
          Page p = new Page(site, pageName);
          p.Load();
          if (!p.Exists()) {
            msg += " created";
            p.text = string.Format(template, val);
            p.Save();
          }
          else {
            msg += " skipped";
          }
          notify(msg);
        }
      }
    }

    public void Replace(string category, string[,] replaces, WikiMedia.ExportNotify notify) {
      int len = replaces.GetLength(0);
      Regex[] re = new Regex[len];
      for (int i = 0; i<len; i++) {
        re[i] = new Regex(replaces[i,0], RegexOptions.Compiled | RegexOptions.Singleline);
      }
      PageList pl = GetPages(category);
  		foreach(Page page in pl) {
  		  page.Load();
  		  string text = page.text;
        for (int i = 0; i<len; i++) {
  		    text = re[i].Replace(text, replaces[i,1]);
        }
  		  if (!text.Equals(page.text)) {
  		    notify(page.title);
    		  page.text = text;
    		  page.Save();
  		  }
  		}
  	}

  }

  public class MyPolicy : ICertificatePolicy {
      public bool CheckValidationResult(
            ServicePoint srvPoint
          , X509Certificate certificate
          , WebRequest request
          , int certificateProblem) {
  
          //Return True to force the certificate to be accepted.
          return true;
  
      } // end CheckValidationResult
  } // class MyPolicy

}
