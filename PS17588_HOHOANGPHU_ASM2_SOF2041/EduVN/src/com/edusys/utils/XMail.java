/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.edusys.utils;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author phuho
 */
public class XMail {

    

    private static String userMail = "phuhhps17588@fpt.edu.vn";
    private static String passMail = "";
    /**
     * Thực hiện gửi mail
     *
     * @param to là mail người nhận
     * @param content là nội dung của mail cần gửi đi
     * @param subject là tiêu đề của mail
     */    
    public static void sendMail(String to, String content, String subject) throws Exception {
        if (!userMail.equals("") && !passMail.equals("")) {
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

                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(userMail));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
                message.setSubject(subject);
                message.setText(content);
                MailSender.queue(message);
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("Vui lòng setup tài khoản gửi mail tại: com.edsys.utils.XMail.java");
        }
    }
}
