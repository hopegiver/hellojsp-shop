<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

ProductDao product = new ProductDao();
	MenuDao menu = new MenuDao();

	DataSet menu_list = menu.find("status != -1 and parent_id = 0", "*", "id asc");
	DataSet sub_menu_list = menu.find("status != -1 and parent_id != 0", "*", "id asc");
	int id = m.reqInt("id");
	DataSet info = product.find("id = " + id);
	
	while(info.next()) {
		info.put("reg_date", m.time("yyyy-MM-dd", info.s("reg_date")));
	}
	
	DataSet list = product.find("status != -1", "*", "id DESC", 3);
	while(list.next()) {
	    list.put("reg_date", m.time("yyyy-MM-dd", list.s("reg_date")));
	}
	//Step4
	String pagetitle = "Product"; 
	String pageaction = ""; 
	p.setVar("pagetitle", pagetitle);
	p.setVar("pageaction", pageaction);
	
	p.setLayout("frontMain");
	p.setBody("front/product_detail");
	p.setVar("menu_list", menu_list);
	p.setVar("sub_menu_list", sub_menu_list);
	p.setVar("info", info);
	p.setVar("list", list);
    p.print();


%>