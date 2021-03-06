<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%

//Step1
UserDao user = new UserDao();

//Step2
int id = m.reqInt("id");
if(id == 0) { m.jsError("Primary Key is required"); return; }

//Step3
DataSet info = user.find("id = " + id);
if(!info.next()) { m.jsError("No Data"); return; }

f.addElement("id", info.s("id"), "title:'ID', required:true");

//Step5
if(m.isPost() && f.validate()) {

	if(!"".equals(info.s("att_file_code"))) {
		m.delFile(f.uploadDir + "/" + info.s("att_file_code"));
	}
	user.item("status", -1);

	//blog.setDebug(out);
	if(!user.update("id = " + id)) {
		m.jsAlert("Error occurred(delete)");
		return;
	}

	m.redirect("index.jsp");
	return;
}

//Step6
p.setLayout("blog");
p.setBody("sample/admin/delete");
p.setVar("info", info);
p.setVar("form_script", f.getScript());
p.print();

%>