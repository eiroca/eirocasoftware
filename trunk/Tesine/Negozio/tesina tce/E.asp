<%@ LANGUAGE = JScript  %>
<%
  var title = "Esito Ordine";
%>
<!--#include file="head_nocache.inc"-->
<!--#include file="header.inc"-->
<!--#include file="openscript.inc"-->
<%
  var oConn;	
  var oRs;	
  var curDir;
  var com = new Array();
  
  if (Session("ordine_ok") != 1) {
    Response.Redirect("F.asp?err=1");
  }
  Session("ordine_ok") = 0;
  curDir = Server.MapPath("pasticceria.mdb");
  oConn = Server.CreateObject("ADODB.Connection");
  oConn.Open("Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+curDir);
  oRs = Server.CreateObject("ADODB.Recordset");
  oRs.ActiveConnection = oConn;

  oRs.Source = "SELECT * FROM prodotti";
  oRs.Open();
  var err;
  err = false;
  index = 0;
  while (!oRs.eof) { 
    idProdotto = ""+oRs("idProdotto");
    qta = Session(idProdotto);
    if (qta>0) {
      com[index] = "update prodotti set qtaDisponibile = qtaDisponibile - "+qta+" where idProdotto="+idProdotto;
      Session(idProdotto) = "0";
      index++;
    }
    oRs.MoveNext(); 
  } 
  oRs.Close();
  oConn.Close();
  oConnUpdate = Server.CreateObject("ADODB.Connection");
  oConnUpdate.Provider="Microsoft.Jet.OLEDB.4.0";
  oConnUpdate.Open(curDir);
  oUpdate = Server.CreateObject("ADODB.Command");
  oUpdate.ActiveConnection = oConnUpdate;
  oConnUpdate.BeginTrans;
  for (i=0; i<com.length; i++) {
    oUpdate.commandText = com[i];
    oUpdate.execute();
  }
  oConnUpdate.CommitTrans;
  oConnUpdate.Close();
%>
ORDINE ACCETTATO<br/>
  <form name="finto">
    <input type="button" value="Continua" onClick="javascript:annulla();"/>
  </form>
<!--#include file="footer.inc"-->
