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
  
  <!-- Markers ********************************************************************** -->

  <xsl:template match="*" mode="data.module.issue.date">
    <fo:marker marker-class-name="chapter.issue.date">
      <fo:inline>
        <xsl:apply-templates/>
      </fo:inline>
    </fo:marker>
  </xsl:template>

  <xsl:template match="*" mode="data.module.bibliomisc">
    <!--<xsl:message><xsl:value-of select="./@role"/> = <xsl:apply-templates/></xsl:message>-->
    <xsl:choose>
    
      <xsl:when test="./@role='page.header.logo'">
        <!-- explicitly select inlinemediaobject to avoid surrounding whitespace -->
        <fo:marker marker-class-name="page.header.logo">
	  <xsl:apply-templates select="d:inlinemediaobject"/>
        </fo:marker>
      </xsl:when>
      
      <xsl:when test="./@role='data.module.code'">
        <fo:marker marker-class-name="chapter.data.module.code">
          <fo:inline>
            <xsl:apply-templates/>
          </fo:inline>
        </fo:marker>
      </xsl:when>

      <xsl:when test="./@role='publication.code'">
        <fo:marker marker-class-name="chapter.publication.code">
          <fo:inline>
            <xsl:apply-templates/>
          </fo:inline>
        </fo:marker>
      </xsl:when>

      <xsl:when test="./@role='applicability'">
        <fo:marker marker-class-name="chapter.applicability">
          <fo:inline>
            <xsl:apply-templates/>
          </fo:inline>
        </fo:marker>
      </xsl:when>

      <xsl:when test="./@role='classification'">
        <fo:marker marker-class-name="chapter.classification">
          <fo:inline>
            <xsl:apply-templates/>
          </fo:inline>
        </fo:marker>
      </xsl:when>

      <xsl:when test="./@role='inwork.blurb'">
        <fo:marker marker-class-name="chapter.inwork.blurb">
          <fo:inline>
            <xsl:apply-templates/>
          </fo:inline>
        </fo:marker>
      </xsl:when>

      <xsl:when test="./@role='producedby.blurb'">
        <fo:marker marker-class-name="chapter.producedby.blurb">
          <fo:inline>
            <xsl:apply-templates/>
          </fo:inline>
        </fo:marker>
      </xsl:when>
      
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>