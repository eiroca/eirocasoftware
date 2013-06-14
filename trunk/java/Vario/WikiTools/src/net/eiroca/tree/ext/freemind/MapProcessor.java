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

import net.eiroca.tree.io.TAGMeta;
import net.eiroca.tree.model.Tree;
import org.xml.sax.Attributes;

/**
 * The Class MapProcessor.
 */
public class MapProcessor extends TAGMeta<MMReader> {

  /**
   * Instantiates a new map processor.
   */
  public MapProcessor() {
    super("map");
  }

  /*
   * (non-Javadoc)
   * @see net.eiroca.node.io.TAG#end(net.eiroca.node.io.TreeReader)
   */
  @Override
  public void end(final MMReader reader) {
    final Tree<Node> tree = reader.getTree();
    tree.setRoot(reader.rootNode);
  }

  /*
   * (non-Javadoc)
   * @see net.eiroca.node.io.TAG#start(net.eiroca.node.io.TreeReader, org.xml.sax.Attributes)
   */
  @Override
  public void start(final MMReader reader, final Attributes attribs) {
    final Map tree = new Map();
    reader.setTree(tree);
    readMeta(tree, attribs);
  }

}
