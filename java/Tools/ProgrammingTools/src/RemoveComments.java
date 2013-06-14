/** GPL >= 3.0
 * Copyright (C) 2006-2010 eIrOcA (eNrIcO Croce & sImOnA Burzio)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/
 */
import java.io.BufferedReader;
import java.io.CharArrayWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;

/**
 * The Class RemoveComments.
 */
public class RemoveComments {

  /** The EXT. */
  public static String EXT = ".java";

  /**
   * The main method.
   * 
   * @param args the arguments
   */
  public static void main(final String[] args) {
    final String pathIn1 = "./in1";
    final String pathIn2 = "./in2";
    final String pathOut = "./out";
    final File f = new File(pathIn1);
    File fin1;
    File fin2;
    File fout1;
    File fout2;
    final String[] files = f.list();
    for (final String path : files) {
      if (!path.endsWith(RemoveComments.EXT)) {
        continue;
      }
      try {
        fin1 = new File(pathIn1 + "/" + path);
        fin2 = new File(pathIn2 + "/" + path);
        fout1 = new File(pathOut + "/" + path.substring(0, path.length() - RemoveComments.EXT.length()) + ".1");
        fout2 = new File(pathOut + "/" + path.substring(0, path.length() - RemoveComments.EXT.length()) + ".2");
        if (fin2.exists()) {
          System.out.println(path);
          fout2.createNewFile();
          RemoveComments.parse(fin2, fout2);
          if (fin1.exists()) {
            fout1.createNewFile();
            RemoveComments.parse(fin1, fout1);
          }
        }
      }
      catch (final Exception e) {
        e.printStackTrace();
      }
    }
  }

  /**
   * Parses the.
   * 
   * @param fin the fin
   * @param fout the fout
   * @throws FileNotFoundException the file not found exception
   */
  public static void parse(final File fin, final File fout) throws FileNotFoundException {
    BufferedReader reader = new BufferedReader(new FileReader(fin));
    final CharArrayWriter writer = new CharArrayWriter();
    // Remove comments
    int curr = 0;
    int prev = 0;
    int status = 0;
    while (true) {
      curr = RemoveComments.read(reader);
      if (curr == -1) {
        break;
      }
      switch (status) {
        case 1: // 'characters'
          writer.write(curr);
          if ((curr == '\'') && (prev != '\\')) {
            status = 0;
          }
          prev = ((prev == '\\') && (curr == '\\')) ? '\0' : curr;
          break;
        case 2: // "string"
          writer.write(curr);
          if ((curr == '\"') && (prev != '\\')) {
            status = 0;
          }
          prev = ((prev == '\\') && (curr == '\\')) ? '\0' : curr;
          break;
        case 3: // /* comment */
          if ((curr == '/') && (prev == '*')) { /* comment ends */
            prev = '\0';
            status = 0;
          }
          else { /* comment text */
            prev = curr;
          }
          break;
        default:
          if (prev == '/') {
            if (curr == '/') { // end of line comment
              writer.write('\n');
              prev = '\0';
              while (RemoveComments.read(reader) != '\n') {
              }
            }
            else if (curr == '*') { /* comment starts */
              prev = '\0';
              status = 3;
            }
            else { // normal code
              writer.write(prev);
              writer.write(curr);
              prev = curr;
            }
          }
          else {
            if (curr != '/') {
              writer.write(curr);
            }
            if (prev != '\\') {
              if (curr == '\'') {
                status = 1;
              }
              else if (curr == '\"') {
                status = 2;
              }
            }
            prev = ((prev == '\\') && (curr == '\\')) ? 0 : curr;
          }
          break;
      }
    }
    try {
      reader.close();
    }
    catch (final IOException e) {
      e.printStackTrace();
    }
    writer.close();
    // Remove empty lines and convert tab in spaces
    reader = new BufferedReader(new StringReader(writer.toString()));
    final PrintWriter writ = new PrintWriter(fout);
    String l;
    while (true) {
      try {
        l = reader.readLine();
      }
      catch (final IOException e) {
        l = null;
      }
      if (l == null) {
        break;
      }
      if (l.trim().length() > 0) {
        final StringBuffer sb = new StringBuffer(l.length());
        for (int i = 0; i < l.length(); i++) {
          final char ch = l.charAt(i);
          if (ch == '\t') {
            sb.append("  ");
          }
          else {
            sb.append(ch);
          }
        }
        writ.println(sb.toString());
      }
    }
    writ.close();
  }

  /**
   * Read.
   * 
   * @param reader the reader
   * @return the int
   */
  public static int read(final BufferedReader reader) {
    try {
      return reader.read();
    }
    catch (final IOException e) {
      return -1;
    }
  }

}
