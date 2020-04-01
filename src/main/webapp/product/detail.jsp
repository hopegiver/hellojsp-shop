<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

ProductDao product = new ProductDao();
	MenuDao menu = new MenuDao();
	FileDao productfiles = new FileDao();
	DataSet menu_list = menu.find("status != -1 and parent_id = 0", "*", "id asc");
	DataSet sub_menu_list = menu.find("status != -1 and parent_id != 0", "*", "id asc");
	int id = m.reqInt("id");
	DataSet info = product.find("id = " + id);
	
	while(info.next()) {


		info.put("reg_date", m.time("yyyy-MM-dd", info.s("reg_date")));
	}
	DataSet images = productfiles.find("module = '"+info.s("unique_id")+"'");
	
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
	p.setLoop("list", list);
	p.setLoop("images", images);
    p.print();


%>