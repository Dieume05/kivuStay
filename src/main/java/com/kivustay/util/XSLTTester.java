package com.kivustay.util;

import java.io.File;

import javax.xml.XMLConstants;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class XSLTTester {

    private static final String XML_PATH =
        "C:/Users/hp/Downloads/hotels.xml";

    private static final String XSLT_FOLDER =
        "C:/Users/hp/eclipse-workspace/KivuStay/src/main/webapp/xml/xslt/";

    private static final String OUTPUT_FOLDER =
        "C:/Users/hp/Downloads/";

    public static void main(String[] args) {

        try {
            transform(
                "hotel-brochure.xsl",
                "hotel-brochure.html"
            );

            transform(
                "hotels-by-location.xsl",
                "hotels-by-location.html"
            );

            transform(
                "booking-voucher.xsl",
                "booking-voucher.txt"
            );

            System.out.println();
            System.out.println("ALL THREE XSLT TRANSFORMATIONS COMPLETED!");

        } catch (Exception e) {
            System.err.println("XSLT TRANSFORMATION FAILED:");
            e.printStackTrace();
        }
    }

    private static void transform(
            String stylesheet,
            String outputFile) throws Exception {

        TransformerFactory factory =
            TransformerFactory.newInstance();

        factory.setFeature(
            XMLConstants.FEATURE_SECURE_PROCESSING,
            true
        );

        factory.setAttribute(
            XMLConstants.ACCESS_EXTERNAL_DTD,
            ""
        );

        factory.setAttribute(
            XMLConstants.ACCESS_EXTERNAL_STYLESHEET,
            ""
        );

        File xmlFile = new File(XML_PATH);
        File xslFile = new File(XSLT_FOLDER + stylesheet);
        File resultFile = new File(OUTPUT_FOLDER + outputFile);

        if (!xmlFile.exists()) {
            throw new Exception("XML file not found: " + xmlFile);
        }

        if (!xslFile.exists()) {
            throw new Exception("XSLT file not found: " + xslFile);
        }

        Transformer transformer = factory.newTransformer(
            new StreamSource(xslFile)
        );

        transformer.transform(
            new StreamSource(xmlFile),
            new StreamResult(resultFile)
        );

        System.out.println(
            "SUCCESS: " + stylesheet +
            " -> " + resultFile.getName()
        );
    }
}