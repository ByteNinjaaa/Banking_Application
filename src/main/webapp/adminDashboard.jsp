<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page session="true" %>

<%
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("userRole");

    if (userEmail == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #333;
            color: white;
            padding: 14px;
            text-align: center;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
        }

        .container {
            padding: 30px;
            text-align: center;
        }

        .box {
            background: white;
            padding: 20px;
            margin: 15px auto;
            border-radius: 8px;
            max-width: 600px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="adminDashboard.jsp">Admin Home</a>
    <a href="viewUsers.jsp">View Users</a>
    <a href="viewTransactions.jsp">View Transactions</a>
    <a href="logout.jsp">Logout</a>
</div>

<div class="container">
    <div class="box">
        <h2>Welcome Admin: <%= userName %></h2>
        <p>Email: <%= userEmail %></p>
        <p>You have admin access.</p>
        <p>Use the navigation bar above to manage users and transactions.</p>
    </div>
</div>

</body>
</html>