package com.kivustay.util;

import java.io.File;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class XPathTester {

    private static final String XML_PATH =
            "C:/Users/hp/Downloads/hotels.xml";

    public static void main(String[] args) {

        try {
            // Load the XML document securely.
            DocumentBuilderFactory factory =
                    DocumentBuilderFactory.newInstance();

            factory.setFeature(
                    XMLConstants.FEATURE_SECURE_PROCESSING, true);

            factory.setFeature(
                    "http://apache.org/xml/features/disallow-doctype-decl",
                    true);

            factory.setAttribute(
                    XMLConstants.ACCESS_EXTERNAL_DTD, "");

            factory.setAttribute(
                    XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");

            DocumentBuilder builder =
                    factory.newDocumentBuilder();

            Document document =
                    builder.parse(new File(XML_PATH));

            // Create XPath engine.
            XPath xpath =
                    XPathFactory.newInstance().newXPath();

            System.out.println("KIVUSTAY XPATH TEST RESULTS");
            System.out.println("===========================");

            // Query 1: Hotels with rating >= 4.0
            executeQuery(
                    xpath,
                    document,
                    "QUERY 1: Hotels with rating >= 4.0",
                    "/hotels/hotel[@rating >= 4.0]"
            );

            // Query 2: Hotels located in Gisenyi
            executeQuery(
                    xpath,
                    document,
                    "QUERY 2: Hotels located in Gisenyi",
                    "/hotels/hotel[location='Gisenyi']"
            );

            // Query 3: Rooms with capacity >= 3
            executeQuery(
                    xpath,
                    document,
                    "QUERY 3: Rooms with capacity >= 3",
                    "/hotels/hotel/rooms/room[@capacity >= 3]"
            );

            // Query 4: Confirmed bookings
            executeQuery(
                    xpath,
                    document,
                    "QUERY 4: Confirmed bookings",
                    "/hotels/hotel/rooms/room/bookings/booking[status='CONFIRMED']"
            );

            // Query 5: Available rooms costing less than 100
            executeQuery(
                    xpath,
                    document,
                    "QUERY 5: Available rooms below 100",
                    "/hotels/hotel/rooms/room[@status='AVAILABLE' and pricePerNight < 100]"
            );

        } catch (Exception e) {
            System.out.println("XPath execution failed:");
            e.printStackTrace();
        }
    }

    private static void executeQuery(
            XPath xpath,
            Document document,
            String title,
            String expression) throws Exception {

        System.out.println();
        System.out.println("--------------------------------");
        System.out.println(title);
        System.out.println("XPath: " + expression);

        NodeList results = (NodeList) xpath.evaluate(
                expression,
                document,
                XPathConstants.NODESET
        );

        System.out.println("Number of results: " + results.getLength());

        if (results.getLength() == 0) {
            System.out.println("No matching records found.");
            return;
        }

        for (int i = 0; i < results.getLength(); i++) {

            Node node = results.item(i);

            if (node instanceof Element) {

                Element element = (Element) node;

                if ("hotel".equals(element.getTagName())) {

                    System.out.println(
                            "Hotel: " +
                            element.getElementsByTagName("name")
                                   .item(0).getTextContent() +
                            " | Rating: " +
                            element.getAttribute("rating")
                    );

                } else if ("room".equals(element.getTagName())) {

                    System.out.println(
                            "Room: " +
                            element.getAttribute("number") +
                            " | Type: " +
                            element.getAttribute("type") +
                            " | Capacity: " +
                            element.getAttribute("capacity")
                    );

                } else if ("booking".equals(element.getTagName())) {

                    System.out.println(
                            "Booking ID: " +
                            element.getAttribute("id") +
                            " | Status: " +
                            element.getElementsByTagName("status")
                                   .item(0).getTextContent()
                    );
                }
            }
        }
    }
}