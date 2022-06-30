<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0">
    <!-- <xsl:strip-space elements="*"/>-->
    <xsl:import href="shared/base.xsl"/>
    <xsl:param name="document"/>
    <xsl:param name="app-name"/>
    <xsl:param name="collection-name"/>
    <xsl:param name="path2source"/>
    <xsl:param name="ref"/>
    <xsl:param name="prev"/>
    <xsl:param name="next"/>
    <!--
##################################
### Seitenlayout und -struktur ###
##################################
-->
    <xsl:template match="/">
        <div class="container">
            <div class="card">
                <div class="card-header">
                    <div class="row" style="text-align:left">
                        <div class="col-md-2" style="text-align:right"/>
                        
                        <div class="col-md-8" align="center">
                            <h1>
                                <xsl:value-of select="//tei:title[@level = 'a']"/>
                            </h1>
                            <h5>
                                <muted>
                                    <xsl:value-of select="//tei:title[@type = 'sub']"/>
                                </muted>
                            </h5>
                        </div>
                        <div class="col-md-2" style="text-align:right"/>
                        
                    </div>
                </div>
                <div class="card-body-meta">
                    <xsl:apply-templates select="//tei:body"/>
                    <p/>
                    <xsl:if test="descendant::tei:footNote">
                    <div class="card-body-footnotes">
                        <xsl:text>FUSSNOTEN</xsl:text>
                    <xsl:element name="ol">
                        <xsl:attribute name="footnotes">
                            <xsl:text>list-for-footnotes</xsl:text>
                        </xsl:attribute>
                        <xsl:apply-templates select="descendant::tei:footNote"
                            mode="footnote"/>
                    </xsl:element>
                    </div>
                    </xsl:if>
                    <!-- CMIF Sonderregel: -->
                    <xsl:if test="//tei:profileDesc/tei:correspDesc[10]">
                        <xsl:apply-templates select="//tei:profileDesc/tei:correspDesc"/>
                    </xsl:if>
                </div>
                <div class="card-footer text-muted" style="text-align:center"> ACDH-OeAW, <i>
                        <xsl:value-of select="//tei:title[@type = 'sub']"/> - <xsl:value-of select="//tei:title[@level = 'a']"/>
                    </i>
                    <br/>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$path2source"/>
                        </xsl:attribute> zum TEI Quellendokument </a>
                </div>
            </div>
        </div>
    </xsl:template>
    <!-- LISTPLACE -->
    <xsl:template match="tei:listPlace">
        <ul>
            <xsl:apply-templates select="tei:place" mode="listPlace"/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:place" mode="listPlace">
        <li>
            <xsl:apply-templates select="tei:placeName" mode="listTitle"/>
            <table>
                <xsl:apply-templates select="tei:*[not(self::tei:placeName)]" mode="tabelle"/>
            </table>
        </li>
    </xsl:template>
    <xsl:template match="tei:placeName|tei:orgName|tei:persName|tei:title" mode="listTitle">
        <b>
            <xsl:apply-templates/>
        </b>
        <br/>
    </xsl:template>
    <!-- LISTORG -->
    <xsl:template match="tei:listOrg">
        <ul>
            <xsl:apply-templates mode="listOrg"/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:org" mode="listOrg">
        <li>
            <xsl:apply-templates select="tei:orgName" mode="listTitle"/>
            <table>
                <xsl:apply-templates select="tei:*[not(self::tei:orgName)]" mode="tabelle"/>
            </table>
        </li>
    </xsl:template>
    <xsl:template match="tei:org/tei:place" mode="tabelle">
        <tr>
            <th>Ort</th>
            <td>
                <xsl:apply-templates select="tei:placeName" mode="tabelle"/>
            </td>
        </tr>
        <tr>
            <th/>
            <td>
                <xsl:apply-templates select="tei:location" mode="tabelle"/>
            </td>
        </tr>
    </xsl:template>
    <!-- LISTPERS -->
    <xsl:template match="tei:listPerson">
        <ul>
            <xsl:apply-templates mode="listPerson"/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:person" mode="listPerson">
        <li>
            <xsl:apply-templates select="tei:persName" mode="listTitle"/>
            <table>
                <xsl:choose>
                    <xsl:when test="tei:birth and tei:death">
                        <tr>
                            <xsl:choose>
                                <xsl:when test="tei:birth = tei:death">
                                    <th>Vorkommen</th>
                                    <td>
                                        <xsl:value-of select="tei:birth"/>
                                    </td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <th>Lebensdaten</th>
                                    <td>
                                        <xsl:value-of select="concat(tei:birth, '–', tei:death)"/>
                                    </td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tr>
                    </xsl:when>
                    <xsl:when test="tei:birth">
                        <tr>
                            <th>Geburt</th>
                            <td>
                                <xsl:value-of select="tei:birth"/>
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:when test="tei:death">
                        <tr>
                            <th>Tod</th>
                            <td>
                                <xsl:value-of select="tei:death"/>
                            </td>
                        </tr>
                    </xsl:when>
                </xsl:choose>
                <xsl:apply-templates select="tei:*[not(self::tei:persName or self::tei:birth or self::tei:death)]" mode="tabelle"/>
            </table>
        </li>
    </xsl:template>
    <xsl:template match="tei:occupation" mode="tabelle">
        <tr>
            <th>Beruf</th>
            <td>
               <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
   <!-- LISTWORK -->
    <xsl:template match="tei:listBibl">
        <ul>
            <xsl:apply-templates mode="list"/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:bibl" mode="list">
        <li>
            <xsl:apply-templates select="tei:title" mode="listTitle"/>
        </li>
        <table>
            <xsl:apply-templates select="tei:*[not(self::tei:title)]" mode="tabelle"/>
        </table>
    </xsl:template>
    <xsl:template match="tei:author" mode="tabelle">
        <tr>
        <th>Von</th>
        <td>
                <xsl:value-of select="." separator=", "/>
            </td>
        </tr>
    </xsl:template>
   

        
    
    <xsl:template match="tei:profileDesc">
        <xsl:if test="descendant::tei:correspDesc[10]">
            <xsl:apply-templates select="tei:correspDesc"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:correspDesc">
        <li style="margin: 2em 0;">
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="@ref"/>
                </xsl:attribute>
                <xsl:value-of select="@ref"/>
            </xsl:element>
            <br/>
            <xsl:for-each select="tei:correspAction">
                <table>
                    <tr>
                        <th style="padding-left: 0;">
                            <xsl:choose>
                                <xsl:when test="@type = 'sent'">
                                    <xsl:text>Sendung</xsl:text>
                                </xsl:when>
                                <xsl:when test="@type = 'received'">
                                    <xsl:text>Empfang</xsl:text>
                                </xsl:when>
                                <xsl:when test="@type = 'forwarded'">
                                    <xsl:text>Weiterleitung</xsl:text>
                                </xsl:when>
                                <xsl:when test="@type = 'redirected'">
                                    <xsl:text>Umleitung</xsl:text>
                                </xsl:when>
                                <xsl:when test="@type = 'transmitted'">
                                    <xsl:text>Aufgabe</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </th>
                    </tr>
                    <xsl:apply-templates select="tei:date | tei:persName | tei:placeName" mode="cmif"/>
                </table>
            </xsl:for-each>
        </li>
    </xsl:template>
    <xsl:template mode="cmif" match="tei:date">
        <tr>
            <td>Datum:</td>
            <td>
                <xsl:value-of select="normalize-space(.)"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template mode="cmif" match="tei:persName">
        <tr>
            <td>Akteur:</td>
            <td>
                <xsl:choose>
                    <xsl:when test="@ref">
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of select="@ref"/>
                            </xsl:attribute>
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
    <xsl:template mode="cmif" match="tei:placeName">
        <tr>
            <td>Ort:</td>
            <td>
                <xsl:choose>
                    <xsl:when test="@ref">
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of select="@ref"/>
                            </xsl:attribute>
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
    <!-- TABELLENZEILEN -->
    <xsl:template match="tei:desc" mode="tabelle">
        <xsl:apply-templates select="tei:*" mode="tabelle"/>
    </xsl:template>
    <xsl:template match="tei:gloss" mode="tabelle">
        <th>Typ</th>
        <td>
            <xsl:value-of select="."/>
        </td>
    </xsl:template>
    <xsl:template match="tei:date" mode="tabelle">
        <xsl:variable name="datum-von">
            <xsl:choose>
                <xsl:when test="contains(@from-custom, '|')">
                    <xsl:value-of select="substring-before(@from-custom, '|')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@from-custom"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="datum-bis">
            <xsl:choose>
                <xsl:when test="contains(@to-custom, '|')">
                    <xsl:value-of select="substring-before(@to-custom, '|')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@to-custom"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <xsl:choose>
                <xsl:when test="(@from-custom and @to-custom) and not(@from-custom = @to-custom)">
                    <th>Zeit</th>
                    <td>
                        <xsl:value-of select="$datum-von"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="$datum-bis"/>
                    </td>
                </xsl:when>
                <xsl:when test="(@from-custom and not(@to-custom)) or (@from-custom = @to-custom)">
                    <th>Datum</th>
                    <td>
                        <xsl:value-of select="$datum-von"/>
                    </td>
                </xsl:when>
                <xsl:when test="@to-custom and not(@from-custom)">
                    <th>Bis</th>
                    <td>
                        <xsl:value-of select="$datum-von"/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:location" mode="tabelle">
        <xsl:variable name="lat" select="tokenize(tei:geo, ' ')[1]"/>
        <xsl:variable name="long" select="tokenize(tei:geo, ' ')[2]"/>
        <tr>
            <th>Länge/Breite</th>
            <td>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('https://www.openstreetmap.org/?mlat=', $lat, '&amp;mlon=', $long)"/>
                    </xsl:attribute>
                    <xsl:value-of select="concat($lat, '/', $long)"/>
                </xsl:element>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="tei:code">
        <code><xsl:apply-templates/></code>
    </xsl:template>
    
    
</xsl:stylesheet>