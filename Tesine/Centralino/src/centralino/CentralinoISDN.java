package centralino;

import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.Vector;

public class CentralinoISDN {

  // simbolo speciale per indicare tutte le linee occupate
  private static final int LINES_BUSY = -1;
  // simbolo speciale per indicare la segreteria
  private static final int USER_ST = -1;
  // per comondita uso una costante, ma l'allocazione e' cmq dinamica
  private static final int MAX_UTENTI = 1000;

  // la segreteria risponde al posto degli utenti
  private final boolean forceSegreteria = true;

  // numero del centralino ad esempio "275"
  String numero;
  // numero massimo di linee interne
  int maxLines;
  // vettore che indica quali numeri corrispondono a utenti e quali numeri sono inutilizzati
  boolean validNumber[];
  // vettore che indica quali numeri sono possono prendere una comunicazione
  boolean busyNumber[];
  // vettore che tiene traccia delle connessioni
  ConnectionData connections[];
  // Array che contiene i threads che ascoltano le linee di ingresso
  Vector channels;
  // File su cui si scrivono i numeri chiamati
  PrintWriter logFile = null;

  public CentralinoISDN(final int numChannels, final int aMaxConnections, final String aNumero) {
    numero = aNumero;
    maxLines = aMaxConnections;
    try {
      logFile = new PrintWriter(new FileWriter("ISDNLog.txt"));
    }
    catch (final Exception e) {
      logFile = null;
    }
    setupNumbers();
    setupLines();
    setupChannels(numChannels);
    startChannels();
  }

  public void setupNumbers() {
    int i;
    validNumber = new boolean[CentralinoISDN.MAX_UTENTI];
    busyNumber = new boolean[CentralinoISDN.MAX_UTENTI];
    for (i = 0; i < CentralinoISDN.MAX_UTENTI; i++) {
      validNumber[i] = true;
      busyNumber[i] = false;
    }
  }

  public void setupLines() {
    connections = new ConnectionData[maxLines];
    for (int i = 0; i < maxLines; i++) {
      connections[i] = null;
    }
  }

  public void setupChannels(final int numChannels) {
    channels = new Vector(numChannels);
    for (int i = 0; i < numChannels; i++) {
      channels.addElement(new ChannelListener(this, i + 1));
    }
  }

  public void startChannels() {
    // Inizia ad ascoltare le linee
    for (int i = 0; i < channels.size(); i++) {
      ((Thread) channels.elementAt(i)).start();
    }
  }

  public void stopChannels() {
    // Termina di ascoltare le linee
    for (int i = 0; i < channels.size(); i++) {
      ((Thread) channels.elementAt(i)).stop();
    }
  }

  public synchronized boolean isBusy(final int interno) {
    return busyNumber[interno - 1];
  }

  public synchronized void unlockInterno(final int interno) {
    busyNumber[interno - 1] = false;
  }

  public synchronized boolean lockInterno(final int interno) {
    boolean busy = busyNumber[interno - 1];
    if (!busy) {
      busyNumber[interno - 1] = true;
    }
    return !busy;
  }

  public synchronized int lockLine(final int chan, final int interno) {
    for (int i = 0; i < maxLines; i++) {
      if (connections[i] == null) {
        connections[i] = new ConnectionData(chan, i, interno);
        return i + 1;
      }
    }
    return CentralinoISDN.LINES_BUSY;
  }

  public synchronized void unlockLine(final int line) {
    connections[line - 1] = null;
  }

  public synchronized void closingCall(final int aChan) {
    for (int line = 0; line < maxLines; line++) {
      if (connections[line].chan == aChan) {
        if (connections[line].interno != CentralinoISDN.USER_ST) {
          unlockInterno(connections[line].interno);
        }
        else {
          if (connections[line] != null) {
            connections[line].segr.stop();
            connections[line].segr = null;
          }
        }
        unlockLine(line + 1);
        break;
      }
    }
    ISDNService.HangUp(aChan);
  }

  public synchronized void startSegreteria(final int aChan, final int line) {
    final Segreteria segr = new Segreteria(line);
    connections[line - 1].interno = CentralinoISDN.USER_ST;
    connections[line - 1].segr = segr;
    ISDNService.Answer(aChan); // risponde
    ISDNService.Route(aChan, line); // inoltra la chiamata
    segr.start();
  }

  public synchronized void incomingCall(final int aChan) {
    String msg = "";
    // Suppongo che sia possibile sapere il numero chiamato
    // anche senza alzare la cornetta
    final String num = ISDNService.GetDNIS(aChan);
    int line;
    try {
      final ISDNNumber numeroChiamato = new ISDNNumber(num, numero);
      final int interno = numeroChiamato.getInterno();
      if (validNumber[interno - 1]) { // l'interno esiste
        if (lockInterno(interno)) { // se l'utente puo' ricevere la telefonata
          // mette in comunicazione con l'utente
          if ((line = lockLine(aChan, interno)) != CentralinoISDN.LINES_BUSY) {
            if (forceSegreteria) {
              unlockInterno(interno);
              startSegreteria(aChan, line);
              msg = num + " inoltrato verso la segreteria";
            }
            else {
              ISDNService.Answer(aChan); // risponde
              ISDNService.Route(aChan, line); // inoltra la chiamata
              msg = num + " inoltrato verso l'interno richiesto";
            }
          }
          else { // se non era possibile creare una connessione segnala occupato
            ISDNService.SendBusy(aChan);
            unlockInterno(interno);
            msg = "tutte le linee occupate per gestire " + num;
          }
        }
        else { // se l'utente NON puo' ricevere la telefonata
          if ((line = lockLine(aChan, interno)) != CentralinoISDN.LINES_BUSY) {
            startSegreteria(aChan, line);
            msg = num + " inoltrato verso la segreteria (utente occupato)";
          }
          else {
            ISDNService.SendBusy(aChan);
            msg = "tutte le linee occupate per gestire " + num;
          }
        }
      }
      else {
        ISDNService.SendBusy(aChan);
        msg = "Il numero " + num + " non e' connesso a nessun utente";
      }
    }
    catch (final Exception e) {
      msg = "Numero chiamato inesistente " + num;
    }
    ;
    Log(msg);
  }

  public synchronized void Log(final String msg) {
    if (logFile != null) {
      logFile.println(msg);
      logFile.flush();
    }
  }
}
