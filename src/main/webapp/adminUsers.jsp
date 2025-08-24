<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
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
    <title>Manage Users</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f4f6f8;
        }
        .container {
            max-width: 1000px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #2c3e50;
            color: white;
        }
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
        }
        .delete-btn {
            background-color: #e74c3c;
            color: white;
        }
        .block-btn {
            background-color: #f1c40f;
            color: black;
        }
        .unblock-btn {
            background-color: #27ae60;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Manage Users</h2>
    <table>
        <tr>
            <th>Email</th>
            <th>Name</th>
            <th>Balance</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankdb", "root", "tiger");
                String query = "SELECT email, name, balance, status FROM users WHERE role = 'user'";
                ps = conn.prepareStatement(query);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String email = rs.getString("email");
                    String name = rs.getString("name");
                    double balance = rs.getDouble("balance");
                    String status = rs.getString("status");
        %>
        <tr>
            <td><%= email %></td>
            <td><%= name %></td>
            <td>$<%= balance %></td>
            <td><%= status %></td>
            <td>
                <form action="updateUserStatus" method="post" style="display:inline;">
                    <input type="hidden" name="email" value="<%= email %>" />
                    <input type="hidden" name="action" value="<%= "active".equals(status) ? "block" : "unblock" %>" />
                    <button type="submit" class="btn <%= "active".equals(status) ? "block-btn" : "unblock-btn" %>">
                        <%= "active".equals(status) ? "Block" : "Unblock" %>
                    </button>
                </form>

                <form action="deleteUser" method="post" style="display:inline;" onsubmit="return confirm('Are you sure?');">
                    <input type="hidden" name="email" value="<%= email %>" />
                    <button type="submit" class="btn delete-btn">Delete</button>
                </form>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
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