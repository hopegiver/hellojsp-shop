<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

if(userId != null){
//Step1
	BannerDao banner = new BannerDao();
	
	//Step2
	f.addElement("text1", null, "title:'text1', required:true");
	f.addElement("text2", null, "title:'text2', required:true");
	f.addElement("url", null, "title:'url'");
	
	f.addElement("photo_url", null, "title:'photo_url', required:true");
	
	//Step3
	if(m.isPost() && f.validate()) {
	
		banner.item("text1", f.get("text1"));
		banner.item("text2", f.get("text2"));
		banner.item("url", f.get("url"));
		
		File attFile = f.saveFile("photo_url");
		if(attFile != null) {
			banner.item("photo_url", attFile.getName());
		}
		banner.item("reg_date", m.time("yyyyMMddHHmmss"));
		banner.item("status", 1);
	
		//blog.setDebug(out);
		if(!banner.insert()) {
			m.jsError(" occurred(insert)");
			return;
		}
	
		m.redirect("index.jsp");
		return;
	}
	
	String pagetitle = "Banner"; 
	String pageaction = "add"; 
	p.setVar("pagetitle", pagetitle);
	p.setVar("pageaction", pageaction);
	p.setVar("userId", userId);
	//Step4
	//p.setDebug(out);
	p.setLayout("adminMain");
	p.setBody("admin/banner/create");
	p.setVar("form_script", f.getScript());
	p.print();
} else {
    m.jsAlert("Need to login");
    m.jsReplace("/admin/login.jsp", "window");
}

%>