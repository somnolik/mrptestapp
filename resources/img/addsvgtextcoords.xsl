<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://creativecommons.org/ns#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg"
    xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape">
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="svg:text">
            <xsl:variable name="befx" select="ancestor::svg:a/svg:rect/@x"/>
            <xsl:variable name="befy" select="ancestor::svg:a/svg:rect/@y"/>
            <xsl:variable name="idlabel">
                <xsl:value-of
                    select="
                        concat(ancestor::svg:g/@inkscape:label,
                        '-',
                        substring-after(ancestor::svg:a/@href, 'filterstring='),
                        '-')"
                />
            </xsl:variable>
        <text><!-- this part creates the text from the full title -->
            <xsl:attribute name="x">
                <xsl:value-of select="$befx+.1"/>
            </xsl:attribute>
            <xsl:attribute name="y">
                <xsl:value-of select="$befy+5"/>
            </xsl:attribute>
            <xsl:attribute name="id">
                <xsl:value-of select="$idlabel"/>
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:copy-of select="@*|node()"/>
            <title><xsl:value-of select="./text()"/></title>
        </text>
        <text><!-- this part duplicates the volume number (e.g. VI/2) from the full title and puts it below -->
            <xsl:attribute name="class">label white bold</xsl:attribute>
            <xsl:attribute name="x">
                <xsl:value-of select="$befx+1"/>
            </xsl:attribute>
            <xsl:attribute name="y">
                <xsl:value-of select="$befy+27"/>
            </xsl:attribute>
            <xsl:attribute name="id">
                <xsl:value-of select="$idlabel"/>
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:value-of select="substring-before(substring-after(preceding-sibling::svg:rect/svg:title, 'Band '), ': ')"/>
            <title><xsl:value-of select="substring-before(substring-after(preceding-sibling::svg:rect/svg:title, 'Band '), ': ')"/></title>
        </text>
    </xsl:template>
</xsl:stylesheet>
