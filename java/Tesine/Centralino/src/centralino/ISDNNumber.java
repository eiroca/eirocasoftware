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

public class ISDNNumber {

  private static final int CIFRE_UTENTI = 3;

  private String prefisso;
  private final int interno;

  public ISDNNumber(final String numero, final String numeroCentralino) throws Exception {
    if (numero.length() < ISDNNumber.CIFRE_UTENTI) { throw new Exception("Formato numero di telefono errato"); }
    int l = numero.length();
    l = (l < 3 ? l : 3);
    interno = Integer.parseInt(numero.substring(numero.length() - l + 1));
    if (numero.length() > ISDNNumber.CIFRE_UTENTI + numeroCentralino.length()) {
      prefisso = numero.substring(1, numero.length() - ISDNNumber.CIFRE_UTENTI - numeroCentralino.length());
    }
    else {
      prefisso = "";
    }
  }

  public int getInterno() {
    return interno;
  }

  public String getPrefisso() {
    return prefisso;
  }

}