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
import java.sql.ResultSet;
import java.util.Base64;

/**
 *
 * @author phuho
 */
public class XMail {

    
    private static String userMail;
    private static String passMail;
    
    /**
     * Thực hiện gửi mail
     *
     * @param to là mail người nhận
     * @param content là nội dung của mail cần gửi đi
     * @param subject là tiêu đề của mail
     */    
    public static void sendMail(String to, String content, String subject) throws Exception {
        ResultSet rs = checkSetUpMailer();
        if(rs == null) {
            throw new Exception("Hệ thống chưa set up tài khoản gửi mail");
        }
        userMail = rs.getString("UsernameMailer");
        passMail = rs.getString("PasswordMailer");
        byte[] decodedBytes = Base64.getDecoder().decode(passMail);
        passMail = new String(decodedBytes);
        
        if (!userMail.equals("") && !passMail.equals("")) {
            try {
                Session session = GetSessionLogin(userMail, passMail);
                
                if(session == null) {
                    throw new Exception("Thất bại! Đã xảy ra lỗi khi gửi Email.");
                }

                MimeMessage message = new MimeMessage(session);
                message.setHeader("Content-Type", "text/plain; charset=UTF-8");
                message.setFrom(new InternetAddress(userMail));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
                message.setSubject(subject, "UTF-8");
                message.setContent(content, "text/plain; charset=UTF-8");
                MailSender.queue(message);
                XVerify.jDialog.setVisible(true);
            } catch (Exception e) {
                throw new Exception(e.getMessage());
            }
        } else {
            throw new Exception("Hệ thống chưa setup tài khoản gửi mail");
        }
    }
    
    private static Session GetSessionLogin(String userMail, String passMail) {
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
            return session;
        } catch (Exception e) {
            return null;
        }
    }
    
    public static ResultSet checkSetUpMailer() {
        ResultSet rs;
        try {
            rs = XJdbc.query("Select * from Mailer");
            if(!rs.next()) {
                return null;
            }
        } catch (Exception e) {
            return null;
        }
        return rs;
    }
}
