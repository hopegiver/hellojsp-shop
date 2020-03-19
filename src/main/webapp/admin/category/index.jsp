<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%


        //Step1
        CategoryDao cat = new CategoryDao();

        //Step2
        f.addElement("s_keyword", null, null);
        
        //Step3
        ListManager lm = new ListManager();
        //lm.setDebug(out);
        lm.setRequest(request);
        lm.setTable("tb_category a");
        lm.setFields("a.*");
        lm.addWhere("a.status != -1");
        lm.addWhere("a.parent_id = 0");
        lm.addSearch("a.category_name, a.description", f.get("s_keyword"), "LIKE");
        lm.setOrderBy("a.sort ASC");

        //Step3
        DataSet list = lm.getDataSet();
        while(list.next()) {
            list.put("reg_date", m.time("yyyy-MM-dd", list.s("reg_date")));

        }

        ListManager sub = new ListManager();
        //lm.setDebug(out);
        sub.setRequest(request);
        sub.setTable("tb_category a");
        sub.setFields("a.*");
        sub.addWhere("a.status != -1");
        sub.addWhere("a.parent_id != 0");
        sub.setOrderBy("a.sort ASC");
        DataSet sublist = sub.getDataSet();
        //Step4
		String pagetitle = "Category"; 
		String pageaction = ""; 
		p.setVar("userId", userId);
		p.setVar("pagetitle", pagetitle);
		p.setVar("pageaction", pageaction);
		
        p.setLayout("adminMain");
        p.setBody("admin/category/index");
        
        p.setVar("list", list);
        p.setVar("sublist", sublist);
        p.setVar("total_cnt", lm.getTotalNum());
        p.setVar("pagebar", lm.getPaging());
        p.setVar("form_script", f.getScript());
        
        
        
        p.print();



%>