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