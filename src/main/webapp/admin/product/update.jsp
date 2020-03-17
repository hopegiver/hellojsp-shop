<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

if(userId != null){
	//Step1
	ProductDao product = new ProductDao();
	CategoryDao category = new CategoryDao();
	CategoryModuleDao categoryModule = new CategoryModuleDao();
	
	//Step2
	int id = m.reqInt("id");
	if(id == 0) { m.jsError("Primary Key is required"); return; }
	
	//Step3
	DataSet info = product.find("id = " + id);
	
	
	if(!info.next()) { m.jsError("No Data"); return; }
	
	//Step4
	f.addElement("category_id", info.s("category_id"), "title:'category_id'");
	f.addElement("sub_category_id", info.s("sub_category_id"), "title:'sub_category_id'");
	f.addElement("product_name", info.s("product_name"), "title:'product_name', required:true");
	f.addElement("price", info.s("price"), "title:'price', required:true");
	f.addElement("summary", info.s("summary"), "title:'summary', required:true");
	f.addElement("description", info.s("description"), "title:'description', required:true");
	f.addElement("photo_url", info.s("photo_url"), "title:'photo_url'");
	//Step5
	if(m.isPost() && f.validate()) {
	
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
		
		//blog.setDebug(out);
		if(!product.update("id = " + id)) {
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
	lm.addWhere("a.parent_id = 0");
	lm.setOrderBy("a.id ASC");
	
	DataSet list = lm.getDataSet();
	
	DataSet sublist = category.query(
			"select a.*, b.category_name as parent_name"
			+" from tb_category a"
			+ " left join tb_category b on a.parent_id = b.id "
			+ " where a.parent_id != "+ 0
			);
	
	//Step6
	String pagetitle = "Product"; 
	String pageaction = "update"; 
	p.setVar("pagetitle", pagetitle);
	p.setVar("pageaction", pageaction);
	p.setVar("userId", userId);
	p.setLayout("adminMain");
	p.setBody("admin/product/update");
	p.setVar("list", list);
	p.setVar("sublist", sublist);
	p.setVar("info", info);
	
	p.setVar("form_script", f.getScript());
	p.print();

} else {
    m.jsAlert("Need to login");
    m.jsReplace("/admin/login.jsp", "window");
}

%>