<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Accueil</title>
</head>
<body>
<p>Bienvenue ${ personne.prenom } ${ personne.nom }.</p>
<hr>
<ul>
<c:forEach var="titre" items="${ titres }">
	<li><c:out value="${ titre }"></c:out></li>
</c:forEach>
</ul>
</body>
</html>