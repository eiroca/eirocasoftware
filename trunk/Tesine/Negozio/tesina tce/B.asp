 <%@ LANGUAGE = JScript  %>
<%
  var title = "Prodotti";
%>
<!--#include file="head_cache.inc"-->
<!--#include file="header.inc"-->
<%
  function disponibile(qta) {
    if (qta > 0) {
      Response.write("<td>");
      Response.write("disponibile");
    }
    else {
      Response.write("non disponibile");
    }
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
  Response.write("<table>");
  while (!oRs.eof) { 
    Response.write("<tr>");
    if (oRs("nomeProdotto") == "meringata") {
      Response.write("<td>Meringata</td><td>Descrizione meringata</td>");
      Response.write("<td>");
      disponibile(oRs("qtaDisponibile"));
      Response.write("</td>");
    }
    else if (oRs("nomeProdotto") == "torta di mele") {
      Response.write("<td>torta di mele</td><td>Descrizione torta di mele</td>");
      Response.write("<td>");
      disponibile(oRs("qtaDisponibile"));
      Response.write("</td>");
    }
    else if (oRs("nomeProdotto") == "sacher") {
      Response.write("<td>sacher</td><td>Descrizione sacher</td>");
      Response.write("<td>");
      disponibile(oRs("qtaDisponibile"));
      Response.write("</td>");
    }
    else if (oRs("nomeProdotto") == "tiramisu") {
      Response.write("<td>tiramisu</td><td>Descrizione tiramisu</td>");
      Response.write("<td>");
      disponibile(oRs("qtaDisponibile"));
      Response.write("</td>");
    }
    Response.write("</tr>");
    oRs.MoveNext(); 
  } 
  Response.write("</table>");
  oRs.Close();
  oConn.Close();
%>
<!--#include file="footer.inc"-->
