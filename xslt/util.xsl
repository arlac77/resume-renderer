<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:util="http:/util/">

    <xsl:function name="util:decode_version" as="xs:double*">
        <xsl:param name="version" as="xs:string"/>
        <xsl:copy-of select="(for $s in tokenize($version,'\.') return number(replace($s,'[ A-Za-z_]+','')))"/>
    </xsl:function>

    <!--
    <xsl:template match="/a">
        <xsl:for-each select="*">
            <xsl:sort select="util:decode_version(.)[1]"/>
            <xsl:sort select="util:decode_version(.)[2]"/>
            <xsl:sort select="util:decode_version(.)[3]"/>
        <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:template>
-->
</xsl:stylesheet>