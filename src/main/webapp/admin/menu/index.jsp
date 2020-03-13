<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

    if(userId != null){
        //Step1
        MenuDao menu = new MenuDao();

        //Step2
        f.addElement("s_keyword", null, null);
        
        //Step3
        ListManager lm = new ListManager();
        //lm.setDebug(out);
        lm.setRequest(request);
        lm.setTable("tb_menu a");
        lm.setFields("a.*");
        lm.addWhere("a.status != -1");
        lm.addSearch("a.module, a.menu_name, ", f.get("s_keyword"), "LIKE");
        lm.setOrderBy("a.id DESC");

        //Step3
        DataSet list = lm.getDataSet();
        while(list.next()) {
            list.put("reg_date", m.time("yyyy-MM-dd", list.s("reg_date")));
        }

        //Step4
		String pagetitle = "Menu"; 
		String pageaction = ""; 
		p.setVar("pagetitle", pagetitle);
		p.setVar("pageaction", pageaction);
		p.setVar("userId", userId);
        p.setLayout("adminMain");
        p.setBody("admin/menu/index");
        
        p.setVar("list", list);
        p.setVar("total_cnt", lm.getTotalNum());
        p.setVar("pagebar", lm.getPaging());
        p.setVar("form_script", f.getScript());
        
        
        
        p.print();

    } else {
        m.jsAlert("Need to login");
        m.jsReplace("/admin/login.jsp", "window");
    }

%>