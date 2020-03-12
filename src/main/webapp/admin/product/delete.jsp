<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
ProductDao product = new ProductDao();
CategoryModuleDao categoryModule = new CategoryModuleDao();

//Step2
int id = m.reqInt("id");
if(id == 0) { m.jsError("Primary Key is required"); return; }

//Step3
DataSet info = product.find("id = " + id);
if(!info.next()) { m.jsError("No Data"); return; }

f.addElement("id", info.s("id"), "title:'ID', required:true");

//Step5
if(m.isPost() && f.validate()) {

	if(!"".equals(info.s("att_file_code"))) {
		m.delFile(f.uploadDir + "/" + info.s("att_file_code"));
	}
	product.item("status", -1);

	//blog.setDebug(out);
	if(!product.update("id = " + id)) {
		m.jsAlert("Error occurred(delete)");
		return;
	}
	
	categoryModule.delete("module_id = " + id);
	
	

	m.redirect("index.jsp");
	return;
}

//Step6
String pagetitle = "Product"; 
String pageaction = "delete"; 
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);

p.setLayout("adminMain");
p.setBody("admin/product/delete");
p.setVar("info", info);
p.setVar("form_script", f.getScript());
p.print();

%>