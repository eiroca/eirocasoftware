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
  
  public class Element {
   
    public Element() {
    }
    
  }

  public class Container: Element {
    public Container parent;
    public List<Element> elements = new List<Element>();
    public Container(Container parent) {
      this.parent = parent;
    }

    public override string ToString() {
      StringBuilder sb = new StringBuilder();
      foreach(Element e in elements) {
        sb.Append(e.ToString());
      }
      return sb.ToString();
    }
    
  }

  public class NewLine: Element {
    public NewLine() {
    }
    
    public override string ToString() {
      return "\n";
    }
  }

  public class Text: Element {
    
    public const int FMT_ITALIC    = 1;
    public const int FMT_BOLD      = 2;
    public const int FMT_UNDERLINE = 4;
      
    public StringBuilder text;
    public int format;

    public bool bold {
      get {
        return (format & FMT_BOLD) == FMT_BOLD;
      }
      set {
        if (value) {
          format = format | FMT_BOLD;
        }
        else {
          format = format & ~FMT_BOLD;
        }
      }
    }

    public bool italic {
      get {
        return (format & FMT_ITALIC) == FMT_ITALIC;
      }
      set {
        if (value) {
          format = format | FMT_ITALIC;
        }
        else {
          format = format & ~FMT_ITALIC;
        }
      }
    }

    public bool underline {
      get {
        return (format & FMT_UNDERLINE) == FMT_UNDERLINE;
      }
      set {
        if (value) {
          format = format | FMT_UNDERLINE;
        }
        else {
          format = format & ~FMT_UNDERLINE;
        }
      }
    }

    public Text() {
      text = new StringBuilder();
    }
    
    public Text(string text) : this() {
      Append(text);
    }
    
    public Text Append(string text) {
      this.text.Append(text);
      return this;
    }
    
    public override string ToString() {
      return text.ToString();
    }
    
  }

  public class HyperLink: Text {
    public string URL;
    
    public HyperLink() {
    }

    public override string ToString() {
      return "["+base.ToString()+"]";
    }
    
  }

  public class ListItem: Text {
    public int level;
    public int num;
    public int mode;
    
    public ListItem() {
      level = 1;
      num = 1;
      mode = 0;
    }

    public override string ToString() {
      return "\t"+base.ToString();
    }
  }

  public class Paragraph: Container {
    
    public Paragraph(Container parent): base(parent) {}
  
    public override string ToString() {
      return base.ToString()+"\n";
    }

  }

  public class List: Container {
    
    public List(Container parent): base(parent) {
    }
    
  }
  
  public class Header: Container {

    public List<Element> title = new List<Element>();
    public int level;
    
    public Header(Container parent): base(parent) {
    }
  
    public virtual bool isEmpty() {
      return (elements.Count==0);
    }

    public string name {
      get { 
        string res = null;
        if (title.Count>0) {
          res = title[0].ToString();
        }
        return res; 
      }
    }
    
    public override string ToString() {
      StringBuilder sb = new StringBuilder();
      sb.Append(title.ToString()).Append('\n');
      sb.Append(base.ToString()).Append('\n');
      return sb.ToString();
    }

  }

  public class Document: Container {
    
    public List<Header> headers = new List<Header>();

    public Document(): base(null) {
    }

    public Header FindHeader(int level, string name) {
      for (int i = 0; i < headers.Count-1; i++) {
        Header header = headers[i];
        if ((header.level==level) && (header.name.Equals(name))) {
          return header;
        }
      }
      return null;
    }

    public Header FindHeader(string name) {
      for (int i = 0; i < headers.Count-1; i++) {
        Header header = headers[i];
        if (header.name == null) {
          continue;
        }
        if (header.name.Equals(name)) {
          return header;
        }
      }
      return null;
    }

  }
  
}
