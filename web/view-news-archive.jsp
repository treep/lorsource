<%@ page pageEncoding="koi8-r" contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.Connection,java.sql.ResultSet,java.sql.Statement,ru.org.linux.site.BadSectionException,ru.org.linux.site.Section,ru.org.linux.site.Template" errorPage="/error.jsp" buffer="200kb"%>
<%@ page import="ru.org.linux.util.DateUtil" %>
<%@ page import="ru.org.linux.util.ServletParameterParser" %>
<% Template tmpl = new Template(request, config, response); %>
<%= tmpl.head() %>
<% Connection db=null;
  try { %>
<%
  int sectionid = new ServletParameterParser(request).getInt("section");

  db = tmpl.getConnection();

  Section section = new Section(db, sectionid);

  Statement st = db.createStatement();

  String ptitle = section.getName() + " - �����";
%>
	<title><%= ptitle %></title>
<jsp:include page="WEB-INF/jsp/header.jsp"/>
<H1><%= ptitle %></H1>
<%

if (!section.isBrowsable()) { throw new BadSectionException(sectionid); }

%>
<%

  ResultSet rs = st.executeQuery("select year, month, c from monthly_stats where section=" + sectionid + " order by year, month");
  while (rs.next()) {
    int tMonth = rs.getInt("month");
    int tYear = rs.getInt("year");
    out.print("<a href=\"view-news.jsp?year=" + tYear + "&amp;month=" + tMonth + "&amp;section=" + sectionid + "\">" + rs.getInt("year") + ' ' + DateUtil.getMonth(tMonth) + "</a> (" + rs.getInt("c") + ")<br>");
  }
  rs.close();
%>

<%
	st.close();
  } finally {
    if (db!=null) {
      db.close();
    }
  }
%>
<jsp:include page="WEB-INF/jsp/footer.jsp"/>