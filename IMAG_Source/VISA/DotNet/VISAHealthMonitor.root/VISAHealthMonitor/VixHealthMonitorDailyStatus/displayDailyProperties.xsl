<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <html>
      <head>
        <title>
          Daily Updates - <xsl:value-of select="/DailyProperties/@Date"/>
        </title>

        <link rel="stylesheet" type="text/css" href="layout.css" />
      </head>
      <body>
        <h2>
          Daily Updates - <xsl:value-of select="/DailyProperties/@Date"/>
        </h2>

        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="/DailyProperties/@Yesterday"/>
          </xsl:attribute>
          <xsl:text disable-output-escaping="yes">Yesterday</xsl:text>
        </a>
        <br />
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="/DailyProperties/@Tomorrow"/>
          </xsl:attribute>
          <xsl:text disable-output-escaping="yes">Tomorrow</xsl:text>
        </a>

        <xsl:for-each select="DailyProperties/Site">
		      <xsl:sort select="@SiteName"/>
          <h3>
            <xsl:value-of select="@SiteName"/> [<xsl:value-of select="@SiteNumber"/>]
          </h3>
          <table border="1">
            <tr>
              <th>Name</th>
              <th>Value</th>
              <th>Date</th>
            </tr>

            <xsl:for-each select="Property">
              <tr>
                <td>
                  <xsl:value-of select="@Name"/>
                </td>
                <td>
                  <xsl:value-of select="@Value"/>
                </td>
                <td>
                  <xsl:value-of select="@DateUpdated"/>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>