<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:pro="http://mfelten.de/mf/profile"
                xmlns="http://mfelten.de/mf/profile" exclude-result-prefixes="pro">
  
  <xsl:output indent="yes"/>
  <xsl:param name="a" select="('../knowledge.xml')"/>
  
  <xsl:function name="pro:merge_software">
    <xsl:param name="a" as="element(pro:software)"/>
    <xsl:param name="b" as="element(pro:software)?"/>
    
    <software>
      <xsl:attribute name="relevance" select="max(($a/@relevance,$b/@relevance,5))"/>
      <xsl:for-each select="distinct-values(($a/pro:name,$b/pro:name))">
        <pro:name><xsl:value-of select="."/></pro:name>
      </xsl:for-each>
      
      <xsl:for-each select="distinct-values(($a/pro:version,$b/pro:version))">
        <pro:version><xsl:value-of select="."/></pro:version>
      </xsl:for-each>
      
      <xsl:for-each select="distinct-values(($a/pro:category,$b/pro:category))">
        <pro:category><xsl:value-of select="."/></pro:category>
      </xsl:for-each>
      
      <xsl:for-each select="distinct-values(($a/pro:manufacturer,$b/pro:manufacturer))">
        <pro:manufacturer><xsl:value-of select="."/></pro:manufacturer>
      </xsl:for-each>
    </software>
  </xsl:function>
  
  <xsl:template match="pro:profile">
    <knowledge>
      <xsl:for-each-group select="(document($a)/pro:knowledge/pro:software,//pro:software)" group-by="pro:name">
        <xsl:sort select="(pro:name)[1]"/>
        <software>
          <xsl:copy-of select="current-group()/@relevance"/>
          <xsl:copy-of select="pro:name"/>
          <xsl:for-each select="distinct-values(current-group()/pro:manufacturer)">
            <xsl:sort select="."/>
            <manufacturer>
              <xsl:value-of select="."/>
            </manufacturer>
          </xsl:for-each>
          <xsl:for-each select="distinct-values(current-group()/pro:category)">
            <xsl:sort select="."/>
            <category>
              <xsl:value-of select="."/>
            </category>
          </xsl:for-each>
          <xsl:for-each select="distinct-values(current-group()/pro:version)">
            <xsl:sort select="."/>
            <version>
              <xsl:value-of select="."/>
            </version>
          </xsl:for-each>
        </software>
      </xsl:for-each-group>
    </knowledge>
  </xsl:template>
  
</xsl:stylesheet>

