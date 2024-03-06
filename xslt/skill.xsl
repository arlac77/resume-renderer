<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:pro="http://mfelten.de/mf/profile" exclude-result-prefixes="xs xsi pro">

    <xsl:function name="pro:skills_initialize" as="element(pro:skill)*">
        <xsl:copy-of select="document($skills.url)//pro:skill" />
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
</xsl:stylesheet>