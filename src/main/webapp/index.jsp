<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

MenuDao menu = new MenuDao();
ProductDao product = new ProductDao();
BannerDao banner = new BannerDao();	
PartnerDao partner = new PartnerDao();

	DataSet menu_list = menu.find("status != -1 and parent_id = 0", "*", "id asc");
	DataSet sub_menu_list = menu.find("status != -1 and parent_id != 0", "*", "id asc");
	DataSet list = product.find("status != -1", "*", "id DESC", 8);
	
	DataSet bann = banner.find("status != -1", "*", "id DESC", 3);
	
	DataSet part = partner.find("status != -1", "*", "id ASC");
	while(list.next()) {
	    list.put("reg_date", m.time("yyyy-MM-dd", list.s("reg_date")));
	}
	
	//Step4
	String pagetitle = "Product"; 
	String pageaction = ""; 
	p.setVar("pagetitle", pagetitle);
	p.setVar("pageaction", pageaction);
	
	p.setLayout("frontMain");
	p.setBody("front/home");

	p.setVar("menu_list", menu_list);
	p.setVar("sub_menu_list", sub_menu_list);
	p.setVar("list", list);
	p.setVar("bann", bann);
	p.setVar("part", part);
    p.print();


%>