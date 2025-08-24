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
    <title>All Users</title>
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
            max-width: 1000px;
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

        button {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-danger {
            background-color: #e74c3c;
            color: white;
        }

        .btn-success {
            background-color: #2ecc71;
            color: white;
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
    <h2>All Registered Users</h2>
    <table>
        <thead>
            <tr>
                <th>User ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Balance</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankdb", "root", "tiger");

                    String query = "SELECT id, name, email, role, balance, status FROM users";
                    ps = conn.prepareStatement(query);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                        String email = rs.getString("email");
                        String userRole = rs.getString("role");
                        double balance = rs.getDouble("balance");
                        String status = rs.getString("status");
            %>
            <tr>
                <td><%= id %></td>
                <td><%= name %></td>
                <td><%= email %></td>
                <td><%= userRole %></td>
                <td>$<%= balance %></td>
                <td><%= status %></td>
                <td>
                    <% if ("active".equalsIgnoreCase(status)) { %>
                        <form method="post" action="updateUserStatus">
                            <input type="hidden" name="email" value="<%= email %>">
                            <input type="hidden" name="action" value="block">
                            <button type="submit" class="btn-danger">Block</button>
                        </form>
                    <% } else { %>
                        <form method="post" action="updateUserStatus">
                            <input type="hidden" name="email" value="<%= email %>">
                            <input type="hidden" name="action" value="unblock">
                            <button type="submit" class="btn-success">Unblock</button>
                        </form>
                    <% } %>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
        </tbody>
    </table>
</div>

</body>
</html>