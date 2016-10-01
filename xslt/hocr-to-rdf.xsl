<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:hocr="http://www.purl.org/hocr#" xmlns:functx="http://www.functx.com" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" extension-element-prefixes="saxon" version="2.0" xpath-default-namespace="http://www.w3.org/1999/xhtml">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="base_uri">http://localhost:8080/fcrepo/rest/collection/test/004/doc/</xsl:param>
    <xsl:variable name="line" select="0" saxon:assignable="yes"/>
    <xsl:function name="functx:trim" as="xs:string">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence select="replace(replace($arg, '\s+$', ''), '^\s+', '')"/>
    </xsl:function>
    <xsl:template match="node() | @*">
        <xsl:copy copy-namespaces="yes">
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template name="ocr_page">
        <xsl:for-each select="./body/div[@class = 'ocr_page']">
            <xsl:element name="rdf:Description">
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="concat($base_uri, ./@id)"/>
                </xsl:attribute>
                <xsl:namespace name="hocr" select="'http://www.purl.org/hocr#'"/>
                <xsl:element name="hocr:bbox">
                    <xsl:analyze-string select="./@title" regex="bbox (.+?);">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:element>
                <xsl:call-template name="ocr_area"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="ocr_area">
        <xsl:for-each select="./div[@class = 'ocr_carea']">
            <xsl:element name="hocr:hasContent">
                <xsl:attribute name="rdf:resource">
                    <xsl:value-of select="concat($base_uri, ./@id)"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="html">
        <xsl:element namespace="http://www.w3.org/1999/02/22-rdf-syntax-ns#" name="rdf:RDF">
            <xsl:call-template name="ocr_page"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="span"/>
    <xsl:template match="head"/>
</xsl:stylesheet>
