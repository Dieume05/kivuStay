KivuStay – XML and XSLT Documentation

1. Introduction

KivuStay uses XML to represent hotel and accommodation information. XML Schema Definition (XSD) describes the expected structure and constraints of this data, while XSLT transforms the XML into different presentation formats.

The project includes three XSLT stylesheets:

- "hotel brochure.xsl"
- "booked voucher.xsl"
- "hotels by location.xsl"

2. XML Data Source

File: "hotels (1).xml"

This file stores the hotel information used by the XML transformation features.

Its structure includes:

- Hotels and their identifying attributes.
- Hotel names, locations, descriptions and image URLs.
- Hotel amenities.
- Rooms, including room numbers, types, capacities and statuses.
- Room prices per night.
- Bookings, including dates, guest numbers and booking statuses.

The XML root element is "hotels".

3. XML Schema Definition

File: "hotel.xsd"

The XSD defines the expected structure and data constraints for the hotel XML document.

Important constraints include:

- Hotel and room identifiers must be positive integers.
- Hotel ratings must be between 1.0 and 5.0.
- Room capacity must be between 1 and 20.
- Supported room types are STANDARD, DELUXE, FAMILY and SUITE.
- Valid booking statuses are PENDING, CONFIRMED and CANCELLED.
- Valid room statuses are AVAILABLE, MAINTENANCE and INACTIVE.
- Check-in and check-out values use the XML Schema date type.

These restrictions help describe acceptable hotel and booking data.

4. Hotel Brochure Transformation

File: "hotel brochure.xsl"

Output format: HTML

This stylesheet transforms hotel XML data into an accommodation brochure.

It:

- Displays each hotel's name, location, rating and description.
- Presents amenities as styled labels.
- Generates a table containing room number, room type, capacity, price per night and room status.
- Uses embedded CSS to provide a consistent KivuStay visual design.

The stylesheet displays all room statuses; it does not filter rooms based on availability.

5. Booking Voucher Transformation

File: "booked voucher.xsl"

Output format: Plain text

This stylesheet searches for booking elements throughout the hotel XML document and generates a separate voucher section for each booking.

Each voucher contains:

- Booking ID.
- Hotel name and location.
- Room number and room type.
- Check-in and check-out dates.
- Number of guests.
- Booking status.

The stylesheet also includes a closing thank-you message for KivuStay customers.

6. Hotels by Location Transformation

File: "hotels by location.xsl"

Output format: HTML

This stylesheet organizes hotels into groups according to their location.

It uses:

- "xsl:key" to create a key for hotels based on their location.
- "key()" to retrieve hotels belonging to a location.
- "generate-id()" to select each unique location once.
- "xsl:sort" to sort locations and hotel names alphabetically.

Each location is displayed as a section containing the hotels associated with it, together with their descriptions and ratings.

This makes it easier to browse accommodation options by geographical location.

7. Technologies Used

Technology| Purpose
XML| Stores structured hotel and booking data
XSD| Defines the XML structure and data constraints
XPath| Selects elements and attributes from XML
XSLT 1.0| Transforms XML into HTML and plain text
HTML| Presents brochure and location information
CSS| Styles the generated HTML documents

8. Conclusion

The XML, XSD and XSLT components support the KivuStay accommodation platform by providing structured hotel data, defining data constraints and generating different representations of the information.

The three stylesheets demonstrate how the same XML data can be transformed into an accommodation brochure, booking vouchers and a hotel directory grouped by location.