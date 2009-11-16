/**
 * (C) 2006-2009 eIrOcA (eNrIcO Croce & sImOnA Burzio)
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 3 of the License, or (at your option) any later
 * version.
 */
using System;
using System.Collections.Generic;
using System.Text;

namespace WikiHelper.lib.WikiMedia {

  public class WikiContainer {
    public List<string> data = new List<string>();
    bool _wasNull = false;
    bool _isEmpty = true;
    
    public WikiContainer() {
    }

    public virtual bool isEmpty() {
      return _isEmpty;
    }
    
    public virtual void Add(string row) {
      string tRow = row.Trim();
      if (String.IsNullOrEmpty(tRow)) {
        if (!_wasNull) {
          _wasNull = true;
        }
        else {
          data.Add("");
        }
      }
      else {
        if (!_isEmpty) {
          if (_wasNull) {
            data.Add("");
          }
        }
        data.Add(row);
        _isEmpty = false;
        _wasNull = false;
      }
    }
    
 }

  public class WikiHeader : WikiContainer {

    public int level;
    public string name;
    
    public WikiHeader() {
      
    }
    
    public override string ToString() {
      return Format(true, true, false, "\n");
    }
    
    public string Format(bool head, bool raw, bool pack, string sep) {
      StringBuilder sb = new StringBuilder();
      if (head) {
        for (int i = 0; i < level; i++) { 
          sb.Append('=');
        }
        sb.Append(' ').Append(name).Append(' ');
        for (int i = 0; i < level; i++) { 
          sb.Append('=');
        }
        sb.Append(sep);
      }
      if (raw) {
        for (int i = 0; i < data.Count; i++) {
          string row = data[i].ToString();
          if (!(pack && String.IsNullOrEmpty(row)))  {
            sb.Append(row).Append(sep);
          }
        }
      }
      return sb.ToString();
    }
    
  }

  public class WikiDocument  {
    
    public List<WikiHeader> headers = new List<WikiHeader>();
    public WikiContainer rowData = new WikiContainer();
    
    public override string ToString() {
      StringBuilder sb = new StringBuilder(1024);
      for (int i = 0; i < rowData.data.Count-1; i++) {
        sb.Append(rowData.data[i].ToString()).Append('\n');
      }
      for (int i = 0; i < headers.Count-1; i++) {
        WikiHeader header = headers[i];
        sb.Append(header.ToString());
      }
      return sb.ToString();
    }
    
    public WikiHeader FindHeader(int level, string name) {
      for (int i = 0; i < headers.Count-1; i++) {
        WikiHeader header = headers[i];
        if ((header.level==level) && (header.name.Equals(name))) {
          return header;
        }
      }
      return null;
    }

    public WikiHeader FindHeader( string name) {
      for (int i = 0; i < headers.Count-1; i++) {
        WikiHeader header = headers[i];
        if (header.name.Equals(name)) {
          return header;
        }
      }
      return null;
    }

    WikiHeader header = null;

    public Char[] SEP  = new Char [] {'\n'};
    
    public WikiDocument(string text) {
      header = null;
      string[] rows = text.Split(SEP);
      for (int i=0; i<rows.Length; i++) {
        string row = rows[i].Trim();
        ProcessRow(row);
      }
    }

    public void ProcessRow(string row) {
      if (row.StartsWith("=")) {
        ProcessHeaderRow(row);
      }
      else {
        if ((header!=null) && (!row.StartsWith("{{Categorie"))) {
          header.Add(row);
        }
        else {
          rowData.Add(row);
        }
      }
    }

    public void ProcessHeaderRow(string row) {
      WikiHeader newHeader = new WikiHeader();
      int lev = 0;
      int state = 0;
      StringBuilder name = new StringBuilder();
      for (int ci = 0; ci<row.Length; ci++) {
        if (row[ci] == '=') {
          if (state == 0) {
            lev++;
          }
          else {
            state = 2;
          }
        }
        else {
          if (state==0) {
            state = 1;
          }
          if (state==1) {
            name.Append(row[ci]);
          }
        }
      }
      newHeader.name = name.ToString().Trim();
      newHeader.level = lev;
      headers.Add(newHeader);
      header = newHeader;
    }
    
  }

}
