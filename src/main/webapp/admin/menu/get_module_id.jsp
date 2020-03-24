<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%

CategoryDao category = new CategoryDao();
BlogDao blog = new BlogDao();
ContentDao content = new ContentDao();

//String module = f.get("module");
int module = m.reqInt("module");
int module_id = m.reqInt("module_id");
        if(module == 1){
            DataSet content_one = content.find("status != -1", "id, name", "id asc");
            p.setLayout("module");
            p.setBody("admin/menu/child_module");
            p.setVar("type", "content");
            p.setVar("module_id", module_id);
            p.setVar("content_list", content_one);
            p.print();
        }

        if(module == 2){

            DataSet content_one = category.find("status != -1", "id,parent_id,category_name");
            p.setLayout("module");
            p.setBody("admin/menu/child_module");
            p.setVar("type", "category");
            p.setVar("module_id", module_id);
            p.setVar("content_list", content_one);
            p.print();
        }

        if(module == 3){
            DataSet content_one = blog.find("status != -1", "id,subject");

            p.setLayout("module");
            p.setBody("admin/menu/child_module");
            p.setVar("type", "blog");
            p.setVar("module_id", module_id);
            p.setVar("content_list", content_one);
            p.print();
        }
        //p.print(Writer module);
%>