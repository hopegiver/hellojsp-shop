<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%

    FileDao file = new FileDao();


        file.item("module", f.get("module"));
        File attFile = f.saveFile("file");
        if (attFile != null) {
            file.item("file_name", attFile.getName());
        }

        int newId = file.insertWithId();


%>