<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0">
    <xsl:import href="shared/base_index.xsl"/>
    <xsl:param name="entiyID"/>
    
    <xsl:template match="/">
        <xsl:variable name="entity" as="node()" select="//tei:bibl[@xml:id=$entiyID][1]"/>
        <xsl:variable name="entity-vorhanden">
            <xsl:choose>
                <xsl:when test="//tei:bibl[@xml:id=$entiyID][1]">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$entity-vorhanden">
            <div class="modal" id="myModal" role="dialog">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <xsl:choose>
                            <xsl:when test="$entity">
                                <div class="modal-header">
                                    <h3 class="modal-title">
                                        <xsl:value-of select="$entity/tei:title"/>  
                                        <br/>
                                        <small>
                                            <xsl:if test="$entity/tei:author">
                                                <xsl:text>von </xsl:text>
                                                <xsl:choose>
                                                    <xsl:when test="$entity/tei:author[tei:surname and tei:forename]">
                                                        <xsl:value-of select="concat($entity/tei:author/tei:forename, ' ',$entity/tei:author/tei:surname)"/>
                                                    </xsl:when>
                                                    <xsl:when test="$entity/tei:author/tei:surname">
                                                        <xsl:value-of select="$entity/tei:author/tei:surname"/>
                                                    </xsl:when>
                                                    <xsl:when test="$entity/tei:author/tei:forename">
                                                        <xsl:value-of select="$entity/tei:author/tei:forename"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="$entity/tei:author"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <br/>
                                            </xsl:if>
                                            <xsl:if test="$entity/tei:date">
                                                <xsl:text>erschienen </xsl:text>
                                                <xsl:value-of select="$entity/tei:date"/><br/>
                                            </xsl:if>
                                            <xsl:if test="$entity/tei:gloss">
                                                <hi rend="italics"><xsl:value-of select="$entity/tei:gloss"/></hi><br/>
                                            </xsl:if>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="concat('hits.html?searchkey=', $entiyID)"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="target">_blank</xsl:attribute>
                                                Erwähnungen
                                            </a>
                                        </small>
                                    </h3>
                                    <button type="button" class="close" data-dismiss="modal">
                                        <span class="fa fa-times"/>
                                    </button>
                                </div>
                                <div class="modal-body-pmb">
                                    <div>
                                        <xsl:variable name="pmb-weg">
                                            <xsl:choose>
                                                <xsl:when test="contains($entiyID,'pmb')">
                                                    <xsl:value-of select="replace($entiyID,'pmb', '')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$entiyID"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:variable name="pmb-url" select="concat('https://pmb.acdh.oeaw.ac.at/apis/entities/entity/work/', $pmb-weg, '/detail')"/>
                                        <p class="pmbAbfrageText">
                                            <xsl:element name="a">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="$pmb-url"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="target">
                                                    <xsl:text>_blank</xsl:text>
                                                </xsl:attribute>
                                                <xsl:text>Zum PMB-Eintrag</xsl:text>
                                            </xsl:element>
                                        </p>
                                    </div>
                                    
                                    
                                </div>
                            </xsl:when>
                        </xsl:choose>
                        <div class="modal-footer"><!--<button type="button" class="btn btn-default" data-dismiss="modal">X</button>--></div>
                    </div>
                </div>
            </div>
        </xsl:if>
        <script type="text/javascript">
            $(window).load(function(){
            $('#myModal').modal('show');
            });
        </script>
    </xsl:template>
</xsl:stylesheet>