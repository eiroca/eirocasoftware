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
import java.io.FileReader;
import java.io.IOException;
import java.io.StringWriter;
import java.net.URLEncoder;
import java.util.StringTokenizer;
import au.com.bytecode.opencsv.CSVReader;
import au.com.bytecode.opencsv.CSVWriter;

public class ComparazioneEnergia {

  private static final String ADDRESS_FILE = "bin/estrazione.csv";

  public static void main(final String[] args) throws IOException {

    final StringWriter sw = new StringWriter();

    final CSVWriter writer = new CSVWriter(sw, '\t', '"');
    final CSVReader reader = new CSVReader(new FileReader(ComparazioneEnergia.ADDRESS_FILE));
    String[] nextLine;
    boolean first = true;
    while ((nextLine = reader.readNext()) != null) {
      final String[] line = new String[9];
      if (first) {
        first = false;
        line[0] = "Name";
        line[1] = "Sito";
        line[2] = "Verificabile";
        line[3] = "Produttore";
        line[4] = "Energia";
        line[5] = "GAS";

      }
      else {
        final String name = nextLine[0];
        final String what = nextLine[5];
        final String sito = nextLine[2];
        final StringTokenizer st = new StringTokenizer(name, "\n");
        line[0] = st.nextToken();
        if (sito.equals("")) {
          line[1] = "";
          line[2] = "N";
          line[6] = "";
          line[7] = "";
          line[8] = "";
        }
        else {
          line[1] = "http://" + sito;
          line[2] = "Y";
          line[6] = "http://www.google.com/search?hl=it&safe=off&q=" + URLEncoder.encode("RECS site:" + sito, "UTF-8") + "&btnG=Cerca&meta=&aq=f&oq=";
          line[7] = "http://www.google.com/search?hl=it&safe=off&q=" + URLEncoder.encode("nucleare site:" + sito, "UTF-8") + "&btnG=Cerca&meta=&aq=f&oq=";
          line[8] = "http://www.google.com/search?hl=it&safe=off&q=" + URLEncoder.encode("termovalizzatore site:" + sito, "UTF-8") + "&btnG=Cerca&meta=&aq=f&oq=";
        }
        line[3] = what.contains(" produzione dell'energia elettrica") ? "Y" : "N";
        line[4] = what.contains(" vendita a clienti") ? "Y" : "N";
        line[5] = what.contains(" vendita a clienti finali del gas naturale") ? "Y" : "N";
      }
      writer.writeNext(line);
    }
    System.out.println("\n\nGenerated CSV File:\n\n");
    System.out.println(sw.toString());
    writer.close();
    reader.close();
  }
}
