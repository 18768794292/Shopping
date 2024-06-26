<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="two.domain.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="two.dao.ProductDao" %>
<%@ page import="two.dao.impl.ProductDaoImpl" %>
<%@ page import="two.dao.ProductTypeDao" %>
<%@ page import="two.domain.ProductType" %>
<%@ page import="two.dao.impl.ProductTypeDaoImpl" %>
<%
    // 从数据库获取商品列表
    ProductDao productDao = new ProductDaoImpl();
    List<Product> products;

    // 获取用户选择的商品类型参数
    String typeIdParam = request.getParameter("typeId");

    if (typeIdParam != null && !typeIdParam.isEmpty()) {
        int typeId = Integer.parseInt(typeIdParam);
        // 如果存在商品类型参数，则按类型获取产品
        products = productDao.getProductsByType(typeId);
    } else {
        // 否则获取所有产品
        products = productDao.getAllProducts();
    }

    // 获取所有商品类型
    ProductTypeDao productTypeDao = new ProductTypeDaoImpl();
    List<ProductType> productTypes = productTypeDao.getAllProductTypes();
%>
<html>
<head>
    <title>DJ冰淇淋 - 产品列表</title>
    <style>
        body {
            text-align: center;
            background-color: #f2f9f4; /* 浅蓝绿背景色 */
            font-family: Arial, sans-serif;
            color: #004d40; /* 深绿文本颜色 */
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #004d40;
            padding: 10px;
            color: #fff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
        }

        .button-container {
            position: absolute;
            top: 10px;
            left: 10px;
            display: flex;
            gap: 10px;
        }

        .button {
            background-color: #004d40;
            color: #fff;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .button:hover {
            background-color: #00352e; /* 深绿色 */
        }

        h1, h2 {
            color: #004d40; /* 深绿标题颜色 */
        }

        .product-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
            margin: 20px;
        }

        .product-card {
            width: 200px;
            margin: 10px;
            padding: 10px;
            border: 1px solid #004d40; /* 深绿边框颜色 */
            text-align: left;
        }

        img {
            max-width: 100%;
            height: auto;
        }
    </style>
    <script>
        function filterProducts() {
            // 获取用户选择的商品类型
            var selectedTypeId = document.getElementById("productTypeFilter").value;

            // 页面跳转到 products 页面并带上选择的商品类型参数
            if (selectedTypeId === "0") {
                // 用户选择了"All Categories"
                window.location.href = "products";
            } else {
                // 用户选择了具体的商品类型
                window.location.href = "products?typeId=" + selectedTypeId;
            }
        }

    </script>
</head>
<body>

<header>
    <h1>DJ海边小店 - 欢迎您选购</h1>
    <div class="button-container">
        <button class="button" onclick="redirectToCart()">我的购物车</button>
        <button class="button" onclick="redirectToOrders()">我的订单</button>
        <button class="button" onclick="redirectToMy()">我的信息</button>
        <button class="button" onclick="redirectToProductTypes()">管理商品类型</button>
        <button class="button" onclick="redirectToManageOrders()">管理订单</button>
        <button class="button" onclick="redirectToIndex()">返回登录界面</button>
    </div>
</header>

<h2>DJ海边小店 - 欢迎您选购</h2>

<label for="productTypeFilter">选择商品类型:</label>
<select id="productTypeFilter" onchange="filterProducts()">
    <option value="0">全部商品</option>
    <% for (ProductType productType : productTypes) { %>
    <option value="<%= productType.getId() %>" <% if (typeIdParam != null && typeIdParam.equals(String.valueOf(productType.getId()))) { %>selected<% } %>><%= productType.getTypeName() %></option>
    <% } %>
</select>

<form action="addProduct" method="post">
    <label for="productName">商品名称:</label>
    <input type="text" id="productName" name="productName" required><br>

    <label for="productPrice">商品价格:</label>
    <input type="text" id="productPrice" name="productPrice" required><br>

    <label for="productDescription">商品描述:</label>
    <textarea id="productDescription" name="productDescription"></textarea><br>

    <label for="productImage">商品图片URL:</label>
    <input type="text" id="productImage" name="productImage"><br>

    <label for="productStock">商品库存:</label>
    <input type="text" id="productStock" name="productStock" required><br>

    <label for="selectProductType">商品类型：</label>
    <select id="selectProductType" name="productType" required>
        <option value="" disabled selected>选择商品类型</option>
        <% for (ProductType productType : productTypes) { %>
        <option value="<%= productType.getId() %>"><%= productType.getTypeName() %></option>
        <% } %>
    </select><br>

    <input type="submit" value="添加商品">
</form>

<%
    if (products != null && !products.isEmpty()) {
        for (Product product : products) {
%>
<div class="product-container">
    <div class="product-card">
        <h3><%= product.getName() %></h3>
        <img src="<%= product.getImage() %>" alt="<%= product.getName() %> Image" width="150" height="200">
        <p><strong>价格:</strong> <%= product.getPrice() %></p>
        <p><strong>描述:</strong> <%= product.getDescription() %></p>
        <p><strong>库存:</strong> <%= product.getStock() %></p>

        <p><strong>状态:</strong> <%= product.getStatus() == 1 ? "上架" : "下架" %></p>

        <p><strong>类型:</strong> <%= product.getProductType().getTypeName() %></p>

        <form action="products" method="post">
            <input type="hidden" name="productId" value="<%= product.getId() %>">
            <input type="hidden" name="action" value="putOnSale">
            <input type="submit" value="上架">
        </form>
        <form action="products" method="post">
            <input type="hidden" name="productId" value="<%= product.getId() %>">
            <input type="hidden" name="action" value="takeOffSale">
            <input type="submit" value="下架">
        </form>
        <form action="products" method="post">
            <input type="hidden" name="productId" value="<%= product.getId() %>">
            <input type="hidden" name="action" value="editInfo">
            <input type="submit" value="编辑信息">
        </form>

        <!-- 添加到购物车按钮 -->
        <form action="addToCart" method="post">
            <input type="hidden" name="productId" value="<%= product.getId() %>">
            <input type="hidden" name="productName" value="<%= product.getName() %>">
            <input type="hidden" name="productPrice" value="<%= product.getPrice() %>">
            <label for="quantity">数量:</label>
            <input type="number" name="quantity" id="quantity" value="1" min="1">
            <input type="submit" value="添加到购物车">
        </form>
    </div>
</div>
<%
    }
} else {
%>
<p>暂无商品。</p>
<%
    }
%>

<script>
    function redirectToCart() {
        window.location.href = "cart.jsp";
        alert("跳转到我的购物车");
    }

    function redirectToOrders() {
        alert("跳转到我的订单");
        window.location.href = "orders.jsp";
    }
    function redirectToMy(){
        alert("跳转到我的信息");
        window.location.href = "my.jsp";
    }
    function redirectToProductTypes(){
        alert("跳转到商品类型管理");
        window.location.href = "productTypes.jsp";
    }
    function  redirectToManageOrders(){
        alert("跳转到订单管理");
        window.location.href = "ManageOrders.jsp";
    }
    function redirectToIndex(){
        alert("返回登录页面");
        window.location.href = "index.jsp";
    }

</script>

</body>
</html>
