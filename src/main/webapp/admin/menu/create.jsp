<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
MenuDao menu = new MenuDao();

//Step2
f.addElement("parent_id", null, "title:'parent_id'");
f.addElement("menu_name", null, "title:'menu_name', required:true");
f.addElement("module", null, "title:'module', required:true");
f.addElement("module_id", null, "title:'module_id'");



//Step3
if(m.isPost() && f.validate()) {
	
	menu.item("parent_id", f.get("parent_id"));
	menu.item("module", f.get("module"));
	menu.item("module_id", f.get("module_id"));
	menu.item("menu_name", f.get("menu_name"));
	
	menu.item("reg_date", m.time("yyyyMMddHHmmss"));
	menu.item("status", 1);

	
	if(!menu.insert()) {
		m.jsError(" occurred(insert)");
		return;
	}

	m.redirect("index.jsp");
	return;
}

DataSet main_menu = menu.find("parent_id = " + 0 + " AND status = " + 1 + " ");


//Step4
//p.setDebug(out);
String pagetitle = "Menu"; 
String pageaction = "add"; 
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);
p.setVar("userId", userId);
p.setLayout("adminMain");
p.setBody("admin/menu/create");
p.setVar("main_menu", main_menu);

p.setVar("form_script", f.getScript());
p.print();

%>