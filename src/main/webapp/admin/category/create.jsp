<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
CategoryDao category = new CategoryDao();

//Step2
f.addElement("parent_id", null, "title:'parent_id'");
f.addElement("category_name", null, "title:'category_name', required:true");
f.addElement("description", null, "title:'description'");

//Step3
if(m.isPost() && f.validate()) {

	category.item("parent_id", f.get("parent_id"));
	
	category.item("category_name", f.get("category_name"));
	category.item("description", f.get("description"));
	category.item("reg_date", m.time("yyyyMMddHHmmss"));
	category.item("status", 1);

	
	if(!category.insert()) {
		m.jsError(" occurred(insert)");
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
lm.setOrderBy("a.id ASC");

DataSet list = lm.getDataSet();

//Step4
//p.setDebug(out);
String pagetitle = "Category"; 
String pageaction = "add"; 
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);
		
p.setLayout("adminMain");
p.setBody("admin/category/create");
p.setVar("list", list);
p.setVar("form_script", f.getScript());
p.print();

%>