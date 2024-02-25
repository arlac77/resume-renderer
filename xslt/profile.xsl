<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:pro="http://mfelten.de/mf/profile"
    xmlns:i18n="http://mfelten.de/mf/i18n" exclude-result-prefixes="xs xsi pro i18n">

    <xsl:function name="pro:software" as="element(pro:software)">
        <xsl:param name="name" as="xs:string*" />
        <xsl:variable name="software" as="element()*" select="document($knowledge)/pro:knowledge/pro:software[pro:name=$name]" />

        <pro:software>
            <xsl:attribute name="relevance" select="($software/@relevance,5)[1]" />
            <xsl:copy-of select="$software/@*[name()!='relevance'],$software/*" />
        </pro:software>
    </xsl:function>

    <xsl:function name="i18n:lookup">
        <xsl:param name="key" />
        <xsl:variable name="i18n.entries" as="element(i18n:entry)*" select="document($bundles)//i18n:locale[@language=$lang]/i18n:group/i18n:entry" />
        <xsl:value-of select="document($bundles)//i18n:locale[@language=$lang]/i18n:group/i18n:entry[@id = $key]/@value" />
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

    <xsl:template match="pro:software[@skill]" mode="collect-skills">
        <xsl:variable name="software" as="element(pro:software)" select="pro:software((@name,pro:name)[1])" />

        <xsl:choose>
            <xsl:when test="$software[@relevance>=$relevance]">
                <skill>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$software/pro:name[1]" />
                    </xsl:attribute>
                    <xsl:attribute name="level">
                        <xsl:value-of select="@skill" />
                    </xsl:attribute>
                    <xsl:attribute name="category">
                        <xsl:value-of select="($software/pro:category)[1]" />
                    </xsl:attribute>
                </skill>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>
                    <xsl:value-of select="$software/pro:name[1]" />
 ,                    <xsl:value-of select="$software/@relevance" />
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>