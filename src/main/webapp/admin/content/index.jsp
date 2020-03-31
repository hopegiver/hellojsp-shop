<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%


        //Step1
        ContentDao content = new ContentDao();

        //Step2
        f.addElement("s_keyword", null, null);

        //Step3
        ListManager lm = new ListManager();
        //lm.setDebug(out);
        lm.setRequest(request);
        lm.setTable("tb_content a");
        lm.setFields("a.*");
        lm.addWhere("a.status != -1");
        lm.addSearch("a.name", f.get("s_keyword"), "LIKE");
        lm.setOrderBy("a.id DESC");

        //Step3
        DataSet list = lm.getDataSet();
        while(list.next()) {
            list.put("reg_date", m.time("yyyy-MM-dd", list.s("reg_date")));
        }

        //Step4
		String pagetitle = "Content";
		String pageaction = ""; 
		p.setVar("pagetitle", pagetitle);
		p.setVar("pageaction", pageaction);
		p.setVar("userId", userId);
        p.setLayout("adminMain");
        p.setBody("admin/content/index");
		
        p.setLoop("list", list);
        p.setVar("total_cnt", lm.getTotalNum());
        p.setVar("pagebar", lm.getPaging());
        p.setVar("form_script", f.getScript());
        p.print();



%>