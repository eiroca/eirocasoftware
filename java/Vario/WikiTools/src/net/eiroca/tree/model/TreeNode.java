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
package net.eiroca.tree.model;

import java.util.Map;

/**
 * The Interface TreeNode.
 */
public interface TreeNode extends MetaDataCollector {

  /**
   * Adds the child.
   * 
   * @param child the child
   */
  void addChild(TreeNode child);

  /**
   * Builds the id.
   * 
   * @param prefix the prefix
   * @param pos the pos
   */
  void buildID(final String prefix, final int pos);

  /**
   * Execute.
   * 
   * @param action the action
   * @param nodeFirst the node first
   */
  void execute(final NodeTraversal action, final boolean nodeFirst);

  /**
   * Find by id.
   * 
   * @param aID the a id
   * @param exact the exact
   * 
   * @return the tree node
   */
  TreeNode findByID(final String aID, final boolean exact);

  /**
   * Gets the children.
   * 
   * @param index the index
   * 
   * @return the children
   */
  TreeNode getChildren(int index);

  /**
   * Gets the children count.
   * 
   * @return the children count
   */
  int getChildrenCount();

  /**
   * Gets the iD.
   * 
   * @return the iD
   */
  String getID();

  /**
   * Gets the meta.
   * 
   * @return the meta
   */
  Map<String, String> getMeta();

  /**
   * Gets the owner.
   * 
   * @return the owner
   */
  Tree<? extends TreeNode> getOwner();

  /**
   * Gets the parent.
   * 
   * @return the parent
   */
  TreeNode getParent();

  /**
   * Checks for children.
   * 
   * @return true, if successful
   */
  boolean hasChildren();

  /**
   * Removes the id.
   */
  void removeID();

  /**
   * Sets the iD.
   * 
   * @param aID the new iD
   */
  void setID(final String aID);

  /**
   * Sets the parent.
   * 
   * @param parent the new parent
   */
  void setParent(TreeNode parent);

}
