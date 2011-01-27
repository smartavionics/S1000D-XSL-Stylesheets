<?xml version="1.0" encoding="UTF-8"?>

<!-- ********************************************************************

     This file is part of the S1000D XSL stylesheet distribution.
     
     Copyright (C) 2010-2011 Smart Avionics Ltd.
     
     See ../COPYING for copyright details and other information.

     ******************************************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
  xmlns:rx="http://www.renderx.com/XSL/Extensions" version="1.0">
  
  <!-- Titles ********************************************************************** -->

  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="section.title.level4.properties">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="section.title.level5.properties">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="component.title.properties">
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    <xsl:attribute name="space-before.optimum">
      <xsl:value-of select="concat($body.font.master, 'pt')"/>
    </xsl:attribute>
    <xsl:attribute name="space-before.minimum">
      <xsl:value-of select="concat($body.font.master, 'pt * 0.8')"/>
    </xsl:attribute>
    <xsl:attribute name="space-before.maximum">
      <xsl:value-of select="concat($body.font.master, 'pt * 1.2')"/>
    </xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="font-size" >
      <xsl:value-of select="$font.size.heading"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="formal.title.properties"
    use-attribute-sets="normal.para.spacing">
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.8em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="chapter.titlepage.recto.style">
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$font.size.heading"/>
    </xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="start-indent">0pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="bridgehead.title.properties"
    use-attribute-sets="normal.para.spacing">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$font.size.heading"/>
    </xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="start-indent">0pt</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.8em</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:template match="d:bridgehead">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="font.style">
      <xsl:choose>
        <xsl:when test="@renderas='centerhead'">
          <xsl:text>italic</xsl:text>  
        </xsl:when>
        <xsl:when test="@renderas='sidehead' or @renderas='sidehead0'">
          <xsl:text>normal</xsl:text>  
        </xsl:when>        
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="text.align">
      <xsl:choose>
        <xsl:when test="@renderas='centerhead'">
          <xsl:text>center</xsl:text>  
        </xsl:when>
        <xsl:when test="@renderas='sidehead' or @renderas='sidehead0'">
          <xsl:text>left</xsl:text>  
        </xsl:when>        
      </xsl:choose>
    </xsl:variable>
    <fo:block id="{$id}" xsl:use-attribute-sets="bridgehead.title.properties"
      font-style="{$font.style}" text-align="{$text.align}">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
    
  <xsl:template match="d:phrase[@role='margin.note']">
    <xsl:call-template name="margin.note"/>
  </xsl:template>

  <xsl:template name="section.titlepage">
    <xsl:variable name="renderas">
      <xsl:choose>
        <xsl:when test="@renderas = 'sect1'">1</xsl:when>
        <xsl:when test="@renderas = 'sect2'">2</xsl:when>
        <xsl:when test="@renderas = 'sect3'">3</xsl:when>
        <xsl:when test="@renderas = 'sect4'">4</xsl:when>
        <xsl:when test="@renderas = 'sect5'">5</xsl:when>
        <xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="level">
      <xsl:choose>
        <xsl:when test="$renderas != ''">
          <xsl:value-of select="$renderas"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="section.level"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <!-- xsl:use-attribute-sets takes only a Qname, not a variable -->
    <xsl:choose>
      <xsl:when test="$level = 1">
        <xsl:element name="fo:{$section.container.element}"
          use-attribute-sets="section.title.level1.properties">
          <xsl:call-template name="s1000d.titlepage.recto"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$level = 2">
        <xsl:element name="fo:{$section.container.element}"
          use-attribute-sets="section.title.level2.properties">
          <xsl:call-template name="s1000d.titlepage.recto"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$level = 3">
        <xsl:element name="fo:{$section.container.element}"
          use-attribute-sets="section.title.level3.properties">
          <xsl:call-template name="s1000d.titlepage.recto"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$level = 4">
        <xsl:element name="fo:{$section.container.element}"
          use-attribute-sets="section.title.level4.properties">
          <xsl:call-template name="s1000d.titlepage.recto"/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="sect1.titlepage.recto">
    <xsl:element name="fo:{$section.container.element}"
      use-attribute-sets="section.title.level1.properties">
      <xsl:call-template name="s1000d.titlepage.recto"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="sect2.titlepage.recto">
    <xsl:element name="fo:{$section.container.element}"
      use-attribute-sets="section.title.level2.properties">
      <xsl:call-template name="s1000d.titlepage.recto"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="sect3.titlepage.recto">
    <xsl:element name="fo:{$section.container.element}"
      use-attribute-sets="section.title.level3.properties">
      <xsl:call-template name="s1000d.titlepage.recto"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="sect4.titlepage.recto">
    <xsl:element name="fo:{$section.container.element}"
      use-attribute-sets="section.title.level4.properties">
      <xsl:call-template name="s1000d.titlepage.recto"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="s1000d.titlepage.recto">
    <fo:block font-family="{$title.fontset}" start-indent="0pt"
      keep-with-next.within-page="always">
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="{$body.start.indent}"/>
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block text-align="left">
                <xsl:apply-templates mode="label.markup" select="."/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block text-align="left">
                <xsl:variable name="template">
                  <xsl:call-template name="gentext.template">
                    <xsl:with-param name="context" select="'title-unnumbered'"/>
                    <xsl:with-param name="name">
                      <xsl:call-template name="xpath.location"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="substitute-markup">
                  <xsl:with-param name="allow-anchors" select="0"/>
                  <xsl:with-param name="template" select="$template"/>
                </xsl:call-template>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>