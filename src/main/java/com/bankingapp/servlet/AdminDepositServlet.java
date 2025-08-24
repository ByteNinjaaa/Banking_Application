package com.bankingapp.servlet;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/adminDeposit")
public class AdminDepositServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userEmail = request.getParameter("email");
        double amount = Double.parseDouble(request.getParameter("amount"));

        String dbUrl = "jdbc:mysql://localhost:3306/bankdb";
        String dbUser = "root";
        String dbPass = "tiger";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            // Update balance
            String update = "UPDATE users SET balance = balance + ? WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(update);
            ps.setDouble(1, amount);
            ps.setString(2, userEmail);
            int rowsUpdated = ps.executeUpdate();

            // Optionally insert into transactions table
            if (rowsUpdated > 0) {
                String insertTransaction = "INSERT INTO transactions (sender_email, receiver_email, amount) VALUES (?, ?, ?)";
                PreparedStatement ps2 = conn.prepareStatement(insertTransaction);
                ps2.setString(1, "admin@bank.com");  // Use your admin identifier
                ps2.setString(2, userEmail);
                ps2.setDouble(3, amount);
                ps2.executeUpdate();
                ps2.close();
            }

            ps.close();
            conn.close();

            response.sendRedirect("adminDashboard.jsp");  // You can add a success param here if needed

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}