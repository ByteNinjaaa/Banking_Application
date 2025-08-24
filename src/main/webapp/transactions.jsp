<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.*" %>
<%
    if (session == null || session.getAttribute("userName") == null) {
        response.sendRedirect("index.html");
        return;
    }

    String email = (String) session.getAttribute("userEmail");
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Transaction History</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f8;
        }

        .container {
            max-width: 900px;
            margin: 60px auto;
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }

        h2 {
            margin-bottom: 25px;
            color: #2c3e50;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #ecf0f1;
            color: #2c3e50;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <h2>Recent Transactions</h2>
    <table>
        <tr>
            <th>Date</th>
            <th>Sender</th>
            <th>Receiver</th>
            <th>Amount</th>
            <th>Type</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankdb", "root", "tiger");

                ps = con.prepareStatement(
                    "SELECT sender_email, receiver_email, amount, type, timestamp FROM transactions " +
                    "WHERE sender_email = ? OR receiver_email = ? ORDER BY timestamp DESC"
                );
                ps.setString(1, email);
                ps.setString(2, email);
                rs = ps.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getTimestamp("timestamp") %></td>
            <td><%= rs.getString("sender_email") %></td>
            <td><%= rs.getString("receiver_email") %></td>
            <td>$<%= rs.getDouble("amount") %></td>
            <td><%= rs.getString("type") %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        %>
    </table>
</div>
</body>
</html>