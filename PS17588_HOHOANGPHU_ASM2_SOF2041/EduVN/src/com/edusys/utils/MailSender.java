package com.edusys.utils;

import java.util.List;
import java.util.ArrayList;
import javax.mail.Transport;
import javax.mail.internet.MimeMessage;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author phuho
 */
public class MailSender extends Thread {

    static final List<MimeMessage> queue = new ArrayList<>();

    public static void queue(MimeMessage mail) {
        synchronized (queue) {
            queue.add(mail);
            queue.notify();
        }
        MailSender mailSender = new MailSender();
        mailSender.start();
    }

    @Override
    public void run() {
        while (true) {
            try {
                synchronized (queue) {
                    if (queue.size() > 0) {
                        try {
                            MimeMessage mail = queue.remove(0);
                            Transport.send(mail);
                        } catch (Exception e) {
                            throw new Exception(e.getMessage());
                        }
                    } else {
                        queue.wait();
                    }
                }
            } catch (Exception e) {
                MsgBox.alert(null, e.getMessage());
            }
        }
    }
}
