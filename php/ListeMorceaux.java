

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.Tableau;

/**
 * Servlet implementation class ListeMorceaux
 */
@WebServlet("/ListeMorceaux")
public class ListeMorceaux extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ListeMorceaux() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		
		String idAlbum = request.getParameter("id_album");
		
		String[] tabs = {"piste_morceau", "titre_morceau", "duree_morceau"};
		String[] tabLegends = {"numero de piste", "titre morceau", "duree morceau"};
		
		try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn=DriverManager.getConnection("jdbc:mysql://localhost/elec","elec", "elec");
		Statement stmt = conn.createStatement();
		
		StringBuilder strQuery = new StringBuilder();
		strQuery.append("SELECT * FROM morceau WHERE morceau.album_id=");
		strQuery.append(idAlbum);
		strQuery.append(" ORDER BY morceau.piste_morceau ASC");
		
		ResultSet rs = stmt.executeQuery(strQuery.toString());
		 
		Tableau tal = new Tableau(out,tabs,tabLegends,rs);
		
		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println(" <HEAD><TITLE>A Servlet</TITLE></HEAD>");
		out.println(" <BODY>");
		tal.display();
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
