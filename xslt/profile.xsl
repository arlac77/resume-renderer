<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:pro="http://mfelten.de/mf/profile"
    xmlns:i18n="http://mfelten.de/mf/i18n" exclude-result-prefixes="xs xsi pro">

    <xsl:function name="pro:skill" as="element(pro:skill)">
        <xsl:param name="name" as="xs:string*" />
        <xsl:variable name="skill" as="element()*" select="document($skills.url)/pro:knowledge/pro:skill[pro:name=$name]" />

        <pro:skill>
            <xsl:attribute name="relevance" select="($skill/@relevance,5)[1]" />
            <xsl:copy-of select="$skill/@*[name()!='relevance'],$skill/*" />
        </pro:skill>
    </xsl:function>

    <xsl:template match="text()" mode="collect-skills" />

    <xsl:template match="pro:skill" mode="collect-skills">
        <skill>
            <xsl:copy-of select="@*" />
            <xsl:attribute name="name">
                <xsl:value-of select="pro:title" />
            </xsl:attribute>
        </skill>
    </xsl:template>

    <xsl:template match="pro:skill[@level]" mode="collect-skills">
        <xsl:variable name="skill" as="element(pro:skill)" select="pro:skill((@name,pro:name)[1])" />

        <xsl:choose>
            <xsl:when test="$skill[@relevance>=$relevance]">
                <skill>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$skill/pro:name[1]" />
                    </xsl:attribute>
                    <xsl:attribute name="level">
                        <xsl:value-of select="@level" />
                    </xsl:attribute>
                    <xsl:attribute name="category">
                        <xsl:value-of select="($skill/pro:category)[1]" />
                    </xsl:attribute>
                </skill>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>
                    <xsl:value-of select="$skill/pro:name[1]" />
 ,                    <xsl:value-of select="$skill/@relevance" />
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>