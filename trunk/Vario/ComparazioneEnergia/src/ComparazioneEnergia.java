import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.List;
import java.util.StringTokenizer;
import net.htmlparser.jericho.Element;
import net.htmlparser.jericho.Source;
import au.com.bytecode.opencsv.CSVReader;
import au.com.bytecode.opencsv.CSVWriter;

public class ComparazioneEnergia {

  private static final String ADDRESS_FILE = "bin/estrazione.csv";

  public static void main(String[] args) throws IOException {

    StringWriter sw = new StringWriter();

    CSVWriter writer = new CSVWriter(sw, '\t', '"');
    CSVReader reader = new CSVReader(new FileReader(ADDRESS_FILE));

    String[] nextLine;
    boolean first = true;
    while ((nextLine = reader.readNext()) != null) {
      String[] line = new String[9];
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
        String name = nextLine[0];
        String what = nextLine[5];
        String sito = nextLine[2];
        StringTokenizer st = new StringTokenizer(name, "\n");
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

  }
}
