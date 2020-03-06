<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
CategoryDao category = new CategoryDao();

//Step2
int id = m.reqInt("id");
if(id == 0) { m.jsError("Primary Key is required"); return; }

//Step3
DataSet info = category.find("id = " + id);
if(!info.next()) { m.jsError("No Data"); return; }

//Step4
f.addElement("parent_id", info.s("parent_id"), "title:'parent_id'");
f.addElement("category_name", info.s("category_name"), "title:'category_name', required:true");
f.addElement("description", info.s("description"), "title:'description'");
//Step5
if(m.isPost() && f.validate()) {

	category.item("parent_id", f.get("parent_id"));
	category.item("category_name", f.get("category_name"));
	category.item("description", f.get("description"));

	//blog.setDebug(out);
	if(!category.update("id = " + id)) {
		m.jsAlert("Error occurred(update)");
		return;
	}

	m.redirect("index.jsp");
	return;
}

ListManager lm = new ListManager();
//lm.setDebug(out);
lm.setRequest(request);
lm.setTable("tb_category a");
lm.setFields("a.*");
lm.addWhere("a.status != -1");
lm.setOrderBy("a.id DESC");

DataSet list = lm.getDataSet();

//Step6
String pagetitle = "Category"; 
String pageaction = "update"; 
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);

p.setLayout("adminMain");
p.setBody("admin/category/update");
p.setVar("list", list);
p.setVar("info", info);
p.setVar("form_script", f.getScript());
p.print();

%>