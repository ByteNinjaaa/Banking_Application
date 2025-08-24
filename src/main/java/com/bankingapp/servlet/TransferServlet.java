package com.bankingapp.servlet;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/transfer")
public class TransferServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("index.html");
            return;
        }

        String senderEmail = (String) session.getAttribute("userEmail");
        String recipientEmail = request.getParameter("recipientEmail");
        double amount = Double.parseDouble(request.getParameter("amount"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankdb", "root", "tiger");
            conn.setAutoCommit(false);

            PreparedStatement getSender = conn.prepareStatement("SELECT balance FROM users WHERE email = ?");
            getSender.setString(1, senderEmail);
            ResultSet senderRs = getSender.executeQuery();

            if (!senderRs.next()) {
                session.setAttribute("transferMsg", "Sender not found.");
                response.sendRedirect("dashboard.jsp");
                return;
            }

            double senderBalance = senderRs.getDouble("balance");
            if (amount <= 0 || senderBalance < amount) {
                session.setAttribute("transferMsg", "Insufficient balance or invalid amount.");
                response.sendRedirect("dashboard.jsp");
                return;
            }

            PreparedStatement getRecipient = conn.prepareStatement("SELECT balance FROM users WHERE email = ?");
            getRecipient.setString(1, recipientEmail);
            ResultSet recipientRs = getRecipient.executeQuery();

            if (!recipientRs.next()) {
                session.setAttribute("transferMsg", "Recipient not found.");
                response.sendRedirect("dashboard.jsp");
                return;
            }

            double recipientBalance = recipientRs.getDouble("balance");

            PreparedStatement deductSender = conn.prepareStatement("UPDATE users SET balance = ? WHERE email = ?");
            deductSender.setDouble(1, senderBalance - amount);
            deductSender.setString(2, senderEmail);
            deductSender.executeUpdate();

            PreparedStatement addRecipient = conn.prepareStatement("UPDATE users SET balance = ? WHERE email = ?");
            addRecipient.setDouble(1, recipientBalance + amount);
            addRecipient.setString(2, recipientEmail);
            addRecipient.executeUpdate();

            PreparedStatement insertStmt = conn.prepareStatement(
                "INSERT INTO transactions (sender_email, receiver_email, amount, type, timestamp) VALUES (?, ?, ?, 'transfer', NOW())");
            insertStmt.setString(1, senderEmail);
            insertStmt.setString(2, recipientEmail);
            insertStmt.setDouble(3, amount);
            insertStmt.executeUpdate();

            conn.commit();
            conn.close();

            session.setAttribute("balance", senderBalance - amount);
            session.setAttribute("transferMsg", "✅ Transfer Successful. Remaining Balance is: $" + (senderBalance - amount));

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("transferMsg", "Transfer failed due to an error.");
        }

        response.sendRedirect("transfer.jsp");
    }
}