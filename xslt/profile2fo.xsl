<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:pro="http://mfelten.de/mf/profile"
	xmlns:i18n="http://mfelten.de/mf/i18n" exclude-result-prefixes="xs xsi pro i18n">

	<xsl:output indent="yes"/>

	<xsl:param name="content" select="'profile'"/>
	<!-- project_overview -->
	<xsl:param name="lang" select="'de'"/>
	<xsl:param name="bundles" select="()"/>
	<xsl:param name="with_contact" select="true()"/>
	<xsl:param name="relevance" select="5" />
	<xsl:param name="from_date" select="'1966-12-14'"/>

	<xsl:template match="/pro:profile">
		<xsl:variable name="i18n.entries" as="element(i18n:entry)*" select="document($bundles)//i18n:locale[@language=$lang]/i18n:group/i18n:entry"/>

		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>
				<fo:simple-page-master master-name="A4" page-height="29.7cm" page-width="21cm" margin-top="1.0cm" margin-bottom="1.0cm" margin-left="0.8cm" margin-right="0.8cm">
					<fo:region-body margin-top="1.7cm" margin-bottom="1.7cm"/>
					<fo:region-before extent="1.5cm"/>
					<fo:region-after extent="1.5cm"/>
				</fo:simple-page-master>
			</fo:layout-master-set>

			<fo:page-sequence master-reference="A4" initial-page-number="1" language="{$lang}">
				<fo:static-content flow-name="xsl-region-before">
					<fo:block font-size="12pt" font-family="sans-serif" line-height="normal" text-align="center">
						<xsl:value-of select="concat(pro:person/pro:name,' ',pro:person/pro:surname)"/>
					</fo:block>
				</fo:static-content>
				<fo:static-content flow-name="xsl-region-after">
					<fo:block-container space-after="2.5mm" height="14pt" font-size="10pt">
						<fo:block>
							<xsl:value-of select="$i18n.entries[@id='page']/@value"/>
							<xsl:value-of select="' '"/>
							<fo:page-number/>
							<xsl:value-of select="' '"/>
							<xsl:value-of select="$i18n.entries[@id='version']/@value"/>
							<xsl:value-of select="' '"/>
							<xsl:value-of select="replace(pro:version,'\D','')"/>
						</fo:block>
					</fo:block-container>
				</fo:static-content>

				<fo:flow flow-name="xsl-region-body">
					<xsl:if test="$content='project_overview'">
						<fo:block font-size="16pt" font-family="sans-serif" line-height="22pt" space-after.optimum="3pt" text-align="center">
							<xsl:value-of select="$i18n.entries[@id='job_overview']/@value"/>
						</fo:block>

						<fo:table font-size="10pt">
							<fo:table-column column-width="6mm"/>
							<fo:table-column column-width="14mm"/>
							<fo:table-column column-width="14mm"/>
							<fo:table-column column-width="37mm"/>
							<fo:table-column column-width="37mm"/>
							<fo:table-column column-width="90mm"/>

							<fo:table-header>
								<fo:table-row height="14pt" background-color="#AAAAAA">									<!-- padding-top="4pt" -->
									<fo:table-cell>
										<fo:block>
											<xsl:value-of select="$i18n.entries[@id='number']/@value"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>
											<xsl:value-of select="$i18n.entries[@id='from']/@value"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>
											<xsl:value-of select="$i18n.entries[@id='to']/@value"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>
											<xsl:value-of select="$i18n.entries[@id='customer']/@value"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>
											<xsl:value-of select="$i18n.entries[@id='contract']/@value"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>
											<xsl:value-of select="$i18n.entries[@id='job']/@value"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-header>

							<fo:table-body>
								<xsl:apply-templates select="pro:job[pro:from &gt; $from_date]" mode="project_overview">
									<xsl:with-param name="i18n.entries" as="element(i18n:entry)*" select="$i18n.entries" tunnel="yes"/>
									<xsl:sort select="pro:to" order="descending"/>
								</xsl:apply-templates>
							</fo:table-body>
						</fo:table>
					</xsl:if>

					<xsl:if test="$content='profile'">
						<fo:block font-size="11pt" font-family="sans-serif" line-height="22pt" space-after.optimum="3pt" text-align="left">
							<fo:table>
								<fo:table-column column-width="30mm"/>
								<fo:table-column column-width="80mm"/>
								<fo:table-column column-width="60mm"/>
								<fo:table-body>
									<fo:table-row>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="$i18n.entries[@id='name']/@value"/>
