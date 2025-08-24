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
    <title>Transfer Money</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f8;
        }

        .container {
            max-width: 600px;
            margin: 60px auto;
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        }

        h2 {
            margin-bottom: 25px;
            color: #2c3e50;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        input, button {
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        button {
            background-color: #3498db;
            color: white;
            font-weight: bold;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="container">
        <h2>Transfer Money</h2>
        <form action="transfer" method="post">
            <input type="email" name="recipientEmail" placeholder="Recipient Email" required />
            <input type="number" name="amount" placeholder="Amount" step="0.01" required />
            <button type="submit">Send Money</button>
        </form>

        <% if (session.getAttribute("transferMsg") != null) { %>
            <p style="color: green;"><%= session.getAttribute("transferMsg") %></p>
            <% session.removeAttribute("transferMsg"); %>
        <% } %>
    </div>
</body>
</html>