<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0"><!-- <xsl:strip-space elements="*"/>-->
    <xsl:import href="shared/base.xsl"/>
    <xsl:param name="document"/>
    <xsl:param name="app-name"/>
    <xsl:param name="collection-name"/>
    <xsl:param name="path2source"/>
    <xsl:param name="ref"/><!--
##################################
### Seitenlayout und -struktur ###
##################################
-->
    <xsl:template match="/">
        <div class="page-header">
            <h2 align="center">
                <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title">
                    <xsl:apply-templates/>
                    <br/>
                </xsl:for-each>
            </h2>
        </div>
        <div class="regest">
            <div class="card-header">
                <div class="card-header">
                    <h3 class="card-title">
                        <h2 align="center">Header</h2>
                    </h3>
                </div>
                <div class="card-body">
                    <table class="table table-striped">
                        <tbody>
                            <tr>
                                <th>
                                    <abbr title="tei:titleStmt/tei:title">Dokument</abbr>
                                </th>
                                <td>
                                    <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title">
                                        <xsl:apply-templates/>
                                        <br/>
                                    </xsl:for-each>
                                </td>
                            </tr>
                            <xsl:if test="//tei:msIdentifier">
                                <tr>
                                    <th>
                                        <abbr title="//tei:msIdentifier">Signatur</abbr>
                                    </th>
                                    <td>
                                        <xsl:for-each select="//tei:msIdentifier/child::*">
                                            <abbr>
                                                <xsl:attribute name="title">
                                                    <xsl:value-of select="name()"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="."/>
                                            </abbr>
                                            <br/>
                                        </xsl:for-each><!--<xsl:apply-templates select="//tei:msIdentifier"/>-->
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="//tei:msContents">
                                <tr>
                                    <th>
                                        <abbr title="//tei:msContents">Regest</abbr>
                                    </th>
                                    <td>
                                        <xsl:apply-templates select="//tei:msContents"/>
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="//tei:supportDesc/tei:extent">
                                <tr>
                                    <th>
                                        <abbr title="//tei:supportDesc/tei:extent">Extent</abbr>
                                    </th>
                                    <td>
                                        <xsl:apply-templates select="//tei:supportDesc/tei:extent"/>
                                    </td>
                                </tr>
                            </xsl:if>
                            <tr>
                                <th>Verantwortlich</th>
                                <td>
                                    <xsl:for-each select="//tei:author">
                                        <xsl:apply-templates/>
                                    </xsl:for-each>
                                </td>
                            </tr>
                            <xsl:if test="//tei:titleStmt/tei:respStmt">
                                <tr>
                                    <th>
                                        <abbr title="//tei:titleStmt/tei:respStmt">responsible</abbr>
                                    </th>
                                    <td>
                                        <xsl:for-each select="//tei:titleStmt/tei:respStmt">
                                            <p>
                                                <xsl:apply-templates/>
                                            </p>
                                        </xsl:for-each>
                                    </td>
                                </tr>
                            </xsl:if>
                                <tr>
                                    <th>
                                        <abbr title="//tei:availability//tei:p[1]">License</abbr>
                                    </th>
                                    <xsl:choose>
                                        <xsl:when test="//tei:licence[@target]">
                                         <td align="center">
                                             <a class="navlink" target="_blank">
                                                 <xsl:attribute name="href">
                                                     <xsl:value-of select="//tei:licence[1]/data(@target)"/>
                                                 </xsl:attribute>
                                                 <xsl:value-of select="//tei:licence[1]/data(@target)"/>
                                             </a>
                                         </td>
                                        </xsl:when>
                                        <xsl:when test="//tei:licence">
                                            <td>
                                                <xsl:apply-templates select="//tei:licence"/>
                                            </td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <td>no license provided</td>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </tr>                            
                        </tbody>
                    </table>
                    <div class="card-footer">
                        <p style="text-align:center;">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$path2source"/>
                                </xsl:attribute>
                                see the TEI source of this document
                            </a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
        <div class="card-header">
            <div class="card-header">
                <h3 class="card-title">
                    <h2 align="center">
                        Body
                    </h2>
                </h3>
            </div>
            <div class="card-body">
                <xsl:if test="//tei:div/tei:head">
                    <h3 id="clickme">
                        <abbr title="Click to display Table of Contents">[Table of Contents]</abbr>
                    </h3>
                    <div id="headings" class="readmore">
                        <ul>
                            <xsl:for-each select="/tei:TEI/tei:text/tei:body//tei:div/tei:head">
                                <li>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:text>#hd</xsl:text>
                                            <xsl:number level="any"/>
                                        </xsl:attribute>
                                        <xsl:number level="multiple" count="tei:div" format="1.1. "/>
                                    </a>
                                    <xsl:choose>
                                        <xsl:when test=".//tei:orig">
                                            <xsl:apply-templates select=".//tei:orig"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="."/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </xsl:if>
                <div>
                    <xsl:apply-templates select="//tei:text"/>
                </div>
            </div>
            <xsl:if test="tei:TEI/tei:text/tei:body//tei:note">
                <div class="card-footer">
                        <div class="footnotes">
                            <h4 title="mit Buchstaben gezählte Noten beziehen sich auf textuelle Varianten, der Rest ist Kommentar">Anmerkungen</h4>
                            <xsl:for-each select="tei:TEI/tei:text/tei:body//tei:note[@type='variant']">
                                <div class="footnote">
                                    <xsl:element name="a">
                                        <xsl:attribute name="name">
                                            <xsl:text>fn</xsl:text>
                                            <xsl:number level="any" format="a" count="tei:note[@type='variant']"/>
                                        </xsl:attribute>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:text>#fna_</xsl:text>
                                                <xsl:number level="any" format="a" count="tei:note[@type='variant']"/>
                                            </xsl:attribute>
                                            <span style="font-size:7pt;vertical-align:super;">
                                                <xsl:number level="any" format="a" count="tei:note[@type='variant']"/>
                                            </span>
                                        </a>
                                    </xsl:element>
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates/>
                                </div>
                            </xsl:for-each>
                            <xsl:if test="tei:TEI/tei:text/tei:body//tei:note[@type='variant']">
                                <br/>
                            </xsl:if>
                            <xsl:for-each select="tei:TEI/tei:text/tei:body//tei:note[@type='footnote']">
                                <div class="footnote">
                                    <xsl:element name="a">
                                        <xsl:attribute name="name">
                                            <xsl:text>fn</xsl:text>
                                            <xsl:number level="any" format="1" count="tei:note[@type='footnote']"/>
                                        </xsl:attribute>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:text>#fna_</xsl:text>
                                                <xsl:number level="any" format="1" count="tei:note[@type='footnote']"/>
                                            </xsl:attribute>
                                            <span style="font-size:7pt;vertical-align:super;">
                                                <xsl:number level="any" format="1" count="tei:note[@type='footnote']"/>
                                            </span>
                                        </a>
                                    </xsl:element>
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates/>
                                </div>
                            </xsl:for-each>
                        </div>
                    
                </div>
            </xsl:if>
            <script type="text/javascript">
                $(document).ready(function(){
                $( "div[class~='readmore']" ).hide();
                });
                $("#clickme").click(function(){
                $( "div[class~='readmore']" ).toggle("slow");
                });
            </script>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <xsl:element name="div">
            <xsl:attribute name="style">
                <xsl:text>text-align:right;</xsl:text>
            </xsl:attribute>
            <xsl:text>[S. </xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>] - </xsl:text>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
                Retrodigitalisat (PDF, Verlag der ÖAW)
            </a>
        </xsl:element>
        <xsl:element name="hr"/>
    </xsl:template>
    
    <xsl:template match="tei:note[@type='footnote']">
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:text>fna_</xsl:text>
                <xsl:number level="any" format="1" count="tei:note[@type='footnote']"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#fn</xsl:text>
                <xsl:number level="any" format="1" count="tei:note[@type='footnote']"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <span style="font-size:7pt;vertical-align:super;">
                <xsl:number level="any" format="1" count="tei:note[@type='footnote']"/>
            </span>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:note[@type='variant']">
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:text>fna_</xsl:text>
                <xsl:number level="any" format="a" count="tei:note[@type='variant']"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#fn</xsl:text>
                <xsl:number level="any" format="a" count="tei:note[@type='variant']"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <span style="font-size:7pt;vertical-align:super;">
                <xsl:number level="any" format="a" count="tei:note[@type='variant']"/>
            </span>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="tei:listEvent">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    
    <xsl:template match="tei:event">
        <li>
            <a href="{./@ref}" title="externe Quelle: {./@ref}" target="hw">
                <xsl:apply-templates/>
            </a>
        </li>
    </xsl:template>
    
    <xsl:template match="tei:head[parent::tei:event]">
        <a>
            <xsl:attribute name="name">
                <xsl:text>hd</xsl:text>
                <xsl:number level="any"/>
            </xsl:attribute>
            <xsl:text> </xsl:text>
        </a>
            <xsl:apply-templates/>
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:label[ancestor::tei:event]">
        <xsl:choose>
            <xsl:when test="contains(.,'):')">
                <xsl:value-of select="substring-after(., '):')"/> <!-- strips off "TOP in Sitzung ... Ministerrats" -->
            </xsl:when>
            <xsl:when test="contains(ancestor::tei:event,'Beilage')">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="ancestor::tei:event/@ref[1]"/>
                    </xsl:attribute>
                    Beilage</a>
            </xsl:when>
            <xsl:when test="starts-with(., 'Minister')"/>
            <xsl:otherwise>
                <xsl:text>Beilage</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:*/@corresp">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="."/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
</xsl:stylesheet>