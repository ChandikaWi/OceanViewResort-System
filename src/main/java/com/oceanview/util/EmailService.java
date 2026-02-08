/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.util;

import java.util.Properties;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.mail.*;
import javax.mail.internet.*;
import javax.mail.util.ByteArrayDataSource;

/**
 *
 * @author Chand
 */

public class EmailService {

    private static final String SENDER_EMAIL = "chandikawi17@gmail.com"; 
    private static final String SENDER_PASSWORD = "hrmnzwkvnvrfazcn"; 

    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });
    }

    public static void sendBookingConfirmation(String recipient, String name, int resId, String checkIn, String checkOut) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject("Reservation Confirmed - Ocean View Resort");

            String content = "Dear " + name + ",\n\n"
                    + "Thank you for choosing Ocean View Resort!\n"
                    + "Your reservation (ID: " + resId + ") is confirmed.\n\n"
                    + "Check-in: " + checkIn + "\n"
                    + "Check-out: " + checkOut + "\n\n"
                    + "We look forward to seeing you!";

            message.setText(content);
            Transport.send(message);
            System.out.println("Booking Email Sent Successfully.");
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public static void sendBillWithAttachment(String recipient, String name, byte[] pdfBytes) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject("Your Invoice - Ocean View Resort");

            BodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setText("Dear " + name + ",\n\nPlease find attached your invoice for your recent stay.\n\nThank you,\nOcean View Resort");

            MimeBodyPart attachmentPart = new MimeBodyPart();
            DataSource source = new ByteArrayDataSource(pdfBytes, "application/pdf");
            attachmentPart.setDataHandler(new DataHandler(source));
            attachmentPart.setFileName("Invoice.pdf");

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);
            multipart.addBodyPart(attachmentPart);

            message.setContent(multipart);
            Transport.send(message);
            System.out.println("Bill Email Sent Successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
