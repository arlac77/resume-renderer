<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:pro="http://mfelten.de/mf/profile" exclude-result-prefixes="xs xsi pro">

    <xsl:function name="pro:skills_initialize" as="element(pro:skill)*">
        <xsl:copy-of select="document($skills.url)//pro:skill" />
    </xsl:function>

    <xsl:function name="pro:skill" as="element(pro:skill)">
        <xsl:param name="name" as="xs:string*" />
        <xsl:variable name="skill" as="element()*" select="document($skills.url)/pro:knowledge/pro:skill[pro:name=$name]" />

        <pro:skill>
            <xsl:attribute name="relevance" select="($skill/@relevance,5)[1]" />
            <xsl:copy-of select="$skill/@*[name()!='relevance'],$skill/*" />
        </pro:skill>
    </xsl:function>

    <xsl:function name="pro:skill_with_category" as="element(pro:skill)*">
        <xsl:param name="skills" as="element(pro:skill)*"/>
        <xsl:param name="skill" as="element(pro:skill)*" />
        <xsl:param name="category" as="xs:string*" />
        <xsl:copy-of select="$skills[pro:name/text()=$skill/pro:name/text() and pro:category/text()=$category]"/>
    </xsl:function>

    <xsl:template match="pro:skill[string-length(text()) > 0]" mode="extract_skills">
        <pro:skill>
            <pro:name>
                <xsl:value-of select="text()"/>
            </pro:name>
        </pro:skill>
    </xsl:template>

    <xsl:template match="pro:skill[pro:name]" mode="extract_skills">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="text()" mode="extract_skills"/>

    <xsl:function name="pro:extract_skills" as="element(pro:skill)*">
        <xsl:param name="element"/>
        <xsl:variable name="skills" as="element(pro:skill)*">
            <xsl:apply-templates select="$element" mode="extract_skills"/>
        </xsl:variable>
        <xsl:for-each select="$skills">
            <xsl:copy-of select="pro:skill(pro:name[1])"/>
        </xsl:for-each>
    </xsl:function>

</xsl:stylesheet>