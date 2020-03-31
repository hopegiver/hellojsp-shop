<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

if(userId != null){
	//Step1
	ProductDao product = new ProductDao();
	CategoryDao category = new CategoryDao();
	ProductvariantDao productvariant = new ProductvariantDao();
	CategoryModuleDao catModule = new CategoryModuleDao();
	//Step2
	int id = m.reqInt("id");
	if(id == 0) { m.jsError("Primary Key is required"); return; }
	
	//Step3
	DataSet info = product.find("id = " + id);
	
	if(!info.next()) { m.jsError("No Data"); return; }
	
	//Step4
	f.addElement("cats", info.s("categories"), "title:'cats'");
	f.addElement("cat_ids", info.s("category_id"), "title:'cat_ids'");
	f.addElement("product_name", info.s("product_name"), "title:'product_name', required:true");
	f.addElement("price", info.s("price"), "title:'price', required:true");
	f.addElement("summary", info.s("summary"), "title:'summary', required:true");
	f.addElement("description", info.s("description"), "title:'description', required:true");
	f.addElement("photo_url", info.s("photo_url"), "title:'photo_url'");

	String[] color_split = info.s("colors").split(",");
	String[] size_split = info.s("sizes").split(",");
	 //Boolean utga =  m.inArray("Black", color_split);
	//Step5
	if(m.isPost() && f.validate()) {
	
		product.item("category_id", f.get("cat_ids"));
		product.item("categories", f.get("cats"));
		product.item("product_name", f.get("product_name"));
		product.item("price", f.get("price"));
		product.item("summary", f.get("summary"));
		product.item("description", f.get("description"));
		product.item("colors", f.get("colors"));
		product.item("sizes", f.get("sizes"));
		File attFile = f.saveFile("photo_url");
		if(attFile != null) {
			product.item("photo_url", attFile.getName());
		}
		
		//blog.setDebug(out);
		if(!product.update("id = " + id)) {
			m.jsAlert("Error occurred(update)");
			return;
		}
		catModule.delete("module_id = " + id);
		String[] cat_ids = f.get("cat_ids").split(",");
		for (String cid : cat_ids)
		{
			catModule.item("category_id", cid);
			catModule.item("module_id", id);
			int catmid = catModule.insertWithId();
		}

		productvariant.delete("product_id = " + id);
		int variantCount =  f.getInt("variant_count");
		for(int i = 1; i <= variantCount; i+=1){

			if(f.getInt("variant"+ i) == 1) {
				productvariant.item("product_id", id);
				productvariant.item("color", f.get("product_color" + i));
				productvariant.item("size", f.get("product_size" + i));
				productvariant.item("price", f.get("product_price" + i));
				int pvid = productvariant.insertWithId();
			}

		}
	
		m.redirect("index.jsp");
		return;
	}


	String pagetitle = "Product"; 
	String pageaction = "update"; 
	p.setVar("pagetitle", pagetitle);
	p.setVar("pageaction", pageaction);
	p.setVar("userId", userId);

	p.setVar("colors", color_split);
	p.setVar("sizes", size_split);
	p.setLayout("adminMain");
	p.setBody("admin/product/update");

	p.setVar("info", info);
	
	p.setVar("form_script", f.getScript());
	p.print();

} else {
    m.jsAlert("Need to login");
    m.jsReplace("/admin/login.jsp", "window");
}

%>