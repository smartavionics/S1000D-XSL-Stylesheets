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
  
  <!-- Chapter ********************************************************************** -->

  <xsl:template match="d:chapter">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:variable name="master-reference">
      <xsl:call-template name="select.pagemaster"/>
    </xsl:variable>

    <fo:page-sequence hyphenate="{$hyphenate}"
      master-reference="{$master-reference}">
      <xsl:attribute name="language">
        <xsl:call-template name="l10n.language"/>
      </xsl:attribute>
      <xsl:attribute name="format">
        <xsl:call-template name="page.number.format">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="initial-page-number">
        <xsl:call-template name="initial.page.number">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="force-page-count">
        <xsl:call-template name="force.page.count">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:attribute name="hyphenation-character">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-character'"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="hyphenation-push-character-count">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'hyphenation-push-character-count'"
          />
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="hyphenation-remain-character-count">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key"
            select="'hyphenation-remain-character-count'"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:apply-templates select="." mode="running.head.mode">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="." mode="running.foot.mode">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:apply-templates>

      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="set.flow.properties">
          <xsl:with-param name="element" select="local-name(.)"/>
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:call-template>

        <xsl:apply-templates select="d:info/d:date"
          mode="data.module.issue.date"/>
        <xsl:apply-templates select="d:info/d:bibliomisc"
          mode="data.module.bibliomisc"/>

        <fo:block id="{$id}"/>

	<xsl:if test="not(d:info/d:bibliomisc[@role='no.chapter.title'])">
          <fo:block xsl:use-attribute-sets="component.titlepage.properties">
            <xsl:call-template name="chapter.titlepage"/>
          </fo:block>
        </xsl:if>

	<xsl:apply-templates select="*[@role='before.toc']"/>

	<xsl:if test="not(d:info/d:bibliomisc[@role='no.toc'])">
	  <xsl:variable name="toc.params">
	    <xsl:call-template name="find.path.params">
	      <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
	    </xsl:call-template>
	  </xsl:variable>
	  <xsl:if test="contains($toc.params, 'toc')">
	    <xsl:call-template name="component.toc">
	      <xsl:with-param name="toc.title.p"
			      select="contains($toc.params, 'title')"/>
	    </xsl:call-template>
	    <xsl:call-template name="component.toc.separator"/>
	  </xsl:if>
        
	  <xsl:if test=".//d:table">
	    <xsl:call-template name="list.of.titles">
	      <xsl:with-param name="titles" select="'table'"/>
	      <xsl:with-param name="nodes" select=".//d:table"/>
	    </xsl:call-template>
	  </xsl:if>
        
	  <xsl:if test=".//d:figure">
	    <xsl:call-template name="list.of.titles">
	      <xsl:with-param name="titles" select="'figure'"/>
	      <xsl:with-param name="nodes" select=".//d:figure"/>
	    </xsl:call-template>
	  </xsl:if>
	</xsl:if>

	<xsl:apply-templates select="*[not(@role='before.toc')]|processing-instruction()"/>

        <fo:block id="{$id}-end" text-align-last="center"
          xsl:use-attribute-sets="root.properties" font-weight="bold"
          font-size="11pt" margin-top="10pt" start-indent="0pt">
          <fo:inline>End of data module</fo:inline>
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
</xsl:stylesheet>