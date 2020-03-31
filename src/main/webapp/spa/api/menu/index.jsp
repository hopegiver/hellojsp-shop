<%@ page contentType="text/xml; charset=utf-8" %><%@ include file="../init.jsp" %><%

//Step1
MenuDao menu = new MenuDao();

DataSet menuInfo = menu.find("status != -1 AND parent_id = 0", "*", "sort");



//Step4
p.setLoop("list", menuInfo);

p.print(1);

%>