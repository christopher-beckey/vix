<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="rootPath" select="/Build/BuildProjects/@tfsPath" />
  
  <xsl:template match="Build">
    <xsl:element name="TFSImportSelectionSet">
      <xsl:element name="ServerFolderPaths">
        <xsl:apply-templates select="BuildProjects/BuildProject" />
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="BuildProject">
    <xsl:element name="Path">
      <xsl:value-of select="'$/'"/>
      <xsl:value-of select="$rootPath"/>
      <xsl:value-of select="'/'"/>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
