<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" indent="yes"
                encoding="UTF-8"/>

    <xsl:template match="/">

        <html>
        <head>
            <title>KivuStay - Accommodation Brochure</title>

            <style>
                body {
                    font-family: Arial, sans-serif;
                    background: #f8f7f2;
                    color: #102b35;
                    margin: 0;
                    padding: 30px;
                }

                header {
                    background: #102b35;
                    color: white;
                    padding: 35px;
                    text-align: center;
                    border-radius: 12px;
                    margin-bottom: 30px;
                }

                header h1 {
                    margin: 0;
                    font-size: 34px;
                }

                header p {
                    color: #e9dfca;
                }

                .hotel {
                    background: white;
                    padding: 25px;
                    margin-bottom: 22px;
                    border-radius: 12px;
                    box-shadow: 0 3px 12px
                                rgba(0,0,0,0.07);
                }

                .hotel h2 {
                    color: #267c78;
                    margin-top: 0;
                }

                .rating {
                    color: #b8860b;
                    font-weight: bold;
                }

                .amenities {
                    margin: 15px 0;
                }

                .amenity {
                    display: inline-block;
                    background: #e9dfca;
                    padding: 6px 12px;
                    margin: 4px;
                    border-radius: 20px;
                    font-size: 13px;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 15px;
                }

                th, td {
                    padding: 11px;
                    text-align: left;
                    border-bottom: 1px solid #eee;
                }

                th {
                    background: #267c78;
                    color: white;
                }

                footer {
                    text-align: center;
                    margin-top: 35px;
                    color: #777;
                }
            </style>
        </head>

        <body>

            <header>
                <h1>KivuStay</h1>
                <p>Discover beautiful accommodation
                   around Lake Kivu</p>
            </header>

            <main>

                <xsl:for-each select="hotels/hotel">

                    <section class="hotel">

                        <h2>
                            <xsl:value-of select="name"/>
                        </h2>

                        <p>
                            <strong>Location:</strong>
                            <xsl:value-of select="location"/>
                        </p>

                        <p class="rating">
                            Rating:
                            <xsl:value-of select="@rating"/>
                            / 5
                        </p>

                        <p>
                            <xsl:value-of select="description"/>
                        </p>

                        <h3>Amenities</h3>

                        <div class="amenities">
                            <xsl:for-each
                                select="amenities/amenity">

                                <span class="amenity">
                                    <xsl:value-of select="."/>
                                </span>

                            </xsl:for-each>
                        </div>

                        <h3>Available Room Information</h3>

                        <table>
                            <tr>
                                <th>Room Number</th>
                                <th>Room Type</th>
                                <th>Capacity</th>
                                <th>Price / Night</th>
                                <th>Status</th>
                            </tr>

                            <xsl:for-each select="rooms/room">

                                <tr>
                                    <td>
                                        <xsl:value-of
                                            select="@number"/>
                                    </td>

                                    <td>
                                        <xsl:value-of
                                            select="@type"/>
                                    </td>

                                    <td>
                                        <xsl:value-of
                                            select="@capacity"/>
                                    </td>

                                    <td>
                                        <xsl:value-of
                                            select="pricePerNight"/>
                                    </td>

                                    <td>
                                        <xsl:value-of
                                            select="@status"/>
                                    </td>
                                </tr>

                            </xsl:for-each>
                        </table>

                    </section>

                </xsl:for-each>

            </main>

            <footer>
                KivuStay Accommodation Platform
                - Lake Kivu, Rwanda
            </footer>

        </body>
        </html>

    </xsl:template>

</xsl:stylesheet>