<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%

    CategoryDao category = new CategoryDao();


//String module = f.get("module");

    int cat = m.reqInt("cat");
    int sub_cat_id = m.reqInt("sub_cat_id");
    if(cat != 0) {
        DataSet sub_category = category.find("status != -1 and parent_id = " + cat + "", "id,parent_id,category_name");
        p.setLayout("module");
        p.setBody("admin/product/sub_category");
        p.setVar("type", "category");
        p.setVar("cat", cat);
        p.setVar("sub_cat_id", sub_cat_id);
        p.setLoop("sub_category", sub_category);
        p.print();
    }

    //p.print(Writer module);
%>