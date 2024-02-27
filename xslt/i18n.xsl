<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:i18n="http://mfelten.de/mf/i18n" exclude-result-prefixes="xs xsi i18n">

    <xsl:function name="i18n:lookup">
        <xsl:param name="key" />
        <xsl:variable name="i18n.entries" as="element(i18n:entry)*" select="document($bundles)//i18n:locale[@language=$lang]/i18n:group/i18n:entry" />
        <xsl:value-of select="document($bundles)//i18n:locale[@language=$lang]/i18n:group/i18n:entry[@id = $key]/@value" />
    </xsl:function>
    
</xsl:stylesheet>