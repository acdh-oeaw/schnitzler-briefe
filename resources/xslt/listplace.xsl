<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0">
    <xsl:import href="shared/base_index.xsl"/>
    <xsl:param name="entiyID"/>
    <xsl:template match="/">
        <xsl:variable name="entity" as="node()" select="//tei:place[@xml:id=$entiyID][1]"/>
        <xsl:variable name="entity-vorhanden">
            <xsl:choose>
                <xsl:when test="//tei:place[@xml:id=$entiyID][1]">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$entity-vorhanden">
            <div class="modal" tabindex="-1" role="dialog" id="myModal">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <xsl:choose>
                            <xsl:when test="$entity">
                                <div class="modal-header">
                                    <h3 class="modal-title">
                                        <xsl:value-of select="$entity/tei:placeName[1]"/>
                                        <br/>
                                        <small>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="concat('hits.html?searchkey=', $entiyID)"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="target">_blank</xsl:attribute>
                                                Erwähnungen 
                                            </a> in den Briefen
                                            
                                            <xsl:if test="$entity/tei:location/tei:geo/@decls='LatLng'">
                                                <br/>
                                                <xsl:variable name="openstreetmap-lat" select="$entity/tei:location/tei:geo[@decls='LatLng']/tokenize(.,' ')[1]"/>
                                                <xsl:variable name="openstreetmap-lng" select="$entity/tei:location/tei:geo[@decls='LatLng']/tokenize(.,' ')[2]"/>
                                                <xsl:variable name="openstreetmap-url" select="concat('https://www.openstreetmap.org/?mlat=',$openstreetmap-lat,'%26mlon=',$openstreetmap-lng,'#map=17/',$openstreetmap-lat,'/', $openstreetmap-lng)"/>
                                                <xsl:element name="a">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$openstreetmap-url"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="target">
                                                        <xsl:text>_blank</xsl:text>
                                                    </xsl:attribute>
                                                    <i class="fas fa-map-pin"></i>
                                                    <xsl:text> Ort</xsl:text>
                                                </xsl:element>
                                                
                                            </xsl:if>
                                        </small>
                                    </h3>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">x</span>
                                    </button>
                                </div>
                                <div>
                                    <h3 class="pmb">PMB</h3>
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
                                    <xsl:variable name="pmb-url" select="concat('https://pmb.acdh.oeaw.ac.at/apis/entities/entity/place/', $pmb-weg, '/detail')"/>
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
                                <div class="modal-body-pmb"/>
                                
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