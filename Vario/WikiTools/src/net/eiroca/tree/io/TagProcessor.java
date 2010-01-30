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

import net.eiroca.tree.model.TreeReader;
import org.xml.sax.Attributes;

/**
 * The Interface TagProcessor.
 */
public interface TagProcessor<TR extends TreeReader<?>> {

  /**
   * Gets the name.
   * 
   * @return the name
   */
  String getName();

  /**
   * Start.
   * 
   * @param reader the reader
   * @param attribs the attribs
   */
  void start(TR reader, Attributes attribs);

  /**
   * Characters.
   * 
   * @param reader the reader
   * @param chr the chr
   * @param start the start
   * @param length the length
   */
  void characters(TR reader, final char[] chr, final int start, final int length);

  /**
   * End.
   * 
   * @param reader the reader
   */
  void end(TR reader);

}
