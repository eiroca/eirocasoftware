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
package net.eiroca.tree.ext.freemind;

import net.eiroca.tree.model.TreeWriter;

/**
 * The Class MMWriter.
 */
public class MMWriter implements TreeWriter<Map> {

  /*
   * (non-Javadoc)
   *
   * @see net.eiroca.node.io.TreeWriter#writeTree(net.eiroca.node.model.Tree,
   *      boolean)
   */
  public String writeTree(final Map tree, final boolean compact) {
    final StringBuffer buf = new StringBuffer(1024);
    buf.append("<?xml version=\"1.0\"?>");
    MMUtil.MAP.open(buf, true);
    MMUtil.MAP.writeMeta(buf, tree.getMeta());
    MMUtil.MAP.openClose(buf);
    MMUtil.NODE.writeNode(buf, tree.getRoot());
    MMUtil.MAP.close(buf, false);
    return buf.toString();
  }

}
