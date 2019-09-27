package cs;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.io.DataInputStream;
import java.io.InputStream;

/*
 * Individual ServerThread listens for the client to tell it what command to run, then
 * runs that command and sends the output of that command to the client
 *
 */
public class ServerThread extends Thread {
	Socket client = null;
	PrintWriter output;
	BufferedReader input;
	
	public ServerThread(Socket client) {
		this.client = client;
	}
	
	public void run() {
		System.out.print("Accepter la connexion. ");

		try {
			// get the input stream from the connected socket
	        InputStream inputStream = client.getInputStream();
	        // create a DataInputStream so we can read data from it.
	        DataInputStream dataInputStream = new DataInputStream(inputStream);
	        byte[] bytes = new byte[10240]; // 10K
	        long total = 0;
	        long start = System.currentTimeMillis();
	        
	        // read the message from the socket
		    String message = dataInputStream.readUTF();
		    total += message.length();
		    
			long cost = System.currentTimeMillis() - start;
			if (cost > 0 && System.currentTimeMillis() % 10 == 0) {
				System.out.println("nombre de paquets:" + total + " octets, debit par seconde: " + total / cost + "KB/s" + ",duree:" + cost);
			}
			
		}
		catch (IOException e) {
			e.printStackTrace();
		} 

		finally {
			// close the connection to the client
			try {
				client.close();
			}
			catch (IOException e) {
				e.printStackTrace();	
			}			
			System.out.println("Output ferme.");
		}

	}
}

