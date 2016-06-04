<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sv="http://www.jcp.org/jcr/sv/1.0" xmlns:functx="http://www.functx.com" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" extension-element-prefixes="saxon" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="page" select="0" saxon:assignable="yes"/>
    <xsl:variable name="line" select="0" saxon:assignable="yes"/>
    <xsl:function name="functx:trim" as="xs:string">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence select="replace(replace($arg, '\s+$', ''), '^\s+', '')"/>
    </xsl:function>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>
            <p>Identity Template</p>
        </desc>
    </doc>
    <xsl:template match="node() | @*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="page">
        <saxon:assign name="page" select="$page + 1"/>
        <xsl:variable name="uid" select="concat('page:', format-number($page, '000'))"/>
        <xsl:element name="sv:node">
            <xsl:attribute name="sv:name">
                <xsl:value-of select="$uid"/>
            </xsl:attribute>
            <xsl:element name="sv:property">
                <xsl:attribute name="sv:name">jcr:primaryType</xsl:attribute>
                <xsl:attribute name="sv:type">Name</xsl:attribute>
                <xsl:element name="sv:value">nt:folder</xsl:element>
            </xsl:element>
            <xsl:element name="sv:property">
                <xsl:attribute name="sv:name">jcr:mixinTypes</xsl:attribute>
                <xsl:attribute name="sv:type">Name</xsl:attribute>
                <xsl:attribute name="sv:multiple">true</xsl:attribute>
                <xsl:element name="sv:value">fedora:Container</xsl:element>
                <xsl:element name="sv:value">fedora:Resource</xsl:element>
            </xsl:element>
            <xsl:for-each select="child::line">
                <saxon:assign name="line" select="$line + 1"/>
                <xsl:variable name="line_uid" select="concat('line:', format-number($line, '00000'))"/>
                <xsl:element name="sv:node">
                    <xsl:attribute name="sv:name">
                        <xsl:value-of select="$line_uid"/>
                    </xsl:attribute>
                    <xsl:element name="sv:property">
                        <xsl:attribute name="sv:name">jcr:primaryType</xsl:attribute>
                        <xsl:attribute name="sv:type">Name</xsl:attribute>
                        <xsl:element name="sv:value">nt:folder</xsl:element>
                    </xsl:element>
                    <xsl:element name="sv:property">
                        <xsl:attribute name="sv:name">jcr:mixinTypes</xsl:attribute>
                        <xsl:attribute name="sv:type">Name</xsl:attribute>
                        <xsl:attribute name="sv:multiple">true</xsl:attribute>
                        <xsl:element name="sv:value">fedora:Container</xsl:element>
                        <xsl:element name="sv:value">fedora:Resource</xsl:element>
                    </xsl:element>
                    <xsl:for-each select="child::node()">
                        <xsl:variable name="ln">
                            <xsl:value-of select="local-name()"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="not(string($ln))">
                                <xsl:variable name="nn" select="concat('dcterms:', 'title')"/>
                                <xsl:element name="sv:property">
                                    <xsl:attribute name="sv:name">
                                        <xsl:value-of select="$nn"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="sv:type">String</xsl:attribute>
                                    <xsl:element name="sv:value">
                                        <xsl:value-of select="."/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="nn" select="concat('node:', $ln)"/>                                
                                <xsl:element name="sv:property">
                                    <xsl:attribute name="sv:name">
                                        <xsl:value-of select="$nn"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="sv:type">String</xsl:attribute>
                                    <xsl:element name="sv:value">
                                        <xsl:value-of select="."/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:for-each select="@*">
                            <xsl:element name="sv:property">
                                <xsl:attribute name="sv:name">
                                    <xsl:value-of select="local-name()"/>
                                </xsl:attribute>
                                <xsl:attribute name="sv:type">String</xsl:attribute>
                                <xsl:element name="sv:value">
                                    <xsl:value-of select="."/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
