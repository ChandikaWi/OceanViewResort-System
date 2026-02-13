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

    // EMAIL CONFIGURATION
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

    //  Booking Confirmation Email
    public static void sendBookingConfirmation(String recipient, String name, int resId, String roomType, String checkIn, String checkOut, String totalBill) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject("Reservation Confirmed - Ocean View Resort");

            StringBuilder html = new StringBuilder();
            html.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden;'>");
            
            // Header
            html.append("<div style='background-color: #0056b3; padding: 20px; text-align: center;'>");
            html.append("<h1 style='color: #ffffff; margin: 0; font-size: 24px;'>Ocean View Resort</h1>");
            html.append("</div>");
            
            // Body
            html.append("<div style='padding: 25px; background-color: #ffffff;'>");
            html.append("<h2 style='color: #333333; margin-top: 0;'>Booking Confirmation</h2>");
            html.append("<p style='color: #555555; font-size: 16px;'>Dear <strong>").append(name).append("</strong>,</p>");
            html.append("<p style='color: #555555;'>Thank you for choosing Ocean View Resort. Your reservation details are below:</p>");
            
            // Table
            html.append("<table style='width: 100%; border-collapse: collapse; margin-top: 20px; margin-bottom: 20px;'>");
            
            html.append("<tr style='background-color: #f8f9fa;'>");
            html.append("<td style='padding: 12px; border: 1px solid #e0e0e0; color: #555;'><strong>Reservation ID</strong></td>");
            html.append("<td style='padding: 12px; border: 1px solid #e0e0e0; color: #333;'>").append(resId).append("</td></tr>");
            
            html.append("<tr>");
            html.append("<td style='padding: 12px; border: 1px solid #e0e0e0; color: #555;'><strong>Guest Name</strong></td>");
            html.append("<td style='padding: 12px; border: 1px solid #e0e0e0; color: #333;'>").append(name).append("</td></tr>");

            html.append("<tr style='background-color: #f8f9fa;'>");
            html.append("<td style='padding: 12px; border: 1px solid #e0e0e0; color: #555;'><strong>Room Type</strong></td>");
            html.append("<td style='padding: 12px; border: 1px solid #e0e0e0; color: #333;'>").append(roomType).append("</td></tr>");
            
            html.append("<tr>");
            html.append("<td style='padding: 12px; border: 1px solid #e0e0e0; color: #555;'><strong>Check-in</strong></td>");
            html.append("<td style='padding: 12px; border: 1px solid #e0e0e0; color: #333;'>").append(checkIn).append("</td></tr>");
            
            html.append("<tr style='background-color: #f8f9fa;'>");
            html.append("<td style='padding: 12px; border: 1px solid #e0e0e0; color: #555;'><strong>Check-out</strong></td>");
            html.append("<td style='padding: 12px; border: 1px solid #e0e0e0; color: #333;'>").append(checkOut).append("</td></tr>");

            html.append("<tr>");
            html.append("<td style='padding: 12px; border: 1px solid #e0e0e0; color: #0056b3; font-weight: bold;'><strong>Total Bill</strong></td>");
            html.append("<td style='padding: 12px; border: 1px solid #e0e0e0; color: #0056b3; font-weight: bold;'>").append(totalBill).append("</td></tr>");
            
            html.append("</table>");
            
            html.append("<p style='color: #555;'>We look forward to welcoming you!</p>");
            html.append("<p style='color: #555;'>Best Regards,<br><strong>Ocean View Resort Management</strong></p>");
            html.append("</div>");
            
            // Footer
            html.append("<div style='background-color: #f4f4f4; text-align: center; padding: 15px; font-size: 12px; color: #888;'>");
            html.append("&copy; 2026 Ocean View Resort. All rights reserved.");
            html.append("</div></div>");

            message.setContent(html.toString(), "text/html; charset=utf-8");
            Transport.send(message);
            System.out.println("Booking Email Sent Successfully.");
            
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    //  Invoice/Bill Email 
    public static void sendBillWithAttachment(String recipient, String name, byte[] pdfBytes) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject("Your Invoice - Ocean View Resort");

            // HTML Body
            BodyPart messageBodyPart = new MimeBodyPart();
            StringBuilder html = new StringBuilder();
            
            html.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden;'>");
            
            // Header 
            html.append("<div style='background-color: #0056b3; padding: 20px; text-align: center;'>");
            html.append("<h1 style='color: #ffffff; margin: 0; font-size: 24px;'>Ocean View Resort</h1>");
            html.append("</div>");
            
            // Body Content
            html.append("<div style='padding: 25px; background-color: #ffffff;'>");
            html.append("<h2 style='color: #333333; margin-top: 0;'>Your Invoice is Ready</h2>");
            html.append("<p style='color: #555555; font-size: 16px;'>Dear <strong>").append(name).append("</strong>,</p>");
            html.append("<p style='color: #555555; line-height: 1.5;'>Thank you for choosing Ocean View Resort for your recent stay. We hope you had a wonderful experience.</p>");
            
            // Call to Action Box
            html.append("<div style='background-color: #f8f9fa; border-left: 4px solid #0056b3; padding: 15px; margin: 20px 0;'>");
            html.append("<p style='margin: 0; color: #333;'><strong>Please find your official invoice attached to this email.</strong></p>");
            html.append("</div>");
            
            html.append("<p style='color: #555555;'>If you have any questions regarding this bill, please contact our support team.</p>");
            html.append("<p style='color: #555555;'>Best Regards,<br><strong>Ocean View Resort Finance Team</strong></p>");
            html.append("</div>");
            
            // Footer
            html.append("<div style='background-color: #f4f4f4; text-align: center; padding: 15px; font-size: 12px; color: #888;'>");
            html.append("&copy; 2026 Ocean View Resort. All rights reserved.<br>Galle, Sri Lanka | +94 77 531 4055");
            html.append("</div></div>");

            messageBodyPart.setContent(html.toString(), "text/html; charset=utf-8");

            // Attachment
            MimeBodyPart attachmentPart = new MimeBodyPart();
            DataSource source = new ByteArrayDataSource(pdfBytes, "application/pdf");
            attachmentPart.setDataHandler(new DataHandler(source));
            attachmentPart.setFileName("Invoice.pdf");

            // Combine
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