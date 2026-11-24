<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html"
                encoding="UTF-8"
                indent="yes"/>

    <!-- Group hotels by their location -->
    <xsl:key name="hotelsByLocation"
             match="hotel"
             use="location"/>

    <xsl:template match="/">

        <html>
        <head>
            <title>KivuStay - Hotels by Location</title>

            <style>
                body {
                    font-family: Arial, sans-serif;
                    background: #f8f7f2;
                    color: #102b35;
                    padding: 30px;
                }

                header {
                    background: #102b35;
                    color: white;
                    text-align: center;
                    padding: 30px;
                    border-radius: 12px;
                }

                .location {
                    background: white;
                    margin-top: 25px;
                    padding: 22px;
                    border-radius: 12px;
                }

                .location h2 {
                    color: #267c78;
                    border-bottom: 2px solid #e9dfca;
                    padding-bottom: 10px;
                }

                .hotel {
                    padding: 15px;
                    border-bottom: 1px solid #eee;
                }

                .rating {
                    color: #b8860b;
                    font-weight: bold;
                }

                footer {
                    text-align: center;
                    margin-top: 30px;
                    color: #777;
                }
            </style>
        </head>

        <body>

            <header>
                <h1>KivuStay</h1>
                <p>Accommodation grouped by location</p>
            </header>

            <main>

                <!-- Select each unique location once -->
                <xsl:for-each
                    select="hotels/hotel[
                    generate-id() =
                    generate-id(
                    key('hotelsByLocation', location)[1])
                    ]">

                    <xsl:sort select="location"/>

                    <section class="location">

                        <h2>
                            <xsl:value-of select="location"/>
                        </h2>

                        <!-- Display all hotels in this location -->
                        <xsl:for-each
                            select="key('hotelsByLocation', location)">

                            <xsl:sort select="name"/>

                            <div class="hotel">

                                <h3>
                                    <xsl:value-of select="name"/>
                                </h3>

                                <p>
                                    <xsl:value-of
                                        select="description"/>
                                </p>

                                <p class="rating">
                                    Rating:
                                    <xsl:value-of select="@rating"/>
                                    / 5
                                </p>

                            </div>

                        </xsl:for-each>

                    </section>

                </xsl:for-each>

            </main>

            <footer>
                KivuStay - Discover Lake Kivu
            </footer>

        </body>
        </html>

    </xsl:template>

</xsl:stylesheet>