<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
PartnerDao partner = new PartnerDao();

//Step2
int id = m.reqInt("id");
if(id == 0) { m.jsError("Primary Key is required"); return; }

//Step3
DataSet info = partner.find("id = " + id);
if(!info.next()) { m.jsError("No Data"); return; }

//Step4

info.put("reg_date", m.time("yyyy-MM-dd HH:mm", info.s("reg_date")));

//Step5
String pagetitle = "Partner"; 
String pageaction = "view"; 
p.setVar("pagetitle", pagetitle);
p.setVar("pageaction", pageaction);
p.setVar("userId", userId);
p.setLayout("adminMain");
p.setBody("admin/partner/read");
p.setVar("info", info);
p.print();

%>