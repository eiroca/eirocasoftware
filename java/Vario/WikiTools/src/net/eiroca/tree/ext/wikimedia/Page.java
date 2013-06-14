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

import net.eiroca.tree.model.Tree;
import net.eiroca.tree.model.TreeNode;

/**
 * The Class Page.
 */
public class Page extends Tree<Line> {

  /*
   * (non-Javadoc)
   * @see net.eiroca.tree.model.Tree#newNode(int, net.eiroca.tree.model.TreeNode)
   */
  @Override
  public Line newNode(final int level, final TreeNode source) {
    return new Line(this, source);
  }

}
