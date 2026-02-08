/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.oceanview.controller;

import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.oceanview.dao.DBConnection;
import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.util.EmailService; 
import java.io.ByteArrayOutputStream;   
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.temporal.ChronoUnit;
import java.awt.Color;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Chand
 */

@WebServlet("/BillServlet")
public class BillServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("dashboard.jsp?error=missing_id");
            return;
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM reservations WHERE res_id = ?")) {
            
            stmt.setInt(1, Integer.parseInt(idParam));
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int resId = rs.getInt("res_id");
                String guestName = rs.getString("guest_name");
                String email = rs.getString("email");
                String roomType = rs.getString("room_type");
                Date checkIn = rs.getDate("check_in");
                Date checkOut = rs.getDate("check_out");

                long nights = ChronoUnit.DAYS.between(checkIn.toLocalDate(), checkOut.toLocalDate());
                if (nights == 0) nights = 1; 
                
                RoomTypeDAO roomDao = new RoomTypeDAO();
                BigDecimal rate = roomDao.getRoomPrice(roomType); 
                BigDecimal total = rate.multiply(new BigDecimal(nights)); 

                Document doc = new Document();
                PdfWriter.getInstance(doc, baos);
                doc.open();

                
                Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 24, Color.BLUE);
                Paragraph title = new Paragraph("OCEAN VIEW RESORT", titleFont);
                title.setAlignment(Element.ALIGN_CENTER);
                doc.add(title);
                
                Paragraph subtitle = new Paragraph("Galle, Sri Lanka | Contact: +94 11 222 3333", 
                        FontFactory.getFont(FontFactory.HELVETICA, 12, Color.GRAY));
                subtitle.setAlignment(Element.ALIGN_CENTER);
                subtitle.setSpacingAfter(20);
                doc.add(subtitle);

                doc.add(new Paragraph("______________________________________________________________________________"));
                doc.add(new Paragraph(" "));

                PdfPTable metaTable = new PdfPTable(2);
                metaTable.setWidthPercentage(100);
                metaTable.addCell(getCell("Bill To: " + guestName, PdfPCell.NO_BORDER));
                metaTable.addCell(getCell("Invoice #: " + resId, PdfPCell.NO_BORDER, Element.ALIGN_RIGHT));
                metaTable.addCell(getCell("Date: " + new java.util.Date().toString(), PdfPCell.NO_BORDER));
                metaTable.addCell(getCell("", PdfPCell.NO_BORDER));
                doc.add(metaTable);
                doc.add(new Paragraph(" "));

                PdfPTable table = new PdfPTable(4);
                table.setWidthPercentage(100);
                table.setSpacingBefore(10f);
                table.setSpacingAfter(10f);

                addHeader(table, "Description");
                addHeader(table, "Rate (USD)");
                addHeader(table, "Nights");
                addHeader(table, "Total (USD)");

                table.addCell(roomType + " Room Stay");
                table.addCell("$" + rate);
                table.addCell(String.valueOf(nights));
                table.addCell("$" + total);

                doc.add(table);

                Paragraph grandTotal = new Paragraph("GRAND TOTAL: $" + total, 
                        FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16));
                grandTotal.setAlignment(Element.ALIGN_RIGHT);
                doc.add(grandTotal);

                doc.add(new Paragraph(" "));
                doc.add(new Paragraph(" "));
                Paragraph footer = new Paragraph("Thank you for staying with us!", 
                        FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 12, Color.DARK_GRAY));
                footer.setAlignment(Element.ALIGN_CENTER);
                doc.add(footer);

                
                doc.close(); 
                
                if (email != null && !email.trim().isEmpty()) {
                    new Thread(() -> {
                        EmailService.sendBillWithAttachment(email, guestName, baos.toByteArray());
                    }).start();
                }

                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=Bill_" + resId + ".pdf");
                response.setContentLength(baos.size());
                
                response.getOutputStream().write(baos.toByteArray());
                response.getOutputStream().flush();

            } else {
                response.sendRedirect("reservations.jsp?error=not_found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private PdfPCell getCell(String text, int border) {
        PdfPCell cell = new PdfPCell(new Phrase(text));
        cell.setBorder(border);
        return cell;
    }
    
    private PdfPCell getCell(String text, int border, int align) {
        PdfPCell cell = getCell(text, border);
        cell.setHorizontalAlignment(align);
        return cell;
    }

    private void addHeader(PdfPTable table, String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, Color.WHITE)));
        cell.setBackgroundColor(Color.BLUE);
        cell.setPadding(5);
        table.addCell(cell);
    }
}
