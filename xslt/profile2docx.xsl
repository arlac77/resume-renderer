<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:pro="http://mfelten.de/mf/profile"
    xmlns:i18n="http://mfelten.de/mf/i18n"
    xmlns="http://mfelten.de/mf/profile" exclude-result-prefixes="pro i18n">

    <xsl:include href="profile.xsl" />
    <xsl:include href="skill.xsl" />
    <xsl:include href="i18n.xsl" />

    <xsl:param name="dest" select="'build/profile'" />
    <xsl:param name="lang" select="'de'" />
    <xsl:param name="bundles" select="'../i18n/profile.xml'" />
    <xsl:param name="resources" select="'../resources'" />
    <xsl:param name="skills.url" select="'../skills.xml'" />
    <xsl:param name="with_contact" select="true()" />
    <xsl:param name="relevance" select="5" />
    <xsl:param name="from_date" select="'1970-01-01'" />

    <xsl:variable name="skill" as="element(pro:skill)*" select="pro:skills_initialize()" />

    <xsl:output indent="yes" />

    <xsl:template match="pro:profile">
        <xsl:result-document href="{$dest}/[Content_Types].xml">
            <Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
                <Default Extension="xml" ContentType="application/xml" />
                <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml" />
                <Default Extension="jpeg" ContentType="image/jpeg" />
                <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml" />
                <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml" />
                <Override PartName="/word/settings.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml" />
                <Override PartName="/word/webSettings.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.webSettings+xml" />
                <Override PartName="/word/fontTable.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.fontTable+xml" />
                <Override PartName="/word/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml" />
                <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml" />
                <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml" />
            </Types>
        </xsl:result-document>

        <xsl:result-document href="{$dest}/docProps/core.xml">
            <cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                <dc:creator>
                    <xsl:value-of select="pro:person/pro:name" />
                    <xsl:value-of select="pro:person/pro:surname" />
                </dc:creator>
                <cp:lastModifiedBy>
                    <xsl:value-of select="pro:person/pro:name" />
                    <xsl:value-of select="pro:person/pro:surname" />
                </cp:lastModifiedBy>
                <cp:revision>
                    <xsl:value-of select="pro:version" />
                </cp:revision>
                <dcterms:created xsi:type="dcterms:W3CDTF">2012-08-07T00:00:00Z</dcterms:created>
                <dcterms:modified xsi:type="dcterms:W3CDTF">2019-12-05T00:00:00Z</dcterms:modified>
            </cp:coreProperties>
        </xsl:result-document>

        <xsl:result-document href="{$dest}/docProps/app.xml">
            <Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties"
                xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
                <Application>profile2docx</Application>
                <DocSecurity>0</DocSecurity>
                <ScaleCrop>false</ScaleCrop>
                <Company>
                    <xsl:value-of select="pro:person/pro:name" />
                    <xsl:value-of select="pro:person/pro:surname" />
                </Company>
                <LinksUpToDate>false</LinksUpToDate>
                <SharedDoc>false</SharedDoc>
                <HyperlinksChanged>false</HyperlinksChanged>
                <AppVersion>1.0</AppVersion>
            </Properties>
        </xsl:result-document>

        <xsl:result-document href="{$dest}/_rels/.rels">
            <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
                <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml" />
            </Relationships>
        </xsl:result-document>

        <xsl:result-document href="{$dest}/word/styles2.xml">
            <w:styles xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml"
                xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml"
                xmlns:w16cex="http://schemas.microsoft.com/office/word/2018/wordml/cex"
                xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid"
                xmlns:w16="http://schemas.microsoft.com/office/word/2018/wordml"
                xmlns:w16sdtdh="http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash"
                xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" mc:Ignorable="w14 w15 w16se w16cid w16 w16cex w16sdtdh">
                <w:style w:type="paragraph" w:styleId="ListBullet">
                    <w:name w:val="List Bullet"/>
                    <w:basedOn w:val="Normal"/>
                    <w:uiPriority w:val="10"/>
                    <w:qFormat/>
                    <w:rsid w:val="00E3618F"/>
                    <w:pPr>
                        <w:numPr>
                            <w:numId w:val="1"/>
                        </w:numPr>
                        <w:contextualSpacing/>
                    </w:pPr>
                    <w:rPr>
                        <w:color w:val="404040" w:themeColor="text1" w:themeTint="BF"/>
                    </w:rPr>
                </w:style>
            </w:styles>
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
                xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                xmlns:w10="urn:schemas-microsoft-com:office:word"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup"
                xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk"
                xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
                xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
                <w:body>
                    <w:p>
                        <w:r>
                            <w:t>
                                <xsl:value-of select="concat(pro:person/pro:postal-code, ' ', pro:person/pro:city)" />
                            </w:t>
                        </w:r>
                    </w:p>
                    <w:p>
                        <w:r>
                            <w:t>
                                <xsl:value-of select="i18n:lookup(pro:person/pro:country)" />
                            </w:t>
                        </w:r>
                    </w:p>
                    <w:sectPr w:rsidR="0001">
                        <w:pgSz w:w="12240" w:h="15840" />
                        <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="720" w:footer="720" w:gutter="0" />
                        <w:cols w:space="720" />
                        <w:docGrid w:linePitch="360" />
                    </w:sectPr>

                    <w:tc>
                        <w:tcPr>
                            <w:tcW w:w="10080" w:type="dxa"/>
                            <w:gridSpan w:val="3"/>
                        </w:tcPr>
                        <w:p>
                            <w:pPr>
                                <w:pStyle w:val="Heading1"/>
                            </w:pPr>
                            <w:sdt>
                                <w:sdtContent>
                                    <w:r>
                                        <w:t>Skills</w:t>
                                    </w:r>
                                </w:sdtContent>
                            </w:sdt>
                        </w:p>
                    </w:tc>

                    <xsl:variable name="extracted_skills" as="element(pro:skill)*">
                        <xsl:apply-templates select="." mode="extract_skills"/>
                    </xsl:variable>

                    <xsl:for-each-group select="$extracted_skills" group-by="@name">
                        <xsl:sort select="@category" />
                        <xsl:sort select="@level" />
                        <xsl:sort select="@name" />
                        <w:p>
                            <w:pPr>
                                <w:pStyle w:val="ListBullet"/>
                            </w:pPr>

                            <w:r>
                                <w:t>
                                    <xsl:value-of select="@name" />
                                </w:t>
                                <w:t>
                                    <xsl:value-of select="' '" />
                                </w:t>
                                <w:t>
                                    <xsl:value-of select="i18n:lookup(@level)" />
                                </w:t>
                            </w:r>
                        </w:p>
                    </xsl:for-each-group>

                    <w:sectPr>
                        <w:pgSz w:w="12240" w:h="15840" />
                        <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="720" w:footer="720" w:gutter="0" />
                        <w:cols w:space="720" />
                        <w:docGrid w:linePitch="360" />
                    </w:sectPr>
                </w:body>
            </w:document>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>