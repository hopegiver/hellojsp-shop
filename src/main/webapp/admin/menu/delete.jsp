<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
MenuDao menu = new MenuDao();

//Step2
int id = m.reqInt("id");
if(id == 0) { m.jsError("Primary Key is required"); return; }

//Step3
DataSet info = menu.find("id = " + id);
if(!info.next()) { m.jsError("No Data"); return; }

f.addElement("id", info.s("id"), "title:'ID', required:true");

//Step5
if(m.isPost() && f.validate()) {

	if(!"".equals(info.s("att_file_code"))) {
		m.delFile(f.uploadDir + "/" + info.s("att_file_code"));
	}
	menu.item("status", -1);

	//blog.setDebug(out);
	if(!menu.update("id = " + id)) {
		m.jsAlert("Error occurred(delete)");
		return;
	}

	m.redirect("index.jsp");
	return;
}

//Step6
String pagetitle = "Menu"; 
String pageaction = "delete"; 
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);
p.setVar("userId", userId);
p.setLayout("adminMain");
p.setBody("admin/menu/delete");
p.setVar("info", info);
p.setVar("form_script", f.getScript());
p.print();

%>