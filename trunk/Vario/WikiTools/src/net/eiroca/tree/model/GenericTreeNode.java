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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * The Class TreeNode.
 */
public class GenericTreeNode<T extends TreeNode> implements TreeNode, Iterable<T> {

  /** The node id. */
  protected String nodeID;

  /** The parent. */
  protected T parent;

  /** The owner. */
  protected Tree<T> owner;

  /** The children. */
  protected final List<T> children = new ArrayList<T>();

  /** The meta. */
  protected final Map<String, String> meta = new HashMap<String, String>();

  /**
   * Instantiates a new tree node.
   * 
   * @param owner the owner
   */
  public GenericTreeNode(final Tree<T> owner) {
    this.owner = owner;
  }

  /**
   * Instantiates a new tree node.
   * 
   * @param ownerTree the owner tree
   * @param sourceNode the source node
   */
  public GenericTreeNode(final Tree<T> ownerTree, final TreeNode sourceNode) {
    owner = ownerTree;
    if (sourceNode != null) {
      nodeID = sourceNode.getID();
      meta.putAll(sourceNode.getMeta());
    }
  }

  /**
   * Gets the parent.
   * 
   * @return the parent
   */
  public T getParent() {
    return parent;
  }

  /**
   * Gets the owner.
   * 
   * @return the owner
   */
  public Tree<T> getOwner() {
    return owner;
  }

  /* (non-Javadoc)
   * @see net.eiroca.tree.model.TreeNode#addChild(net.eiroca.tree.model.TreeNode)
   */
  @SuppressWarnings("unchecked")
  public void addChild(final TreeNode child) {
    final T aChild = (T) child;
    children.add(aChild);
    child.setParent(this);
  }

  /*
   * (non-Javadoc)
   *
   * @see java.lang.Iterable#iterator()
   */
  public Iterator<T> iterator() {
    return children.iterator();
  }

  /**
   * Checks for children.
   * 
   * @return true, if successful
   */
  public boolean hasChildren() {
    return !children.isEmpty();
  }

  /* (non-Javadoc)
   * @see net.eiroca.tree.model.TreeNode#getChildren(int)
   */
  public T getChildren(final int index) {
    return children.get(index);
  }

  /**
   * Gets the children count.
   * 
   * @return the children count
   */
  public int getChildrenCount() {
    return children.size();
  }

  /**
   * Sets the parent.
   * 
   * @param parent the new parent
   */
  @SuppressWarnings("unchecked")
  public void setParent(final TreeNode parent) {
    this.parent = (T) parent;
  }

  /*
   * (non-Javadoc)
   *
   * @see net.eiroca.node.model.MetaDataCollector#setMeta(java.lang.String,
   *      java.lang.String)
   */
  public void setMeta(final String name, final String val) {
    if (val == null) {
      meta.remove(name);
    }
    else {
      meta.put(name, val);
    }
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
   * Gets the iD.
   * 
   * @return the iD
   */
  public String getID() {
    return nodeID;
  }

  /**
   * Sets the iD.
   * 
   * @param aID the new iD
   */
  public void setID(final String aID) {
    nodeID = aID;
  }

  /**
   * Find by id.
   * 
   * @param aID the a id
   * @param exact the exact
   * 
   * @return the tree node
   */
  public TreeNode findByID(final String aID, final boolean exact) {
    TreeNode res = (exact ? null : this);
    if (aID.equals(getID())) {
      res = this;
    }
    else if (hasChildren()) {
      String uID;
      for (final TreeNode node : this) {
        uID = node.getID();
        if ((uID != null) && (aID.startsWith(uID))) {
          res = node.findByID(aID, exact);
          break;
        }
      }
    }
    return res;
  }

  /**
   * Removes the id.
   */
  public void removeID() {
    setID(null);
    for (final TreeNode u : this) {
      u.removeID();
    }
  }

  /**
   * Builds the id.
   * 
   * @param prefix the prefix
   * @param pos the pos
   */
  public void buildID(final String prefix, final int pos) {
    final String myId = prefix + Integer.toString(pos, Character.MAX_RADIX);
    setID(myId);
    int cnt = 0;
    for (final TreeNode u : this) {
      cnt++;
      u.buildID(myId + ".", cnt);
    }
  }

  /**
   * Execute.
   * 
   * @param action the action
   * @param nodeFirst the node first
   */
  public void execute(final NodeTraversal action, final boolean nodeFirst) {
    if (nodeFirst) {
      action.process(this);
    }
    for (final TreeNode u : this) {
      u.execute(action, nodeFirst);
    }
    if (!nodeFirst) {
      action.process(this);
    }
  }

}
