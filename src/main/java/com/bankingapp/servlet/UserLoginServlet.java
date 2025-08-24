package com.bankingapp.servlet;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class UserLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String dbUrl = "jdbc:mysql://localhost:3306/bankdb";
        String dbUser = "root";
        String dbPass = "tiger";

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            // Include role and email in the query
            String sql = "SELECT name, email, balance, role FROM users WHERE email = ? AND password = ? AND status='active'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Retrieve values from DB
                String userName = rs.getString("name");
                String userEmail = rs.getString("email");
                String role = rs.getString("role");
                double balance = rs.getDouble("balance");

                // Set session attributes
                HttpSession session = request.getSession();
                session.setAttribute("userName", userName);
                session.setAttribute("userEmail", userEmail);
                session.setAttribute("balance", balance);
                session.setAttribute("userRole", role);

                // Redirect based on role
                if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("adminDashboard.jsp");
                } else {
                    response.sendRedirect("dashboard.jsp");
                }
            } else {
                // Invalid login
                out.println("<!DOCTYPE html><html><head><title>Login Failed</title>");
                out.println("<style>");
                out.println("body { font-family: Arial; background-color: #f9f9f9; padding: 40px; }");
                out.println(".container { background: white; padding: 20px; max-width: 400px; margin: auto; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); text-align: center; }");
                out.println("h2 { color: red; }");
                out.println("</style></head><body>");
                out.println("<div class='container'>");
                out.println("<h2>Invalid Login</h2>");
                out.println("<p>Email or password is incorrect.</p>");
                out.println("</div></body></html>");
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3 style='color:red;'>Database error occurred.</h3>");
            out.println("<p>" + e.getMessage() + "</p>");
        }
    }
}