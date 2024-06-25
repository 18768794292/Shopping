package two.servlet;

import two.dao.UserDao;
import two.dao.impl.UserDaoImpl;
import two.domain.User;
import two.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private final UserDao userDao = new UserDaoImpl();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);
        User user = userDao.login(username, password);
        if (user != null) {

            request.getSession().setAttribute("user", user);

            UserService.setLoggedInUserId(user.getId());

            if (user.getRole() == 1) {

                response.sendRedirect(request.getContextPath() + "/manage.jsp");
            } else {

                response.sendRedirect(request.getContextPath() + "/main.jsp");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
