<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%

        //Step1
        CategoryDao category = new CategoryDao();

        MenuDao menu = new MenuDao();

        //Step2
        DataSet catInfo = category.find("status != -1 AND parent_id = 0", "*", "sort");

        DataSet subCat = category.find("status != -1 AND parent_id != 0", "*", "sort");

        while(subCat.next()) {
                subCat.put("reg_date", m.time("yyyy-MM-dd", subCat.s("reg_date")));
        }

        while(catInfo.next()) {
                catInfo.put("reg_date", m.time("yyyy-MM-dd", catInfo.s("reg_date")));
        }

        int id = m.reqInt("id");
        int del = m.reqInt("del");

        DataSet info = category.find("id = " + id);
        if(id != 0) {
                if(del != 0){
                        category.item("status", -1);
                        category.update("id = " + id);

                        m.redirect("index.jsp");
                        return;
                }else{
                        if(!info.next()) { m.jsError("No Data"); return; }

                        f.addElement("parent_id", info.s("parent_id"), "title:'parent_id'");
                        f.addElement("category_name", info.s("category_name"), "title:'category_name', required:true");
                        f.addElement("description", info.s("description"), "title:'description'");
                        f.addElement("sort", info.s("sort"), "title:'sort'");


                        if(m.isPost() && f.validate()) {

                                category.item("parent_id", f.get("parent_id"));
                                category.item("category_name", f.get("category_name"));
                                category.item("description", f.get("description"));
                                category.item("sort", f.get("sort"));

                                //blog.setDebug(out);
                                if(!category.update("id = " + id)) {
                                        m.jsAlert("Error occurred(update)");
                                        return;
                                }
                                m.redirect("index.jsp");
                                return;
                        }
                        if(m.isPost() && f.validate()) {
                                category.item("status", -1);

                                //blog.setDebug(out);
                                if(!category.update("id = " + id)) {
                                        m.jsAlert("Error occurred(delete)");
                                        return;
                                }

                                m.redirect("index.jsp");
                                return;
                        }
                }
        } else {
                f.addElement("parent_id", null, "title:'parent_id'");
                f.addElement("category_name", null, "title:'category_name', required:true");
                f.addElement("description", null, "title:'description'");
                f.addElement("sort", null, "title:'sort',  required:true");

                if(m.isPost() && f.validate()) {

                        category.item("parent_id", f.get("parent_id"));

                        category.item("category_name", f.get("category_name"));
                        category.item("description", f.get("description"));
                        category.item("reg_date", m.time("yyyyMMddHHmmss"));
                        category.item("sort", f.get("sort"));
                        category.item("status", 1);


                        //blog.setDebug(out);
                        if(!category.insert()) {
                                m.jsError(" occurred(insert)");
                                return;
                        }

                        m.redirect("index.jsp");
                        return;
                }
        }


        //Step4
        String pagetitle = "Category";

        String pageaction = "";

        //    p.setDebug(out);
        p.setLayout("adminMain");
        p.setBody("admin/category/index");
        p.setVar("id", id);
        p.setVar("list", catInfo);
        p.setVar("sublist", subCat);
        p.setVar("info", info);
        p.setVar("parent", catInfo);
        p.setVar("userId", userId);
        p.setVar("form_script", f.getScript());
        p.setVar("pagetitle", pagetitle);
        p.setVar("pageaction", pageaction);
        p.print();



%>