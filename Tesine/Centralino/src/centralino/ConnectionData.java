package centralino;

public class ConnectionData {

  public int chan;
  public int line;
  public int interno;
  public Segreteria segr;

  public ConnectionData(final int aChan, final int aLine, final int aInterno) {
    chan = aChan;
    line = aLine;
    interno = aInterno;
    segr = null;
  }
}