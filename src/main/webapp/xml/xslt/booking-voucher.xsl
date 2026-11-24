<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:text>========================================
          KIVUSTAY BOOKING VOUCHERS
========================================

</xsl:text>

        <xsl:for-each select="hotels/hotel/rooms/room/bookings/booking">

            <xsl:text>----------------------------------------
BOOKING VOUCHER
----------------------------------------
Booking ID: </xsl:text>
            <xsl:value-of select="@id"/>

            <xsl:text>
Hotel: </xsl:text>
            <xsl:value-of select="../../../../name"/>

            <xsl:text>
Location: </xsl:text>
            <xsl:value-of select="../../../../location"/>

            <xsl:text>
Room Number: </xsl:text>
            <xsl:value-of select="../../@number"/>

            <xsl:text>
Room Type: </xsl:text>
            <xsl:value-of select="../../@type"/>

            <xsl:text>
Check-in: </xsl:text>
            <xsl:value-of select="checkIn"/>

            <xsl:text>
Check-out: </xsl:text>
            <xsl:value-of select="checkOut"/>

            <xsl:text>
Number of Guests: </xsl:text>
            <xsl:value-of select="numberOfGuests"/>

            <xsl:text>
Booking Status: </xsl:text>
            <xsl:value-of select="status"/>

            <xsl:text>

</xsl:text>

        </xsl:for-each>

        <xsl:text>========================================
Thank you for choosing KivuStay!
Discover the beauty of Lake Kivu.
========================================
</xsl:text>

    </xsl:template>

</xsl:stylesheet>