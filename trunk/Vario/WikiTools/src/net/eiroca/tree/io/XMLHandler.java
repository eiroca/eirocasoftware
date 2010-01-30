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
package net.eiroca.tree.io;

import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Stack;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import net.eiroca.tree.model.Tree;
import net.eiroca.tree.model.TreeReader;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 * The Class XMLHandler.
 */
public class XMLHandler<TR extends Tree<?>> extends DefaultHandler implements TreeReader<TR> {

  /** The tree. */
  public TR tree;

  /** The data. */
  public Map<String, String> data = new HashMap<String, String>();

  /** The procs. */
  public Stack<TagProcessor<TreeReader<?>>> procs = new Stack<TagProcessor<TreeReader<?>>>();

  /*
   * (non-Javadoc)
   *
   * @see net.eiroca.node.io.NodeMapReader#getNodeMap()
   */
  public TR getTree() {
    return tree;
  }

  /*
   * (non-Javadoc)
   *
   * @see net.eiroca.node.io.NodeMapReader#setNodeMap(net.eiroca.node.model.NodeMap)
   */
  public void setTree(final TR tree) {
    this.tree = tree;
  }

  /*
   * (non-Javadoc)
   *
   * @see net.eiroca.node.io.NodeMapReader#getData()
   */
  public Map<String, String> getData() {
    return data;
  }

  /*
   * (non-Javadoc)
   *
   * @see org.xml.sax.helpers.DefaultHandler#startElement(java.lang.String,
   *      java.lang.String, java.lang.String, org.xml.sax.Attributes)
   */
  @Override
  public void startElement(final String uri, final String localName, final String qName, final Attributes attribs) throws SAXException {
    final TagProcessor<TreeReader<?>> processor = TagFactory.getProcessor(qName);
    if (processor != null) {
      processor.start(this, attribs);
    }
    procs.push(processor);
  }

  /*
   * (non-Javadoc)
   *
   * @see org.xml.sax.helpers.DefaultHandler#endElement(java.lang.String,
   *      java.lang.String, java.lang.String)
   */
  @Override
  public void endElement(final String uri, final String localName, final String qName) throws SAXException {
    procs.pop();
    final TagProcessor<TreeReader<?>> processor = TagFactory.getProcessor(qName);
    if (processor != null) {
      processor.end(this);
    }
  }

  /*
   * (non-Javadoc)
   *
   * @see org.xml.sax.helpers.DefaultHandler#characters(char[], int, int)
   */
  @Override
  public void characters(final char[] chr, final int start, final int length) throws SAXException {
    final TagProcessor<TreeReader<?>> processor = procs.peek();
    if (processor != null) {
      processor.characters(this, chr, start, length);
    }
  }

  /*
   * (non-Javadoc)
   *
   * @see net.eiroca.node.io.NodeMapReader#readNodeMap(java.net.URL)
   */
  public TR readTree(final URL path) {
    tree = null;
    data.clear();
    procs.clear();
    try {
      final SAXParserFactory parserFactory = SAXParserFactory.newInstance();
      final SAXParser parser = parserFactory.newSAXParser();
      parser.parse(new InputSource(path.openStream()), this);
    }
    catch (final IOException e) {
      e.printStackTrace();
    }
    catch (final ParserConfigurationException e) {
      e.printStackTrace();
    }
    catch (final SAXException e) {
      e.printStackTrace();
    }
    return tree;
  }

}
