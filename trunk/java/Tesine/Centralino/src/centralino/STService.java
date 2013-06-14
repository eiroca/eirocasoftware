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

public class STService {

  private static int msgNum = 0;

  public static final void Connect(final int line) {
    //
  }

  public static final void Disconnect(final int line) {
    //
  }

  public static final String GetDNIS(final int line) {
    return "275003";
  }

  public static String getInMsg(final int interno) {
    return "msg_" + Integer.toString(interno);
  }

  public static synchronized String getOutMsg(final int interno) {
    // occorre creare un file univoco, non conoscendo il File System
    // creo un nome univoco tramite un contatore, Att! permette di memorizzare
    // solo 1000000 di messaggi univoci.
    STService.msgNum = (STService.msgNum + 1) % 1000000000;
    return Integer.toString(interno) + "_" + Integer.toString(STService.msgNum);
  }

  public static final void Play(final int line, final String outMsg) {
    //
  }

  public static final void Record(final int line, final String inMsg) {
    //
  }

  private STService() {
    //
  }

}