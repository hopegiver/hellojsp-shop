<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
ProductDao product = new ProductDao();
CategoryModuleDao categoryModule = new CategoryModuleDao();

//Step2
int id = m.reqInt("id");
if(id == 0) { m.jsError("Primary Key is required"); return; }

//Step3
DataSet info = product.find("id = " + id);

DataSet cat_info = categoryModule.find("module_id = " + id);

if(!cat_info.next()) { m.jsError("No Data"); return; }


if(!info.next()) { m.jsError("No Data"); return; }

//Step4
f.addElement("category_id", cat_info.s("category_id"), "title:'category_id'");
f.addElement("sub_category_id", cat_info.s("category_id"), "title:'sub_category_id'");
f.addElement("product_name", info.s("product_name"), "title:'product_name', required:true");
f.addElement("price", info.s("price"), "title:'price', required:true");
f.addElement("summary", info.s("summary"), "title:'summary', required:true");
f.addElement("description", info.s("description"), "title:'description', required:true");
f.addElement("photo_url", info.s("photo_url"), "title:'photo_url'");
//Step5
if(m.isPost() && f.validate()) {

	product.item("product_name", f.get("product_name"));
	product.item("price", f.get("price"));
	product.item("summary", f.get("summary"));
	product.item("description", f.get("description"));
	
	File attFile = f.saveFile("photo_url");
	if(attFile != null) {
		product.item("photo_url", attFile.getName());
	}
	
	//blog.setDebug(out);
	if(!product.update("id = " + id)) {
		m.jsAlert("Error occurred(update)");
		return;
	}
	
	categoryModule.delete("module_id = " + id);
	categoryModule.item("category_id", f.get("category_id"));
	categoryModule.item("module_id", id);
	
	if(!categoryModule.insert()) {
		
		m.jsError(" occurred(category insert)");
		return;
	}
	
	categoryModule.item("category_id", f.get("sub_category_id"));
	categoryModule.item("module_id", id);
	
	if(!categoryModule.insert()) {
		
		m.jsError(" occurred(sub category insert)");
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
lm.addWhere("a.parent_id = 0");
lm.setOrderBy("a.id ASC");

DataSet list = lm.getDataSet();

ListManager lmsub = new ListManager();
lmsub.setRequest(request);
lmsub.setTable("tb_category a");
lmsub.setFields("a.*");
lmsub.addWhere("a.status != -1");
lmsub.addWhere("a.parent_id != 0");
lmsub.setOrderBy("a.id ASC");

DataSet sublist = lmsub.getDataSet();

//Step6
String pagetitle = "Product"; 
String pageaction = "update"; 
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);

p.setLayout("adminMain");
p.setBody("admin/product/update");
p.setVar("list", list);
p.setVar("sublist", sublist);
p.setVar("info", info);
p.setVar("cat_info", cat_info);

p.setVar("form_script", f.getScript());
p.print();

%>