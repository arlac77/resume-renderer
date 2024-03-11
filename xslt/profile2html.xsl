<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:pro="http://mfelten.de/mf/profile"
    xmlns:i18n="http://mfelten.de/mf/i18n" exclude-result-prefixes="xs xsi pro i18n">

    <xsl:include href="profile.xsl" />
    <xsl:include href="skill.xsl" />
    <xsl:include href="i18n.xsl" />

    <xsl:output indent="yes" />

    <xsl:param name="content" select="'profile'" />
    <xsl:param name="lang" select="'de'" />
    <xsl:param name="bundles" select="'../i18n/profile.xml'" />
    <xsl:param name="resources" select="'../resources'" />
    <xsl:param name="skills.url" select="'../skills.xml'" />
    <xsl:param name="with_contact" select="true()" />
    <xsl:param name="relevance" select="5" />
    <xsl:param name="from_date" select="'1966-12-14'" />

    <xsl:variable name="skill" as="element(pro:skill)*" select="pro:skills_initialize()" />

    <xsl:template match="pro:skill[text()]">
        <span class="skill">
            <xsl:apply-templates />
        </span>
    </xsl:template>

    <xsl:template match="/pro:profile">
        <xsl:variable name="extracted_skills" as="element(pro:skill)*" select="pro:extract_skills(.)"/>

        <html>
            <xsl:attribute name="lang" select="$lang" />
            <head>
                <meta name="description">
                    <xsl:attribute name="content" select="concat(pro:focus/pro:item[1]/pro:title,' ',replace(pro:version,'\D',''))" />
                </meta>
                <meta name="keywords">
                    <xsl:attribute name="content" select="concat('resume,cv,',pro:person/pro:name,' ',pro:person/pro:surname,string-join(distinct-values($extracted_skills[@relevance>=$relevance]/pro:name[1]),','))" />
                </meta>
                <meta name="author">
                    <xsl:attribute name="content" select="concat(pro:person/pro:name,' ',pro:person/pro:surname)" />
                </meta>
                <meta name="viewport" content="width=device-width,initial-scale=1.0" />
                <link href="index.css" rel="stylesheet" />
                <title>
                    <xsl:value-of select="concat(pro:person/pro:name,' ',pro:person/pro:surname,' - ',i18n:lookup('resume'), ' ', replace(pro:version,'\D',''))" />
                </title>
            </head>
            <body>
                <main class="font-main hyphens-manual">
                    <div class="page mx-auto max-w-letter md:h-letter p-6 xsm:p-8 sm:p-9 md:p-16 bg-white">
                        <header class="flex items-center mb-9">
                            <div class="initials-container mr-5 text-base leading-none text-white bg-gray-700 font-medium print:bg-black px-3 py-2.5">
                                <xsl:for-each select="pro:person/pro:initials">
                                    <div>
                                        <xsl:attribute name="class" select="concat('initial text-center',if(position() = 1) then ' pb-0.8' else '')" />
                                        <xsl:value-of select="." />
                                    </div>
                                </xsl:for-each>
                            </div>
                            <h1 class="text-2xl font-semibold text-gray-700">
                                <xsl:value-of select="concat(pro:person/pro:name,' ',pro:person/pro:surname)" />
                            </h1>
                        </header>

                        <div class="md:col-2 print:col-2 col-gap-md md:h-letter-col print:h-letter-col col-fill">
                            <section>
                                <xsl:for-each select="pro:focus/pro:item">
                                    <section class="mb-4 col-break-avoid">
                                        <header>
                                            <h3 class="text-lg text-gray-700 font-semibold leading-heading">
                                                <xsl:value-of select="(pro:title[@xml:lang=$lang],pro:title[not(exists(@xml:lang))])[1]" />
                                            </h3>
                                            <p class="text-m text-gray-600 leading-normal">
                                                <xsl:value-of select="i18n:lookup('since')" />
        &#160;<xsl:value-of select="@since" />
                                            </p>
                                        </header>

                                        <xsl:for-each select="pro:details[@xml:lang=$lang or not(exists(@xml:lang))]">
                                            <p class="mt-1.5 text-m text-gray-700 leading-normal">
                                                <xsl:apply-templates select="."/>
                                            </p>
                                        </xsl:for-each>
                                    </section>
                                </xsl:for-each>
                            </section>

                            <section class="mt-7">
                                <div class="col-break-avoid">
                                    <h2 class="mb-4 text-2sm text-gray-500 font-bold print:font-normal tracking-widest">
                                        <xsl:value-of select="i18n:lookup('EXPERIENCE')" />
                                    </h2>

                                    <xsl:for-each select="pro:job[pro:from &gt; $from_date and pro:customer and (pro:details or pro:title)]">
                                        <xsl:sort select="pro:to" order="descending" />
                                        <section class="mb-4 col-break-avoid">
                                            <header>
                                                <h3 class="text-lg text-gray-700 font-semibold leading-heading">
                                                    <xsl:value-of select="pro:customer" />
                                                </h3>
                                                <p class="text-m text-gray-600 leading-normal">
                                                    <xsl:value-of select="pro:from" />
 –                                                    <xsl:value-of select="pro:to" />
 |                                                    <xsl:value-of select="(pro:title[@xml:lang=$lang],pro:title[not(exists(@xml:lang))])[1]" />
                                                </p>
                                            </header>
                                            <p class="mt-1.5 text-m text-gray-700 leading-normal">
                                                <xsl:for-each select="pro:details[@xml:lang=$lang]">
                                                    <b class="font-normal print:font-medium text-gray-600 print:text-black">
        (                                                        <xsl:value-of select="position()" />
 ) </b>
                                                    <xsl:apply-templates select="."/>
                                                </xsl:for-each>
                                            </p>
                                        </section>
                                    </xsl:for-each>
                                </div>
                            </section>

                            <section class="mt-7">
                                <div class="col-break-avoid">
                                    <h2 class="mb-4 text-2sm text-gray-500 font-bold print:font-normal tracking-widest">
                                        <xsl:value-of select="i18n:lookup('SKILLS')" />
                                    </h2>

                                    <xsl:for-each-group select="$extracted_skills" group-by="pro:name[1]">
                                        <xsl:sort select="pro:category[1]" />
                                        <xsl:sort select="pro:name[1]" />

                                        <xsl:if test="@level and @relevance>=$relevance">
                                            <section class="mb-4 col-break-avoid">
                                                <header>
                                                    <span class="text-lg text-gray-700 font-semibold leading-heading">
                                                        <xsl:value-of select="pro:name[1]" />
                                                    </span>
        &#160; <span class="text-m text-gray-600 leading-normal">
                                                    <xsl:value-of select="i18n:lookup(@level)" />
                                                </span>
                                            </header>
                                        </section>
                                    </xsl:if>
                                </xsl:for-each-group>
                            </div>

                            <section class="mb-4 col-break-avoid">
                                <header>
                                    <h3 class="text-lg text-gray-700 font-semibold leading-heading">
                                        <xsl:value-of select="i18n:lookup('OTHER')" />
                                    </h3>
                                </header>
                                <ul class="mt-1.5 mb-6 flex flex-wrap text-m leading-normal">
                                    <xsl:for-each select="(for $name in distinct-values($extracted_skills/pro:name[1]) return pro:skill($name))[@relevance>=$relevance and not(@level)]">
                                        <xsl:sort select="translate(pro:name[1],'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqestuvwxyz')" />
                                        <li class="px-3 mr-1.5 mt-1.5 text-base text-gray-700 leading-relaxed print:bg-white print:border-inset bg-gray-250">
                                            <xsl:choose>
                                                <xsl:when test="@href">
                                                    <a>
                                                        <xsl:attribute name="href" select="@href"></xsl:attribute>
                                                        <xsl:value-of select="pro:name[1]" />
                                                    </a>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="pro:name[1]" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </section>

                            <section class="mb-4 col-break-avoid">
                                <header>
                                    <h3 class="text-lg text-gray-700 font-semibold leading-heading">
                                        <xsl:value-of select="i18n:lookup('LANGUAGES')" />
                                    </h3>
                                </header>
                                <ul class="py-1.5 leading-normal flex flex-wrap">
                                    <xsl:for-each select="pro:language">
                                        <li class="px-3 mr-1.5 mt-1.5 text-base text-gray-700 leading-relaxed print:bg-white print:border-inset bg-gray-250">
                                            <xsl:value-of select="i18n:lookup(@name)" />
 -                                            <xsl:value-of select="i18n:lookup(@type)" />
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </section>
                        </section>

                        <section class="mt-7">
                            <!-- To keep in the same column -->
                            <div class="col-break-avoid">

                                <h2 class="mb-4 text-2sm text-gray-500 font-bold print:font-normal tracking-widest">
                                    <xsl:value-of select="i18n:lookup('CONTACT')" />
                                </h2>

                                <section class="mb-4 col-break-avoid">
                                    <ul>
                                        <li class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                            <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                                <xsl:copy-of select="document(concat($resources,'/github.svg'))" />
                                            </span>
                                            <span class="ml-1.5">
                                                <a>
                                                    <xsl:attribute name="href" select="concat('https://github.com/',pro:person/pro:github)" />
                                                    <xsl:value-of select="pro:person/pro:github" />
                                                </a>
                                            </span>
                                        </li>
                                        <xsl:if test="pro:person/pro:telegram">
                                            <li class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                                <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                                    <xsl:copy-of select="document(concat($resources,'/telegram.svg'))" />
                                                </span>
                                                <span class="ml-1.5">
                                                    <a>
                                                        <xsl:attribute name="href" select="concat('https://t.me/',pro:person/pro:telegram)" />
                                                        <xsl:value-of select="pro:person/pro:telegram" />
                                                    </a>
                                                </span>
                                            </li>
                                        </xsl:if>
                                        <li class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                            <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                                <xsl:copy-of select="document(concat($resources,'/location.svg'))" />
                                            </span>
                                            <span class="ml-1.5">
                                                <a>
                                                    <xsl:attribute name="href" select="concat('https://www.google.com/maps/search/?api=1&amp;query=',pro:person/pro:city)" />
                                                    <xsl:value-of select="pro:person/pro:postal-code" />
 -                                                    <xsl:value-of select="pro:person/pro:city" />
 ,                                                    <xsl:value-of select="i18n:lookup(pro:person/pro:country)" />
                                                </a>
                                            </span>
                                        </li>
                                        <li class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                            <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                                <xsl:copy-of select="document(concat($resources,'/email.svg'))" />
                                            </span>
                                            <span class="ml-1.5">
                                                <a>
                                                    <xsl:attribute name="href" select="concat('mailto:',pro:person/pro:email)" />
                                                    <xsl:value-of select="pro:person/pro:email" />
                                                </a>
                                            </span>
                                        </li>
                                        <li class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                            <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                                <xsl:copy-of select="document(concat($resources,'/mobile.svg'))" />
                                            </span>
                                            <span class="ml-1.5">
                                                <a>
                                                    <xsl:attribute name="href" select="concat('tel:',replace(pro:person/pro:mobile,' ',''))" />
                                                    <xsl:value-of select="pro:person/pro:mobile" />
                                                </a>
                                            </span>
                                        </li>
                                    </ul>
                                </section>
                            </div>

                        </section>
                    </div>
                </div>
            </main>
        </body>
    </html>
</xsl:template>
</xsl:stylesheet>