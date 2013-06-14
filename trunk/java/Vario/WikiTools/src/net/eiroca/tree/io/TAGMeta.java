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

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import net.eiroca.tree.model.MetaDataCollector;
import net.eiroca.tree.model.TreeNode;
import net.eiroca.tree.model.TreeReader;
import org.xml.sax.Attributes;

/**
 * The Class TAGMeta.
 */
public class TAGMeta<TR extends TreeReader<?>> extends TAG<TR> {

  /** The ATR_id. */
  public String ATR_ID = "id";

  /** The Constant order. */
  protected final static List<String> order = new ArrayList<String>();

  /**
   * Instantiates a new tAG meta.
   * 
   * @param name the name
   */
  public TAGMeta(final String name) {
    super(name);
  }

  /**
   * Read meta.
   * 
   * @param meta the meta
   * @param attribs the attribs
   */
  public void readMeta(final MetaDataCollector meta, final Attributes attribs) {
    String name;
    String value;
    for (int i = 0; i < attribs.getLength(); i++) {
      name = attribs.getQName(i);
      value = attribs.getValue(i);
      meta.setMeta(name, value);
    }
  }

  /**
   * Write meta.
   * 
   * @param buf the buffer
   * @param meta the meta
   */
  public void writeMeta(final StringBuffer buf, final Map<String, String> meta) {
    final HashSet<String> done = new HashSet<String>();
    for (final String metaName : TAGMeta.order) {
      final String val = meta.get(metaName);
      if (val != null) {
        writeAttribute(buf, metaName, meta.get(metaName), false);
        done.add(metaName);
      }
    }
    for (final String metaName : meta.keySet()) {
      if (!done.contains(metaName)) {
        writeAttribute(buf, metaName, meta.get(metaName), false);
      }
    }
  }

  /**
   * Write node.
   * 
   * @param buf the buf
   * @param node the node
   * 
   * @return true, if successful
   */
  public boolean writeNode(final StringBuffer buf, final TreeNode node) {
    if (node == null) { return false; }
    open(buf, true);
    writeString(buf, ATR_ID, node.getID());
    writeMeta(buf, node.getMeta());
    boolean compact = true;
    if (node.hasChildren()) {
      if (compact) {
        openClose(buf);
        compact = false;
      }
      for (int i = 0; i < node.getChildrenCount(); i++) {
        writeNode(buf, node.getChildren(i));
      }
    }
    close(buf, compact);
    return true;
  }

}
