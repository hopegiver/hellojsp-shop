<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%

    //Step1
    CategoryDao category = new CategoryDao();
    BlogDao blog = new BlogDao();
    ContentDao content = new ContentDao();
    MenuDao menu = new MenuDao();

     //Step2
        DataSet menuInfo = menu.find("status != -1 AND parent_id = 0", "*", "sort");

        DataSet subMenu = menu.find("status != -1 AND parent_id != 0", "*", "sort");

        while(subMenu.next()) {
            subMenu.put("reg_date", m.time("yyyy-MM-dd", subMenu.s("reg_date")));
        }

        while(menuInfo.next()) {
            menuInfo.put("reg_date", m.time("yyyy-MM-dd", menuInfo.s("reg_date")));
        }

        DataSet parent = menu.find("status != -1 AND parent_id = 0 ");

        int id = m.reqInt("id");
        int del = m.reqInt("del");

        DataSet info = menu.find("id = " + id);
        if(id != 0) {
            if(del != 0){
                menu.item("status", -1);
                menu.update("id = " + id);

                m.redirect("index.jsp");
                return;
            }else{
                if(!info.next()) { m.jsError("No Data"); return; }

                f.addElement("module", info.s("module"), "title:'module'");
                f.addElement("current_id", info.s("module"), "title:'current_id'");
                f.addElement("menu_name", info.s("menu_name"), "title:'menu_name', required:true");
                f.addElement("module_id", info.s("module_id"), "title:'module_id'");
                f.addElement("module_id_hide", info.s("module_id"), "title:'module_id'");
                f.addElement("parent_id", info.s("parent_id"), "title:'parent_id'");

                f.addElement("reg_date", info.s("reg_date"), "title:'reg_date', editable:false");

                if(m.isPost() && f.validate()) {

                            String module_id = f.get("module_id");
                            menu.item("module", f.get("module"));
                            menu.item("menu_name", f.get("menu_name"));
                            menu.item("module_id", module_id);
                            menu.item("parent_id", f.get("parent_id"));


                        if(!menu.update("id = " + id)) {
                                    m.jsAlert("Error occurred(update)");
                                    return;
                            }
                        m.redirect("index.jsp");
                            return;
                }
                if(m.isPost() && f.validate()) {
                        menu.item("status", -1);

                        //blog.setDebug(out);
                        if(!menu.update("id = " + id)) {
                                m.jsAlert("Error occurred(delete)");
                                return;
                        }

                        m.redirect("index.jsp");
                        return;
                }
            }
        } else {
                f.addElement("menu_name", null, "title:'menu_name', required:true");
                f.addElement("parent_id", null, "title:'parent_id'");
                f.addElement("module", null, "title:'module'");
                f.addElement("module_id", "", "title:'module_id'");
                f.addElement("parent_id", "", "title:'parent_id'");

                if(m.isPost() && f.validate()) {

                        menu.item("module", f.get("module"));
                        menu.item("menu_name", f.get("menu_name"));
                        menu.item("module_id", f.getInt("module_id", 0));
                        menu.item("parent_id", f.getInt("parent_id", 0));

                        menu.item("reg_date", m.time("yyyyMMddHHmmss"));
                        menu.item("status", 1);


                        //blog.setDebug(out);
                        if(!menu.insert()) {
                                m.jsError(" occurred(insert)");
                                return;
                        }

                        m.redirect("index.jsp");
                        return;
                }
        }


        //Step4
        String pagetitle = "Menu";

        String pageaction = "";
         String module = f.get("module");

    p.setVar("module", module);

        //    p.setDebug(out);
        p.setLayout("adminMain");
        p.setBody("admin/menu/index");
        p.setVar("id", id);
        p.setVar("list", menuInfo);
        p.setVar("sublist", subMenu);
        p.setVar("info", info);
        p.setVar("parent", parent);

        p.setVar("form_script", f.getScript());
        p.setVar("pagetitle", pagetitle);
        p.setVar("pageaction", pageaction);
        p.print();



%>