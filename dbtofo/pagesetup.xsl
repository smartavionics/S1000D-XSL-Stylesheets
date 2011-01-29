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

  <xsl:template name="user.pagemasters">

    <!-- body pages -->
    <fo:simple-page-master master-name="body-first-dbtofo"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:value-of select="$page.margin.inner"/>
	<xsl:if test="$fop.extensions != 0">
	  <xsl:value-of select="concat(' - (',$title.margin.left,')')"/>
        </xsl:if>
	<xsl:if test="$fop.extensions != 0">
	  <xsl:value-of select="concat(' - (',$title.margin.left,')')"/>
        </xsl:if>
      </xsl:attribute>
      <xsl:attribute name="margin-{$direction.align.end}">
        <xsl:value-of select="$page.margin.outer"/>
      </xsl:attribute>
      <xsl:if test="$axf.extensions != 0">
        <xsl:call-template name="axf-page-master-properties">
          <xsl:with-param name="page.master">body-first</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
                      margin-left="{$body.margin.inner}"
                      column-gap="{$column.gap.body}"
                      column-count="{$column.count.body}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-first"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-first"
                       extent="{$region.after.extent}"
                       display-align="after"/>
      <fo:region-start region-name="xsl-region-start-first"
                       extent="{$body.margin.inner}"
                       reference-orientation="90"
                       display-align="before"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="body-odd-dbtofo"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
			   margin-left="{$body.margin.inner}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:value-of select="$page.margin.inner"/>
	<xsl:if test="$fop.extensions != 0">
	  <xsl:value-of select="concat(' - (',$title.margin.left,')')"/>
        </xsl:if>
      </xsl:attribute>
      <xsl:attribute name="margin-{$direction.align.end}">
        <xsl:value-of select="$page.margin.outer"/>
      </xsl:attribute>
      <xsl:if test="$axf.extensions != 0">
        <xsl:call-template name="axf-page-master-properties">
          <xsl:with-param name="page.master">body-odd</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
		      margin-left="{$body.margin.inner}"
                      column-gap="{$column.gap.body}"
                      column-count="{$column.count.body}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-odd"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-odd"
                       extent="{$region.after.extent}"
                       display-align="after"/>
      <fo:region-start region-name="xsl-region-start-odd"
                       extent="{$body.margin.inner}"
                       reference-orientation="90"
                       display-align="before"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="body-even-dbtofo"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
			   margin-right="{$body.margin.inner}"
                           margin-top="{$page.margin.top}"
                           margin-bottom="{$page.margin.bottom}">
      <xsl:attribute name="margin-{$direction.align.start}">
        <xsl:value-of select="$page.margin.outer"/>
	<xsl:if test="$fop.extensions != 0">
	  <xsl:value-of select="concat(' - (',$title.margin.left,')')"/>
        </xsl:if>
      </xsl:attribute>
      <xsl:attribute name="margin-{$direction.align.end}">
        <xsl:value-of select="$page.margin.inner"/>
      </xsl:attribute>
      <xsl:if test="$axf.extensions != 0">
        <xsl:call-template name="axf-page-master-properties">
          <xsl:with-param name="page.master">body-even</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <fo:region-body margin-bottom="{$body.margin.bottom}"
                      margin-top="{$body.margin.top}"
		      margin-right="{$body.margin.inner}"
                      column-gap="{$column.gap.body}"
                      column-count="{$column.count.body}">
      </fo:region-body>
      <fo:region-before region-name="xsl-region-before-even"
                        extent="{$region.before.extent}"
                        display-align="before"/>
      <fo:region-after region-name="xsl-region-after-even"
                       extent="{$region.after.extent}"
                       display-align="after"/>
      <fo:region-end region-name="xsl-region-end-even"
                     extent="{$body.margin.inner}"
                     reference-orientation="90"
                     display-align="before"/>
    </fo:simple-page-master>

    <!-- setup for body pages -->
    <fo:page-sequence-master master-name="body-dbtofo">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="body-first-dbtofo"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="body-odd-dbtofo"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference 
                                              odd-or-even="even">
          <xsl:attribute name="master-reference">
            <xsl:choose>
              <xsl:when test="$double.sided != 0">body-even-dbtofo</xsl:when>
              <xsl:otherwise>body-odd-dbtofo</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </fo:conditional-page-master-reference>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

  </xsl:template>
  
  <xsl:template name="select.user.pagemaster">
    <xsl:param name="element"/>
    <xsl:param name="pageclass"/>
    <xsl:param name="default-pagemaster"/>

    <xsl:value-of select="$default-pagemaster"/>
    <xsl:if test="$default-pagemaster = 'body'">
      <xsl:text>-dbtofo</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="inner.margin.mode">
    <xsl:param name="master-reference" select="'unknown'"/>
    <xsl:param name="gentext-key" select="local-name(.)"/>
    <xsl:param name="content-inner"/>
    <xsl:param name="content-outer"/>

    <!-- remove -draft from reference -->
    <xsl:variable name="pageclass">
      <xsl:choose>
        <xsl:when test="contains($master-reference, '-draft')">
	  <xsl:value-of select="substring-before($master-reference, '-draft')"/>
        </xsl:when>
        <xsl:otherwise>
	  <xsl:value-of select="$master-reference"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <fo:static-content flow-name="xsl-region-start-first">
      <xsl:copy-of select="$content-inner"/>
      <xsl:copy-of select="$content-outer"/>
    </fo:static-content>

    <fo:static-content flow-name="xsl-region-start-odd">
      <xsl:copy-of select="$content-inner"/>
      <xsl:copy-of select="$content-outer"/>
    </fo:static-content>

    <fo:static-content flow-name="xsl-region-end-even">
      <fo:block margin-top="5mm"/>
      <xsl:copy-of select="$content-outer"/>
      <xsl:copy-of select="$content-inner"/>
    </fo:static-content>
    
  </xsl:template>

</xsl:stylesheet>
