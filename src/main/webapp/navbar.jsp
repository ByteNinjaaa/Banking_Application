<style>
    body {
        margin: 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f4f6f8;
    }

    .navbar {
        background-color: #2c3e50;
        padding: 14px 30px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: white;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    .navbar-links {
        display: flex;
        gap: 20px;
        align-items: center;
    }

    .navbar a {
        text-decoration: none;
        color: #ecf0f1;
        font-weight: 500;
        transition: color 0.3s ease;
    }

    .navbar a:hover {
        color: #1abc9c;
    }

    .logout-btn {
        background-color: #e74c3c;
        border: none;
        color: white;
        padding: 8px 16px;
        border-radius: 5px;
        cursor: pointer;
        font-weight: bold;
        transition: background-color 0.3s ease;
    }

    .logout-btn:hover {
        background-color: #c0392b;
    }
</style>

<div class="navbar">
    <div class="navbar-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="transaction.jsp">Transaction</a>
        <a href="transfer.jsp">Transfer</a>
        <a href="transactions.jsp">Transactions</a>
        <a href="changePassword.jsp">Change Password</a>
    </div>
    <form action="index.html" method="post" style="margin: 0;">
        <button type="submit" class="logout-btn">Logout</button>
    </form>
</div>