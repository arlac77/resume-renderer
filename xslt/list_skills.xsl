<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pro="http://mfelten.de/mf/profile"
  xmlns="http://mfelten.de/mf/profile" exclude-result-prefixes="pro">

  <xsl:include href="knowledge.xsl" />

  <xsl:output indent="yes"/>
  <xsl:param name="knowledge" select="'../knowledge.xml'" />

  <xsl:template match="text()" />

  <xsl:template match="pro:knowledge">
    <xsl:copy-of select="pro:with_category(pro:software,'os')"/>
  </xsl:template>

  </xsl:stylesheet>