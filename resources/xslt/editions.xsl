<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0"><!-- <xsl:strip-space elements="*"/>-->
    <xsl:import href="shared/base.xsl"/>
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
    <!--
##################################
### Seitenlayout und -struktur ###
##################################
-->
    <xsl:template match="/">
        <div class="page-header">
            <div class="row" style="text-align:left">
                <div class="col-md-2">
                    <xsl:if test="$prev">
                        <h1>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$prev"/>
                                </xsl:attribute>
                                <i class="fas fa-chevron-left" title="prev"/>
                            </a>
                        </h1>
                    </xsl:if>
                </div>
                <div class="col-md-8">
                    <h1 style="font-size:small;" align="center">
                        <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title[@level='s']">
                            <xsl:apply-templates/>
                            <xsl:if test="position() != last()">, </xsl:if>
                        </xsl:for-each>
                    </h1>
                    <h2 align="center">
                        <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title[@level='m']">
                            <xsl:apply-templates/>
                            <xsl:if test="position() != last()">, </xsl:if>
                        </xsl:for-each>
                    </h2>
                    <h3 align="center">
                        <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title[@level='a']">
                            <xsl:apply-templates/>
                            <xsl:if test="position() != last()">, </xsl:if>
                        </xsl:for-each>
                    </h3>
                    <h2 style="text-align:center;">
                        <input type="range" min="1" max="{$amount}" value="{$currentIx}" data-rangeslider="" style="width:100%;"/>
                        <a id="output" class="btn btn-main btn-outline-primary btn-sm" href="show.html?document=entry__1879-03-03.xml&amp;directory=editions" role="button">go to </a>
                    </h2>
                </div>
                <div class="col-md-2" style="text-align:right">
                    <xsl:if test="$next">
                        <h1>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$next"/>
                                </xsl:attribute>
                                <i class="fas fa-chevron-right" title="next"/>
                            </a>
                        </h1>
                    </xsl:if>
                </div>
            </div>
        </div>
        <!--<div class="regest">
            <div class="card">
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
                                        <abbr title="//tei:msIdentifie">Signatur</abbr>
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
                                        </xsl:for-each><!-\-<xsl:apply-templates select="//tei:msIdentifier"/>-\->
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
                                    <xsl:for-each select="//teiHeader//tei:author">
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
        </div>-->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <!--<h2 align="center">
                        Body
                    </h2>-->
                    
                </h3>
                <p align="center">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$path2source"/>
                        </xsl:attribute>
                        see the TEI source of this document
                    </a>
                </p>
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
            <div class="card-footer">
                <xsl:if test="tei:TEI/tei:text/tei:body//tei:note">
                    <div class="panel-footer">
                        <h4 title="mit Buchstaben gezählte Noten beziehen sich auf die Textkritik, der Rest Kommentar">Anmerkungen</h4>
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
                                        <sup>
                                            <xsl:number level="any" format="a" count="tei:note[@type='variant']"/>
                                        </sup>
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
                                        <sup>
                                            <xsl:number level="any" format="1" count="tei:note[@type='footnote']"/>
                                        </sup>
                                    </a>
                                </xsl:element>
                                <xsl:text> </xsl:text>
                                <xsl:apply-templates/>
                            </div>
                        </xsl:for-each>
                    </div>
                </xsl:if>
            
        </div>
        </div>
        <script type="text/javascript">
            $(document).ready(function(){
            $( "div[class~='readmore']" ).hide();
            });
            $("#clickme").click(function(){
            $( "div[class~='readmore']" ).toggle("slow");
            });
        </script>
    </xsl:template>
    
    <xsl:template match="tei:head">
        <xsl:if test="@xml:id[starts-with(.,'org') or starts-with(.,'ue')]">
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
        </xsl:if>
        <a>
            <xsl:attribute name="name">
                <xsl:text>hd</xsl:text>
                <xsl:number level="any"/>
            </xsl:attribute>
            <xsl:text> </xsl:text>
        </a>
        <div>
            <xsl:choose>
                <xsl:when test="@type='regest'">
                    <h5>
                        <xsl:apply-templates/>
                    </h5>
                </xsl:when>
                <xsl:otherwise>
                    <h3>
                        <xsl:apply-templates/>
                        <xsl:if test="@corresp">
                            <span style="font-size:.5em;"> - Retrodigitalisat (<a target="_blank">
                                    <xsl:attribute name="title">
                                        <xsl:value-of select="normalize-space(@corresp)"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="normalize-space(@corresp)"/>
                                    </xsl:attribute>PDF</a>)
                            </span>
                        </xsl:if>
                    </h3>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <xsl:element name="span">
            <xsl:attribute name="style">
                <xsl:text>text-align:right;display:block;</xsl:text>
            </xsl:attribute>
            <xsl:text>[S. </xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>] - Retrodigitalisat </xsl:text>
            <a target="_blank">
                <xsl:attribute name="href">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
                <xsl:attribute name="title">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
                (PDF)
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
            <sup>
                <xsl:number level="any" format="1" count="tei:note[@type='footnote']"/>
            </sup>
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
            <sup>
                <xsl:number level="any" format="a" count="tei:note[@type='variant']"/>
            </sup>
        </xsl:element>
    </xsl:template>
   
    <xsl:template match="tei:idno">
        <span>
            <xsl:value-of select="@type"/>
            <xsl:text>. </xsl:text>
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()"> – </xsl:if>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:quote">
        <q>
            <xsl:apply-templates/>
        </q>
    </xsl:template>
    
    <xsl:template match="//tei:hi">
        <xsl:choose>
            <xsl:when test="@rend='#letterspaced'">
                <span style="letter-spacing:0.08em;">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend='ul'">
                <u>
                    <xsl:apply-templates/>
                </u>
            </xsl:when>
            <xsl:when test="@rend='italic'">
                <i>
                    <xsl:apply-templates/>
                </i>
            </xsl:when>
            <xsl:otherwise><!-- style durchreichen -->
                <span>
                    <xsl:choose>
                        <xsl:when test="@rend">
                            <xsl:attribute name="style">
                                <xsl:for-each select=".[contains(concat(' ', normalize-space(@rend), ' '), ' #')]">
                                    <xsl:variable name="style" select="substring-after(., '#')"/>
                                    <xsl:value-of select="root()//tei:rendition[@xml:id=current()/$style]"/>
                                </xsl:for-each>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:when test="@rendition[not(contains(.,' '))]">
                            <xsl:variable name="style" select="substring-after(@rendition, '#')"/>
                            <xsl:attribute name="style">
                                <xsl:value-of select="root()//tei:rendition[@xml:id=current()/$style]"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:title">
        <strong>
            <xsl:apply-templates/>
            <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
            </xsl:if>
        </strong>
    </xsl:template>
    
    <xsl:template match="tei:listPerson[@type='attendants']">
        <xsl:for-each select="tei:person">
            <xsl:apply-templates select="."/>
            <xsl:if test="position()!=last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:person">
        <xsl:choose>
            <xsl:when test="@role='protocol'">
                <abbr title="Protokoll">P.</abbr>
                <xsl:text> </xsl:text>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@role='chair'">
                <abbr title="Vorsitz">VS.</abbr>
                <xsl:text> </xsl:text>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@role='notpresent'">
                <abbr title="abwesend">abw.</abbr>
                <xsl:text> </xsl:text>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <abbr title="anwesend">anw.</abbr>
                <xsl:text> </xsl:text>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>