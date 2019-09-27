package com.mvc.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mvc.beans.Personne;

/**
 * Servlet implementation class ServletAuthentif
 */
@WebServlet("/ServletAuthentif")
public class ServletAuthentif extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ServletAuthentif() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		getServletContext().getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//System.out.println("Bienvenue");
		String login = request.getParameter("login");
		String password = request.getParameter("password");
		if (login.equals("toto") && password.equals("1234")) {
			Personne p = new Personne();
			p.setLogin(login);
			p.setPassword(password);
			p.setNom("Durand");
			p.setPrenom("Pierre");
			request.setAttribute("personne", p);
			
			String[] titres = {"Vague de froid en Europe", "Le soleil est de retour", "Mais bientôt la grisaille"};
			request.setAttribute("titres", titres);
			
			getServletContext().getRequestDispatcher("/WEB-INF/accueil.jsp").forward(request, response);
		}
		else {
			request.setAttribute("message", "Erreur d'authentification");
			getServletContext().getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
		}
	}

}
