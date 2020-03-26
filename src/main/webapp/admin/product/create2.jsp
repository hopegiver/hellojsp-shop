<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

    //Step1

    String colors = f.get("colors");

    String pagetitle = "Product";
    String pageaction = "add";
    p.setVar("pagetitle", pagetitle);
    p.setVar("pageaction", pageaction);
    p.setVar("userId", userId);
    p.setVar("colors", colors);
    p.setLayout("adminMain");
    p.setBody("admin/product/create2");

    p.setVar("form_script", f.getScript());
    p.print();

%>