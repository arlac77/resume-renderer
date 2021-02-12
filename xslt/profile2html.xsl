<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:pro="http://mfelten.de/mf/profile"
    xmlns:i18n="http://mfelten.de/mf/i18n" exclude-result-prefixes="xs xsi pro i18n">

    <xsl:output indent="yes" />

    <xsl:param name="content" select="'profile'" />
    <xsl:param name="lang" select="'de'" />
    <xsl:param name="country" select="'de'" />
    <xsl:param name="bundles" select="()" />
    <xsl:param name="with_contact" select="true()" />
    <xsl:param name="relevance" select="5" />
    <xsl:param name="from_date" select="'1950-01-01'" />
    <xsl:param name="bundles" select="()" />
    <xsl:param name="knowledge" select="'../knowledge.xml'" />

    <xsl:function name="pro:software">
        <xsl:param name="name" as="xs:string*"/>
        <xsl:variable name="software" as="element()*" select="document($knowledge)/pro:knowledge/pro:software[pro:name=$name]"/>

        <pro:software>
            <xsl:attribute name="relevance" select="($software/@relevance,5)[1]"/>
            <pro:name>
                <xsl:value-of select="($software/name,$name)[1]"/>
            </pro:name>
            <xsl:copy-of select="$software/*"/>
        </pro:software>
    </xsl:function>

    <xsl:function name="i18n:lookup">
        <xsl:param name="key" />
        <xsl:variable name="i18n.entries" as="element(i18n:entry)*" select="document($bundles)//i18n:locale[@language=$lang]/i18n:group/i18n:entry" />
        <xsl:if test="count($i18n.entries[@id = $key]) = 0">
            <xsl:message>Missing i18n entry for <xsl:value-of select="$key"/>
            </xsl:message>
        </xsl:if>
        <xsl:value-of select="$i18n.entries[@id = $key]/@value" />
    </xsl:function>

    <xsl:template match="/pro:key">
        <b>
            <xsl:apply-templates />
        </b>
    </xsl:template>

    <xsl:template match="/pro:profile">
        <html lang="en">
            <head>
                <meta charset="UTF-8" />
                <meta name="description">
                    <xsl:attribute name="description" select="pro:focus/pro:item[1]/pro:title"/>
                </meta>
                <meta name="keywords">
                    <xsl:attribute name="content" select="concat('resume,cv,',pro:person/pro:name,' ',pro:person/pro:surname)" />
                </meta>
                <meta name="author">
                    <xsl:attribute name="content" select="concat(pro:person/pro:name,' ',pro:person/pro:surname)" />
                </meta>
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <meta http-equiv="X-UA-Compatible" content="ie=edge" />
                <link href="https://fonts.googleapis.com/css?family=IBM+Plex+Sans:300,300i,400,400i,500,500i,600,600i,700,700i&amp;display=swap&amp;subset=latin-ext" rel="stylesheet" />
                <link href="build.css" rel="stylesheet" />
                <title>
                    <xsl:value-of select="concat(pro:person/pro:name,' ',pro:person/pro:surname,' - Resume')" />
                </title>
            </head>
            <body>
                <main class="font-main hyphens-manual ">
                    <div class="page mx-auto max-w-letter md:h-letter p-6 xsm:p-8 sm:p-9 md:p-16 bg-white">
                        <header class="flex items-center mb-9">
                            <div class="initials-container mr-5 text-base leading-none text-white bg-gray-700 font-medium print:bg-black px-3 py-2.5">
                                <xsl:for-each select="pro:person/pro:initials">
                                    <div>
                                        <xsl:attribute name="class" select="concat('initial text-center',if(position() = 1) then ' pb-0.8' else '')"/>
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

                                        <xsl:for-each select="pro:description[@xml:lang=$lang]">
                                            <p class="mt-1.5 text-m text-gray-700 leading-normal">
                                                <xsl:value-of select="." />
                                            </p>
                                        </xsl:for-each>
                                    </section>
                                </xsl:for-each>
                            </section>

                            <section class="mt-7">
                                <div class="col-break-avoid">
                                    <h2 class="mb-4 text-2sm text-gray-500 font-bold print:font-normal tracking-widest">EXPERIENCE</h2>

                                    <xsl:for-each select="pro:job[pro:from &gt; $from_date]">
                                        <xsl:sort select="pro:to" order="descending" />
                                        <section class="mb-4 col-break-avoid">
                                            <header>
                                                <h3 class="text-lg text-gray-700 font-semibold leading-heading">
                                                    <xsl:value-of select="pro:customer" />
                                                </h3>
                                                <p class="text-m text-gray-600 leading-normal">
                                                    <xsl:value-of select="pro:from" />
                                                    –
                                                    <xsl:value-of select="pro:to" />
                                                    |
                                                    <xsl:value-of select="(pro:title[@xml:lang=$lang],pro:title[not(exists(@xml:lang))])[1]" />
                                                </p>
                                            </header>
                                            <p class="mt-1.5 text-m text-gray-700 leading-normal">
                                                <xsl:for-each select="pro:summary[@xml:lang=$lang]">
                                                    <b class="font-normal print:font-medium text-gray-600 print:text-black">
                                                        (
                                                        <xsl:value-of select="position()" />
                                                        )
                                                    </b>
                                                    <xsl:value-of select="." />
                                                </xsl:for-each>
                                            </p>
                                        </section>
                                    </xsl:for-each>
                                </div>

                                <!--
                                     <section class="mb-4 col-break-avoid">
                                     <header>
                                     <h3 class="text-lg text-gray-700 font-semibold leading-heading">Mammoth GmbH</h3>
                                     <p class="text-m text-gray-600 leading-normal">Feb 2017 – Apr 2018 | Android Developer</p>
                                     </header>
                                     <p class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                     <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                     <svg class="w-4.5 h-4.5 print:pb-0.5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                     <path class="text-gray-600 print:text-gray-900 fill-current" d="M12 22a10 10 0 1 1 0-20 10 10 0 0 1 0 20zm0-2a8 8 0 1 0 0-16 8 8 0 0 0 0 16zm-2.3-8.7l1.3 1.29 3.3-3.3a1 1 0 0 1 1.4 1.42l-4 4a1 1 0 0 1-1.4 0l-2-2a1 1 0 0 1 1.4-1.42z" />
                                     </svg>
                                     </span>
                                     <span class="ml-1.5">ZZZ.</span>
                                     </p>
                                     <p class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                     <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                     <svg class="w-4.5 h-4.5 print:pb-0.5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                     <path class="text-gray-600 print:text-gray-900 fill-current" d="M12 22a10 10 0 1 1 0-20 10 10 0 0 1 0 20zm0-2a8 8 0 1 0 0-16 8 8 0 0 0 0 16zm-2.3-8.7l1.3 1.29 3.3-3.3a1 1 0 0 1 1.4 1.42l-4 4a1 1 0 0 1-1.4 0l-2-2a1 1 0 0 1 1.4-1.42z" />
                                     </svg>
                                     </span>
                                     <span class="ml-1.5">Tested beef rump beef ribs, shankle corned beef neck. Ribeye turducken pancetta sausage. Biltong atl. Yamoi.</span>
                                     </p>
                                     </section>
                                     
                                     <section class="mb-4 col-break-avoid">
                                     <header>
                                     <h3 class="text-lg text-gray-700 font-semibold leading-heading">Exquisite Systems d.o.o.</h3>
                                     <p class="text-m text-gray-600 leading-normal">May 2015 – Dec 2016 | Software QA Specialist</p>
                                     </header>
                                     <p class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                     <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                     <svg class="w-4.5 h-4.5 print:pb-0.5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                     <path class="text-gray-600 print:text-gray-900 fill-current" d="M12 22a10 10 0 1 1 0-20 10 10 0 0 1 0 20zm0-2a8 8 0 1 0 0-16 8 8 0 0 0 0 16zm-2.3-8.7l1.3 1.29 3.3-3.3a1 1 0 0 1 1.4 1.42l-4 4a1 1 0 0 1-1.4 0l-2-2a1 1 0 0 1 1.4-1.42z" />
                                     </svg>
                                     </span>
                                     <span class="ml-1.5">Handled shankle frankfurter t-bone brisket short paloin</span>
                                     </p>
                                     <p class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                     <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                     <svg class="w-4.5 h-4.5 print:pb-0.5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                     <path class="text-gray-600 print:text-gray-900 fill-current" d="M12 22a10 10 0 1 1 0-20 10 10 0 0 1 0 20zm0-2a8 8 0 1 0 0-16 8 8 0 0 0 0 16zm-2.3-8.7l1.3 1.29 3.3-3.3a1 1 0 0 1 1.4 1.42l-4 4a1 1 0 0 1-1.4 0l-2-2a1 1 0 0 1 1.4-1.42z" />
                                     </svg>
                                     </span>
                                     <span class="ml-1.5">Monitored salami sprge ribs brisket flank, pork 5+ meat</span>
                                     </p>
                                     </section>
                                -->
                            </section>


                            <section class="mt-7">
                                <div class="col-break-avoid">

                                    <h2 class="mb-4 text-2sm text-gray-500 font-bold print:font-normal tracking-widest">SKILLS</h2>

                                    <xsl:for-each-group select="//pro:skill" group-by="pro:title">
                                        <xsl:sort select="@level"/>
                                        <xsl:sort select="pro:title"/>

                                        <section class="mb-4 col-break-avoid">
                                            <header>
                                                <h3 class="text-lg text-gray-700 font-semibold leading-heading">
                                                    <xsl:value-of select="(pro:title[@xml:lang=$lang],pro:title[not(exists(@xml:lang))])[1]" />
                                                </h3>
                                                <p class="text-m text-gray-600 leading-normal">
                                                    <xsl:value-of select="i18n:lookup(@level)" />
                                                </p>
                                            </header>
                                            <xsl:for-each select="pro:details[@xml:lang=$lang]">
                                                <p class="mt-1.5 text-m text-gray-700 leading-normal">
                                                    <xsl:value-of select="." />
                                                </p>
                                            </xsl:for-each>
                                            <!--
                                                 <ul class="mt-1.5 mb-6 flex flex-wrap text-m leading-normal">
                                                 <li class="px-3 mr-1.5 mt-1.5 text-base text-gray-700 leading-relaxed print:bg-white print:border-inset bg-gray-250">ES6</li>
                                                 <li class="px-3 mr-1.5 mt-1.5 text-base text-gray-700 leading-relaxed print:bg-white print:border-inset bg-gray-250">React</li>
                                                 </ul>
                                            -->
                                        </section>
                                    </xsl:for-each-group>
                                </div>

                                <section class="mb-4 col-break-avoid">
                                    <header>
                                        <h3 class="text-lg text-gray-700 font-semibold leading-heading">Other</h3>
                                    </header>
                                    <ul class="mt-1.5 mb-6 flex flex-wrap text-m leading-normal">
                                        <xsl:for-each select="distinct-values(//pro:software[pro:software(pro:name)/@relevance>=$relevance]/pro:name)">
                                            <xsl:sort select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqestuvwxyz')"/>
                                            <li class="px-3 mr-1.5 mt-1.5 text-base text-gray-700 leading-relaxed print:bg-white print:border-inset bg-gray-250">
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </section>

                                <section class="mb-4 col-break-avoid">
                                    <header>
                                        <h3 class="text-lg text-gray-700 font-semibold leading-heading">Languages</h3>
                                    </header>
                                    <ul class="py-1.5 leading-normal flex flex-wrap">
                                        <xsl:for-each select="pro:language">
                                            <li class="px-3 mr-1.5 mt-1.5 text-base text-gray-700 leading-relaxed print:bg-white print:border-inset bg-gray-250">
                                                <xsl:value-of select="i18n:lookup(@name)" />
                                                -
                                                <xsl:value-of select="i18n:lookup(@type)" />
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </section>

                            </section>


                            <section class="mt-7">
                                <!-- To keep in the same column -->
                                <div class="col-break-avoid">

                                    <h2 class="mb-4 text-2sm text-gray-500 font-bold print:font-normal tracking-widest">CONTACT</h2>

                                    <section class="mb-4 col-break-avoid">
                                        <ul>
                                            <li class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                                <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                                    <svg class="w-4.5 h-4.5"
                                                        xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
                                                        <path class="text-gray-600 print:text-gray-900 fill-current" d="M19.48 13.03A4 4 0 0 1 16 19h-4a4 4 0 1 1 0-8h1a1 1 0 0 0 0-2h-1a6 6 0 1 0 0 12h4a6 6 0 0 0 5.21-8.98L21.2 12a1 1 0 1 0-1.72 1.03zM4.52 10.97A4 4 0 0 1 8 5h4a4 4 0 1 1 0 8h-1a1 1 0 0 0 0 2h1a6 6 0 1 0 0-12H8a6 6 0 0 0-5.21 8.98l.01.02a1 1 0 1 0 1.72-1.03z" />
                                                    </svg>
                                                </span>
                                                <span class="ml-1.5">
                                                    <a href="https://github.com/arlac77">
                                                        <xsl:attribute name="href" select="concat('https://github.com/',pro:person/pro:github)"/>
                                                        <xsl:value-of select="pro:person/pro:github" />
                                                    </a>
                                                </span>
                                            </li>
                                            <xsl:if test="pro:person/pro:telegram">
                                                <li class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                                    <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                                        <svg class="w-4.5 h-4.5"
                                                            xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 512 512" width="24">
                                                            <g>
                                                                <path class="text-gray-600 print:text-gray-900 fill-current" d="M477.805,102.981l-67.327,317.515c-5.08,22.41-18.326,27.984-37.15,17.431l-102.585-75.596l-49.497,47.607c-5.477,5.478-10.06,10.061-20.617,10.061l7.37-104.479l190.129-171.804c8.268-7.37-1.792-11.454-12.848-4.083L150.233,287.633l-101.19-31.671c-22.011-6.873-22.408-22.012,4.581-32.568L449.419,70.911C467.744,64.04,483.779,74.994,477.805,102.981z" style="fill:#FFFFFF;"/>
                                                                <path class="text-gray-600 print:text-gray-900 fill-current" d="M389.819,453.082c-6.575,0-13.769-2.164-21.383-6.433c-0.36-0.202-0.709-0.427-1.042-0.672l-95.797-70.595l-43.353,41.698c-5.775,5.774-12.978,12.918-27.617,12.918c-2.774,0-5.424-1.152-7.315-3.183c-1.892-2.029-2.855-4.754-2.66-7.521l7.37-104.479c0.182-2.578,1.354-4.984,3.271-6.717l148.935-134.58L155.562,296.095c-2.48,1.562-5.521,1.956-8.315,1.082l-101.19-31.672c-19.627-6.128-22.91-17.06-23.12-23.03c-0.282-8.018,4.182-19.452,27.045-28.395l395.843-152.5c4.736-1.776,9.363-2.661,13.836-2.661c9.022,0,16.929,3.631,22.264,10.225c4.812,5.947,9.699,17.007,5.66,35.926L420.26,422.57c-0.01,0.046-0.02,0.091-0.029,0.137C414.239,449.135,398.605,453.081,389.819,453.082z M378.737,429.491c5.425,2.959,9.01,3.591,11.081,3.591c1.865,0,7.536,0,10.892-14.731l67.313-317.444c1.842-8.628,1.24-15.615-1.647-19.184c-1.505-1.86-3.765-2.804-6.715-2.804c-2.066,0-4.331,0.457-6.73,1.356L57.219,232.725c-9.771,3.822-13.369,7.515-14.161,8.964c0.74,0.919,3.25,2.943,8.965,4.728l96.79,30.294l231.036-145.476c5.356-3.543,11.187-5.493,16.433-5.493c6.65,0,12.04,3.301,14.064,8.616c1.015,2.663,2.503,9.632-5.564,16.823L217.69,320.239l-6.001,85.075c0.761-0.723,1.574-1.536,2.484-2.446c0.046-0.046,0.093-0.092,0.14-0.137l49.497-47.607c3.509-3.376,8.941-3.734,12.865-0.844L378.737,429.491z"/>
                                                            </g>
                                                        </svg>
                                                    </span>
                                                    <span class="ml-1.5">
                                                        <a>
                                                            <xsl:attribute name="href" select="concat('https://t.me/',pro:person/pro:telegram)"/>
                                                            <xsl:value-of select="pro:person/pro:telegram" />
                                                        </a>
                                                    </span>
                                                </li>
                                            </xsl:if>
                                            <li class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                                <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                                    <svg class="w-4.5 h-4.5"
                                                        xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
                                                        <path class="text-gray-600 print:text-gray-900 fill-current" d="M5.64 16.36a9 9 0 1 1 12.72 0l-5.65 5.66a1 1 0 0 1-1.42 0l-5.65-5.66zm11.31-1.41a7 7 0 1 0-9.9 0L12 19.9l4.95-4.95zM12 14a4 4 0 1 1 0-8 4 4 0 0 1 0 8zm0-2a2 2 0 1 0 0-4 2 2 0 0 0 0 4z" />
                                                    </svg>
                                                </span>
                                                <span class="ml-1.5">
                                                    <xsl:value-of select="pro:person/pro:postal-code" />
                                                    -
                                                    <xsl:value-of select="pro:person/pro:city" />
