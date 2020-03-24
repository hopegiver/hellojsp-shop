<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

    MenuDao menu = new MenuDao();

    ContentDao content = new ContentDao();
    int id = m.reqInt("id");

    DataSet menu_list = menu.find("status != -1 and parent_id = 0", "*", "id asc");
    DataSet sub_menu_list = menu.find("status != -1 and parent_id != 0", "*", "id asc");
    if(id == 0) {
        DataSet content_one = content.find("status != -1", "*", "id asc", 1);

        while (content_one.next()) {
            content_one.put("reg_date", m.time("yyyy-MM-dd", content_one.s("reg_date")));
        }
        //Step4
        String pagetitle = "Content";
        String pageaction = "";
        p.setVar("pagetitle", pagetitle);
        p.setVar("pageaction", pageaction);

        p.setLayout("frontMain");
        p.setBody("front/content");
        p.setVar("menu_list", menu_list);
        p.setVar("sub_menu_list", sub_menu_list);

        p.setVar("content_one", content_one);
        p.print();
    }else{
        DataSet content_one = content.find("id = id", "*");

        while (content_one.next()) {
            content_one.put("reg_date", m.time("yyyy-MM-dd", content_one.s("reg_date")));
        }
        //Step4
        String pagetitle = "Content";
        String pageaction = "";
        p.setVar("pagetitle", pagetitle);
        p.setVar("pageaction", pageaction);

        p.setLayout("frontMain");
        p.setBody("front/content");
        p.setVar("menu_list", menu_list);
        p.setVar("sub_menu_list", sub_menu_list);

        p.setVar("content_one", content_one);
        p.print();
    }


%>