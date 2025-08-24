<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("index.html");
        return;
    }

    String msg = (String) session.getAttribute("passwordMsg");
    session.removeAttribute("passwordMsg");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Change Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f6f6f6;
        }

        .container {
            width: 400px;
            margin: 80px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        form input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: #3498db;
            color: white;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .msg {
            text-align: center;
            color: green;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .error {
            color: red;
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <h2>Change Password</h2>
    <% if (msg != null) { %>
        <div class="msg <%= msg.startsWith("❌") ? "error" : "" %>"><%= msg %></div>
    <% } %>
    <form action="updatePassword" method="post">
        <input type="password" name="currentPassword" placeholder="Current Password" required />
        <input type="password" name="newPassword" placeholder="New Password" required />
        <input type="password" name="confirmPassword" placeholder="Confirm New Password" required />
        <button type="submit">Update Password</button>
    </form>
</div>
</body>
</html>