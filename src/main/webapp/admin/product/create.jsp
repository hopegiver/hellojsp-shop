<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
ProductDao product = new ProductDao();
CategoryDao category = new CategoryDao();
ProductvariantDao productvariant = new ProductvariantDao();
CategoryModuleDao catModule = new CategoryModuleDao();
//Step2

f.addElement("cats", null, "title:'cats', required:true");
f.addElement("product_name", null, "title:'product_name', required:true");
f.addElement("price", null, "title:'price', required:true");
f.addElement("summary", null, "title:'summary', required:true");
f.addElement("description", null, "title:'description', required:true");
f.addElement("photo_url", null, "title:'photo_url'");
//Step3
if(m.isPost() && f.validate()) {


	product.item("category_id", f.get("cat_ids"));
	product.item("categories", f.get("cats"));
	product.item("product_name", f.get("product_name"));
	product.item("price", f.get("price"));
	product.item("summary", f.getArr("summary"));
	product.item("description", f.get("description"));
	product.item("colors", f.get("colors"));
	product.item("sizes", f.get("sizes"));
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

	String[] cat_ids = f.get("cat_ids").split(",");
	for (String id : cat_ids)
	{
		catModule.item("category_id", id);
		catModule.item("module_id", newId);
		int catmid = catModule.insertWithId();
	}


	int variantCount =  f.getInt("variant_count");
	for(int i = 1; i <= variantCount; i+=1){

		if(f.getInt("variant"+ i) == 1) {
			productvariant.item("product_id", newId);
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
String pageaction = "add";
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);
p.setVar("userId", userId);
p.setLayout("adminMain");
p.setBody("admin/product/create");

p.setVar("form_script", f.getScript());
p.print();

%>