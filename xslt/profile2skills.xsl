<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pro="http://mfelten.de/mf/profile"
  xmlns="http://mfelten.de/mf/profile" exclude-result-prefixes="pro">

  <xsl:include href="skill.xsl" />

  <xsl:output indent="yes"/>
  <xsl:param name="skills.url" select="'../skills.xml'" />

  <xsl:template match="processing-instruction('xml-model')">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="/pro:profile">
    <xsl:variable name="extracted_skills" as="element(pro:skill)*">
      <xsl:apply-templates select="." mode="extract_skills"/>
    </xsl:variable>
    
    <knowledge>
      <xsl:for-each-group select="(document($skills.url)/pro:knowledge/pro:skill,$extracted_skills)" group-by="pro:name[1]">
        <xsl:sort select="pro:name[1]"/>
        <skill>
          <xsl:copy-of select="current-group()/@*"/>
          <xsl:copy-of select="pro:name"/>
          <xsl:for-each select="distinct-values(current-group()/pro:category)">
            <xsl:sort select="."/>
            <category>
              <xsl:value-of select="."/>
            </category>
          </xsl:for-each>
          <xsl:for-each select="distinct-values(current-group()/pro:manufacturer)">
            <xsl:sort select="."/>
            <manufacturer>
              <xsl:value-of select="."/>
            </manufacturer>
          </xsl:for-each>
          <xsl:for-each select="distinct-values(current-group()/pro:version)">
            <xsl:sort select="replace(., '[^\d\.]', '')" data-type="number"/>
            <version>
              <xsl:value-of select="."/>
            </version>
          </xsl:for-each>
        </skill>
      </xsl:for-each-group>
    </knowledge>
  
  </xsl:template>

</xsl:stylesheet>
