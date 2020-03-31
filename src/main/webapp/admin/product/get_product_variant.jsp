<%@ page contentType="text/html; charset=utf-8" %><%@ include file="../init.jsp" %><%


    ProductvariantDao productvariant = new ProductvariantDao();

    String pro_id = m.request("pro_id");

    DataSet variants = productvariant.find("product_id = " + pro_id);

    String colors = m.request("colors");
    String sizes = m.request("size");
    String price = m.request("price");
    //int sub_cat_id = m.reqInt("sub_cat_id");
    String[] color_split = colors.split(",");
    String[] size_split = sizes.split(",");


        p.setLayout("module");
        p.setBody("admin/product/product_variant");
        p.setVar("type", "product");
        p.setVar("colors", color_split);
        p.setVar("sizes", size_split);
        p.setVar("price", price);
        p.setLoop("variants", variants);
        p.print();


    //p.print(Writer module);
%>