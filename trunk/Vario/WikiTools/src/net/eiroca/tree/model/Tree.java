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

import java.util.HashMap;
import java.util.Map;

/**
 * The Class Tree.
 */
public abstract class Tree<TN extends TreeNode> implements MetaDataCollector {

  /** The root. */
  protected TN root;

  /** The meta. */
  protected final Map<String, String> meta = new HashMap<String, String>();

  /**
   * Instantiates a new tree.
   */
  public Tree() {
    //
  }

  /*
   * (non-Javadoc)
   *
   * @see net.eiroca.node.model.MetaDataCollector#setMeta(java.lang.String,
   *      java.lang.String)
   */
  public void setMeta(final String name, final String value) {
    meta.put(name, value);
  }

  /*
   * (non-Javadoc)
   *
   * @see net.eiroca.node.model.MetaDataCollector#getMeta(java.lang.String)
   */
  public String getMeta(final String name) {
    return meta.get(name);
  }

  /**
   * Gets the meta.
   * 
   * @return the meta
   */
  public Map<String, String> getMeta() {
    return meta;
  }

  /**
   * Gets the root.
   * 
   * @return the root
   */
  public TN getRoot() {
    return root;
  }

  /**
   * Sets the root.
   * 
   * @param root the new root
   */
  public void setRoot(final TN root) {
    this.root = root;
  }

  /**
   * Find by id.
   * 
   * @param theID the the id
   * @param exact the exact
   * 
   * @return the tree node
   */
  @SuppressWarnings("unchecked")
  public TN findByID(final String theID, final boolean exact) {
    final TN node = (TN) root.findByID(theID, exact);
    return (node == null ? root : node);
  }

  /**
   * Removes the id.
   */
  public void removeID() {
    root.removeID();
  }

  /**
   * Buid id.
   */
  public void buidID() {
    root.buildID("", 0);
  }

  /**
   * Execute.
   * 
   * @param action the action
   * @param nodeFirst the node first
   */
  public void execute(final NodeTraversal action, final boolean nodeFirst) {
    root.execute(action, nodeFirst);
  }

  /**
   * Clone childs.
   * 
   * @param level the level
   * @param parent the parent
   * @param srcNode the src node
   */
  protected void cloneChilds(int level, final TreeNode parent, final TreeNode srcNode) {
    level++;
    for (int i = 0; i < srcNode.getChildrenCount(); i++) {
      final TreeNode child = srcNode.getChildren(i);
      final TN newChild = newNode(level, child);
      parent.addChild(newChild);
      if (child.hasChildren()) {
        cloneChilds(level, newChild, child);
      }
    }
  }

  /**
   * Import from.
   * 
   * @param source the source
   */
  public void importFrom(final Tree<? extends TreeNode> source) {
    root = null;
    if (source.getRoot() != null) {
      final TreeNode srcRoot = source.getRoot();
      final TN dstRoot = newNode(0, srcRoot);
      root = dstRoot;
      if (srcRoot.hasChildren()) {
        cloneChilds(0, dstRoot, srcRoot);
      }
    }
  }

  /**
   * New node.
   * 
   * @param level the level
   * @param source the source
   * 
   * @return the tN
   */
  abstract public TN newNode(int level, TreeNode source);

}
