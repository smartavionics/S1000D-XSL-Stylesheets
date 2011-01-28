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
  
  <!-- Sections ***************************************************************** -->
  
  <xsl:template match="d:section|d:sect1|d:sect2|d:sect3|d:sect4">
    <xsl:choose>
      <xsl:when test="./preceding-sibling::*[position() = 1 and name() = 'title']">
        <!-- don't add space if preceding sibling is a title -->
        <xsl:apply-imports/>
      </xsl:when>
      <xsl:otherwise>
        <!-- add space before nested section headings -->
        <xsl:element name="fo:{$section.container.element}">
          <xsl:attribute name="space-before.minimum">10pt</xsl:attribute>
          <xsl:apply-imports/>
        </xsl:element>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- suppress space before first paragraph after section heading (and note) -->
  <!-- increase priority so that this template is used in preference to *[@revisionflag] -->
  <xsl:template match="d:para[1]" priority="1">
    <xsl:variable name="content">
      <xsl:choose>
        <xsl:when
	  test="parent::d:section|parent::d:sect1|parent::d:sect2|parent::d:sect3|parent::d:sect4|parent::d:note">
	  <xsl:variable name="keep.together">
	    <xsl:call-template name="pi.dbfo_keep-together"/>
	  </xsl:variable>
	  <fo:block>
	    <xsl:if test="$keep.together != ''">
	      <xsl:attribute name="keep-together.within-column"><xsl:value-of
		  select="$keep.together"/></xsl:attribute>
	    </xsl:if>
	    <xsl:call-template name="anchor"/>
	    <xsl:apply-templates/>
	  </fo:block>
        </xsl:when>
        <xsl:otherwise>
	  <xsl:apply-imports/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@revisionflag">
        <xsl:call-template name="make.change.bar">
	  <xsl:with-param name="content">
	    <xsl:copy-of select="$content"/>
	  </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
