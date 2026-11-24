package com.kivustay.servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import com.kivustay.dao.HotelExportDAO;

@WebServlet("/export/hotels")
public class HotelExportServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/xml");
        response.setCharacterEncoding("UTF-8");

        response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"hotels.xml\"");

        response.setHeader("Cache-Control", "no-store");

        try {
            HotelExportDAO dao =
                    new HotelExportDAO(getServletContext());

            List<Map<String, Object>> hotels =
                    dao.getHotelsForExport();

            XMLOutputFactory factory =
                    XMLOutputFactory.newInstance();

            XMLStreamWriter writer =
                    factory.createXMLStreamWriter(
                            response.getWriter());

            writer.writeStartDocument("UTF-8", "1.0");

            writer.writeComment(
                    "KivuStay accommodation data export");

            writer.writeStartElement("hotels");
            writer.writeAttribute("generatedBy", "KivuStay");
            writer.writeAttribute("version", "1.0");

            // Export each hotel.
            for (Map<String, Object> hotel : hotels) {

                writer.writeStartElement("hotel");

                writer.writeAttribute(
                        "id",
                        String.valueOf(hotel.get("hotelId")));

                writer.writeAttribute(
                        "rating",
                        String.valueOf(hotel.get("rating")));

                writer.writeComment(
                        "Hotel: " + hotel.get("hotelName"));

                writeElement(writer, "name",
                        hotel.get("hotelName"));

                writeElement(writer, "location",
                        hotel.get("location"));

                writeElement(writer, "description",
                        hotel.get("description"));

                writeElement(writer, "imageUrl",
                        hotel.get("imageUrl"));

                // Export repeated amenities.
                writer.writeStartElement("amenities");

                @SuppressWarnings("unchecked")
                List<String> amenities =
                        (List<String>) hotel.get("amenities");

                for (String amenity : amenities) {
                    writeElement(writer, "amenity", amenity);
                }

                writer.writeEndElement();

                // Export physical rooms.
                writer.writeStartElement("rooms");

                @SuppressWarnings("unchecked")
                List<Map<String, Object>> rooms =
                        (List<Map<String, Object>>) hotel.get("rooms");

                for (Map<String, Object> room : rooms) {

                    writer.writeStartElement("room");

                    writer.writeAttribute(
                            "id",
                            String.valueOf(room.get("roomId")));

                    writer.writeAttribute(
                            "number",
                            String.valueOf(room.get("roomNumber")));

                    writer.writeAttribute(
                            "type",
                            String.valueOf(room.get("roomType")));

                    writer.writeAttribute(
                            "capacity",
                            String.valueOf(room.get("capacity")));

                    writer.writeAttribute(
                            "status",
                            String.valueOf(room.get("roomStatus")));

                    writeElement(writer, "pricePerNight",
                            room.get("pricePerNight"));

                    // Export booking dates and details.
                    writer.writeStartElement("bookings");

                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> bookings =
                            (List<Map<String, Object>>) room.get("bookings");

                    for (Map<String, Object> booking : bookings) {

                        writer.writeStartElement("booking");

                        writer.writeAttribute(
                                "id",
                                String.valueOf(
                                        booking.get("bookingId")));

                        writeElement(writer, "checkIn",
                                booking.get("checkIn"));

                        writeElement(writer, "checkOut",
                                booking.get("checkOut"));

                        writeElement(writer, "numberOfGuests",
                                booking.get("numberOfGuests"));

                        writeElement(writer, "status",
                                booking.get("status"));

                        writer.writeEndElement();
                    }

                    writer.writeEndElement(); // bookings
                    writer.writeEndElement(); // room
                }

                writer.writeEndElement(); // rooms
                writer.writeEndElement(); // hotel
            }

            writer.writeEndElement(); // hotels
            writer.writeEndDocument();

            writer.flush();
            writer.close();

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to export hotel XML.", e);
        }
    }

    /**
     * Writes an XML element and safely handles null values.
     */
    private void writeElement(
            XMLStreamWriter writer,
            String elementName,
            Object value) throws XMLStreamException {

        writer.writeStartElement(elementName);

        if (value != null) {
            writer.writeCharacters(String.valueOf(value));
        }

        writer.writeEndElement();
    }
}