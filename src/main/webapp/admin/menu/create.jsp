<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
MenuDao menu = new MenuDao();

//Step2
f.addElement("parent_id", null, "title:'parent_id'");
f.addElement("menu_name", null, "title:'menu_name', required:true");


//Step3
if(m.isPost() && f.validate()) {

	menu.item("parent_id", f.get("parent_id"));
	
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

ListManager lm = new ListManager();
//lm.setDebug(out);
lm.setRequest(request);
lm.setTable("tb_menu a");
lm.setFields("a.*");
lm.addWhere("a.status != -1");
lm.setOrderBy("a.id DESC");

DataSet list = lm.getDataSet();

//Step4
//p.setDebug(out);
String pagetitle = "Menu"; 
String pageaction = "add"; 
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);
		
p.setLayout("adminMain");
p.setBody("admin/menu/create");
p.setVar("list", list);
p.setVar("form_script", f.getScript());
p.print();

%>