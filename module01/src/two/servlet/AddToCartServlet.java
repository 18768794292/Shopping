package two.servlet;

import two.dao.CartDao;
import two.dao.ProductDao;
import two.dao.impl.CartDaoImpl;
import two.dao.impl.ProductDaoImpl;
import two.domain.CartItem;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
    private final CartDao cartDao = new CartDaoImpl();
    private final ProductDao productDao = new ProductDaoImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {

            int productId = Integer.parseInt(request.getParameter("productId"));


            int productStatus = productDao.getProductStatus(productId);

            if (productStatus == 1) {
                String productName = request.getParameter("productName");
                BigDecimal productPrice = new BigDecimal(request.getParameter("productPrice"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));


                cartDao.addToCart(productId, productName, productPrice, quantity);


                response.sendRedirect(request.getContextPath() + "/cart.jsp");
            } else {

                response.sendRedirect(request.getContextPath() + "/kong.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();

            response.getWriter().write("添加商品到购物车时出错");
        }
    }
}
