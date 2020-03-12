<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%
UserDao user = new UserDao();
	
	auth.destroy();
	
	p.setBody("admin/login");
	p.setVar("form_script", f.getScript());
	p.print();
%>

</script>
