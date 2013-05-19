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

import java.net.URL;
import java.util.Stack;
import net.eiroca.tree.io.TagProcessor;
import net.eiroca.tree.io.XMLHandler;

/**
 * The Class MMReader.
 */
public class MMReader extends XMLHandler<Map> {

  /** The tag. */
  public final TagProcessor<MMReader> tag = MMUtil.MAP;

  /** The parent nodes. */
  public final Stack<Node> parentNodes = new Stack<Node>();

  /** The root node. */
  public Node rootNode;

  /** The new node. */
  public Node newNode;

  /*
   * (non-Javadoc)
   *
   * @see net.eiroca.node.io.XMLHandler#readTree(java.net.URL)
   */
  @Override
  public Map readTree(final URL path) {
    parentNodes.clear();
    rootNode = null;
    newNode = null;
    return super.readTree(path);
  }

}
