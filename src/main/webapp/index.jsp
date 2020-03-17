<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

ProductDao product = new ProductDao();
BannerDao banner = new BannerDao();	
PartnerDao partner = new PartnerDao();	
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
	
	p.setVar("list", list);
	p.setVar("bann", bann);
	p.setVar("part", part);
    p.print();


%>