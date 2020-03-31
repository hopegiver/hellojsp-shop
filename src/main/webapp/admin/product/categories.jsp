<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%

    CategoryDao category = new CategoryDao();
    CategoryModuleDao catModule = new CategoryModuleDao();

    int id = m.reqInt("id");
    DataSet parentCat = category.find("status != -1 AND parent_id = 0", "id, parent_id, category_name");
    DataSet childCat = category.find("status != -1 AND parent_id != 0", "id, parent_id, category_name");
    DataSet cats = catModule.find("module_id = " + id);

    p.setBody("admin/product/categorySelect");
    p.setLoop("list", parentCat);
    p.setLoop("sublist", childCat);
    p.setLoop("cats", cats);
    p.print();

%>