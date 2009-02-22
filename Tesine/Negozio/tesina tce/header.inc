  <body>
    <table class="PAGE">
      <tr class="TOP">
        <td class="TOP_HOME">
          <a href="A.asp"><img src="./res/sitebanner.gif" alt="Pasticceria B. Jones" /></a>
        </td>
        <td class="TOP_TITLE" colspan="2">Che pasticcera B. Jones!
<%
  if (title!=null) {
    Response.write(" - "+title);
  }
%>        
        </td>
      </tr>
      <tr>
        <td class="MENU" rowspan="2" align="left" valign="top">
          <table class="MENU_LIST">
            <tr>
              <td>
                <a class="MENU_LINK" href="B.asp">
                  <span class="MENU_ICON"><img src="./res/menubullet.gif" alt="-"/></span>
                  <span class="MENU_TEXT">Prodotti</span>
                </a>
              </td>
            </tr>
            <tr>
              <td>
                <a class="MENU_LINK" href="C.asp?new=1">
                  <span class="MENU_ICON"><img src="./res/menubullet.gif" alt="-" /></span>
                  <span class="MENU_TEXT">Ordina</span>
                </a>
              </td>
            </tr>
          </table>
        </td>
        <td class="BANNER_TOP" colspan="2" />
      </tr>
      <tr>
        <td class="CONTENT" colspan="2">
