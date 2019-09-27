

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.TableUtil;

/**
 * Servlet implementation class ListeAlbumGetField
 */
@WebServlet("/ListeAlbumGetField")
public class ListeAlbumGetField extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ListeAlbumGetField() {
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
	
		
		try {
			TableUtil talbleUtilArtiste = new TableUtil("artiste");
			TableUtil talbleUtilAlbum = new TableUtil("album");
			TableUtil talbleUtilGenre = new TableUtil("genre");
			
			out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
			out.println("<HTML>");
			out.println(" <HEAD><TITLE>A Servlet</TITLE></HEAD>");
			out.println(" <BODY>");
			out.println("<table border='1' cellspacing='0' cellpadding='3'>");
			out.println("<tr><th>titre_album</th><th>nom artiste</th><th>genre</th></tr>");
			
			for(int i=1 ;i <= 3 ; i++){
				out.println("<tr><td>" + talbleUtilAlbum.getFieldValue("titre_album",i) + "</td>");
				out.println("<td>" + talbleUtilArtiste.getFieldValue("nom_artiste",i) + "</td>");
				out.println("<td>" + talbleUtilGenre.getFieldValue("libelle_genre",i) + "</td></tr>");
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
