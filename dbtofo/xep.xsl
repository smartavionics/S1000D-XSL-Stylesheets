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
  xmlns:rx="http://www.renderx.com/XSL/Extensions"
  version="1.0">
  
  <xsl:template match="*" mode="xep.outline">
    <xsl:apply-templates select="*" mode="xep.outline"/>
  </xsl:template>
  
  <xsl:template match="d:chapter|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:section" mode="xep.outline">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="bookmark-label">
      <xsl:call-template name="bookmark.label"/>
    </xsl:variable>
    <xsl:if test="$bookmark-label != ''">
      <rx:bookmark internal-destination="{$id}" xsl:exclude-result-prefixes="d l">
        <rx:bookmark-label>
          <xsl:value-of select="normalize-space($bookmark-label)"/>
        </rx:bookmark-label>
        <xsl:apply-templates select="*" mode="xep.outline"/>
      </rx:bookmark>
    </xsl:if>
  </xsl:template>

  <xsl:template name="xep-document-information">
    <xsl:variable name="author" select="(//d:chapter[1]/d:info/d:bibliomisc[@role='publication.author'])"/>
    <xsl:variable name="title" select="(//d:chapter[1]/d:info/d:bibliomisc[@role='publication.title'])"/>
    <rx:meta-info>
      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">author</xsl:attribute>
        <xsl:attribute name="value">
	  <xsl:value-of select="normalize-space($author)"/>
        </xsl:attribute>
      </xsl:element>

      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">creator</xsl:attribute>
        <xsl:attribute name="value">
          <xsl:value-of select="$creator.tool"/>
        </xsl:attribute>
      </xsl:element>

      <xsl:element name="rx:meta-field">
        <xsl:attribute name="name">title</xsl:attribute>
        <xsl:attribute name="value">
	  <xsl:value-of select="normalize-space($title)"/>
        </xsl:attribute>
      </xsl:element>

      <xsl:if test="//d:keyword">
        <xsl:element name="rx:meta-field">
	  <xsl:attribute name="name">keywords</xsl:attribute>
	  <xsl:attribute name="value">
	    <xsl:for-each select="//d:keyword">
	      <xsl:value-of select="normalize-space(.)"/>
	      <xsl:if test="position() != last()">
	        <xsl:text>, </xsl:text>
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:attribute>
        </xsl:element>
      </xsl:if>

      <xsl:if test="//d:subjectterm">
        <xsl:element name="rx:meta-field">
	  <xsl:attribute name="name">subject</xsl:attribute>
	  <xsl:attribute name="value">
	    <xsl:for-each select="//d:subjectterm">
	      <xsl:value-of select="normalize-space(.)"/>
	      <xsl:if test="position() != last()">
	        <xsl:text>, </xsl:text>
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:attribute>
        </xsl:element>
      </xsl:if>
    </rx:meta-info>
  </xsl:template>

</xsl:stylesheet>
