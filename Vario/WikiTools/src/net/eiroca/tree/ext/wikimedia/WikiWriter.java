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
package net.eiroca.tree.ext.wikimedia;

import net.eiroca.tree.model.TreeNode;
import net.eiroca.tree.model.TreeWriter;

/**
 * The Class WikiWriter.
 */
public class WikiWriter implements TreeWriter<Page> {

  /** The level header. */
  public int levelHeader = 3;

  /** The level dotted. */
  public int levelDotted = 3;

  /**
   * Instantiates a new wiki writer.
   * 
   * @param headerLevels the header levels
   * @param dottedLevels the dotted levels
   */
  public WikiWriter(final int headerLevels, final int dottedLevels) {
    levelHeader = headerLevels;
    levelDotted = dottedLevels + headerLevels;
  }

  /**
   * Write node.
   * 
   * @param buf the buf
   * @param node the node
   * @param writeInfo the write info
   * @param level the level
   * 
   * @return true, if successful
   */
  public boolean writeNode(final StringBuffer buf, final Line node, final boolean writeInfo, int level) {
    if (node == null) { return false; }
    final String text = node.getText();
    final String link = node.getLink();
    if (level < levelHeader) {
      for (int i = 0; i <= level; i++) {
        buf.append('=');
      }
    }
    else if (level < levelDotted) {
      for (int i = levelHeader - 1; i < level; i++) {
        buf.append('*');
      }
    }
    else {
      for (int i = levelDotted - 1; i < level; i++) {
        buf.append(':');
      }
    }
    buf.append(' ');
    buf.append(text);
    if (link != null) {
      buf.append(" [").append(link).append("]");
    }
    if (level < levelHeader) {
      buf.append(' ');
      for (int i = 0; i <= level; i++) {
        buf.append('=');
      }
    }
    buf.append('\n');
    if (node.hasChildren()) {
      level++;
      for (final TreeNode u : node) {
        writeNode(buf, (Line) u, writeInfo, level);
      }
    }
    return true;
  }

  /*t
   * (non-Javadoc)
   *
   * @see net.eiroca.node.io.TreeWriter#writeTree(net.eiroca.node.model.Tree,
   *      boolean)
   */
  public String writeTree(final Page tree, final boolean compact) {
    final StringBuffer buf = new StringBuffer(1024);
    writeNode(buf, tree.getRoot(), !compact, 0);
    return buf.toString();
  }

}
