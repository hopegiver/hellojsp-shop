<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%

CategoryDao category = new CategoryDao();
BlogDao blog = new BlogDao();
ContentDao content = new ContentDao();

//String module = f.get("module");
int module = m.reqInt("module");


        //DataSet mod = blog.find("status != -1");
        out.println(module);




        //p.print(Writer module);
%>