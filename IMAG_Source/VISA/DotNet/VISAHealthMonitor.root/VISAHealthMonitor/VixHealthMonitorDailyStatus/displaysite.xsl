<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <head>
    <title>
      <xsl:value-of select="/Site/@SiteName"/> - Health</title>

    <link rel="stylesheet" type="text/css" href="layout.css" />
  </head>
  <body>
    <h2>
      <xsl:value-of select="/Site/@SiteName"/> [<xsl:value-of select="/Site/@SiteNumber"/>] Health Updated: <xsl:value-of select="/Site/@LastUpdated"/></h2>
    <br />

    <a>
      <xsl:attribute name="href"><xsl:value-of select="/Site/@SiteNumber" />_monitoredProperties.xml</xsl:attribute>
      View Monitored Properties History
    </a>

    <table border="1">
    <tr bgcolor="">
      <th align="left">Property</th>
      <th align="left">Value</th>
    </tr>
    <xsl:for-each select="Site/Values/Property">
    
      <tr >
  
        <td><xsl:value-of select="@name"/></td>
        <xsl:choose>
          <xsl:when test="@value != ''">
            <td>
              <xsl:value-of select="@value"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            </td>
          </xsl:otherwise>
        </xsl:choose>
        
      </tr>
    </xsl:for-each>
    </table>
    
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>