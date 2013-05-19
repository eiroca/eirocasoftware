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
import java.io.File;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import net.eiroca.tree.ext.freemind.MMReader;
import net.eiroca.tree.ext.freemind.Map;
import net.eiroca.tree.ext.wikimedia.Page;
import net.eiroca.tree.ext.wikimedia.WikiWriter;

/**
 * The Class MM2Wiki.
 */
public class MM2Wiki {

  /**
   * The main method.
   * 
   * @param args the arguments
   */
  public static void main(final String[] args) {
    final MMReader reader = new MMReader();
    final WikiWriter writer = new WikiWriter(2, 1);
    final SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
    final String pathIn = "./in";
    final String pathOut = "./out";
    final File f = new File(pathIn);
    File fin;
    File fout;
    String xml;
    final String[] files = f.list();
    for (final String path : files) {
      if (!path.endsWith(".mm")) {
        continue;
      }
      System.out.println(path);
      try {
        fin = new File(pathIn + "/" + path);
        fout = new File(pathOut + "/" + path.substring(0, path.length() - 3));
        Map nodeMap;
        nodeMap = reader.readTree(fin.toURI().toURL());
        final Page out = new Page();
        out.importFrom(nodeMap);
        xml = writer.writeTree(out, false);
        fout.createNewFile();
        final Date d = new Date(fin.lastModified());
        final PrintWriter pw = new PrintWriter(fout);
        pw.println("<mm>[[" + path + "]]</mm>");
        pw.println(xml);
        pw.println("<br>Automatic generated from " + path + " dated " + df.format(d));
        pw.close();
      }
      catch (final Exception e) {
        e.printStackTrace();
        // System.out.println(e.toString());
      }
    }
  }

}