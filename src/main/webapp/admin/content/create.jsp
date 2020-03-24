<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%


//Step1
	ContentDao content = new ContentDao();
	
	//Step2
	f.addElement("name", null, "title:'name', required:true");
	f.addElement("content", null, "title:'content', required:true");

	f.addElement("photo_url", null, "title:'photo_url', required:true");
	
	//Step3
	if(m.isPost() && f.validate()) {

		content.item("name", f.get("name"));
		content.item("content", f.get("content"));

		File attFile = f.saveFile("photo_url");
		if(attFile != null) {
			content.item("photo_url", attFile.getName());
		}
		content.item("reg_date", m.time("yyyyMMddHHmmss"));
		content.item("status", 1);
	
		//blog.setDebug(out);
		if(!content.insert()) {
			m.jsError(" occurred(insert)");
			return;
		}
	
		m.redirect("index.jsp");
		return;
	}
	
	String pagetitle = "Content";
	String pageaction = "add"; 
	p.setVar("pagetitle", pagetitle);
	p.setVar("pageaction", pageaction);
	p.setVar("userId", userId);
	//Step4
	//p.setDebug(out);
	p.setLayout("adminMain");
	p.setBody("admin/content/create");
	p.setVar("form_script", f.getScript());
	p.print();


%>