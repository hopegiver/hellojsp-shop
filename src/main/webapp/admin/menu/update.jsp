<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
MenuDao menu = new MenuDao();

//Step2
int id = m.reqInt("id");
if(id == 0) { m.jsError("Primary Key is required"); return; }

//Step3
DataSet info = menu.find("id = " + id);
if(!info.next()) { m.jsError("No Data"); return; }

//Step4
f.addElement("parent_id", info.s("parent_id"), "title:'parent_id'");
f.addElement("menu_name", info.s("menu_name"), "title:'menu_name', required:true");

//Step5
if(m.isPost() && f.validate()) {

	menu.item("parent_id", f.get("parent_id"));
	menu.item("menu_name", f.get("menu_name"));

	//blog.setDebug(out);
	if(!menu.update("id = " + id)) {
		m.jsAlert("Error occurred(update)");
		return;
	}

	m.redirect("index.jsp");
	return;
}

ListManager lm = new ListManager();
//lm.setDebug(out);
lm.setRequest(request);
lm.setTable("tb_menu a");
lm.setFields("a.*");
lm.addWhere("a.status != -1");
lm.setOrderBy("a.id DESC");

DataSet list = lm.getDataSet();

//Step6
String pagetitle = "Menu"; 
String pageaction = "update"; 
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);
p.setVar("userId", userId);
p.setLayout("adminMain");
p.setBody("admin/menu/update");
p.setVar("list", list);
p.setVar("info", info);
p.setVar("form_script", f.getScript());
p.print();

%>