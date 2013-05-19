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

/**
 * The Class Utils.
 */
public final class Utils {

  /**
   * Read int.
   * 
   * @param val the val
   * @param def the def
   * 
   * @return the int
   */
  public static int readInt(final String val, final int def) {
    int res = def;
    if (val != null) {
      try {
        res = Integer.parseInt(val);
      }
      catch (final NumberFormatException e) {
        System.err.println(e.toString());
      }
    }
    return res;
  }

}
