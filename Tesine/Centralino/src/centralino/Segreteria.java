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