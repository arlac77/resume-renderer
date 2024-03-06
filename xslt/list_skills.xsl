<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pro="http://mfelten.de/mf/profile"
  xmlns="http://mfelten.de/mf/profile">

  <xsl:include href="skill.xsl" />

  <xsl:output indent="yes"/>
  <xsl:param name="skills.url" select="'../skills.xml'" />

  <xsl:template match="/pro:profile">
    <xsl:apply-templates select="." mode="extract_skills"/>
  </xsl:template>
</xsl:stylesheet>