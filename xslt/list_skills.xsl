<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pro="http://mfelten.de/mf/profile"
  xmlns="http://mfelten.de/mf/profile">

  <xsl:include href="skill.xsl" />

  <xsl:output indent="yes"/>
  <xsl:param name="skills.url" select="'../skills.xml'" />

  <xsl:variable name="skills" as="element(pro:skill)*" select="pro:skills_initialize()" />

  <xsl:template match="text()" />

  <xsl:template match="pro:skill">
    <xsl:copy-of select="pro:skill_with_category($skills,.,'messaging')"/>
  </xsl:template>

</xsl:stylesheet>