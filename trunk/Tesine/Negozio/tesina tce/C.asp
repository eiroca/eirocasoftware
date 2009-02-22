<%@ LANGUAGE = JScript  %>
<%
  var title = "Ordine";
%>

<!--#include file="head_nocache.inc"-->
<!--#include file="header.inc"-->

<%
  if (Request("new")>0) {
    Session.Contents.RemoveAll();
  }
  var oConn;	
  var oRs;	
  var curDir;
  
  curDir = Server.MapPath("pasticceria.mdb");
  oConn = Server.CreateObject("ADODB.Connection");
  oConn.Open("Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+curDir);
  oRs = Server.CreateObject("ADODB.Recordset");
  oRs.ActiveConnection = oConn;

  oRs.Source = "SELECT * FROM prodotti";
  oRs.Open();
  var prodotti = new Array();
  var index;
  index = 0;
  
  while (!oRs.eof) { 
    prodotti[index] = "" + oRs("idProdotto");
    index++;
    oRs.MoveNext(); 
  } 
  oRs.Close();
  oConn.Close();
%>

<script language="JavaScript">

function controlla(nam, qta) {
  var res;
  res = true;
  val = parseInt(qta);
  if (""+val == "NaN" ) {
    res = false;
  }
  else if (val<0) {
    res = false;
  }
  if (!res) {
    alert("QTa invalida correggere");
  }
  return res;
}

function invia() {
  var tot = 0;
  var form = window.document.forms[0];
  for (var i=0; i<form.elements.length; i++) {
    if (form.elements[i].type == "text") {
      val = form.elements[i].value;
      ok = controlla(form.elements[i].name, val);
      if (!ok) {
        return;
      }    
      tot = tot + val;
    }
  }
  if (tot<1) {
    alert("Ordine Invalido");
    return;
  }
  document.ordine.submit();
}
</script>

  <form name="ordine" action="D.asp" method="post">
<%
  var i;
  Response.write("<table>");
  for (i=0; i<prodotti.length; i++) {
    idProdotto = prodotti[i];
    if (idProdotto == "1") {
      Response.write("<td>Meringata</td>");
    }
    else if (idProdotto == "2") {
      Response.write("<td>Torta di Mele</td>");
    }
    else if (idProdotto == "3") {
      Response.write("<td>Sacher</td>");
    }
    else if (idProdotto == "5") {
      Response.write("<td>Tiramisu</td>");
    }
    if (Session(idProdotto) == null) {
      Session(idProdotto) = 0;
    }
    Response.write("<td>");
    Response.write("<input type=\"text\"");
    Response.write(" value=\""+Session(idProdotto)+"\"");
    Response.write(" name=\"i_"+idProdotto+"\">");
    Response.write("</td>");
    Response.write("</tr>");
  }
  Response.write("</table>");
%>
    <input type="reset" value="Azzera Campi"/>
    <input type="button" value="Invia" onClick="javascript:invia();"/>
  </form>
<!--#include file="footer.inc"-->
