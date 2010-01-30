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

import net.eiroca.tree.model.GenericTreeNode;
import net.eiroca.tree.model.Tree;
import net.eiroca.tree.model.TreeNode;

/**
 * The Class Node.
 */
public class Node extends GenericTreeNode<Node> {

  /**
   * Instantiates a new node.
   * 
   * @param owner the owner
   */
  public Node(final Tree<Node> owner) {
    super(owner);
  }

  /**
   * Instantiates a new node.
   * 
   * @param ownerTree the owner tree
   * @param sourceNode the source node
   */
  public Node(final Tree<Node> ownerTree, final TreeNode sourceNode) {
    super(ownerTree, sourceNode);
  }

}
