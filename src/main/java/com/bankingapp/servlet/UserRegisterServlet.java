package com.bankingapp.servlet;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/register")
public class UserRegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankdb", "root", "tiger");

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO users (name, email, password, balance, role, status) VALUES (?, ?, ?, 0, 'user', 'active')"
            );
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.executeUpdate();

            conn.close();
            response.sendRedirect("index.html");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp");
        }
    }
}