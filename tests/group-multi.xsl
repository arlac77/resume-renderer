<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output indent="yes"/>

    <xsl:template match="/a">

        <xsl:for-each-group select="skill" group-by="name[1]">
            <skill>
                <xsl:for-each select="distinct-values(current-group()/name)">
                    <name>
                        <xsl:copy-of select="."/>
                    </name>
                </xsl:for-each>
            </skill>
        </xsl:for-each-group>

    </xsl:template>

</xsl:stylesheet>
