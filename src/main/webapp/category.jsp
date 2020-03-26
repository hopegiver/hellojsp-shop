<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

    MenuDao menu = new MenuDao();

    CategoryDao category = new CategoryDao();
    ProductDao product = new ProductDao();
    int id = m.reqInt("id");
    DataSet info = category.find("id = "  + id);
    if(!info.next()) { m.jsError("No Data"); return; }


    DataSet menu_list = menu.find("status != -1 and parent_id = 0", "*", "id asc");
    DataSet sub_menu_list = menu.find("status != -1 and parent_id != 0", "*", "id asc");

    DataSet category_list = category.find("status != -1 and parent_id = 0", "*", "id asc");
    DataSet sub_category_list = category.find("status != -1 and parent_id != 0", "*", "id asc");

        ListManager lm = new ListManager();
        //lm.setDebug(out);
        lm.setRequest(request);
        lm.setTable("tb_product a");
        lm.setFields("a.*");
        lm.addWhere("a.status != -1");
        lm.addWhere("a.category_id =" + id + " or a.sub_category_id =" + id);
        lm.addSearch("a.product_name", f.get("s_keyword"), "LIKE");
        lm.setOrderBy("a.id DESC");

        //Step3
        DataSet list = lm.getDataSet();

        while (list.next()) {
            list.put("reg_date", m.time("yyyy-MM-dd", list.s("reg_date")));
        }
        //Step4
        String pagetitle = "Product";
        String pageaction = "";
        p.setVar("pagetitle", pagetitle);
        p.setVar("pageaction", pageaction);

        p.setLayout("frontMain");
        p.setBody("front/product_list");
        p.setVar("id", id);
        p.setVar("info", info);
        p.setVar("menu_list", menu_list);
        p.setVar("sub_menu_list", sub_menu_list);
        p.setVar("category_list", category_list);
        p.setVar("sub_category_list", sub_category_list);
        p.setVar("product_list", list);
        p.print();



%>