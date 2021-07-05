<?xml version="1.0" encoding="UTF-8"?>
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
                                        <xsl:value-of select="$entity"/>  
                                    <br/>
                                        <small><!-- -->
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
                                    <table class="table table-boardered table-hover">
                                        <tr>
                                            <th>Name</th>
                                            <td>
                                                <xsl:value-of select="//tei:bibl[@xml:id=$entiyID]"/>
                                            </td>
                                        </tr>
                                        <xsl:if test="$entity/tei:idno[@type='URL']">
                                            <tr>
                                                <th>URL:</th>
                                                <td>
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="$entity/tei:idno[@type='URL']/text()"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="$entity/tei:idno[@type='URL']/text()"/>
                                                    </a>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="$entity/tei:idno">
                                            <tr>
                                                <th>URL:</th>
                                                <td>
                                                    <xsl:value-of select="$entity/tei:idno/text()"/>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                    </table><!--<div><h4 data-toggle="collapse" data-target="#more"> more (tei structure)</h4><div id="more" class="collapse"><xsl:choose><xsl:when test="//*[@xml:id=$entiyID or @id=$entiyID]"><xsl:apply-templates select="//*[@xml:id=$entiyID or @id=$entiyID]" mode="start"/></xsl:when><xsl:otherwise>Looks like there exists no index entry for ID<strong><xsl:value-of select="concat(' ', $entiyID)"/></strong></xsl:otherwise></xsl:choose></div></div>-->
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