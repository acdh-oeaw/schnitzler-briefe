<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foo="whatever"
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0">
    <!-- <xsl:strip-space elements="*"/>-->
    <xsl:import href="editions-links.xsl"/>
    <xsl:param name="document"/>
    <xsl:param name="app-name"/>
    <xsl:param name="collection-name"/>
    <xsl:param name="path2source"/>
    <xsl:param name="ref"/>
    <xsl:param name="prev"/>
    <xsl:param name="next"/>
    <xsl:param name="currentIx"/>
    <xsl:param name="amount"/>
    <xsl:param name="progress"/>
    <xsl:param name="projectName"/>
    <xsl:param name="authors"/>
    <xsl:variable name="quotationURL">
        <xsl:value-of
            select="concat('https://schnitzler-briefe.acdh.oeaw.ac.at/pages/show.html?document=', $document)"
        />
    </xsl:variable>
    <xsl:variable name="quotationString">
        <xsl:value-of
            select="concat(normalize-space(//tei:titleStmt/tei:title[@level = 'a']), '. In: Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren. Digitale Edition. Hg. Martin Anton Müller und Gerd Hermann Susen, ', $quotationURL, ' (Abfrage ', $currentDate, ')')"
        />
    </xsl:variable>
    <xsl:variable name="doctitle">
        <xsl:value-of select="//tei:titleStmt/tei:title[@level = 'a']/text()"/>
    </xsl:variable>
    <xsl:variable name="currentDate">
        <xsl:value-of select="format-date(current-date(), '[Y]-[M]-[D]')"/>
    </xsl:variable>
    <xsl:variable name="pid">
        <xsl:value-of select="//tei:publicationStmt//tei:idno[@type = 'URI']/text()"/>
    </xsl:variable>
    <xsl:variable name="current-view" select="'links'"/>
    <xsl:variable name="current-view-deutsch" select="'Links'"/>
    <!--
