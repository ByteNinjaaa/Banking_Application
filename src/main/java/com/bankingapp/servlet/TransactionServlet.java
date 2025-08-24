package com.bankingapp.servlet;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/transaction")
public class TransactionServlet extends HttpServlet {

    // Handle Deposit / Withdraw
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("index.html");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String type = request.getParameter("type");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/bankdb", "root", "tiger");

            // Fetch current balance
            PreparedStatement ps = conn.prepareStatement("SELECT balance FROM users WHERE email = ?");
            ps.setString(1, userEmail);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                double balance = rs.getDouble("balance");

                if (type.equalsIgnoreCase("Withdraw") && amount > balance) {
                    session.setAttribute("transactionMsg", "❌ Insufficient balance.");
                    response.sendRedirect("dashboard.jsp");
                    return;
                }

                double newBalance = type.equalsIgnoreCase("Deposit") ? balance + amount : balance - amount;

                // Update balance
                PreparedStatement update = conn.prepareStatement("UPDATE users SET balance = ? WHERE email = ?");
                update.setDouble(1, newBalance);
                update.setString(2, userEmail);
                update.executeUpdate();

                // Record transaction
                PreparedStatement insert = conn.prepareStatement(
                        "INSERT INTO transactions (sender_email, receiver_email, amount, type, timestamp) VALUES (?, ?, ?, ?, NOW())");
                insert.setString(1, userEmail);
                insert.setString(2, userEmail); // Self for deposit/withdraw
                insert.setDouble(3, amount);
                insert.setString(4, type);
                insert.executeUpdate();

                session.setAttribute("balance", newBalance);
                session.setAttribute("transactionMsg", "✅ " + type + " of $" + amount + " successful. New balance: $" + newBalance);
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("transactionMsg", "❌ Transaction failed due to an error.");
        }

        response.sendRedirect("dashboard.jsp");
    }

    // Handle View Transaction History
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("index.html");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankdb", "root", "tiger");

            PreparedStatement ps = conn.prepareStatement(
                    "SELECT * FROM transactions WHERE sender_email = ? OR receiver_email = ? ORDER BY timestamp DESC"
            );
            ps.setString(1, userEmail);
            ps.setString(2, userEmail);

            ResultSet rs = ps.executeQuery();
            request.setAttribute("transactions", rs);

            RequestDispatcher rd = request.getRequestDispatcher("transactions.jsp");
            rd.forward(request, response);

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");
        }
    }
}