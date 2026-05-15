<%@ page language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.io.*,javax.servlet.http.*,javax.servlet.*" %>
<%
String loginError = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {
    String u = request.getParameter("uname");
    String p = request.getParameter("pwd");

    if (u == null) u = "";
    if (p == null) p = "";
    u = u.trim();

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/saga?useSSL=false&serverTimezone=UTC",
            "root",
            "123456"
        );

        ps = con.prepareStatement("SELECT username FROM user WHERE username=? AND password=?");
        ps.setString(1, u);
        ps.setString(2, p);

        rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("username", u);
            response.sendRedirect("home.html");
            return;
        } else {
            loginError = "Invalid username or password";
        }
    } catch (Exception e) {
        loginError = "Server error. Please try again.";
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Saga(Login Page)</title>
    <style>
    body{
    background-color: rgb(255, 226, 231);
    }
    .logo{
    height:50px;
    margin-left: 50px;
    margin-top: 30px;
    border-radius: 10px;
    }
    header{
    display: block;
    height: 108px;
    position:fixed;
    top:0;
    left:0;
    right:0;
    background-color: rgb(247, 209, 215);
    z-index: 5;
}
.container{
    display: flex;
    align-items: center;
    justify-content: center;

}
.login{
    margin-top: 5px;
    display:inline-flex;
    justify-content: center;
    align-items: center;
    background-color: rgb(247, 209, 215);
    border-radius: 13px;
    padding: 12px 12px 12px 12px;
    height: 300px;
    width: 250px;
 
}
.names{
    font-size: 16px;
    color: rgb(156, 75, 89) ;;
    padding-bottom: 2px;
    padding-top: 13px;
}
.box{
    border-radius: 10px;
    border-color: aliceblue;
    border-width: 0.3px;
    height: 18px;
 
}
.button{
    font-size: 13px;
     background-color:rgb(247, 209, 215) ;
    height: 30px;
    width: 60px;
    color: rgb(156, 75, 89) ;
    font-weight: 2px;
    text-decoration: solid;
    border-color: rgba(242, 199, 214, 0.9);
    border-radius: 15px;
    margin-top: 20px;
    margin-left: 120px;
    cursor: pointer;
    border-style:ridge;
}
.font{
    margin-top: 50px;
    color:  rgb(156, 75, 89) ;
    font-weight: 100;
}
.link{
       font-size: 15px;
        margin-left: 57px;
        color:  rgb(156, 75, 89) ;
            font-weight: 500;

}
p{
    font-size: 20px;
    display: flex;
    margin-top:180px;
    justify-content: center;
    color:  rgb(156, 75, 89) ;
    font-weight: 700;

   
}
.error-message
{   font-size: 14px;
    position: absolute;
    display: none;
    margin-left:230px ;
    margin-top: -30px;
    padding: 3px;
    border-radius: 10px;
    color: rgb(156, 75, 89);;
    border:0.1px solid rgba(220, 155, 166, 0.8);

}
    </style>
</head>
<body>
    <header>
       <a href="home.html"> <img class="logo" src="logo.jpeg"> </a>
    </header>
    <p>Login</p>
    <div class="container">
    <div class="login">
    <form method="post" action="login.jsp" onsubmit="return validateForm(event)">
        <div class="names">
        <label for="username">Username</label><br>
        </div> 
        <input class="box" type="text" id="username" name="uname" placeholder=" Enter Username"><br>
         <span id="username-error" class="error-message"></span>
        <div class="names"><label for="password">Password</label><br>
        </div>
        <input class="box" type="password" id="password" name="pwd" placeholder=" Enter Password"><br>
           <span id="password-error" class="error-message"></span>
        <span id="login-error" class="error-message" style="margin-top: 6px; margin-left: 0; position: static; 
        <%= loginError.isEmpty() ? "display:none;" : "display:block;" %>"><%= loginError %></span>
        <input class="button" type="submit" value="Login"><br>
        <h5 class="font">Not a user? <a class="link" href="registration.jsp">Register</a></h5>
    </form>
    </div>
    </div>
</body>
<script>
function validateForm(event) 
{
    const username = document.getElementById("username").value.trim();
    const password = document.getElementById("password").value;
    const usernameError = document.getElementById("username-error");
    const passwordError = document.getElementById("password-error");
    const loginError = document.getElementById("login-error");

    let isValid = true;
    usernameError.textContent = "";
    passwordError.textContent = "";
    usernameError.style.display = "none";
    passwordError.style.display = "none";
    loginError.style.display = "<%= loginError.isEmpty() ? "none" : "block" %>";

    if (username === "" || /\d/.test(username)) {
        usernameError.textContent = "Invalid username";
        usernameError.style.display = "block";
        isValid = false;
    }

    if (password === "" || password.length < 6) {
        passwordError.textContent = "Password must be at least 6 characters";
        passwordError.style.display = "block";
        isValid = false;
    }

    return isValid;
}
</script>
</html>
