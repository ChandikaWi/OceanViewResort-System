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
import java.text.SimpleDateFormat;
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

    private static final Color OCEAN_BLUE = new Color(0, 86, 179); 
    private static final Color HEADER_TEXT = Color.WHITE;
    private static final Color BORDER_GRAY = new Color(200, 200, 200);

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
                // Fetch Data
                int resId = rs.getInt("res_id");
                String guestName = rs.getString("guest_name");
                String email = rs.getString("email");
                String roomType = rs.getString("room_type");
                Date checkIn = rs.getDate("check_in");
                Date checkOut = rs.getDate("check_out");

                // Calculations
                long nights = ChronoUnit.DAYS.between(checkIn.toLocalDate(), checkOut.toLocalDate());
                if (nights == 0) nights = 1; 
                
                RoomTypeDAO roomDao = new RoomTypeDAO();
                BigDecimal rate = roomDao.getRoomPrice(roomType); 
                BigDecimal total = rate.multiply(new BigDecimal(nights)); 
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                String todayDate = sdf.format(new java.util.Date());

                // PDF GENERATION START
                Document doc = new Document(PageSize.A4);
                PdfWriter.getInstance(doc, baos);
                doc.open();

                // TOP HEADER 
                PdfPTable headerTable = new PdfPTable(2);
                headerTable.setWidthPercentage(100);
                
                // Left: Company Info
                PdfPCell companyCell = new PdfPCell();
                companyCell.setBorder(PdfPCell.NO_BORDER);
                companyCell.addElement(new Paragraph("OCEAN VIEW RESORT", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, OCEAN_BLUE)));
                companyCell.addElement(new Paragraph("Galle, Sri Lanka", FontFactory.getFont(FontFactory.HELVETICA, 10, Color.GRAY)));
                companyCell.addElement(new Paragraph("Tel: +94 77 531 4055", FontFactory.getFont(FontFactory.HELVETICA, 10, Color.GRAY)));
                companyCell.addElement(new Paragraph("Email: info@oceanview.com", FontFactory.getFont(FontFactory.HELVETICA, 10, Color.GRAY)));
                headerTable.addCell(companyCell);

                // Right: Big "INVOICE" Text
                PdfPCell titleCell = new PdfPCell(new Paragraph("INVOICE", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 30, Color.LIGHT_GRAY)));
                titleCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titleCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleCell.setBorder(PdfPCell.NO_BORDER);
                headerTable.addCell(titleCell);
                
                doc.add(headerTable);
                doc.add(new Paragraph(" ")); 
                
                // Line Separator
                doc.add(new Paragraph("______________________________________________________________________________", FontFactory.getFont(FontFactory.HELVETICA, 10, Color.LIGHT_GRAY)));
                doc.add(new Paragraph(" ")); 

                // CUSTOMER & INVOICE DETAILS 
                PdfPTable infoTable = new PdfPTable(2);
                infoTable.setWidthPercentage(100);
                infoTable.setWidths(new float[]{1, 1}); 

                // Column 1: Bill To
                PdfPCell billToCell = new PdfPCell();
                billToCell.setBorder(PdfPCell.NO_BORDER);
                billToCell.addElement(new Paragraph("BILL TO:", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, Color.GRAY)));
                billToCell.addElement(new Paragraph(guestName.toUpperCase(), FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, Color.BLACK)));
                billToCell.addElement(new Paragraph(email, FontFactory.getFont(FontFactory.HELVETICA, 10, Color.BLACK)));
                infoTable.addCell(billToCell);

                // Column 2: Invoice Meta Data 
                PdfPTable metaInner = new PdfPTable(2);
                metaInner.setWidthPercentage(100);
                metaInner.setWidths(new float[]{40, 60}); 

                // Add Meta Rows
                addMetaRow(metaInner, "Invoice #:", String.valueOf(resId));
                addMetaRow(metaInner, "Date:", todayDate);
                addMetaRow(metaInner, "Check-In:", sdf.format(checkIn));
                addMetaRow(metaInner, "Check-Out:", sdf.format(checkOut));

                PdfPCell metaWrapper = new PdfPCell(metaInner);
                metaWrapper.setBorder(PdfPCell.NO_BORDER);
                infoTable.addCell(metaWrapper);

                doc.add(infoTable);
                doc.add(new Paragraph(" "));

                // MAIN ITEMS TABLE 
                PdfPTable table = new PdfPTable(4);
                table.setWidthPercentage(100);
                table.setWidths(new float[]{4, 1.5f, 1, 1.5f}); 
                table.setSpacingBefore(10f);

                // Table Headers 
                addHeader(table, "DESCRIPTION", Element.ALIGN_LEFT);
                addHeader(table, "RATE", Element.ALIGN_RIGHT);
                addHeader(table, "NIGHTS", Element.ALIGN_CENTER);
                addHeader(table, "AMOUNT", Element.ALIGN_RIGHT);

                // Table Data 
                addItemRow(table, roomType + " - Accommodation", "$" + rate, String.valueOf(nights), "$" + total);

                doc.add(table);

                // GRAND TOTAL SECTION
                PdfPTable totalTable = new PdfPTable(2);
                totalTable.setWidthPercentage(100);
                totalTable.setWidths(new float[]{7, 3});
                totalTable.setSpacingBefore(5f);

                PdfPCell emptyCell = new PdfPCell(new Phrase(""));
                emptyCell.setBorder(PdfPCell.NO_BORDER);
                totalTable.addCell(emptyCell);

                PdfPCell totalCell = new PdfPCell();
                totalCell.setBorder(PdfPCell.NO_BORDER); 
                totalCell.addElement(new Paragraph("TOTAL DUE", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, Color.GRAY)));
                totalCell.addElement(new Paragraph("$" + total, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, OCEAN_BLUE)));
                totalCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                totalTable.addCell(totalCell);

                doc.add(totalTable);

                // FOOTER
                doc.add(new Paragraph(" "));
                doc.add(new Paragraph(" "));
                
                Paragraph footer = new Paragraph("Thank you for choosing Ocean View Resort!", FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 12, OCEAN_BLUE));
                footer.setAlignment(Element.ALIGN_CENTER);
                doc.add(footer);

                doc.close(); 
                // PDF END
                
                // Email Thread
                if (email != null && !email.trim().isEmpty()) {
                    final String fGuestName = guestName;
                    final String fEmail = email;
                    final byte[] pdfBytes = baos.toByteArray();
                    
                    new Thread(() -> {
                        EmailService.sendBillWithAttachment(fEmail, fGuestName, pdfBytes);
                    }).start();
                }

                // Download
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=Invoice_" + resId + ".pdf");
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


    // Header Cell
    private void addHeader(PdfPTable table, String text, int align) {
        PdfPCell cell = new PdfPCell(new Phrase(text, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, HEADER_TEXT)));
        cell.setBackgroundColor(OCEAN_BLUE);
        cell.setPadding(8);
        cell.setHorizontalAlignment(align);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(PdfPCell.NO_BORDER);
        table.addCell(cell);
    }

    // Data Row
    private void addItemRow(PdfPTable table, String desc, String rate, String qty, String total) {
        table.addCell(createItemCell(desc, Element.ALIGN_LEFT));
        table.addCell(createItemCell(rate, Element.ALIGN_RIGHT));
        table.addCell(createItemCell(qty, Element.ALIGN_CENTER));
        table.addCell(createItemCell(total, Element.ALIGN_RIGHT));
    }

    private PdfPCell createItemCell(String text, int align) {
        PdfPCell cell = new PdfPCell(new Phrase(text, FontFactory.getFont(FontFactory.HELVETICA, 10)));
        cell.setPadding(8);
        cell.setHorizontalAlignment(align);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBorder(PdfPCell.BOTTOM); 
        cell.setBorderColor(BORDER_GRAY);
        return cell;
    }

    // Metadata Row 
    private void addMetaRow(PdfPTable table, String label, String value) {
        PdfPCell lbl = new PdfPCell(new Phrase(label, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.GRAY)));
        lbl.setBorder(PdfPCell.NO_BORDER);
        lbl.setHorizontalAlignment(Element.ALIGN_RIGHT);
        lbl.setPaddingBottom(4f);
        
        // Value Cell
        PdfPCell val = new PdfPCell(new Phrase(value, FontFactory.getFont(FontFactory.HELVETICA, 10, Color.BLACK)));
        val.setBorder(PdfPCell.NO_BORDER);
        val.setHorizontalAlignment(Element.ALIGN_RIGHT);
        val.setPaddingBottom(4f);
        
        table.addCell(lbl);
        table.addCell(val);
    }
}
