<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

if(userId != null){
//Step1
	PartnerDao partner = new PartnerDao();
	
	//Step2
	f.addElement("name", null, "title:'name', required:true");
	
	f.addElement("photo_url", null, "title:'photo_url', required:true");
	
	//Step3
	if(m.isPost() && f.validate()) {
	
		partner.item("name", f.get("name"));
		
		File attFile = f.saveFile("photo_url");
		if(attFile != null) {
			partner.item("photo_url", attFile.getName());
		}
		partner.item("reg_date", m.time("yyyyMMddHHmmss"));
		partner.item("status", 1);
	
		//blog.setDebug(out);
		if(!partner.insert()) {
			m.jsError(" occurred(insert)");
			return;
		}
	
		m.redirect("index.jsp");
		return;
	}
	
	String pagetitle = "Partner"; 
	String pageaction = "add"; 
	p.setVar("pagetitle", pagetitle);
	p.setVar("pageaction", pageaction);
	p.setVar("userId", userId);
	//Step4
	//p.setDebug(out);
	p.setLayout("adminMain");
	p.setBody("admin/partner/create");
	p.setVar("form_script", f.getScript());
	p.print();
} else {
    m.jsAlert("Need to login");
    m.jsReplace("/admin/login.jsp", "window");
}

%>