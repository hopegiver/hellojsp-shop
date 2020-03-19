<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%


        //Step1
        MenuDao menu = new MenuDao();


        //Step2

        ListManager lm = new ListManager();
        //lm.setDebug(out);
        lm.setRequest(request);
        lm.setTable("tb_menu a");
        lm.setFields("a.*");
        lm.addWhere("a.status != -1");
        lm.addWhere("a.parent_id = 0");
        lm.setOrderBy("a.id asc");

        //Step3
        DataSet list = lm.getDataSet();
        while(list.next()) {
            list.put("reg_date", m.time("yyyy-MM-dd", list.s("reg_date")));
        }
        
        ListManager sub = new ListManager();
        //lm.setDebug(out);
        sub.setRequest(request);
        sub.setTable("tb_menu a");
        sub.setFields("a.*");
        sub.addWhere("a.status != -1");
        sub.addWhere("a.parent_id != 0");
        
        sub.setOrderBy("a.sort asc");


        DataSet sublist = sub.getDataSet();
        while(sublist.next()) {
        	sublist.put("reg_date", m.time("yyyy-MM-dd", sublist.s("reg_date")));
        }

        int id = m.reqInt("id");

        if(id != 0){
            DataSet info = menu.find("id = " + id);
            if(!info.next()) { m.jsError("No Data"); return; }

            //Step4
            f.addElement("parent_id", info.s("parent_id"), "title:'parent_id'");
            f.addElement("menu_name", info.s("menu_name"), "title:'menu_name', required:true");
            f.addElement("module", info.s("module"), "title:'module', required:true");
            f.addElement("module_id", info.s("module_id"), "title:'module_id'");
            //Step5
            if(m.isPost() && f.validate()) {

                menu.item("parent_id", f.get("parent_id"));
                menu.item("menu_name", f.get("menu_name"));
                menu.item("module", f.get("module"));
                menu.item("module_id", f.get("module_id"));
                //blog.setDebug(out);
                if(!menu.update("id = " + id)) {
                    m.jsAlert("Error occurred(update)");
                    return;
                }

                m.redirect("index.jsp");
                return;
            }
        }

        //Step4
		String pagetitle = "Menu";

		p.setVar("pagetitle", pagetitle);
		if(id != 0) {
		    p.setVar("pageaction", "edit");
		}else{
		    p.setVar("pageaction", "new");
		}
		p.setVar("userId", userId);
        p.setLayout("adminMain");
        p.setBody("admin/menu/index");
        
        p.setVar("list", list);
        p.setVar("sublist", sublist);
        p.setVar("total_cnt", lm.getTotalNum());
        p.setVar("pagebar", lm.getPaging());
        p.setVar("form_script", f.getScript());
        
        
        
        p.print();



%>