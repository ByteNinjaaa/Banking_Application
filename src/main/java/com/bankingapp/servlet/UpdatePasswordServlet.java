package com.bankingapp.servlet;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/updatePassword")
public class UpdatePasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("index.html");
            return;
        }

        String email = (String) session.getAttribute("userEmail");
        String current = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");

        if (!newPass.equals(confirm)) {
            session.setAttribute("passwordMsg", "❌ New passwords do not match.");
            response.sendRedirect("changePassword.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/bankdb", "root", "tiger");

            PreparedStatement ps = conn.prepareStatement(
                "SELECT password FROM users WHERE email = ?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next() && current.equals(rs.getString("password"))) {
                PreparedStatement update = conn.prepareStatement(
                    "UPDATE users SET password = ? WHERE email = ?");
                update.setString(1, newPass);
                update.setString(2, email);
                update.executeUpdate();

                session.setAttribute("passwordMsg", "✅ Password updated successfully.");
            } else {
                session.setAttribute("passwordMsg", "❌ Current password is incorrect.");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("passwordMsg", "❌ Error updating password.");
        }

        response.sendRedirect("changePassword.jsp");
    }
}