##################################
### Seitenlayout und -struktur ###
##################################
-->
    <xsl:template match="/">
        <div class="card">
            <div class="card card-header">
                <div class="row">
                    <div class="col-md-2">
                        <xsl:if
                            test="//tei:correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'previous_letter']">
                            <xsl:variable name="previousLetterInCollectionTitle"
                                select="//tei:correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'previous_letter']"/>
                            <xsl:variable name="previousLetterInCollectionTarget"
                                select="//tei:correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'previous_letter']/@target"/>
                            <h1>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of
                                            select="concat('show.html?document=',$previousLetterInCollectionTarget,'.xml&amp;stylesheet=', $current-view)"
                                        />
                                    </xsl:attribute>
                                    <i class="fas fa-chevron-left"
                                        title="{$previousLetterInCollectionTitle}"/>
                                </a>
                            </h1>
                        </xsl:if>
                    </div>
                    <div class="col-md-8">
                        <h2 align="center">
                            <xsl:for-each
                                select="//tei:fileDesc/tei:titleStmt/tei:title[@level = 'a']">
                                <xsl:apply-templates/>
                                <br/>
                            </xsl:for-each>
                        </h2>
                    </div>
                    <div class="col-md-2" style="text-align:right">
                        <xsl:if
                            test="//tei:correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'next_letter']">
                            <xsl:variable name="nextLetterInCollectionTitle"
                                select="//tei:correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'next_letter']"/>
                            <xsl:variable name="nextLetterInCollectionTarget"
                                select="//tei:correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'next_letter']/@target"/>
                            <h1>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of
                                            select="concat('show.html?document=',$nextLetterInCollectionTarget,'.xml&amp;stylesheet=', $current-view)"
                                        />
                                    </xsl:attribute>
                                    <i class="fas fa-chevron-right"
                                        title="{$nextLetterInCollectionTitle}"/>
                                </a>
                            </h1>
                        </xsl:if>
                    </div>
                </div>
            </div>
            <div class="card-body-normalertext">
                <div>
                    <xsl:apply-templates select="//tei:text/tei:body"/>
                    <xsl:element name="ol">
                        <xsl:attribute name="class">
                            <xsl:text>list-for-footnotes</xsl:text>
                        </xsl:attribute>
                        <xsl:apply-templates select="//tei:footNote" mode="footnote"/>
                    </xsl:element>
                </div>
            </div>
            <div class="card-body">
                <xsl:variable name="datum">
                    <xsl:choose>
                        <xsl:when
                            test="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@when">
                            <xsl:value-of
                                select="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@when"
                            />
                        </xsl:when>
                        <xsl:when
                            test="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@notBefore">
                            <xsl:value-of
                                select="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@notBefore"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@notAfter"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <nav class="navbar-expand-md navbar-light bg-white box-shadow">
                    <div>
                        <ul class="navbar-nav mr-auto">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button"
                                    data-toggle="dropdown" aria-haspopup="true"
                                    aria-expanded="false">
                                    <i title="Critical Edition" class="fas fa-glasses"/> ANSICHT
                                        (<xsl:value-of select="$current-view-deutsch"/>) </a>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item"
                                        href="{concat('show.html?document=',$document,'&amp;stylesheet=plain')}">
                                        <i title="Plain Text" class="fas fa-book-reader"/> LESEN</a>
                                    <a class="dropdown-item"
                                        href="{concat('show.html?document=',$document,'&amp;stylesheet=critical')}">
                                        <i title="Critical Edition" class="fas fa-glasses"/>
                                        KRITISCH</a>
                                    <a class="dropdown-item" href="{$path2source}">
                                        <i class="far fa-file-code"/> TEI-XML</a>
                                </div>
                            </li>
                            <xsl:choose>
                                <xsl:when
                                    test="not(//tei:teiHeader[1]/tei:revisionDesc[1]/@status = 'approved')">
                                    <li class="nav-item dropdown">
                                        <a class="nav-link" data-toggle="modal"
                                            data-target="#qualitaet">
                                            <span style="color: orange;">ENTWURF</span>
                                        </a>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                            <li class="nav-item dropdown">
                                <a class="nav-link" data-target="#ueberlieferung" role="button"
                                    data-toggle="modal" aria-haspopup="true" aria-expanded="false">
                                    <i class="fas fa-landmark"/> ÜBERLIEFERUNG </a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link" id="res-act-button-copy-url"
                                    data-copyuri="{$quotationString}">
                                    <span id="copy-url-button">
                                        <i class="fas fa-quote-right"/> ZITIEREN </span>
                                    <span id="copyLinkTextfield-wrapper">
                                        <span type="text" name="copyLinkInputBtn"
                                            id="copyLinkInputBtn" data-copyuri="{$quotationString}">
                                            <i class="far fa-copy"/>
                                        </span>
                                        <textarea rows="4" name="copyLinkTextfield"
                                            id="copyLinkTextfield" value="">
                                            <xsl:value-of select="$quotationString"/>
                                        </textarea>
                                    </span>
                                </a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link">
                                    <xsl:attribute name="target">
                                        <xsl:text>_blank</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of
                                            select="concat('https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__', $datum, '.html')"
                                        />
                                    </xsl:attribute><!--<span style="color:#037a33;">-->
                                    <i class="fas fa-external-link-alt"/> TAGEBUCH<!--</span>-->
                                </a>
                            </li>
                            <xsl:variable name="datum">
                                <xsl:choose>
                                    <xsl:when
                                        test="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@when">
                                        <xsl:value-of
                                            select="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@when"
                                        />
                                    </xsl:when>
                                    <xsl:when
                                        test="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@notBefore">
                                        <xsl:value-of
                                            select="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@notBefore"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@notAfter"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <li class="nav-item dropdown">
                                <span class="nav-link">
                                    <div id="csLink" data-correspondent-1-name=""
                                        data-correspondent-1-id="all" data-correspondent-2-name=""
                                        data-correspondent-2-id="" data-start-date="{$datum}"
                                        data-end-date="" data-range="50"
                                        data-selection-when="before-after"
                                        data-selection-span="median-before-after"
                                        data-result-max="4" data-exclude-edition=""/>
                                </span>
                            </li>
                        </ul>
                    </div>
                </nav>
            </div>
        </div>
        <div class="card-body-anhang">
            <dl>
                <xsl:apply-templates select="//tei:back"/>
            </dl>
            <dl class="kommentarhang">
                <xsl:apply-templates
                    select="//tei:anchor[@type = 'textConst'] | //tei:anchor[@type = 'commentary']"
                    mode="lemma"/>
            </dl>
        </div>
        <div class="row">
            <div class="col-md-2" style="flex: 0 0 50%; max-width: 50%;">
                <!-- navigation in specific correspondence left start -->
                <xsl:if
                    test="//tei:correspDesc/tei:correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'previous_letter']">
                    <xsl:for-each
                        select="//tei:correspDesc/tei:correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'previous_letter']">
                        <h5>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:variable name="name-of-document">
                                        <xsl:value-of select="./@target"/>
                                    </xsl:variable>
                                    <xsl:value-of
                                        select="concat('show.html?document=',$name-of-document,'.xml&amp;stylesheet=', $current-view)"
                                    />
                                </xsl:attribute>
                                <span class="nav-link">
                                    <i class="fas fa-chevron-left"
                                        title="Vorhergehender Brief innerhalb der Korrespondenz"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="./text()"/>
                                </span>
                            </a>
                        </h5>
                    </xsl:for-each>
                </xsl:if>
            </div>
            <div class="col-md-2" style="flex: 0 0 50%; max-width: 50%; text-align: right;">
                <!-- navigation in specific correspondence right start -->
                <xsl:if
                    test="//tei:correspDesc/tei:correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'next_letter']">
                    <xsl:for-each
                        select="//tei:correspDesc/tei:correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'next_letter']">
                        <h5>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:variable name="name-of-document">
                                        <xsl:value-of select="./@target"/>
                                    </xsl:variable>
                                    <xsl:value-of
                                        select="concat('show.html?document=',$name-of-document,'.xml&amp;stylesheet=', $current-view)"
                                    />
                                </xsl:attribute>
                                <span class="nav-link">
                                    <xsl:value-of select="./text()"/>
                                    <xsl:text> </xsl:text>
                                    <i class="fas fa-chevron-right"
                                        title="Nächster Brief innerhalb der Korrespondenz"/>
                                </span>
                            </a>
                        </h5>
                    </xsl:for-each>
                </xsl:if>
            </div>
        </div>
        <div class="modal fade" id="qualitaet" tabindex="-1" role="dialog"
            aria-labelledby="exampleModalLongTitle" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5>Textqualität</h5>
                        <button type="button" class="close" data-dismiss="modal"
                            aria-label="Schließen">
                            <span aria-hidden="true">x</span>
                        </button>
                    </div>
                    <div class="modal-info-body">
                        <p>Diese Abschrift wurde noch nicht ausreichend mit dem Original
                            abgeglichen. Sie sollte derzeit nicht – oder nur durch eigenen Abgleich
                            mit dem Faksimile, falls vorliegend – als Zitatvorlage dienen.</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="ueberlieferung" tabindex="-1" role="dialog"
            aria-labelledby="exampleModalLongTitle" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLongTitle">
                            <xsl:for-each
                                select="//tei:fileDesc/tei:titleStmt/tei:title[@level = 'a']">
                                <xsl:apply-templates/>
                                <br/>
                            </xsl:for-each>
                        </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">x</span>
                        </button>
                    </div>
                    <div class="modal-content">
                        <table class="table table-striped">
                            <tbody>
                                <xsl:for-each select="//tei:correspAction">
                                    <tr>
                                        <th>
                                            <xsl:choose>
                                                <xsl:when test="@type = 'sent'"> Versand: </xsl:when>
                                                <xsl:when test="@type = 'received'"> Empfangen: </xsl:when>
                                                <xsl:when test="@type = 'forwarded'">
                                                  Weitergeleitet: </xsl:when>
                                                <xsl:when test="@type = 'redirected'"> Umgeleitet: </xsl:when>
                                                <xsl:when test="@type = 'transmitted'"> Übermittelt:
                                                </xsl:when>
                                            </xsl:choose>
                                        </th>
                                        <td> </td>
                                        <td>
                                            <xsl:if test="./tei:date">
                                                <xsl:value-of select="./tei:date"/>
                                                <br/>
                                            </xsl:if>
                                            <xsl:if test="./tei:persName">
                                                <xsl:value-of select="./tei:persName" separator="; "/>
                                                <br/>
                                            </xsl:if>
                                            <xsl:if test="./tei:placeName">
                                                <xsl:value-of select="./tei:placeName"
                                                  separator="; "/>
                                                <br/>
                                            </xsl:if>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <br/>
                        <xsl:for-each select="//tei:witness">
                            <h5>TEXTZEUGE <xsl:value-of select="@n"/>
                            </h5>
                            <table class="table table-striped">
                                <tbody>
                                    <xsl:if test="tei:msDesc/tei:msIdentifier">
                                        <tr>
                                            <th>Signatur </th>
                                            <td>
                                                <xsl:for-each
                                                  select="tei:msDesc/tei:msIdentifier/child::*">
                                                  <xsl:value-of select="."/>
                                                  <xsl:if test="not(position() = last())">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                </xsl:for-each>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="//tei:physDesc">
                                        <tr>
                                            <th>Beschreibung </th>
                                            <td>
                                                <xsl:apply-templates
                                                  select="tei:msDesc/tei:physDesc/tei:objectDesc"/>
                                            </td>
                                        </tr>
                                        <xsl:if test="tei:msDesc/tei:physDesc/tei:typeDesc">
                                            <xsl:apply-templates
                                                select="tei:msDesc/tei:physDesc/tei:typeDesc"/>
                                        </xsl:if>
                                        <xsl:if test="tei:msDesc/tei:physDesc/tei:handDesc">
                                            <xsl:apply-templates
                                                select="tei:msDesc/tei:physDesc/tei:handDesc"/>
                                        </xsl:if>
                                        <xsl:if test="tei:msDesc/tei:physDesc/tei:additions">
                                            <tr>
                                                <th/>
                                                <th>Zufügungen</th>
                                            </tr>
                                            <xsl:apply-templates
                                                select="tei:msDesc/tei:physDesc/tei:additions"/>
                                        </xsl:if>
                                    </xsl:if>
                                </tbody>
                            </table>
                        </xsl:for-each>
                        <xsl:for-each select="//tei:biblStruct">
                            <h5>DRUCK <xsl:value-of select="position()"/>
                            </h5>
                            <table class="table table-striped">
                                <tbody>
                                    <tr>
                                        <th/>
                                        <td>
                                            <xsl:choose>
                                                <!-- Zuerst Analytic -->
                                                <xsl:when test="./tei:analytic">
                                                  <xsl:value-of select="foo:analytic-angabe(.)"/>
                                                  <xsl:text> </xsl:text>
                                                  <xsl:text>In: </xsl:text>
                                                  <xsl:value-of
                                                  select="foo:monogr-angabe(./tei:monogr[last()])"/>
                                                </xsl:when>
                                                <!-- Jetzt abfragen ob mehrere monogr -->
                                                <xsl:when test="count(./tei:monogr) = 2">
                                                  <xsl:value-of
                                                  select="foo:monogr-angabe(./tei:monogr[last()])"/>
                                                  <xsl:text>. Band</xsl:text>
                                                  <xsl:text>: </xsl:text>
                                                  <xsl:value-of
                                                  select="foo:monogr-angabe(./tei:monogr[1])"/>
                                                </xsl:when>
                                                <!-- Ansonsten ist es eine einzelne monogr -->
                                                <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="foo:monogr-angabe(./tei:monogr[last()])"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:if
                                                test="not(empty(./tei:monogr//tei:biblScope[@unit = 'sec']))">
                                                <xsl:text>, Sec. </xsl:text>
                                                <xsl:value-of
                                                  select="./tei:monogr//tei:biblScope[@unit = 'sec']"
                                                />
                                            </xsl:if>
                                            <xsl:if
                                                test="not(empty(./tei:monogr//tei:biblScope[@unit = 'pp']))">
                                                <xsl:text>, S. </xsl:text>
                                                <xsl:value-of
                                                  select="./tei:monogr//tei:biblScope[@unit = 'pp']"
                                                />
                                            </xsl:if>
                                            <xsl:if
                                                test="not(empty(./tei:monogr//tei:biblScope[@unit = 'col']))">
                                                <xsl:text>, Sp. </xsl:text>
                                                <xsl:value-of
                                                  select="./tei:monogr//tei:biblScope[@unit = 'col']"
                                                />
                                            </xsl:if>
                                            <xsl:if test="not(empty(./tei:series))">
                                                <xsl:text> (</xsl:text>
                                                <xsl:value-of select="./tei:series/tei:title"/>
                                                <xsl:if test="./tei:series/tei:biblScope">
                                                  <xsl:text>, </xsl:text>
                                                  <xsl:value-of select="./tei:series/tei:biblScope"
                                                  />
                                                </xsl:if>
                                                <xsl:text>)</xsl:text>
                                            </xsl:if>
                                            <xsl:text>.</xsl:text>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </xsl:for-each>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:function name="foo:analytic-angabe">
        <xsl:param name="gedruckte-quellen" as="node()"/>
        <!--  <xsl:param name="vor-dem-at" as="xs:boolean"/><!-\- Der Parameter ist gesetzt, wenn auch der Sortierungsinhalt vor dem @ ausgegeben werden soll -\-><xsl:param name="quelle-oder-literaturliste" as="xs:boolean"/><!-\- Ists Quelle, kommt der Titel kursiv und der Autor Vorname Name -\->-->
        <xsl:variable name="analytic" as="node()" select="$gedruckte-quellen/tei:analytic"/>
        <xsl:choose>
            <xsl:when test="$analytic/tei:author[2]">
                <xsl:value-of
                    select="foo:autor-rekursion($analytic, 1, count($analytic/tei:author))"/>
                <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:when test="$analytic/tei:author[1]">
                <xsl:value-of select="foo:vorname-vor-nachname($analytic/tei:author)"/>
                <xsl:text>: </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="not($analytic/tei:title/@type = 'j')">
                <span class="italic">
                    <xsl:value-of select="normalize-space($analytic/tei:title)"/>
                    <xsl:choose>
                        <xsl:when test="ends-with(normalize-space($analytic/tei:title), '!')"/>
                        <xsl:when test="ends-with(normalize-space($analytic/tei:title), '?')"/>
                        <xsl:otherwise>
                            <xsl:text>.</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space($analytic/tei:title)"/>
                <xsl:choose>
                    <xsl:when test="ends-with(normalize-space($analytic/tei:title), '!')"/>
                    <xsl:when test="ends-with(normalize-space($analytic/tei:title), '?')"/>
                    <xsl:otherwise>
                        <xsl:text>.</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$analytic/tei:editor[1]">
            <xsl:text>. </xsl:text>
            <xsl:choose>
                <xsl:when test="$analytic/tei:editor[2]">
                    <xsl:text>Hg. </xsl:text>
                    <xsl:value-of
                        select="foo:editor-rekursion($analytic, 1, count($analytic/tei:editor))"/>
                </xsl:when>
                <xsl:when
                    test="$analytic/tei:editor[1] and contains($analytic/tei:editor[1], ', ') and not(count(contains($analytic/tei:editor[1], ' ')) &gt; 2) and not(contains($analytic/tei:editor[1], 'Hg') or contains($analytic/tei:editor[1], 'Hrsg'))">
                    <xsl:text>Hg. </xsl:text>
                    <xsl:value-of select="foo:vorname-vor-nachname($analytic/tei:editor/text())"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$analytic/tei:editor/text()"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>.</xsl:text>
        </xsl:if>
    </xsl:function>
    <xsl:function name="foo:monogr-angabe">
        <xsl:param name="monogr" as="node()"/>
        <xsl:choose>
            <xsl:when test="$monogr/tei:author[2]">
                <xsl:value-of select="foo:autor-rekursion($monogr, 1, count($monogr/tei:author))"/>
                <xsl:text>: </xsl:text>
            </xsl:when>
            <xsl:when test="$monogr/tei:author[1]">
                <xsl:value-of select="foo:vorname-vor-nachname($monogr/tei:author/text())"/>
                <xsl:text>: </xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:value-of select="$monogr/tei:title"/>
        <xsl:if test="$monogr/tei:editor[1]">
            <xsl:text>. </xsl:text>
            <xsl:choose>
                <xsl:when test="$monogr/tei:editor[2]">
                    <!-- es gibt mehr als einen Herausgeber -->
                    <xsl:text>Hgg. </xsl:text>
                    <xsl:for-each select="$monogr/tei:editor">
                        <xsl:choose>
                            <xsl:when test="contains(., ', ')">
                                <xsl:value-of
                                    select="concat(substring-after(normalize-space(.), ', '), ' ', substring-before(normalize-space(.), ', '))"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="position() = last()"/>
                            <xsl:when test="position() = last() - 1">
                                <xsl:text> und </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>, </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when
                    test="contains($monogr/tei:editor, 'Hg.') or contains($monogr/tei:editor, 'Hrsg.') or contains($monogr/tei:editor, 'erausge') or contains($monogr/tei:editor, 'Edited')">
                    <xsl:value-of select="$monogr/tei:editor"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Hg. </xsl:text>
                    <xsl:choose>
                        <xsl:when test="contains($monogr/tei:editor, ', ')">
                            <xsl:value-of
                                select="concat(substring-after(normalize-space($monogr/tei:editor), ', '), ' ', substring-before(normalize-space($monogr/tei:editor), ', '))"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$monogr/tei:editor"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$monogr/tei:edition">
            <xsl:text>. </xsl:text>
            <xsl:value-of select="$monogr/tei:edition"/>
        </xsl:if>
        <xsl:choose>
            <!-- Hier Abfrage, ob es ein Journal ist -->
            <xsl:when test="$monogr/tei:title[@level = 'j']">
                <xsl:value-of select="foo:jg-bd-nr($monogr)"/>
            </xsl:when>
            <!-- Im anderen Fall müsste es ein 'm' für monographic sein -->
            <xsl:otherwise>
                <xsl:if test="$monogr[child::tei:imprint]">
                    <xsl:text>. </xsl:text>
                    <xsl:value-of select="foo:imprint-in-index($monogr)"/>
                </xsl:if>
                <xsl:if test="$monogr/tei:biblScope/@unit = 'vol'">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$monogr/tei:biblScope[@unit = 'vol']"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="foo:autor-rekursion">
        <xsl:param name="monogr" as="node()"/>
        <xsl:param name="autor-count"/>
        <xsl:param name="autor-count-gesamt"/>
        <!-- in den Fällen, wo ein Text unter einem Kürzel erschien, wird zum sortieren der key-Wert verwendet -->
        <xsl:value-of select="foo:vorname-vor-nachname($monogr/tei:author[$autor-count])"/>
        <xsl:if test="$autor-count &lt; $autor-count-gesamt">
            <xsl:text>, </xsl:text>
            <xsl:value-of
                select="foo:autor-rekursion($monogr, $autor-count + 1, $autor-count-gesamt)"/>
        </xsl:if>
    </xsl:function>
    <xsl:function name="foo:editor-rekursion">
        <xsl:param name="monogr" as="node()"/>
        <xsl:param name="autor-count"/>
        <xsl:param name="autor-count-gesamt"/>
        <!-- in den Fällen, wo ein Text unter einem Kürzel erschien, wird zum sortieren der key-Wert verwendet -->
        <xsl:value-of select="foo:vorname-vor-nachname($monogr/tei:editor[$autor-count])"/>
        <xsl:if test="$autor-count &lt; $autor-count-gesamt">
            <xsl:text>, </xsl:text>
            <xsl:value-of
                select="foo:autor-rekursion($monogr, $autor-count + 1, $autor-count-gesamt)"/>
        </xsl:if>
    </xsl:function>
    <xsl:function name="foo:vorname-vor-nachname">
        <xsl:param name="autorname"/>
        <xsl:choose>
            <xsl:when test="contains($autorname, ', ')">
                <xsl:value-of select="substring-after($autorname, ', ')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring-before($autorname, ', ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$autorname"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="foo:jg-bd-nr">
        <xsl:param name="monogr"/>
        <!-- Ist Jahrgang vorhanden, stehts als erstes -->
        <xsl:if test="$monogr//tei:biblScope[@unit = 'jg']">
            <xsl:text>, Jg. </xsl:text>
            <xsl:value-of select="$monogr//tei:biblScope[@unit = 'jg']"/>
        </xsl:if>
        <!-- Ist Band vorhanden, stets auch -->
        <xsl:if test="$monogr//tei:biblScope[@unit = 'vol']">
            <xsl:text>, Bd. </xsl:text>
            <xsl:value-of select="$monogr//tei:biblScope[@unit = 'vol']"/>
        </xsl:if>
        <!-- Jetzt abfragen, wie viel vom Datum vorhanden: vier Stellen=Jahr, sechs Stellen: Jahr und Monat, acht Stellen: komplettes Datum
              Damit entscheidet sich, wo das Datum platziert wird, vor der Nr. oder danach, oder mit Komma am Schluss -->
        <xsl:choose>
            <xsl:when test="string-length($monogr/tei:imprint/tei:date/@when) = 4">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="$monogr/tei:imprint/tei:date"/>
                <xsl:text>)</xsl:text>
                <xsl:if test="$monogr//tei:biblScope[@unit = 'nr']">
                    <xsl:text> Nr. </xsl:text>
                    <xsl:value-of select="$monogr//tei:biblScope[@unit = 'nr']"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="string-length($monogr/tei:imprint/tei:date/@when) = 6">
                <xsl:if test="$monogr//tei:biblScope[@unit = 'nr']">
                    <xsl:text>, Nr. </xsl:text>
                    <xsl:value-of select="$monogr//tei:biblScope[@unit = 'nr']"/>
                </xsl:if>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="normalize-space(($monogr/tei:imprint/tei:date))"/>
                <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$monogr//tei:biblScope[@unit = 'nr']">
                    <xsl:text>, Nr. </xsl:text>
                    <xsl:value-of select="$monogr//tei:biblScope[@unit = 'nr']"/>
                </xsl:if>
                <xsl:if test="$monogr/tei:imprint/tei:date">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="normalize-space(($monogr/tei:imprint/tei:date))"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="foo:imprint-in-index">
        <xsl:param name="monogr" as="node()"/>
        <xsl:variable name="imprint" as="node()" select="$monogr/tei:imprint"/>
        <xsl:choose>
            <xsl:when test="$imprint/tei:pubPlace != ''">
                <xsl:value-of select="$imprint/tei:pubPlace" separator=", "/>
                <xsl:choose>
                    <xsl:when test="$imprint/tei:publisher != ''">
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="$imprint/tei:publisher"/>
                        <xsl:choose>
                            <xsl:when test="$imprint/tei:date != ''">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$imprint/tei:date"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$imprint/tei:date != ''">
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="$imprint/tei:date"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$imprint/tei:publisher != ''">
                        <xsl:value-of select="$imprint/tei:publisher"/>
                        <xsl:choose>
                            <xsl:when test="$imprint/tei:date != ''">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$imprint/tei:date"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$imprint/tei:date != ''">
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="$imprint/tei:date"/>
                        <xsl:text>)</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <!-- Kommentar und Textkonstitution -->
    <xsl:template match="tei:note[@type = 'commentary']" mode="lemma-k">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:note[@type = 'textConst']" mode="lemma-k"/>
    <xsl:template match="tei:note[@type = 'textConst']" mode="lemma-t">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:note[@type = 'commentary']" mode="lemma-t"/>
    <xsl:template match="tei:note[@type = 'commentary']" mode="lemma">
        <span class="kommentar-text">
            <xsl:apply-templates select="*[not(name() = tei:anchor or name() = tei:note)]"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:note[@type = 'textConst']" mode="lemma">
        <span class="kommentar-text">
            <xsl:apply-templates select="*[not(name() = tei:anchor or name() = tei:note)]"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:anchor[@type = 'textConst']" mode="lemma">
        <xsl:variable name="xmlid" select="concat(@xml:id, 'h')"/>
        <p class="kommentar">
            <xsl:for-each-group select="following-sibling::node()"
                group-ending-with="//tei:note[@type = 'textConst' and @xml:id = $xmlid]">
                <xsl:if test="position() eq 1">
                    <span class="lemma">
                        <xsl:apply-templates select="current-group()[position() != last()]"
                            mode="lemma-t"/>] </span>
                </xsl:if>
            </xsl:for-each-group>
            <span class="kommentar-text">
                <xsl:apply-templates select="following-sibling::tei:note[@type = 'textConst'][1]"
                    mode="lemma-t"/>
            </span>
        </p>
    </xsl:template>
    <xsl:template match="tei:anchor[@type = 'commentary']" mode="lemma">
        <p class="kommentar">
            <xsl:variable name="xmlid" select="concat(@xml:id, 'h')"/>
            <xsl:for-each-group select="following-sibling::node()"
                group-ending-with="//tei:note[@type = 'commentary' and @xml:id = $xmlid]">
                <xsl:if test="position() eq 1">
                    <span class="lemma">
                        <xsl:apply-templates select="current-group()[position() != last()]"
                            mode="lemma-k"/>] </span>
                </xsl:if>
            </xsl:for-each-group>
            <span class="kommentar-text">
                <xsl:apply-templates select="following-sibling::tei:note[@type = 'commentary'][1]"
                    mode="lemma-k"/>
            </span>
        </p>
    </xsl:template>
    <xsl:template match="tei:add[@place and not(parent::tei:subst)]">
        <span class="add">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- Streichung -->
    <xsl:template match="tei:del[not(ancestor::tei:physDesc)]"/>
    <xsl:template match="tei:del[(ancestor::tei:physDesc)]">
        <span class="del">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- Substi -->
    <xsl:template match="tei:subst">
        <span class="subst-add">
            <xsl:apply-templates select="tei:add"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:footNote">
        <xsl:if test="preceding-sibling::*[1][name() = 'footNote']">
            <!-- Sonderregel für zwei Fußnoten in Folge -->
            <sup>
                <xsl:text>,</xsl:text>
            </sup>
        </xsl:if>
        <xsl:element name="a">
            <xsl:attribute name="class">
                <xsl:text>reference</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#footnote</xsl:text>
                <xsl:number level="any" count="tei:footNote" format="1"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="tei:footNote" format="1"/>
            </sup>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:footNote" mode="footnote">
        <xsl:element name="li">
            <xsl:attribute name="id">
                <xsl:text>footnote</xsl:text>
                <xsl:number level="any" count="tei:footNote" format="1"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="tei:footNote" format="1"/>
            </sup>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:body">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:pb"/>
    <xsl:template match="tei:c[@rendition = '#langesS']" mode="lemma-k">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#langesS']" mode="lemma-t">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#langesS']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-m']">
        <span class="gemination">mm</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-n']">
        <span class="gemination">nn</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#kaufmannsund']">
        <xsl:text>&amp;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#kaufmannsund']" mode="lemma-k">
        <xsl:text>&amp;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#kaufmannsund']" mode="lemma-t">
        <xsl:text>&amp;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#tilde']">~</xsl:template>
    <xsl:template match="tei:c[@rendition = '#tilde']" mode="lemma-k">~</xsl:template>
    <xsl:template match="tei:c[@rendition = '#tilde']" mode="lemma-t">~</xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']">
        <xsl:text>{</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-zu']">
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']" mode="lemma-k">
        <xsl:text>{</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-zu']" mode="lemma-k">
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']" mode="lemma-t">
        <xsl:text>{</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-zu']" mode="lemma-t">
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']" mode="lemma-k">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']" mode="lemma-t">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:function name="foo:spaci-space">
        <xsl:param name="anzahl"/>
        <xsl:param name="gesamt"/>  <br/>
        <xsl:if test="$anzahl &lt; $gesamt">
            <xsl:value-of select="foo:spaci-space($anzahl, $gesamt)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:space[@unit = 'line']">
        <xsl:value-of select="foo:spaci-space(@quantity, @quantity)"/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-m']" mode="lemma-k">
        <span class="gemination">mm</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-n']" mode="lemma-k">
        <span class="gemination">nn</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#prozent']" mode="lemma-k">
        <xsl:text>%</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-m']" mode="lemma-t">
        <span class="gemination">mm</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-n']" mode="lemma-t">
        <span class="gemination">nn</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#prozent']" mode="lemma-t">
        <xsl:text>%</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#prozent']">
        <xsl:text>%</xsl:text>
    </xsl:template>
    <xsl:function name="foo:dots">
        <xsl:param name="anzahl"/> . <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="foo:dots($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:c[@rendition = '#dots']" mode="lemma-k">
        <xsl:value-of select="foo:dots(@n)"/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#dots']" mode="lemma-t">
        <xsl:value-of select="foo:dots(@n)"/>
    </xsl:template>
    <xsl:function name="foo:gaps">
        <xsl:param name="anzahl"/>
        <xsl:text>×</xsl:text>
        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="foo:gaps($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:div[@type = 'image'] | tei:figure">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:graphic">
        <div style="width:100%; text-align:center; padding-bottom: 1rem;">
            <img>
                <xsl:attribute name="src">
                    <xsl:value-of select="concat(@url, '.jpg')"/>
                </xsl:attribute>
                <xsl:attribute name="width">
                    <xsl:text>50%</xsl:text>
                </xsl:attribute>
            </img>
        </div>
    </xsl:template>
    <!-- Verweise auf andere Dokumente   -->
    <xsl:template match="tei:ref[not(@type = 'schnitzlerDiary') and not(@type = 'toLetter')]">
        <xsl:choose>
            <xsl:when test="@target[ends-with(., '.xml')]">
                <xsl:element name="a">
                    <xsl:attribute name="class">reference</xsl:attribute>
                    <xsl:attribute name="href"> show.html?ref=<xsl:value-of
                            select="tokenize(./@target, '/')[4]"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:ref[@type = 'schnitzlerDiary']">
        <xsl:if test="not(@subtype = 'date-only')">
            <xsl:choose>
                <xsl:when test="@subtype = 'See'">
                    <xsl:text>Siehe </xsl:text>
                </xsl:when>
                <xsl:when test="@subtype = 'Cf'">
                    <xsl:text>Vgl. </xsl:text>
                </xsl:when>
                <xsl:when test="@subtype = 'see'">
                    <xsl:text>siehe </xsl:text>
                </xsl:when>
                <xsl:when test="@subtype = 'cf'">
                    <xsl:text>vgl. </xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:text>A. S.: Tagebuch, </xsl:text>
        </xsl:if>
        <a>
            <xsl:attribute name="class">reference</xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of
                    select="concat('https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__', @target, '.html')"
                />
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="substring(@target, 9, 1) = '0'">
                    <xsl:value-of select="substring(@target, 10, 1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring(@target, 9, 2)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>. </xsl:text>
            <xsl:choose>
                <xsl:when test="substring(@target, 6, 1) = '0'">
                    <xsl:value-of select="substring(@target, 7, 1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring(@target, 6, 2)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>. </xsl:text>
            <xsl:value-of select="substring(@target, 1, 4)"/>
        </a>
    </xsl:template>
    <xsl:template match="tei:ref[@type = 'toLetter']">
        <xsl:choose>
            <xsl:when test="@subtype = 'date-only'">
                <a>
                    <xsl:attribute name="class">reference</xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of
                            select="concat('https://schnitzler-briefe.acdh.oeaw.ac.at/pages/show.html?document=', @target)"
                        />
                    </xsl:attribute>
                    <xsl:value-of select="tei:date/text()"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@subtype = 'see'">
                        <xsl:text>Siehe </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'cf'">
                        <xsl:text>Vgl. </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <a>
                    <xsl:attribute name="class">reference</xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of
                            select="concat('https://schnitzler-briefe.acdh.oeaw.ac.at/pages/show.html?document=', @target)"
                        />
                    </xsl:attribute>
                    <xsl:value-of select="tei:title/text()"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Titel kursiv, wenn in Kommentar -->
    <xsl:template
        match="tei:rs[@type = 'work' and not(ancestor::tei:quote) and ancestor::tei:note and not(@subtype = 'implied')]/text()">
        <span class="italics">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <!-- <rs> -->
    <xsl:template match="tei:rs[(@ref or @key) and ancestor::tei:rs]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:rs[(@ref or @key) and not(ancestor::tei:rs)]">
        <!-- das template macht aus allen @refs eine liste, die vorne den typ enthält, also beispielsweise
        so: data-keys="work:pmb33436 person:pmb2425 person:pmb2456"
        es gibt ein gemurkse mit den leerzeichen, die zuerst als ä gesetzt werden, damit sie nicht verloren gehen-->
        <xsl:variable name="unteres-element">
            <xsl:for-each select="descendant::tei:rs">
                <xsl:variable name="type" select="@type"/>
                <xsl:for-each select="tokenize(@ref, ' ')">
                    <xsl:value-of select="$type"/>
                    <xsl:text>:</xsl:text>
                    <xsl:value-of select="concat(substring-after(., '#'), 'ä')"/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="current">
            <xsl:variable name="type" select="@type"/>
            <xsl:for-each select="tokenize(@ref, ' ')">
                <xsl:value-of select="$type"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="concat(substring-after(., '#'), 'ä')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="data-keys"
            select="normalize-space(replace(concat($current, $unteres-element), 'ä', ' '))"/>
        <xsl:element name="a">
            <xsl:choose>
                <xsl:when
                    test="string-length($data-keys) - string-length(translate($data-keys, 'pmb', '')) = 4">
                    <xsl:attribute name="data-key">
                        <xsl:value-of select="substring-after(data(@ref), '#')"/>
                    </xsl:attribute>
                    <xsl:attribute name="data-type">
                        <xsl:value-of select="concat('list', @type, '.xml')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="data-keys">
                        <xsl:value-of select="$data-keys"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!-- Ende rs -->
    <!-- Ergänzungen für neues physDesc -->
    <xsl:template match="tei:incident/tei:desc/tei:stamp">
        <xsl:text>Stempel </xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>:</xsl:text>
        <br/>
        <xsl:if test="tei:placeName"> Ort: <xsl:apply-templates select="./tei:placeName"/>
            <br/>
        </xsl:if>
        <xsl:if test="tei:date"> Datum: <xsl:apply-templates select="./tei:date"/>
            <br/>
        </xsl:if>
        <xsl:if test="tei:time"> Zeit: <xsl:apply-templates select="./tei:time"/>
            <br/>
        </xsl:if>
        <xsl:if test="tei:addSpan"> Vorgang: <xsl:apply-templates select="./tei:addSpan"/>
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:incident">
        <tr>
            <xsl:apply-templates select="tei:desc"/>
        </tr>
    </xsl:template>
    <xsl:template match="tei:additions">
        <xsl:apply-templates select="tei:incident[@type = 'supplement']"/>
        <xsl:apply-templates select="tei:incident[@type = 'postal']"/>
        <xsl:apply-templates select="tei:incident[@type = 'receiver']"/>
        <xsl:apply-templates select="tei:incident[@type = 'archival']"/>
        <xsl:apply-templates select="tei:incident[@type = 'additional-information']"/>
        <xsl:apply-templates select="tei:incident[@type = 'editorial']"/>
    </xsl:template>
    <xsl:template match="tei:incident[@type = 'supplement']/tei:desc">
        <tr>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'supplement'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'supplement'])">
                    <th>Beilage</th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'supplement']">
                    <th>Beilagen</th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'postal']]">
        <xsl:variable name="poschitzion"
            select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'postal'])"/>
        <xsl:choose>
            <xsl:when test="$poschitzion &gt; 0">
                <tr>
                    <th/>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'postal'])">
                <tr>
                    <th>
                        <xsl:text>Versand</xsl:text>
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'postal']">
                <tr>
                    <th>
                        <xsl:text>Versand</xsl:text>
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:incident[@type = 'receiver']/tei:desc">
        <tr>
            <xsl:variable name="receiver"
                select="substring-before(ancestor::tei:teiHeader//tei:correspDesc/tei:correspAction[@type = 'received']/tei:persName[1], ',')"/>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'receiver'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'receiver']">
                    <th>
                        <xsl:value-of select="$receiver"/>
                    </th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <th>
                        <xsl:value-of select="$receiver"/>
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </xsl:otherwise>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'archival']]">
        <tr>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'archival'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'archival'])">
                    <th>
                        <xsl:text>Ordnung</xsl:text>
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'archival']">
                    <th>
                        <xsl:text>Ordnung</xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'additional-information']]">
        <tr>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'additional-information'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'additional-information'])">
                    <th>
                        <xsl:text>Zusatz</xsl:text>
                    </th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'additional-information']">
                    <th>
                        <xsl:text>Zusatz</xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'editorial']]">
        <tr>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'editorial'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'editorial'])">
                    <th>Editorischer Hinweis</th>
                    <td>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'editorial']">
                    <th>Editorischer Hinweise</th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:typeDesc">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:typeDesc/tei:p">
        <tr>
            <xsl:choose>
                <xsl:when test="not(preceding-sibling::tei:p)">
                    <th>Typografie</th>
                </xsl:when>
                <xsl:otherwise>
                    <th/>
                </xsl:otherwise>
            </xsl:choose>
            <td>
                <xsl:apply-templates/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="tei:handDesc">
        <xsl:choose>
            <!-- Nur eine Handschrift, diese demnach vom Autor/der Autorin: -->
            <xsl:when test="not(child::tei:handNote[2]) and not(tei:handNote/@corresp)">
                <tr>
                    <th>Handschrift</th>
                    <td>
                        <xsl:value-of select="foo:handNote(tei:handNote)"/>
                    </td>
                </tr>
            </xsl:when>
            <!-- Nur eine Handschrift, diese nicht vom Autor/der Autorin: -->
            <xsl:when test="not(child::tei:handNote[2]) and (tei:handNote/@corresp)">
                <xsl:choose>
                    <xsl:when test="handNote/@corresp = 'schreibkraft'">
                        <tr>
                            <th>Handschrift einer Schreibkraft</th>
                            <td>
                                <xsl:value-of select="foo:handNote(tei:handNote)"/>
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="sender"
                            select="ancestor::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'sent']/tei:persName[@ref = tei:handNote/@corresp]"/>
                        <tr>
                            <th>Handschrift <xsl:value-of select="$sender"/>
                            </th>
                            <td>
                                <xsl:value-of select="foo:handNote(tei:handNote)"/>
                            </td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="handDesc-v" select="current()"/>
                <xsl:variable name="sender"
                    select="ancestor::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'sent']"
                    as="node()"/>
                <xsl:for-each select="distinct-values(tei:handNote/@corresp)">
                    <xsl:variable name="corespi" select="."/>
                    <xsl:variable name="corespi-name" select="$sender/tei:persName[@ref = $corespi]"/>
                    <xsl:choose>
                        <xsl:when test="count($handDesc-v/tei:handNote[@corresp = $corespi]) = 1">
                            <tr>
                                <th>Handschrift <xsl:value-of
                                        select="foo:vorname-vor-nachname($corespi-name)"/>
                                </th>
                                <td>
                                    <xsl:value-of
                                        select="foo:handNote($handDesc-v/tei:handNote[@corresp = $corespi])"
                                    />
                                </td>
                            </tr>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="$handDesc-v/tei:handNote[@corresp = $corespi]">
                                <tr>
                                    <xsl:choose>
                                        <xsl:when test="position() = 1">
                                            <th>Handschrift <xsl:value-of
                                                  select="foo:vorname-vor-nachname($corespi-name)"/>
                                            </th>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <th/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <td>
                                        <xsl:variable name="poschitzon" select="position()"/>
                                        <xsl:value-of select="$poschitzon"/>
                                        <xsl:text>) </xsl:text>
                                        <xsl:value-of select="foo:handNote(current())"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:function name="foo:handNote">
        <xsl:param name="entry" as="node()"/>
        <xsl:choose>
            <xsl:when test="$entry/@medium = 'bleistift'">
                <xsl:text>Bleistift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'roter_buntstift'">
                <xsl:text>roter Buntstift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'blauer_buntstift'">
                <xsl:text>blauer Buntstift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'gruener_buntstift'">
                <xsl:text>grüner Buntstift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'schwarze_tinte'">
                <xsl:text>schwarze Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'blaue_tinte'">
                <xsl:text>blaue Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'gruene_tinte'">
                <xsl:text>grüne Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'rote_tinte'">
                <xsl:text>rote Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'anderes'">
                <xsl:text>anderes Schreibmittel</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="not($entry/@style = 'nicht_anzuwenden')">
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$entry/@style = 'deutsche-kurrent'">
                <xsl:text>deutsche Kurrentschrift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@style = 'lateinische-kurrent'">
                <xsl:text>lateinische Kurrentschrift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@style = 'gabelsberger'">
                <xsl:text>Gabelsberger Kurzschrift</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="string-length(normalize-space($entry/.)) &gt; 1">
            <xsl:text> (</xsl:text>
            <xsl:apply-templates select="($entry/.)"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:objectDesc/tei:desc[@type = '_blaetter']">
        <xsl:choose>
            <xsl:when test="parent::tei:objectDesc/tei:desc/@type = 'karte'">
                <xsl:choose>
                    <xsl:when test="@n = '1'">
                        <xsl:value-of select="concat(@n, ' Karte')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(@n, ' Karten')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@n = '1'">
                        <xsl:value-of select="concat(@n, ' Blatt')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(@n, ' Blätter')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length(.) &gt; 1">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = '_seiten']">
        <xsl:text>, </xsl:text>
        <xsl:choose>
            <xsl:when test="@n = '1'">
                <xsl:value-of select="concat(@n, ' Seite')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(@n, ' Seiten')"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length(.) &gt; 1">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:if
            test="preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'entwurf' or @type = 'reproduktion'] or following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'entwurf' or @type = 'reproduktion']">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc">
        <xsl:apply-templates
            select="tei:desc[@type = 'karte' or @type = 'bild' or @type = 'kartenbrief' or @type = 'brief' or @type = 'telegramm' or @type = 'widmung' or @type = 'anderes']"/>
        <xsl:apply-templates select="tei:desc[@type = '_blaetter']"/>
        <xsl:apply-templates select="tei:desc[@type = '_seiten']"/>
        <xsl:apply-templates select="tei:desc[@type = 'umschlag']"/>
        <xsl:apply-templates select="tei:desc[@type = 'reproduktion']"/>
        <xsl:apply-templates select="tei:desc[@type = 'entwurf']"/>
        <xsl:apply-templates select="tei:desc[@type = 'fragment']"/>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'karte']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@subtype = 'bildpostkarte'">
                <xsl:text>Bildpostkarte</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'postkarte'">
                <xsl:text>Postkarte</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'briefkarte'">
                <xsl:text>Briefkarte</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'visitenkarte'">
                <xsl:text>Visitenkarte</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Karte</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'reproduktion']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@subtype = 'fotokopie'">
                <xsl:text>Fotokopie</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'fotografische_vervielfaeltigung'">
                <xsl:text>Fotografische Vervielfältigung</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'ms_abschrift'">
                <xsl:text>maschinelle Abschrift</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'hs_abschrift'">
                <xsl:text>handschriftliche Abschrift</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'durchschlag'">
                <xsl:text>maschineller Durchschlag</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Reproduktion</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type='_blaetter' or @type='_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'or @type='_blaetter' or @type='_seiten'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'widmung']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_vorsatzblatt'">
                <xsl:text>Widmung am Vorsatzblatt</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_titelblatt'">
                <xsl:text>Widmung am Titelblatt</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_vortitel'">
                <xsl:text>Widmung am Vortitel</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_schmutztitel'">
                <xsl:text>Widmung am Schmutztitel</xsl:text>
            </xsl:when>
            <xsl:when test="@subtype = 'widmung_umschlag'">
                <xsl:text>Widmung am Umschlag</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Widmung</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'brief']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Brief</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'bild']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@subtype = 'fotografie'">
                <xsl:text>Fotografie</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Bild</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'kartenbrief']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Kartenbrief</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type='_blaetter' or @type='_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type='_blaetter' or @type='_seiten'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'umschlag']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Umschlag</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'telegramm']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Telegramm</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'anderes']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>XXXXAnderes</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf' or @type = '_blaetter' or @type = '_seiten']) or (preceding-sibling::tei:desc[@type = 'umschlag' or @type = 'fragment' or @type = 'reproduktion' or @type = 'entwurf'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'entwurf']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Entwurf</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="(following-sibling::tei:desc[@type = 'fragment']) or (preceding-sibling::tei:desc[@type = 'fragment'])">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[@type = 'fragment']">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.)) &gt; 1">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Fragment</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:objectDesc/tei:desc[not(@type)]">
        <xsl:text>XXXX desc-Fehler</xsl:text>
    </xsl:template>
    <xsl:template match="tei:back">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:back/tei:listPerson[child::*[1]]">
        <span class="lemma">Erwähnte Personen: </span>
        <span class="kommentar-text">
            <xsl:apply-templates select="tei:person"/>
            <xsl:if
                test="following-sibling::tei:listBibl/*[1] or following-sibling::tei:listPlace/*[1] or following-sibling::tei:listOrg/*[1]">
                <xsl:text> — </xsl:text>
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="tei:back/tei:listBibl[child::*[1]]">
        <span class="lemma">Erwähnte Werke: </span>
        <span class="kommentar-text">
            <xsl:apply-templates select="tei:bibl"/>
            <xsl:if
                test="child::*[1] and (following-sibling::tei:listPlace/*[1] or following-sibling::tei:listOrg/*[1])">
                <xsl:text> — </xsl:text>
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="tei:back/tei:listPlace[child::*[1]]">
        <span class="lemma">Erwähnte Orte: </span>
        <span class="kommentar-text">
            <xsl:apply-templates select="tei:place"/>
            <xsl:if test="child::*[1] and following-sibling::tei:listOrg/*[1]">
                <xsl:text> — </xsl:text>
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="tei:back/tei:listOrg[child::*[1]]">
        <span class="lemma">Erwähnte Institutionen: </span>
        <span class="kommentar-text">
            <xsl:apply-templates select="tei:org"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:back/tei:listPerson/tei:person">
        <xsl:apply-templates select="tei:persName[1]"/>
    </xsl:template>
    <xsl:template match="tei:back/tei:listPerson/tei:person/tei:persName">
        <a>
            <xsl:attribute name="data-key">
                <xsl:value-of select="parent::tei:person/@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="data-type">
                <xsl:text>listperson.xml</xsl:text>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="tei:surname and tei:forename">
                    <xsl:value-of select="concat(tei:forename, ' ', tei:surname)"/>
                </xsl:when>
                <xsl:when test="tei:surname">
                    <xsl:value-of select="tei:surname"/>
                </xsl:when>
                <xsl:when test="tei:forename">
                    <xsl:value-of select="tei:forename"/>
                </xsl:when>
            </xsl:choose>
        </a>
        <xsl:if test="parent::tei:person/following-sibling::tei:person">
            <xsl:text> – </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:back/tei:listBibl/tei:bibl">
        <xsl:if test="tei:author[@role = 'author']">
            <xsl:for-each select="tei:author[@role = 'author']">
                <a>
                    <xsl:attribute name="data-key">
                        <xsl:value-of select="@ref"/>
                    </xsl:attribute>
                    <xsl:attribute name="data-type">
                        <xsl:text>listperson.xml</xsl:text>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="tei:surname and tei:forename">
                            <xsl:value-of select="concat(tei:forename, ' ', tei:surname)"/>
                        </xsl:when>
                        <xsl:when test="tei:surname">
                            <xsl:value-of select="tei:surname"/>
                        </xsl:when>
                        <xsl:when test="tei:forename">
                            <xsl:value-of select="tei:forename"/>
                        </xsl:when>
                    </xsl:choose>
                </a>
                <xsl:if test="not(position() = last())">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>: </xsl:text>
        </xsl:if>
        <a>
            <xsl:attribute name="data-key">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="data-type">
                <xsl:text>listwork.xml</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="tei:title[1]"/>
        </a>
        <xsl:if test="tei:date">
            <xsl:value-of select="concat(' (', tei:date/text(), ')')"/>
        </xsl:if>
        <xsl:if test="following-sibling::tei:bibl">
            <xsl:text> – </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:back/tei:listPerson/tei:person/tei:persName">
        <a>
            <xsl:attribute name="data-key">
                <xsl:value-of select="parent::tei:person/@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="data-type">
                <xsl:text>listperson.xml</xsl:text>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="tei:surname and tei:forename">
                    <xsl:value-of select="concat(tei:forename, ' ', tei:surname)"/>
                </xsl:when>
                <xsl:when test="tei:surname">
                    <xsl:value-of select="tei:surname"/>
                </xsl:when>
                <xsl:when test="tei:forename">
                    <xsl:value-of select="tei:forename"/>
                </xsl:when>
            </xsl:choose>
        </a>
        <xsl:if test="parent::tei:person/following-sibling::tei:person">
            <xsl:text> – </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:back/tei:listPlace/tei:place">
        <xsl:apply-templates select="tei:placeName[1]"/>
    </xsl:template>
    <xsl:template match="tei:back/tei:listPlace/tei:place/tei:placeName">
        <a>
            <xsl:attribute name="data-key">
                <xsl:value-of select="parent::tei:place/@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="data-type">
                <xsl:text>listplace.xml</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </a>
        <xsl:if test="parent::tei:place/following-sibling::tei:place">
            <xsl:text> – </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:back/tei:listOrg/tei:org">
        <xsl:apply-templates select="tei:orgName[1]"/>
    </xsl:template>
    <xsl:template match="tei:back/tei:listOrg/tei:org/tei:orgName">
        <a>
            <xsl:attribute name="data-key">
                <xsl:value-of select="parent::tei:org/@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="data-type">
                <xsl:text>listorg.xml</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </a>
        <xsl:if test="parent::tei:org/following-sibling::tei:org">
            <xsl:text> – </xsl:text>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
