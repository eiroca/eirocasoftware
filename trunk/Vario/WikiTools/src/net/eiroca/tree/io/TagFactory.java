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

import java.util.HashMap;
import java.util.Map;
import net.eiroca.tree.model.TreeReader;

/**
 * A factory for creating Tag objects.
 */
public class TagFactory {

  /** The registry. */
  static Map<String, TagProcessor<TreeReader<?>>> registry = new HashMap<String, TagProcessor<TreeReader<?>>>();

  /**
   * Instantiates a new tag factory.
   */
  private TagFactory() {
    super();
  }

  /**
   * Register.
   * 
   * @param processor the processor
   */
  public static void register(final TagProcessor<TreeReader<?>> processor) {
    TagFactory.registry.put(processor.getName(), processor);
  }

  /**
   * Gets the processor.
   * 
   * @param tagName the tag name
   * 
   * @return the processor
   */
  public static TagProcessor<TreeReader<?>> getProcessor(final String tagName) {
    return TagFactory.registry.get(tagName);
  }

}
