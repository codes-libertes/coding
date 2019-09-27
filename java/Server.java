package cs;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

/* 
 * Main server class. This class includes main(), and is the class that listens
 * for incoming connections and starts ServerThreads to handle those connections
 *
 */
public class Server {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		try {
			// listen for incoming connections on port 5001
			ServerSocket socket = new ServerSocket(5001);
			System.out.println("Serveur ecoutant sur le port 5001");

			// loop (forever) until program is stopped
			while(true) {
				// accept a new connection
				Socket client = socket.accept();
				// start a new ServerThread to handle the connection and send
				// output to the client
				Thread thrd = new Thread(new ServerThread(client));
				thrd.start();
			}
		}
		catch (IOException ioe){
			ioe.printStackTrace();
		}
	}
}


