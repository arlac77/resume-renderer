<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:pro="http://mfelten.de/mf/profile" 
                xmlns:i18n="http://mfelten.de/mf/i18n"
                xmlns="http://mfelten.de/mf/profile" exclude-result-prefixes="pro i18n">
    
    <xsl:param name="dest" select="'build/profile'"/>
    <xsl:param name="lang" select="'de'"/>
    <xsl:param name="country" select="'de'"/>
    <xsl:param name="bundles" select="()"/>
    <xsl:param name="with_contact" select="true()"/>
    <xsl:param name="relevance" select="5" />
    <xsl:param name="from_date" select="'1966-12-14'"/>
    
    <xsl:output indent="yes"/>
    
    <xsl:function name="i18n:lookup">
        <xsl:param name="key" />
        <xsl:variable name="i18n.entries" as="element(i18n:entry)*" select="document($bundles)//i18n:locale[@language=$lang]/i18n:group/i18n:entry" />
        <xsl:value-of select="document($bundles)//i18n:locale[@language=$lang]/i18n:group/i18n:entry[@id = $key]/@value" />
    </xsl:function>
    
    
    <xsl:template match="pro:profile">
        
        <xsl:result-document href="{$dest}/Content_Types.xml">
            <Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
                <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
                <Default Extension="xml" ContentType="application/xml"/>
                <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
            </Types>
        </xsl:result-document>
        
        <xsl:result-document href="{$dest}/_rels/.rels">
            <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
                <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
            </Relationships>
        </xsl:result-document>
        
        <xsl:result-document href="{$dest}/word/_rels/document.xml.rels">
            <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
            </Relationships>
        </xsl:result-document>
        
        <xsl:result-document href="{$dest}/word/document.xml">
            <w:document xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" 
                        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" 
                        xmlns:o="urn:schemas-microsoft-com:office:office" 
                        xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" 
                        xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" 
                        xmlns:v="urn:schemas-microsoft-com:vml" 
                        xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" 
                        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" 
                        xmlns:w10="urn:schemas-microsoft-com:office:word" 
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" 
                        xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" 
                        xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" 
                        xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" 
                        xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" 
                        xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 wp14">
                <w:body>
                    <w:p w:rsidR="005F670F" w:rsidRDefault="005F79F5">
                        <w:r>
                            <w:t>Test</w:t>
                            <w:t><xsl:value-of select="pro:person/pro:postal-code" /></w:t>
                            <w:t><xsl:value-of select="pro:person/pro:city" /></w:t>
                            <w:t><xsl:value-of select="i18n:lookup(pro:person/pro:country)" /></w:t>
                        </w:r>
                        <w:bookmarkStart w:id="0" w:name="_GoBack"/>
                        <w:bookmarkEnd w:id="0"/>
                    </w:p>
                    <w:sectPr w:rsidR="005F670F">
                        <w:pgSz w:w="12240" w:h="15840"/>
                        <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="720" w:footer="720" w:gutter="0"/>
                        <w:cols w:space="720"/>
                        <w:docGrid w:linePitch="360"/>
                    </w:sectPr>
                </w:body>
            </w:document>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>

