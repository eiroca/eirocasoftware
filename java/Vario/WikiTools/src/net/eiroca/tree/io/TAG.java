/**
 * Copyright (C) 2006-2010 eIrOcA (eNrIcO Croce & sImOnA Burzio)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/
 * 
 */
package net.eiroca.tree.io;

import java.util.Map;
import net.eiroca.tree.model.TreeReader;
import org.xml.sax.Attributes;

/**
 * The Class TAG.
 */
public class TAG<TR extends TreeReader<?>> implements TagProcessor<TR> {

  /**
   * Encode.
   * 
   * @param buf the buf
   * @param str the str
   */
  public static void encode(final StringBuffer buf, final String str) {
    for (int i = 0; i < str.length(); i++) {
      final char c = str.charAt(i);
      if ((c < 32) || (c > 127)) {
        buf.append("&x").append(Integer.toString(c, 16)).append(';');
      }
      else {
        switch (c) {
          case '&':
            buf.append("&amp;");
            break;
          case '"':
            buf.append("&quot;");
            break;
          default:
            buf.append(c);
            break;
        }
      }
    }
  }

  /** The tag name. */
  private String tagName;

  /** The buf. */
  protected StringBuffer buf;

  /**
   * Instantiates a new tAG.
   * 
   * @param name the name
   */
  @SuppressWarnings("unchecked")
  public TAG(final String name) {
    tagName = name;
    TagFactory.register((TagProcessor<TreeReader<?>>) this);
  }

  /*
   * (non-Javadoc)
   * @see net.eiroca.node.io.TagProcessor#characters(net.eiroca.node.io.TreeReader, char[], int,
   * int)
   */
  @Override
  public void characters(final TR reader, final char[] chr, final int start, final int length) {
    final String str = new String(chr, start, length);
    if (buf != null) {
      buf.append(str);
    }
  }

  /**
   * Close.
   * 
   * @param buf the buf
   * @param compact the compact
   */
  public void close(final StringBuffer buf, final boolean compact) {
    if (compact) {
      buf.append("/>");
    }
    else {
      buf.append("</");
      buf.append(tagName);
      buf.append('>');
    }
  }

  /*
   * (non-Javadoc)
   * @see net.eiroca.node.io.TagProcessor#end(net.eiroca.node.io.TreeReader)
   */
  @Override
  public void end(final TR reader) {
    if (buf != null) {
      final Map<String, String> data = reader.getData();
      final Map<String, String> info = data;
      final String val = buf.toString();
      info.put(tagName, val.length() == 0 ? null : val);
    }
  }

  /*
   * (non-Javadoc)
   * @see net.eiroca.node.io.TagProcessor#getName()
   */
  @Override
  public String getName() {
    return tagName;
  }

  /**
   * Open.
   * 
   * @param buf the buf
   * @param open the open
   */
  public void open(final StringBuffer buf, final boolean open) {
    buf.append('<');
    buf.append(tagName);
    if (!open) {
      buf.append('>');
    }
  }

  /**
   * Open close.
   * 
   * @param buf the buf
   */
  public void openClose(final StringBuffer buf) {
    buf.append('>');
  }

  /**
   * Sets the name.
   * 
   * @param name the new name
   */
  public void setName(final String name) {
    tagName = name;
  }

  /*
   * (non-Javadoc)
   * @see net.eiroca.node.io.TagProcessor#start(net.eiroca.node.io.TreeReader,
   * org.xml.sax.Attributes)
   */
  @Override
  public void start(final TR reader, final Attributes attribs) {
    buf = new StringBuffer(200);
  }

  /**
   * Write attribute.
   * 
   * @param buf the buf
   * @param name the name
   * @param value the value
   * @param last the last
   */
  public void writeAttribute(final StringBuffer buf, final String name, final String value, final boolean last) {
    buf.append(' ');
    buf.append(name);
    buf.append("=\"");
    TAG.encode(buf, value);
    buf.append('"');
    if (last) {
      buf.append('>');
    }
  }

  /**
   * Write c data.
   * 
   * @param buf the buf
   * @param data the data
   */
  public void writeCData(final StringBuffer buf, final String data) {
    if (data != null) {
      TAG.encode(buf, data);
    }
  }

  /**
   * Write int.
   * 
   * @param buf the buf
   * @param atr the atr
   * @param defVal the def val
   * @param val the val
   */
  public void writeInt(final StringBuffer buf, final String atr, final int defVal, final int val) {
    if (val != defVal) {
      writeAttribute(buf, atr, Integer.toString(val), false);
    }
  }

  /**
   * Write string.
   * 
   * @param buf the buf
   * @param atr the atr
   * @param val the val
   */
  public void writeString(final StringBuffer buf, final String atr, final String val) {
    if (val != null) {
      writeAttribute(buf, atr, val, false);
    }
  }

}
