<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

MenuDao menu = new MenuDao();
ProductDao product = new ProductDao();
BannerDao banner = new BannerDao();	
PartnerDao partner = new PartnerDao();
FileDao productfiles = new FileDao();
	DataSet menu_list = menu.find("status != -1 and parent_id = 0", "*", "id asc");
	DataSet sub_menu_list = menu.find("status != -1 and parent_id != 0", "*", "id asc");

	
	DataSet bann = banner.find("status != -1", "*", "id DESC", 3);
	
	DataSet part = partner.find("status != -1", "*", "id ASC");

	DataSet list = product.find("status != -1", "*", "id DESC", 8);
	while(list.next()) {
		DataSet images = productfiles.find("module = '"+list.s("unique_id")+"'", "*", 1);

		list.put("firstimage", images);
	    list.put("reg_date", m.time("yyyy-MM-dd", list.s("reg_date")));
	}
	
	//Step4
	String pagetitle = "Product"; 
	String pageaction = ""; 
	p.setVar("pagetitle", pagetitle);
	p.setVar("pageaction", pageaction);
	
	p.setLayout("frontMain");
	p.setBody("front/home");

	p.setLoop("menu_list", menu_list);
	p.setLoop("sub_menu_list", sub_menu_list);
	p.setLoop("list", list);
	p.setLoop("bann", bann);
	p.setLoop("part", part);
    p.print();


%>