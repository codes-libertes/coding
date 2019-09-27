package cs;

import java.io.DataOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;
import java.util.Scanner;

public class Client {
    public static void main(String[] args) throws IOException {
        // need host and port, we want to connect to the ServerSocket at port 5001
        Socket socket = new Socket("localhost", 5001);
        System.out.println("Connexion avec le serveur!");

        // get the output stream from the socket.
        OutputStream outputStream = socket.getOutputStream();
        // create a data output stream from the output stream so we can send data through it
        DataOutputStream dataOutputStream = new DataOutputStream(outputStream);


        Scanner scanner = new Scanner(System.in);

        System.out.print("Saisir la duree: ");
        long duree = 1;
        duree = scanner.nextLong();
        System.out.print("la duree: " + duree);

        System.out.print("Saisir le debit: ");
        Integer debit = 1;
        debit = scanner.nextInt();
        System.out.print("le debit: " + debit);
        
        scanner.close();
        
        long total = 0;
        
		byte[] bytes = new byte[10 * 1024]; // 10K
	
		for (int i = 0; i < bytes.length; i++) {
			bytes[i] = 12;
		}
       
        long start = System.currentTimeMillis();
        
        boolean dureepasattente = true;
        
        while (dureepasattente) {
            // write the message we want to send
            dataOutputStream.writeUTF(bytes.toString());
            dataOutputStream.flush(); // send the message
            
			total += bytes.length;
			long cost = System.currentTimeMillis() - start;
			if (cost > 0 && System.currentTimeMillis() % 10 == 0) {
				System.out.println("nombre de paquets " + total + " octets, debit moyen: " + total / cost + "KB/s");
			}
			if (cost < duree){
				duree = duree - cost;
			}
			if (duree <= 0) {
				dureepasattente = false;
			}
        }
        
        dataOutputStream.close(); // close the output stream when we're done.

        System.out.println("Fermer client socket");
        socket.close();
    }
}