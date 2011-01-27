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
  
  <!-- admonitions ********************************************************************** -->

  <xsl:attribute-set name="admonition.title.properties">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="text-decoration">underline</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="admonition.properties">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="d:important|d:warning|d:caution|d:tip">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <fo:block space-before.minimum="0.8em" space-before.optimum="1em"
      space-before.maximum="1.2em" padding-top="4pt" padding-bottom="4pt"
      id="{$id}">
      <xsl:if test="$admon.textlabel != 0 or title">
        <xsl:variable name="admon.title">
          <xsl:apply-templates select="." mode="object.title.markup"/>
        </xsl:variable>
        <fo:block keep-with-next="always"
          xsl:use-attribute-sets="admonition.title.properties">
          <xsl:value-of select="translate($admon.title, $lower, $upper)"/>
        </fo:block>
      </xsl:if>

      <fo:block xsl:use-attribute-sets="admonition.properties" font-weight="bold">
        <xsl:apply-templates/>
      </fo:block>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="d:note">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    
    <fo:block space-before.minimum="0.8em" space-before.optimum="1em"
      space-before.maximum="1.2em" padding-top="4pt" padding-bottom="4pt"
      id="{$id}">
      <xsl:if test="$admon.textlabel != 0 or title">
        <xsl:variable name="admon.title">
          <xsl:apply-templates select="." mode="object.title.markup"/>
        </xsl:variable>
        <fo:block keep-with-next="always" font-weight="bold">
          <xsl:value-of select="$admon.title"/>
        </fo:block>
      </xsl:if>
      
      <fo:block xsl:use-attribute-sets="admonition.properties" margin-left="7mm">
        <xsl:apply-templates/>
      </fo:block>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>