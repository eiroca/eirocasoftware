/**
 * Copyright (C) 1998-2010 eIrOcA (eNrIcO Croce & sImOnA Burzio)
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
package centralino;

public class Segreteria extends Thread {

  private final int line;
  private int interno;

  public Segreteria(final int aLine) {
    super();
    line = aLine;
  }

  public void Run() {
    STService.Connect(line);
    final String numero = STService.GetDNIS(line);
    try {
      interno = (new ISDNNumber(numero, "")).getInterno();
    }
    catch (final Exception e) {
      interno = 0;
    }
    if (interno != 0) {
      STService.Play(line, STService.getOutMsg(interno));
      STService.Record(line, STService.getInMsg(interno));
    }
    STService.Disconnect(line);
  }

}