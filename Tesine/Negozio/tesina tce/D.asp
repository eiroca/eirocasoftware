<%@ LANGUAGE = JScript  %>
<%
  var title = "Conferma ordine";
%>
<!--#include file="head_nocache.inc"-->
<!--#include file="header.inc"-->
<!--#include file="openscript.inc"-->
Riepilogo ordine<br/>
<%
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
  var totale;
  totale = 0;
  Response.write("<table>");
  while (!oRs.eof) { 
    idProdotto = ""+oRs("idProdotto");
    qtaMax = oRs("qtaDisponibile");
    qta = parseInt(Request.Form("i_"+idProdotto));
    prz = oRs("prezzoUnitario");
    if (qta>0) {
      Session(idProdotto) = ""+qta;
      Response.write("<tr>");
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
      Response.write("<td class=\"RIGHT\">"+qta+"</td>");
      Response.write("<td class=\"RIGHT\">"+prz+"EUR</td>");
      Response.write("<td class=\"RIGHT\">"+qta*prz+"EUR</td>");
      totale += qta*prz;
      Response.write("</tr>");
    }
    else {
      Session(idProdotto) = 0;
    }
    oRs.MoveNext(); 
  } 
  if (totale>0) {
    Response.write("<tr>");
    Response.write("<td colspan=\"3\">TOTALE</td>");
    Response.write("<td class=\"RIGHT\">"+totale+"EUR</td>");
    Response.write("</tr>");
    Response.write("</table>");
%>
  <form name="finto">
    <input type="button" value="Conferma" onClick="javascript:conferma();"/>
<%  
  }
  else {
%>  
    </table>
    Ordine non valido
    <form name="finto">
<%
  }
  oRs.Close();
  oConn.Close();
%>
    <input type="button" value="Annulla" onClick="javascript:annulla();"/>
  </form>

<!--#include file="footer.inc"-->
