package centralino;

public class STService {

  private static int msgNum = 0;

  public static synchronized String getOutMsg(final int interno) {
    // occorre creare un file univoco, non conoscendo il File System
    // creo un nome univoco tramite un contatore, Att! permette di memorizzare
    // solo 1000000 di messaggi univoci.
    STService.msgNum = (STService.msgNum + 1) % 1000000000;
    return Integer.toString(interno) + "_" + Integer.toString(STService.msgNum);
  }

  public static String getInMsg(final int interno) {
    return "msg_" + Integer.toString(interno);
  }

  public static final void Connect(final int line) {
    //
  }

  public static final String GetDNIS(final int line) {
    return "275003";
  }

  public static final void Play(final int line, final String outMsg) {
    //
  }

  public static final void Record(final int line, final String inMsg) {
    //
  }

  public static final void Disconnect(final int line) {
    //
  }

  private STService() {
    //
  }

}