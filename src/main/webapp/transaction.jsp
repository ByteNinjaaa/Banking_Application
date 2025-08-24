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
    <title>Make a Transaction</title>
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

        input, select, button {
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        button {
            background-color: #27ae60;
            color: white;
            font-weight: bold;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #1e8449;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="container">
        <h2>Make a Transaction</h2>
        <form action="transaction" method="post">
            <input type="number" name="amount" placeholder="Amount" step="0.01" required />
            <select name="type" required>
                <option value="Deposit">Deposit</option>
                <option value="Withdraw">Withdraw</option>
            </select>
            <button type="submit">Submit</button>
        </form>

        <% if (session.getAttribute("txnMsg") != null) { %>
            <p style="color: green;"><%= session.getAttribute("txnMsg") %></p>
            <% session.removeAttribute("txnMsg"); %>
        <% } %>
    </div>
</body>
</html>