,
                                                    <xsl:value-of select="i18n:lookup(pro:person/pro:country)" />
                                                </span>
                                            </li>
                                            <li class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                                <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                                    <svg class="w-4.5 h-4.5"
                                                        xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
                                                        <path class="text-gray-600 print:text-gray-900 fill-current" d="M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6c0-1.1.9-2 2-2zm16 3.38V6H4v1.38l8 4 8-4zm0 2.24l-7.55 3.77a1 1 0 0 1-.9 0L4 9.62V18h16V9.62z" />
                                                    </svg>
                                                </span>
                                                <span class="ml-1.5">
                                                    <a>
                                                        <xsl:attribute name="href" select="concat('mailto:',pro:person/pro:email)"/>
                                                        <xsl:value-of select="pro:person/pro:email" />
                                                    </a>
                                                </span>
                                            </li>
                                            <li class="mt-1.5 flex items-start justify-start text-m text-gray-700 leading-normal">
                                                <span class="icon-parent flex items-center justify-center flex-shrink-0">
                                                    <svg class="w-4.5 h-4.5"
                                                        xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
                                                        <path class="text-gray-600 print:text-gray-900 fill-current" d="M13.04 14.69l1.07-2.14a1 1 0 0 1 1.2-.5l6 2A1 1 0 0 1 22 15v5a2 2 0 0 1-2 2h-2A16 16 0 0 1 2 6V4c0-1.1.9-2 2-2h5a1 1 0 0 1 .95.68l2 6a1 1 0 0 1-.5 1.21L9.3 10.96a10.05 10.05 0 0 0 3.73 3.73zM8.28 4H4v2a14 14 0 0 0 14 14h2v-4.58l-4.5-1.5-1.12 2.26a1 1 0 0 1-1.3.46 12.04 12.04 0 0 1-6.02-6.01 1 1 0 0 1 .46-1.3l2.26-1.14L8.28 4z" />
                                                    </svg>
                                                </span>
                                                <span class="ml-1.5">
                                                    <xsl:value-of select="pro:person/pro:mobile" />
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
