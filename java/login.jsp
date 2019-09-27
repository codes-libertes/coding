<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login</title>
<style type="text/css" media="screen">
.warning {
	color: red;
	text-decoration: bold;
}
</style>
</head>
<body>
	<p class="warning">${ message }</p>
	<form method="post" action="ServletAuthentif">
	<p>
        <label for="login">Login : </label>
        <input type="text" name="login" id="login" tabindex="10" />
      </p>
      <p>
        <label for="password">Password : </label>
        <input type="text" name="password" id="password" tabindex="20" />
      </p>
	<p>
        <input type="submit" value="Valider" />
      </p>
    </form>
    <a href="/ServletInscription">Inscription</a>
</body>
</html>