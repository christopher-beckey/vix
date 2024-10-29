<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <head>
    <title>VIX Daily Status</title>

    <link rel="stylesheet" type="text/css" href="layout.css" />
  </head>
  <body>
    <h2>VIX Health Updated: <xsl:value-of select="/VixHealth/Sites/@DateUpdated"/></h2>
    <xsl:choose>
      <xsl:when test="/VixHealth/Sites/@CsvFile != ''">
        <a>
          <xsl:attribute name="href"><xsl:value-of select="/VixHealth/Sites/@CsvFile"/></xsl:attribute>      
          <xsl:text disable-output-escaping="yes">CSV Output</xsl:text>           
        </a>
      </xsl:when>
    </xsl:choose>
    <br />
    <xsl:value-of select="/VixHealth/Sites/@VixSites"/> VIX Sites
    
    
    <table border="1">
    <tr bgcolor="">
      <th align="left">Site Name</th>
      <th align="left">Site Number</th>
      <th align="left">Version</th>
      <th align="left">Last Loaded</th>
      <th align="left">Health Requests</th>
      <th align="left">Successful Health Requests</th>
      <th align="left">Percent Successful</th>
      <th align="left">Error</th>
    </tr>
    <xsl:for-each select="VixHealth/Sites/Site">
    
      <tr >
        <xsl:choose>
        <xsl:when test="@SiteUrl != ''">
          <td>
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="@SiteUrl" />
              </xsl:attribute>
              <xsl:value-of select="@Name"/>
            </a>            
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td>
            <xsl:value-of select="@Name"/>
          </td>
        </xsl:otherwise>
      </xsl:choose>
        <td><xsl:value-of select="@Number"/></td>
        
        <xsl:choose>
          <xsl:when test="@Version != ''">
            <td>
              <xsl:value-of select="@Version"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            </td>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
          <xsl:when test="@LastLoaded != ''">
            <td>
              <xsl:value-of select="@LastLoaded"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            </td>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
          <xsl:when test="@HealthLoadedCount != ''">
            <td>
              <xsl:value-of select="@HealthLoadedCount"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            </td>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
          <xsl:when test="@SuccessfulHealthLoadedCount != ''">
            <td>
              <xsl:value-of select="@SuccessfulHealthLoadedCount"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            </td>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
          <xsl:when test="@SuccessfulHealthLoadedPercent != ''">
            <td>
              <xsl:value-of select="@SuccessfulHealthLoadedPercent"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            </td>
          </xsl:otherwise>
        </xsl:choose>
        
        <xsl:choose>
          <xsl:when test="@Error != ''">
            <td>
              <xsl:value-of select="@Error"/>
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

    <h2>Daily Properties</h2>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="/VixHealth/Sites/@DailyPropertiesUrl"/>
      </xsl:attribute>
      <xsl:text disable-output-escaping="yes">Daily Properties</xsl:text>
    </a>
    
    <h2>Version Counts</h2>
    <table border="1">
      <tr>
        <th>Version</th>
        <th>Count</th>
      </tr>
      <xsl:for-each select="VixHealth/Statistics/Versions/Version">
    
        <tr>
          <td><xsl:value-of select="@Version"/></td>
          <td><xsl:value-of select="@Count"/></td>
        </tr>
       </xsl:for-each>
    </table>

    <h2>Statistics</h2>
    <table border="1">
      <tr bgcolor="">
        <th align="left">Property</th>
        <th align="left">Value</th>
      </tr>

      <xsl:for-each select="VixHealth/Statistics/Values/Property">
        <tr >
          <td>
            <xsl:value-of select="@name"/>
          </td>
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