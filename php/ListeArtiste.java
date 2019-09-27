
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ListeArtiste
 */
@WebServlet("/ListeArtiste")
public class ListeArtiste extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * Default constructor. 
     */
    public ListeArtiste() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Servlet#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn=DriverManager.getConnection("jdbc:mysql://localhost/elec","elec", "elec");
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery("SELECT a.titre_album,ar.nom_artiste,g.libelle_genre FROM album a "
				+ "INNER JOIN artiste ar on ar.id=a.artiste_id "
				+ "INNER JOIN genre g on g.id = a.genre_id");

		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println(" <HEAD><TITLE>A Servlet</TITLE></HEAD>");
		out.println(" <BODY>");
		out.println("<table border='1' cellspacing='0' cellpadding='3'>");
		out.println("<tr><th>titre album</th><th>nom artiste</th><th>genre</th></tr>");
		
		while(rs.next()){
			out.println("<tr><td>" + rs.getString("titre_album") + "</td>");
			out.println("<td>" + rs.getString("nom_artiste") + "</td>");
			out.println("<td>" + rs.getString("libelle_genre") + "</td></tr>");
		}
		
		out.println("</TABLE>");
		out.println(" </BODY>");
		out.println("</HTML>");
		out.flush();
		out.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
