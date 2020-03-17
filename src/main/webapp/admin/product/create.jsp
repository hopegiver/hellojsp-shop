<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
ProductDao product = new ProductDao();
CategoryDao category = new CategoryDao();
CategoryModuleDao categoryModule = new CategoryModuleDao();

//Step2
f.addElement("category_id", null, "title:'category_id'");
f.addElement("sub_category_id", null, "title:'sub_category_id'");
f.addElement("product_name", null, "title:'product_name', required:true");
f.addElement("price", null, "title:'price', required:true");
f.addElement("summary", null, "title:'summary', required:true");
f.addElement("description", null, "title:'description', required:true");
f.addElement("photo_url", null, "title:'photo_url'");
//Step3
if(m.isPost() && f.validate()) {

	int pro = product.getOneInt("select id from tb_product order by desc");
	
	//m.p(pro.id); if(true) return;
	product.item("category_id", f.get("category_id"));
	product.item("sub_category_id", f.get("sub_category_id"));
	product.item("product_name", f.get("product_name"));
	product.item("price", f.get("price"));
	product.item("summary", f.get("summary"));
	product.item("description", f.get("description"));
	
	File attFile = f.saveFile("photo_url");
	if(attFile != null) {
		product.item("photo_url", attFile.getName());
	}
	
	product.item("reg_date", m.time("yyyyMMddHHmmss"));
	product.item("status", 1);
	
	int newId = product.insertWithId();
	if(newId == 0) {
		
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
lm.addWhere("a.parent_id = 0");
lm.setOrderBy("a.id ASC");

DataSet list = lm.getDataSet();


DataSet sublist = category.query(
		"select a.*, b.category_name as parent_name"
		+" from tb_category a"
		+ " left join tb_category b on a.parent_id = b.id "
		+ " where a.parent_id != "+ 0
		);

//Step4
//p.setDebug(out);
String pagetitle = "Product"; 
String pageaction = "add"; 
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);
p.setVar("userId", userId);
p.setLayout("adminMain");
p.setBody("admin/product/create");
p.setVar("list", list);
p.setVar("sublist", sublist);
p.setVar("form_script", f.getScript());
p.print();

%>