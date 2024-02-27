<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:pro="http://mfelten.de/mf/profile"
    xmlns:i18n="http://mfelten.de/mf/i18n" exclude-result-prefixes="xs xsi pro">

    <xsl:function name="pro:with_category" as="element(pro:software)*">
        <xsl:param name="software" as="element(pro:software)*" />
        <xsl:param name="category" as="xs:string*" />
        <xsl:copy-of select="$software[pro:category/text()=$category]"/>
    </xsl:function>
</xsl:stylesheet>