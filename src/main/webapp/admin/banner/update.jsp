<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
BannerDao banner = new BannerDao();

//Step2
int id = m.reqInt("id");
if(id == 0) { m.jsError("Primary Key is required"); return; }

//Step3
DataSet info = banner.find("id = " + id);
if(!info.next()) { m.jsError("No Data"); return; }

//Step4
f.addElement("text1", info.s("text1"), "title:'text1', required:true");
f.addElement("text2", info.s("text2"), "title:'text2', required:true");

f.addElement("url", info.s("url"), "title:'url'");
f.addElement("photo_url", info.s("photo_url"), "title:'photo_url'");

//Step5
if(m.isPost() && f.validate()) {

	banner.item("text1", f.get("text1"));
	banner.item("text2", f.get("text2"));
	banner.item("url", f.get("url"));
	
	if("Y".equals(f.get("photo_url_del"))) {
		banner.item("photo_url", "");
		m.delFile(f.uploadDir + "/" + info.s("photo_url"));
	}
	
	File attFile = f.saveFile("photo_url");
	if(attFile != null) {
		banner.item("photo_url", attFile.getName());

		if(!"".equals(info.s("photo_url"))) {
			m.delFile(f.uploadDir + "/" + info.s("att_file_code"));
		}
	}

	//blog.setDebug(out);
	if(!banner.update("id = " + id)) {
		m.jsAlert("Error occurred(update)");
		return;
	}

	m.redirect("index.jsp");
	return;
}

//Step6
String pagetitle = "Banner"; 
String pageaction = "edit"; 
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);
p.setVar("userId", userId);
p.setLayout("adminMain");
p.setBody("admin/banner/update");
p.setVar("info", info);
p.setVar("form_script", f.getScript());
p.print();

%>