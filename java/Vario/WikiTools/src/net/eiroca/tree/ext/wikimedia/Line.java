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

import net.eiroca.tree.model.GenericTreeNode;
import net.eiroca.tree.model.Tree;
import net.eiroca.tree.model.TreeNode;

/**
 * The Class Line.
 */
public class Line extends GenericTreeNode<Line> {

  /**
   * Instantiates a new line.
   * 
   * @param owner the owner
   */
  public Line(final Tree<Line> owner) {
    super(owner);
  }

  /**
   * Instantiates a new line.
   * 
   * @param ownerTree the owner tree
   * @param sourceNode the source node
   */
  public Line(final Tree<Line> ownerTree, final TreeNode sourceNode) {
    super(ownerTree, sourceNode);
  }

  /**
   * Gets the link.
   * 
   * @return the link
   */
  public String getLink() {
    return getMeta("LINK");
  }

  /**
   * Gets the text.
   * 
   * @return the text
   */
  public String getText() {
    return getMeta("TEXT");
  }

  /**
   * Sets the link.
   * 
   * @param link the new link
   */
  public void setLink(final String link) {
    setMeta("LINK", link);
  }

  /**
   * Sets the text.
   * 
   * @param text the new text
   */
  public void setText(final String text) {
    setMeta("TEXT", text);
  }

}
