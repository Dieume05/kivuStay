package com.kivustay.util;

import java.io.File;

import javax.xml.XMLConstants;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.xml.sax.SAXException;

public class XMLValidator {

    public static void main(String[] args) {

        String xmlPath =
                "C:/Users/hp/Downloads/hotels.xml";

        String xsdPath =
                "C:/Users/hp/eclipse-workspace/KivuStay/src/main/webapp/xml/hotels.xsd";

        try {
            SchemaFactory factory =
                    SchemaFactory.newInstance(
                            XMLConstants.W3C_XML_SCHEMA_NS_URI);

            factory.setFeature(
                    XMLConstants.FEATURE_SECURE_PROCESSING, true);

            factory.setProperty(
                    XMLConstants.ACCESS_EXTERNAL_DTD, "");

            factory.setProperty(
                    XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");

            Schema schema = factory.newSchema(new File(xsdPath));

            Validator validator = schema.newValidator();

            validator.validate(new javax.xml.transform.stream.StreamSource(
                    new File(xmlPath)));

            System.out.println(
                    "SUCCESS: hotels.xml is valid against hotels.xsd.");

        } catch (SAXException e) {

            System.out.println("VALIDATION FAILED:");
            System.out.println(e.getMessage());

        } catch (Exception e) {

            System.out.println("ERROR:");
            e.printStackTrace();
        }
    }
}