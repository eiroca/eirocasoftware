<%@ LANGUAGE = JScript  %>
<%
  if (Session("ordine_ko")==1) {
    Session.Contents.RemoveAll();
    Response.Redirect("A.asp");
  }
  if ((parseInt(Request("err"))>0) || (Session("ordine_ok")==1)) {
%>
  <form name="finto">
<%
  }
  else {
    var oConn;	
    var oRs;	
    var curDir;
    var errs = new Array();
  
    curDir = Server.MapPath("pasticceria.mdb");
    oConn = Server.CreateObject("ADODB.Connection");
    oConn.Open("Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+curDir);
    oRs = Server.CreateObject("ADODB.Recordset");
    oRs.ActiveConnection = oConn;

    oRs.Source = "SELECT * FROM prodotti";
    oRs.Open();
    var err;
    err = false;
    var i = 0;
    while (!oRs.eof) { 
      idProdotto = ""+oRs("idProdotto");
      qtaMax = oRs("qtaDisponibile");
      qta = Session(idProdotto);
      if (qta>0) {
        if (qta>qtaMax) {
          Session(idProdotto) = ""+qtaMax;
          err= true;
          if (qtaMax==0) {
            errs[i++] = "Il prodotto "+oRs("nomeProdotto")+" non è momentaneamente disponibile (Richiesti "+qta+").";
          }
          else if (qtaMax==1) {
            errs[i++] = "Il prodotto "+oRs("nomeProdotto")+" è disponibile solo in un pezzo (Richiesti "+qta+").";
          }
          else {
            errs[i++] = "Il prodotto "+oRs("nomeProdotto")+" è disponibile solo in "+qtaMax+" pezzi (Richiesti "+qta+").";
          }
          
        }
      }
      oRs.MoveNext(); 
    } 
    oRs.Close();
    oConn.Close();
    if (!err) {
      Session("ordine_ok")=1;
      Response.Redirect("E.asp");
    }
    else {
      Session("ordine_ko")=1;
    }
  }
%>
<%
  var title = "Esito Ordine";
%>
<!--#include file="head_nocache.inc"-->
<!--#include file="header.inc"-->
<!--#include file="openscript.inc"-->
Ordine non accettabile.<br/>
<%
  if (errs!=null) {
    for (var i=0; i<errs.length; i++) {
      Response.write(errs[i]+"<br/>");
    }
%>
  <form name="finto">
    <input type="button" value="Modifica Ordine" onClick="javascript:ordine();"/>
<%
  }
%>

    <input type="button" value="Continua" onClick="javascript:annulla();"/>
  </form>
<!--#include file="footer.inc"-->
