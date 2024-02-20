<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pro="http://mfelten.de/mf/profile"
  xmlns="http://mfelten.de/mf/profile" exclude-result-prefixes="pro">

  <xsl:output indent="yes"/>

  <xsl:template match="pro:knowledge">
    <knowledge>
      <xsl:for-each select="//pro:software">
        <xsl:sort select="(pro:name)[1]"/>
        <software>
          <xsl:copy-of select="@relevance"/>
          <xsl:copy-of select="pro:name"/>
          <xsl:copy-of select="pro:category"/>
          <xsl:copy-of select="pro:manufacturer"/>
          <xsl:copy-of select="pro:version"/>
        </software>
      </xsl:for-each>
    </knowledge>
  </xsl:template>

</xsl:stylesheet>
