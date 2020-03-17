<%@ page contentType="text/html; charset=utf-8" %><%@ include file="/init.jsp" %><%
UserDao user = new UserDao();
	
	auth.destroy();
	
	m.redirect("login.jsp");
%>

</script>
