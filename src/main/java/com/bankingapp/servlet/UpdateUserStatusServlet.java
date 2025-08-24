package com.bankingapp.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/updateUserStatus")
public class UpdateUserStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String action = request.getParameter("action"); // block or unblock

        String newStatus = "block".equalsIgnoreCase(action) ? "blocked" : "active";

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankdb", "root", "tiger")) {
            String sql = "UPDATE users SET status = ? WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("adminUsers.jsp");
    }
}