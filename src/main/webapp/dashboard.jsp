<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    if (session == null || session.getAttribute("userName") == null) {
        response.sendRedirect("index.html");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #2c3e50, #3498db);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #fff;
        }

        .dashboard-content {
            max-width: 700px;
            margin: 80px auto;
            background-color: rgba(255, 255, 255, 0.05);
            padding: 30px;
            border-radius: 12px;
            text-align: center;
        }

        .dashboard-content h2 {
            font-size: 28px;
            margin-bottom: 15px;
            color: #fff;
        }

        .dashboard-content p {
            font-size: 16px;
            margin: 5px 0;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="dashboard-content">
        <h2>Welcome, <%= session.getAttribute("userName") %>!</h2>
        <p>Your email: <%= session.getAttribute("userEmail") %></p>
        <p>Your balance: $<%= session.getAttribute("balance") %></p>
    </div>
</body>
</html>