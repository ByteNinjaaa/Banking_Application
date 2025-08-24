<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page session="true" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("userRole");

    if (userEmail == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <title>All Transactions</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #2c3e50;
            padding: 14px 30px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar a {
            color: #ecf0f1;
            text-decoration: none;
            margin-right: 20px;
            font-weight: bold;
        }

        .navbar a:hover {
            color: #1abc9c;
        }

        .container {
            max-width: 1100px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 12px 15px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #ecf0f1;
        }

        h2 {
            color: #2c3e50;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div>
        <a href="adminDashboard.jsp">Admin Home</a>
        <a href="viewUsers.jsp">View Users</a>
        <a href="viewTransactions.jsp">View Transactions</a>
    </div>
    <div>
        <a href="logout.jsp">Logout</a>
    </div>
</div>

<div class="container">
    <h2>All Transactions</h2>
    <table>
        <tr>
            <th>Transaction ID</th>
            <th>Sender</th>
            <th>Receiver</th>
            <th>Amount ($)</th>
            <th>Date</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankdb", "root", "tiger");

                String query = "SELECT id, sender_email, receiver_email, amount, timestamp FROM transactions ORDER BY timestamp DESC";
                ps = conn.prepareStatement(query);
                rs = ps.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("sender_email") %></td>
            <td><%= rs.getString("receiver_email") %></td>
            <td>$<%= rs.getDouble("amount") %></td>
            <td><%= rs.getTimestamp("timestamp") %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
</div>

</body>
</html>