/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication24;

import com.sun.jdi.connect.Transport;
import java.util.Properties;
import javax.swing.JOptionPane;
import java.mail.*;

/**
 *
 * @author phuho
 */
public class JavaApplication24 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        String userMail = "phuhhps177588@fpt.edu.vn";
        String passMail = "phuokok123";
        if(!userMail.equals("") ||
            !passMail.equals("") ) {
            try {
                Properties properties = new Properties();
                properties.put("mail.smtp.auth", "true");
                properties.put("mail.smtp.starttls.enable", "true");
                properties.put("mail.smtp.host", "smtp.gmail.com");
                properties.put("mail.smtp.port", 587);
                
                Session session = Session.getInstance(properties,
                        new javax.mail.Authenticator() {
                            protected PasswordAuthentication getPasswordAuthentication() {
                                return new PasswordAuthentication(userMail, passMail);
                            }
                        });
               
                
                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(userMail));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
                message.setSubject(subject);
                message.setText(content);
                Transport.send(message);
            } catch (Exception e) {
                JOptionPane.showMessageDialog(null, e.getMessage(), "Message", JOptionPane.ERROR_MESSAGE);
            }
        }
    }
    
}
