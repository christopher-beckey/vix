<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <html>
      <head>
        <title>
          <xsl:value-of select="/SiteMonitoredProperties/@SiteName"/> - Monitored Properties
        </title>

        <link rel="stylesheet" type="text/css" href="layout.css" />
      </head>
      <body>
        <h2>
          <xsl:value-of select="/SiteMonitoredProperties/@SiteName"/> [<xsl:value-of select="/SiteMonitoredProperties/@SiteNumber"/>] Monitored Properties
        </h2>
        <br />


        <xsl:for-each select="SiteMonitoredProperties/SiteMonitoredProperty">
          <h3>
            <xsl:value-of select="@Name"/>
          </h3>
          <table border="1">
            <tr>
              <th>Value</th>
              <th>Date</th>
            </tr>

            <xsl:for-each select="History">
              <tr>
                <td>
                  <xsl:value-of select="@Value"/>
                </td>
                <td>
                  <xsl:value-of select="@Date"/>
                </td>
              </tr>
            </xsl:for-each>
            
            
          </table>
          
        </xsl:for-each>
        
        
    

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>