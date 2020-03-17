<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

if(userId != null){
	//Step1
	ProductDao product = new ProductDao();
	CategoryDao category = new CategoryDao();
	//Step2
	int id = m.reqInt("id");
	if(id == 0) { m.jsError("Primary Key is required"); return; }
	
	//Step3
	DataSet info = product.find("id = " + id);
	if(!info.next()) { m.jsError("No Data"); return; }
	
	//Step4
	//info.put("category_name", m.htt(info.s("category_name")));
	
	info.put("reg_date", m.time("yyyy-MM-dd HH:mm", info.s("reg_date")));
	
	DataSet cat_info = category.find("id = " + info.s("category_id"));
	cat_info.next();
	info.put("category_name", m.htt(cat_info.s("category_name")));
	
	DataSet sub_cat_info = category.find("id = " + info.s("sub_category_id"));
	sub_cat_info.next();
	info.put("sub_category_name", m.htt(sub_cat_info.s("category_name")));
	
	//Step5
	String pagetitle = "Product"; 
	String pageaction = "read"; 
	p.setVar("pagetitle", pagetitle);
	p.setVar("pageaction", pageaction);
	p.setVar("userId", userId);
	p.setLayout("adminMain");
	p.setBody("admin/product/read");
	p.setVar("info", info);
	p.print();
	
} else {
    m.jsAlert("Need to login");
    m.jsReplace("/admin/login.jsp", "window");
}

%>