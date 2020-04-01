<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%

    ProductDao product = new ProductDao();
    String ttt = Hello.sha1(m.time("yyyyMMddHHmmss"));

    int id = m.reqInt("id");
    DataSet info = product.find("id = " + id);

    p.setBody("admin/product/hidemodule");
    p.setVar("info", info);
    p.setVar("ttt", ttt);

    p.print();

%>