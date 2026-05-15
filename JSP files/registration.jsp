<%@ page language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.io.*,javax.servlet.http.*,javax.servlet.*" %>
<%
String serverError = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {
String name = request.getParameter("name");
String email = request.getParameter("email");
String username = request.getParameter("username");
String password = request.getParameter("password");
String cpassword = request.getParameter("cpassword");
if (name == null) name = "";
if (email == null) email = "";
if (username == null) username = "";
if (password == null) password = "";
if (cpassword == null) cpassword = "";

name = name.trim();
email = email.trim();
username = username.trim();

boolean valid = true;

if (name.equals("") || name.matches(".*\\d.*")) valid = false;
if (email.equals("") || email.indexOf("@") == -1) valid = false;
if (username.equals("") || username.matches(".*\\d.*")) valid = false;
if (password.equals("") || password.length() < 6) valid = false;
if (!password.equals(cpassword)) valid = false;

if (!valid) {
    serverError = "Please enter valid details";
} else {
    Connection con = null;
    PreparedStatement checkPs = null;
    PreparedStatement insertPs = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/saga?useSSL=false&serverTimezone=UTC",
            "root",
            "123456"
        );

        checkPs = con.prepareStatement("SELECT username FROM user WHERE username=?");
        checkPs.setString(1, username);
        rs = checkPs.executeQuery();

        if (rs.next()) {
            serverError = "Username already exists";
        } else {
            insertPs = con.prepareStatement(
                "INSERT INTO user(username,password,email,name) VALUES(?,?,?,?)"
            );
            insertPs.setString(1, username);
            insertPs.setString(2, password);
            insertPs.setString(3, email);
            insertPs.setString(4, name);

            int row = insertPs.executeUpdate();

            if (row > 0) {
                response.sendRedirect("login.jsp");
                return;
            } else {
                serverError = "Registration failed";
            }
        }
    } catch (Exception e) {
        serverError = "Server error. Please try again.";
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (checkPs != null) try { checkPs.close(); } catch (Exception e) {}
        if (insertPs != null) try { insertPs.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
}
}
%>
<!DOCTYPE html>

<html lang="en"> <head> <meta charset="UTF-8"> <meta name="viewport" content="width=device-width, initial-scale=1.0"> <title>Saga(Registration Page)</title> 
<style> body{ background-color: rgb(255, 226, 231); } 
.logo{ 
display: inline-flex; 
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
 } 
.container{ 
display: flex;
 align-items: center; 
 justify-content: center;
}
.login{
margin-top:5px;
display:flex;
justify-content: center;
align-items: center;
background-color: rgb(247, 209, 215);
border-radius: 13px;
padding: 12px 12px 12px 12px;
height: 400px;
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
width: 200px;

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
margin-left: 150px;
cursor: pointer;
border-style:ridge;
}
.font{
margin-top: 50px;
color: rgb(156, 75, 89) ;
font-weight: 100;
}
.link{
font-size: 15px;
margin-left: 57px;
color: rgb(156, 75, 89) ;
font-weight: 500;

}
p{
font-size: 20px;
display: flex;
margin-top:180px;
justify-content: center;
color: rgb(156, 75, 89) ;
font-weight: 700;
}
.error-message
{ font-size: 14px;
position: absolute;
display: none;
margin-left:255px ;
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
 <a href="home.html"> 
 <img class="logo" src="logo.jpeg"> </a> 
 </header> 
 <p>Register</p>
  <div class="container"> 
  <div class="login"> 
  <form method="post" action="registration.jsp" onsubmit="return validateForm()"> 
  <div class="names"><label for="Name">Name</label><br></div> 
  <input class="box" type="text" id="name" name="name" placeholder=" Enter Name"><br> 
  <span id="name-error" class="error-message"></span>
      <div class="names"><label for="Email">Email</label><br></div>
    <input class="box" type="text" id="email" name="email" placeholder=" Enter Email"><br>
    <span id="email-error" class="error-message"></span>

    <div class="names"><label for="Username">Username</label><br></div>
    <input class="box" type="text" id="username" name="username" placeholder=" Enter Username"><br>
    <span id="username-error" class="error-message"></span>

    <div class="names"><label for="Password">Password</label><br></div>
    <input class="box" type="password" id="password" name="password" placeholder=" Enter Password"><br>
    <span id="password-error" class="error-message"></span>

    <div class="names"><label for="ComfirmPassword">Confirm Password</label><br></div>
    <input class="box" type="password" id="cpassword" name="cpassword" placeholder=" Confirm Password"><br>
    <span id="cpassword-error" class="error-message"></span>

    <span id="server-error" class="error-message" style="margin-top: 6px; margin-left: 0; position: static; <%= serverError.equals("") ? "display:none;" : "display:block;" %>"><%= serverError %></span>

    <input class="button" type="submit" value="Done"><br>
    <h5 class="font">Already have an account? <a class="link" href="login.jsp">Login</a></h5>
</form>
</div>
</div>
</body> 
</html> 
<script>
// Handle server error for existing user
window.addEventListener('load', function() {
    const serverError = document.getElementById("server-error");
    if (serverError && serverError.textContent.includes("already exists")) {
        alert("User already exists! Please login.");
        window.location.href = "login.jsp";
    }
});

function validateForm() {
    const name = document.getElementById("name").value;
    const email = document.getElementById("email").value;
    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;
    const cpassword = document.getElementById("cpassword").value;

    const nameError = document.getElementById("name-error");
    const emailError = document.getElementById("email-error");
    const usernameError = document.getElementById("username-error");
    const passwordError = document.getElementById("password-error");
    const cpasswordError = document.getElementById("cpassword-error");

    nameError.textContent = "";
    emailError.textContent = "";
    usernameError.textContent = "";
    passwordError.textContent = "";
    cpasswordError.textContent = "";

    let isValid = true;

    if (name === "" || /\d/.test(name)) {
        nameError.textContent = " Please enter your name properly.";
        nameError.style.display = "block";
        isValid = false;
    } else {
        nameError.style.display = "none";
    }

    if (email === "" || !email.includes("@")) {
        emailError.textContent = " Please enter a valid email address.";
        emailError.style.display = "block";
        isValid = false;
    } else {
        emailError.style.display = "none";
    }

    if (username === "" || /\d/.test(username)) {
        usernameError.textContent = " Please enter a proper username";
        usernameError.style.display = "block";
        isValid = false;
    } else {
        usernameError.style.display = "none";
    }

    if (password === "" || password.length < 6) {
        passwordError.textContent = " Password must have atleast 6 characters.";
        passwordError.style.display = "block";
        isValid = false;
    } else {
        passwordError.style.display = "none";
    }

    if (cpassword === "" || cpassword !== password) {
        cpasswordError.textContent = " Please make sure your passwords match.";
        cpasswordError.style.display = "block";
        isValid = false;
    } else {
        cpasswordError.style.display = "none";
    }

    return isValid;
}
</script>
