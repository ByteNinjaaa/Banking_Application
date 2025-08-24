<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
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
    <title>Deposit Money</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f8;
        }

        .container {
            max-width: 600px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #2c3e50;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        select, input[type="number"] {
            width: 100%;
            padding: 12px;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            margin-top: 20px;
            padding: 12px;
            width: 100%;
            background-color: #3498db;
            color: white;
            border: none;
            font-size: 16px;
            font-weight: bold;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background-color: #2980b9;
        }

        .success {
            color: green;
            text-align: center;
        }

        .error {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Deposit Money to User</h2>
    <form action="adminDeposit" method="post">
        <label for="email">Select User:</label>
        <select name="email" required>
            <option value="">-- Choose User --</option>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankdb", "root", "tiger");
                    String query = "SELECT email, name FROM users WHERE role = 'user'";
                    ps = conn.prepareStatement(query);
                    rs = ps.executeQuery();
                    while (rs.next()) {
            %>
                <option value="<%= rs.getString("email") %>"><%= rs.getString("name") %> - <%= rs.getString("email") %></option>
            <%
                    }
                } catch (Exception e) {
                    out.println("<option>Error loading users</option>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
        </select>

        <label for="amount">Amount to Deposit ($):</label>
        <input type="number" name="amount" step="0.01" min="1" required>

        <button type="submit">Deposit</button>
    </form>
</div>

</body>
</html>