<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:pro="http://mfelten.de/mf/profile"
  xmlns:util="http:/util/"
  xmlns="http://mfelten.de/mf/profile" exclude-result-prefixes="pro util">

  <xsl:include href="skill.xsl" />
  <xsl:include href="util.xsl" />

  <xsl:output indent="yes"/>
  <xsl:param name="skills.url" select="'../skills.xml'" />

  <xsl:template match="processing-instruction('xml-model')">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="/pro:profile">
    <xsl:variable name="skills" as="element(pro:skill)*">
      <xsl:apply-templates select="." mode="extract_skills"/>
      <xsl:copy-of select="document($skills.url)/pro:knowledge/pro:skill"/>
    </xsl:variable>

    <knowledge>
      <xsl:variable name="all" as="element()*">
      <xsl:for-each-group select="$skills" group-by="for $n in pro:name[not(@xml:lang)] return translate($n,'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ','abcdefghijklmnopqrstuvwxyzäöü')">

        <skill>
          <xsl:copy-of select="current-group()/@*"/>
          <xsl:for-each-group select="current-group()/pro:name[not(@xml:lang)]" group-by=".">
            <xsl:sort select="."/>
            <name>
              <xsl:value-of select="."/>
            </name>
          </xsl:for-each-group>
          <xsl:for-each-group select="current-group()/pro:name[@xml:lang]" group-by=".">
            <xsl:sort select="@xml:lang"/>
            <name>
              <xsl:copy-of select="@*"/>
              <xsl:value-of select="."/>
            </name>
          </xsl:for-each-group>

          <xsl:for-each select="distinct-values(current-group()/pro:category)">
            <xsl:sort select="."/>
            <category>
              <xsl:value-of select="."/>
            </category>
          </xsl:for-each>
          <xsl:for-each select="distinct-values(current-group()/pro:manufacturer)">
            <xsl:sort select="."/>
            <xsl:if test="string-length(.)&gt;0">
              <manufacturer>
                <xsl:value-of select="."/>
              </manufacturer>
            </xsl:if>
          </xsl:for-each>
          <xsl:for-each select="distinct-values(current-group()/pro:version)">
            <xsl:sort select="util:decode_version(.)[1]"/>
            <xsl:sort select="util:decode_version(.)[2]"/>
            <xsl:sort select="util:decode_version(.)[3]"/>
            <xsl:if test="string-length(.)&gt;0">
              <version>
                <xsl:value-of select="."/>
              </version>
            </xsl:if>
          </xsl:for-each>
        </skill>
      </xsl:for-each-group>
      </xsl:variable>

      <xsl:for-each-group select="$all" group-by="pro:name[1]">
        <xsl:sort select="pro:name[1]"/>
        <xsl:copy-of select="."/>
      </xsl:for-each-group>
    </knowledge>

  </xsl:template>

</xsl:stylesheet>
