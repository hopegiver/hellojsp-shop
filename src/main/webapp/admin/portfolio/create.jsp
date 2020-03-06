<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
PortfolioDao portfolio = new PortfolioDao();

//Step2
f.addElement("subject", null, "title:'subject', required:true");
f.addElement("content", null, "title:'content', required:true");

f.addElement("photo_url", null, "title:'photo_url'");

//Step3
if(m.isPost() && f.validate()) {

	portfolio.item("subject", f.get("subject"));
	
	portfolio.item("content", f.get("content"));
	
	File attFile = f.saveFile("photo_url");
	if(attFile != null) {
		portfolio.item("photo_url", attFile.getName());
	}
	portfolio.item("reg_date", m.time("yyyyMMddHHmmss"));
	portfolio.item("status", 1);

	//blog.setDebug(out);
	if(!portfolio.insert()) {
		m.jsError(" occurred(insert)");
		return;
	}

	m.redirect("index.jsp");
	return;
}

//Step4
//p.setDebug(out);
p.setLayout("blog");
p.setBody("admin/portfolio/create");
p.setVar("form_script", f.getScript());
p.print();

%>