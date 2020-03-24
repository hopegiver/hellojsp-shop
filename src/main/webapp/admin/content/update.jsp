<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%

//Step1
ContentDao content = new ContentDao();

//Step2
int id = m.reqInt("id");
if(id == 0) { m.jsError("Primary Key is required"); return; }

//Step3
DataSet info = content.find("id = " + id);
if(!info.next()) { m.jsError("No Data"); return; }

//Step4
f.addElement("name", info.s("name"), "title:'name', required:true");
f.addElement("content", info.s("content"), "title:'content', required:true");

f.addElement("photo_url", info.s("photo_url"), "title:'photo_url'");

//Step5
if(m.isPost() && f.validate()) {

    content.item("name", f.get("name"));
    content.item("content", f.get("content"));

	if("Y".equals(f.get("photo_url_del"))) {
        content.item("photo_url", "");
		m.delFile(f.uploadDir + "/" + info.s("photo_url"));
	}

	File attFile = f.saveFile("photo_url");
	if(attFile != null) {
        content.item("photo_url", attFile.getName());

		if(!"".equals(info.s("photo_url"))) {
			m.delFile(f.uploadDir + "/" + info.s("att_file_code"));
		}
	}

	//blog.setDebug(out);
	if(!content.update("id = " + id)) {
		m.jsAlert("Error occurred(update)");
		return;
	}

	m.redirect("index.jsp");
	return;
}

//Step6
String pagetitle = "Content";
String pageaction = "edit";
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);
p.setVar("userId", userId);
p.setLayout("adminMain");
p.setBody("admin/content/update");
p.setVar("info", info);
p.setVar("form_script", f.getScript());
p.print();

%>