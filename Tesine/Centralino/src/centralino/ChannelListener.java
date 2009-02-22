package centralino;

public class ChannelListener extends Thread {

  private final int chan;
  private boolean lineUp;
  private final CentralinoISDN centralino;

  public boolean connected = false;

  public ChannelListener(final CentralinoISDN aCentralino, final int aChan) {
    super();
    chan = aChan;
    centralino = aCentralino;
    lineUp = false;
  }

  public void Run() {
    while (true) {
      if (!lineUp && connected) {
        lineUp = true;
        centralino.incomingCall(chan);
      }
      if (lineUp && !connected) {
        lineUp = false;
        centralino.closingCall(chan);
      }
    }
  }
}