:</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="concat(pro:person/pro:name,' ',pro:person/pro:surname)"/>
											</fo:block>
										</fo:table-cell>

										<fo:table-cell number-rows-spanned="5">
											<xsl:if test="pro:person/pro:picture">
												<fo:block id="portrait">
													<fo:block>
														<fo:external-graphic scaling="uniform" content-width="scale-down-to-fit" content-height="100%" width="6cm" src="url({pro:person/pro:picture})"/>
													</fo:block>
												</fo:block>
											</xsl:if>
										</fo:table-cell>

									</fo:table-row>
									<fo:table-row>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="$i18n.entries[@id='birthdate']/@value"/>
:</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="pro:person/pro:birthdate"/>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="$i18n.entries[@id='phone']/@value"/>
:</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="pro:person/pro:phone"/>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="$i18n.entries[@id='mobile']/@value"/>
:</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="pro:person/pro:mobile"/>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="$i18n.entries[@id='github']/@value"/>
:</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="pro:person/pro:github"/>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="$i18n.entries[@id='telegram']/@value"/>
:</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="pro:person/pro:telegram"/>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="$i18n.entries[@id='address']/@value"/>
:</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block text-align="left">
												<xsl:value-of select="pro:person/pro:street"/>
											</fo:block>
											<fo:block text-align="left">
												<xsl:value-of select="concat(pro:person/pro:postal-code,' ', pro:person/pro:city)"/>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:block>

						<fo:block font-size="11pt" font-family="sans-serif" line-height="22pt" space-after.optimum="3pt" text-align="left">

							<fo:block font-size="18pt" font-family="sans-serif" line-height="24pt" space-after.optimum="3pt" text-align="center">
								<xsl:value-of select="$i18n.entries[@id='focus']/@value"/>
							</fo:block>

							<fo:list-block>
								<xsl:for-each select="pro:focus/pro:item/pro:description[@xml:lang=$lang or not(exists(@xml:lang))]">
									<fo:list-item>
										<fo:list-item-label end-indent="label-end()">
											<fo:block>–</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>
												<xsl:value-of select="."/>
											</fo:block>
										</fo:list-item-body>
									</fo:list-item>
								</xsl:for-each>
							</fo:list-block>
						</fo:block>

						<fo:block font-size="11pt" font-family="sans-serif" line-height="21pt" space-after.optimum="3pt" text-align="left">

							<fo:block font-size="18pt" font-family="sans-serif" line-height="24pt" space-after.optimum="3pt" text-align="center">
								<xsl:value-of select="$i18n.entries[@id='job_overview']/@value"/>
							</fo:block>

							<fo:table>
								<fo:table-column column-width="7mm"/>
								<fo:table-column column-width="16mm"/>
								<fo:table-column column-width="16mm"/>
								<fo:table-column column-width="45mm"/>
								<fo:table-column column-width="110mm"/>

								<fo:table-header>
									<fo:table-row height="16pt" background-color="#AAAAAA">										<!-- padding-top="4pt" -->
										<fo:table-cell>
											<fo:block>
												<xsl:value-of select="$i18n.entries[@id='number']/@value"/>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>
												<xsl:value-of select="$i18n.entries[@id='from']/@value"/>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>
												<xsl:value-of select="$i18n.entries[@id='to']/@value"/>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>
												<xsl:value-of select="$i18n.entries[@id='customer']/@value"/>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>
												<xsl:value-of select="$i18n.entries[@id='job']/@value"/>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-header>

								<fo:table-body>
									<xsl:apply-templates select="pro:job[pro:from &gt; $from_date and pro:customer]" mode="overview">
										<xsl:with-param name="i18n.entries" as="element(i18n:entry)*" select="$i18n.entries" tunnel="yes"/>
										<xsl:sort select="pro:to" order="descending"/>
									</xsl:apply-templates>
								</fo:table-body>
							</fo:table>

						</fo:block>

						<xsl:apply-templates select="pro:job[pro:from &gt; $from_date and pro:customer]" mode="details">
							<xsl:with-param name="i18n.entries" as="element(i18n:entry)*" select="$i18n.entries" tunnel="yes"/>
							<xsl:sort select="pro:to" order="descending"/>
						</xsl:apply-templates>
					</xsl:if>

				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<xsl:template match="pro:job" mode="overview">
		<xsl:param name="i18n.entries" as="element(i18n:entry)*" tunnel="yes"/>

		<xsl:variable name="index" select="last() - position() + 1"/>

		<fo:table-row>
			<xsl:if test="position() mod 2 = 0">
				<xsl:attribute name="background-color">#E0E0E0</xsl:attribute>
			</xsl:if>
			<fo:table-cell>
				<fo:block text-align="left">
					<fo:basic-link internal-destination="{concat('project',$index)}">
						<xsl:value-of select="$index"/>
					</fo:basic-link>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="left">
					<xsl:value-of select="pro:from"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="left">
					<xsl:value-of select="(pro:to, 'dato')[1]"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="left">
					<xsl:value-of select="pro:customer"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="left">
					<xsl:value-of select="(pro:summary[@xml:lang=$lang and @kind='one-line'],pro:title[@xml:lang=$lang],pro:title[not(exists(@xml:lang))])[1]"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="pro:job" mode="details">
		<xsl:param name="i18n.entries" as="element(i18n:entry)*" tunnel="yes"/>

		<xsl:variable name="index" select="last() - position() + 1"/>

		<fo:block font-size="11pt" font-family="sans-serif" line-height="20pt" space-after.optimum="3pt" text-align="left" break-before="page" id="{concat('project',$index)}">
			<fo:table>
				<fo:table-column column-width="30mm"/>
				<fo:table-column column-width="90mm"/>
				<fo:table-body>
					<fo:table-row height="16pt">
						<fo:table-cell>
							<fo:block>
								<xsl:value-of select="$i18n.entries[@id='position']/@value"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block>
								<xsl:value-of select="$index"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row height="16pt">
						<fo:table-cell>
							<fo:block>
								<xsl:value-of select="$i18n.entries[@id='from']/@value"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block>
								<xsl:value-of select="pro:from"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row height="16pt">
						<fo:table-cell>
							<fo:block>
								<xsl:value-of select="$i18n.entries[@id='to']/@value"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block>
								<xsl:value-of select="(pro:to, $i18n.entries[@id='to_null']/@value)[1]"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row height="16pt">
						<fo:table-cell>
							<fo:block>
								<xsl:value-of select="$i18n.entries[@id='customer']/@value"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block>
								<xsl:value-of select="pro:customer"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<xsl:if test="$with_contact and pro:contact">
						<fo:table-row height="{16 * count(pro:contact)}pt">
							<fo:table-cell>
								<fo:block>
									<xsl:value-of select="$i18n.entries[@id='contact']/@value"/>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<xsl:for-each select="pro:contact/*">
									<fo:block>
										<xsl:choose>
											<xsl:when test="name()='email'">
												email:
											</xsl:when>
											<xsl:when test="name()='phone'">
												phone:
											</xsl:when>
											<xsl:when test="name()='mobile'">
												mobile:
											</xsl:when>
										</xsl:choose>
										<xsl:value-of select="text()"/>
									</fo:block>
								</xsl:for-each>
							</fo:table-cell>
						</fo:table-row>
					</xsl:if>
				</fo:table-body>
			</fo:table>

			<fo:block space-after="4mm"/>

			<!--
								<xsl:if test="pro:summary[@xml:lang=$lang]">
								<xsl:for-each select="pro:summary[@xml:lang=$lang]"> <fo:block text-align="justify" space-after.optimum="3pt">
								<xsl:value-of select="."/>
								</fo:block>
								</xsl:for-each>
								</xsl:if>
			-->

			<xsl:if test="pro:summary[@xml:lang=$lang]">
				<fo:block font-family="sans-serif" font-style="italic" text-align="justify" space-after="1pt" space-after.optimum="1pt">
					<xsl:value-of select="string-join(pro:summary[@xml:lang=$lang], ' ')"/>
				</fo:block>
				<fo:block space-after="4mm"/>
			</xsl:if>

			<xsl:for-each select="pro:details[@xml:lang=$lang]/pro:p">
				<fo:block text-align="justify">
					<xsl:value-of select="."/>
				</fo:block>
			</xsl:for-each>

			<xsl:if test="pro:hardware">
				<fo:block space-after="4mm"/>
				<fo:table>
					<fo:table-column column-width="50mm"/>
					<fo:table-column column-width="60mm"/>

					<fo:table-header>
						<fo:table-row height="15pt" background-color="#AAAAAA">							<!-- padding-top="4pt" -->
							<fo:table-cell>
								<fo:block>HW-Hersteller</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block>Modell</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-header>

					<fo:table-body>
						<xsl:for-each-group select="pro:hardware" group-by="pro:manufacturer">
							<fo:table-row height="11pt">
								<xsl:if test="position() mod 2 = 0">
									<xsl:attribute name="background-color">#E0E0E0</xsl:attribute>
								</xsl:if>
								<fo:table-cell>
									<fo:block>
										<xsl:value-of select="pro:manufacturer"/>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block>
										<xsl:for-each select="current-group()">
											<xsl:if test="position() &gt; 1">
												<xsl:text>, </xsl:text>
											</xsl:if>
											<xsl:value-of select="pro:model"/>
										</xsl:for-each>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</xsl:for-each-group>
					</fo:table-body>
				</fo:table>
			</xsl:if>
			<xsl:if test="pro:software">
				<fo:block space-after="4mm"/>

				<fo:table>
					<fo:table-column column-width="50mm"/>
					<fo:table-column column-width="60mm"/>
					<fo:table-column column-width="60mm"/>

					<fo:table-header>
						<fo:table-row height="15pt" background-color="#AAAAAA">							<!-- padding-top="4pt" -->
							<fo:table-cell>
								<fo:block>SW-Hersteller</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block>
									<xsl:value-of select="$i18n.entries[@id='product']/@value"/>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block>
									<xsl:value-of select="$i18n.entries[@id='versions']/@value"/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-header>

					<fo:table-body>
						<xsl:for-each select="pro:software">
							<fo:table-row height="11pt">
								<xsl:if test="position() mod 2 = 0">
									<xsl:attribute name="background-color">#E0E0E0</xsl:attribute>
								</xsl:if>
								<fo:table-cell>
									<fo:block>
										<xsl:value-of select="pro:manufacturer"/>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block>
										<xsl:value-of select="pro:name"/>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block>
										<xsl:value-of select="string-join(pro:version,', ')"/>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</xsl:if>
		</fo:block>
	</xsl:template>


	<xsl:template match="pro:job" mode="project_overview">
		<xsl:param name="i18n.entries" as="element(i18n:entry)*" tunnel="yes"/>

		<xsl:variable name="index" select="last() - position() + 1"/>

		<fo:table-row>
			<xsl:if test="position() mod 2 = 0">
				<xsl:attribute name="background-color">#E0E0E0</xsl:attribute>
			</xsl:if>
			<fo:table-cell>
				<fo:block text-align="left">
					<xsl:value-of select="$index"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="left">
					<xsl:value-of select="pro:from"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="left">
					<xsl:value-of select="(pro:to, 'dato')[1]"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="left">
					<xsl:value-of select="pro:customer"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="left">
					<xsl:value-of select="pro:contract/pro:agency"/>
 -					<xsl:value-of select="pro:contract/pro:id"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block text-align="left">
					<xsl:value-of select="(pro:summary[@xml:lang=$lang and @kind='one-line'],pro:title[@xml:lang=$lang],pro:title[not(exists(@xml:lang))])[1]"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="text()" mode="details"/>

</xsl:stylesheet>
