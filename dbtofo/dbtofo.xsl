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

  <xsl:import
    href="http://docbook.sourceforge.net/release/xsl-ns/current/fo/docbook.xsl"/>

  <xsl:output indent="no" method="xml"/>

  <!-- Params & attribute sets *********************************************************** -->
  
  <xsl:param name="s1000d.xsl.version"/>
  
  <xsl:param name="creator.tool">
    <xsl:text>S1000D XSL </xsl:text>
    <xsl:value-of select="$s1000d.xsl.version"/>
    <xsl:text> + Docbook </xsl:text>
    <xsl:value-of select="$DistroTitle"/>
    <xsl:text> V</xsl:text>
    <xsl:value-of select="$VERSION"/>
  </xsl:param>
  
  <xsl:param name="hyphenate">false</xsl:param>
  
  <xsl:param name="font.family">Helvetica</xsl:param>
  
  <xsl:param name="page.margin.top">11mm</xsl:param>
  <xsl:param name="region.before.extent">15mm</xsl:param>
  <xsl:param name="body.margin.top">25mm</xsl:param>
  
  <xsl:param name="page.margin.bottom">12mm</xsl:param>
  <xsl:param name="region.after.extent">15mm</xsl:param>
  <xsl:param name="body.margin.bottom">25mm</xsl:param>
  
  <xsl:param name="page.width.portrait">210mm</xsl:param>
  <xsl:param name="page.margin.inner">10mm</xsl:param>
  <xsl:param name="page.margin.outer">15mm</xsl:param>

  <xsl:param name="body.margin.inner">15mm</xsl:param>  
  <xsl:param name="body.start.indent">20mm</xsl:param>
  
  <xsl:param name="itemizedlist.label.width">7mm</xsl:param>
  <xsl:param name="orderedlist.label.width">7mm</xsl:param>
  
  <xsl:param name="graphic.default.extension">png</xsl:param>
  
  <xsl:attribute-set name="root.properties">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$font.family"/></xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:param name="font.size.heading">14pt</xsl:param>
  
  <xsl:attribute-set name="normal.para.spacing">
    <xsl:attribute name="space-before.optimum">10pt</xsl:attribute>
    <xsl:attribute name="space-before.minimum">8pt</xsl:attribute>
    <xsl:attribute name="space-before.maximum">12pt</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:param name="double.sided">1</xsl:param>

  <xsl:param name="headers.on.blank.pages">0</xsl:param>
  <xsl:param name="footers.on.blank.pages">0</xsl:param>
  
  <xsl:param name="toc.section.depth">4</xsl:param>
  <xsl:param name="bridgehead.in.toc">1</xsl:param>
  
  <xsl:param name="chapter.autolabel" select="0"/>
  <xsl:param name="section.autolabel" select="1"/>

  <xsl:param name="margin.note.float.type">left</xsl:param>
  <xsl:param name="margin.note.width">15mm</xsl:param>  

  <xsl:param name="footnote.font.size">7pt</xsl:param>
  
  <xsl:param name="table.footnote.number.format">1</xsl:param>
  <xsl:param name="default.table.width">100%</xsl:param>
  
  <xsl:attribute-set name="footnote.properties">
    <xsl:attribute name="font-family"><xsl:value-of select="$font.family"/></xsl:attribute>
    <xsl:attribute name="font-size"><xsl:value-of select="$footnote.font.size"/></xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-style">normal</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="start-indent">0pt</xsl:attribute>
    <xsl:attribute name="text-indent">0pt</xsl:attribute>
    <xsl:attribute name="hyphenate"><xsl:value-of select="$hyphenate"/></xsl:attribute>
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    <xsl:attribute name="linefeed-treatment">treat-as-space</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="table.footnote.properties">
    <xsl:attribute name="font-family"><xsl:value-of select="$font.family"/></xsl:attribute>
    <xsl:attribute name="font-size"><xsl:value-of select="$footnote.font.size"/></xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-style">normal</xsl:attribute>
    <xsl:attribute name="space-before">2pt</xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  
  <xsl:param name="xref.with.number.and.title">0</xsl:param>
  
  <xsl:attribute-set name="xref.properties">
    <xsl:attribute name="color">blue</xsl:attribute>
    <xsl:attribute name="text-decoration">underline</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:param name="ulink.show">1</xsl:param>
  <xsl:param name="ulink.footnotes">1</xsl:param>
  
  <xsl:param name="local.l10n.xml" select="document('')"/>
  
  <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n language="en">
      <l:context name="title">
        <l:template name="appendix" text="Appendix %n %t"/>
        <l:template name="chapter" text="Chapter %n %t"/>
        <l:template name="equation" text="Equation %n %t"/>
        <l:template name="example" text="Example %n %t"/>
        <l:template name="figure" text="Fig %n %t"/>
        <l:template name="part" text="Part %n %t"/>
        <l:template name="procedure.formal" text="Procedure %n %t"/>
        <l:template name="productionset.formal" text="Production %n"/>
        <l:template name="table" text="Table %n %t"/>
      </l:context>
      <l:context name="xref-number">
        <l:template name="figure" text="Fig %n"/>
        <l:template name="table" text="Table %n"/>
      </l:context>
    </l:l10n>
  </l:i18n>
  
  <!-- *************************************************************************** -->
  
  <xsl:include href="admonitions.xsl"/>
  <xsl:include href="change_bars.xsl"/>
  <xsl:include href="chapters.xsl"/>
  <xsl:include href="figures.xsl"/>
  <xsl:include href="fop1.xsl"/>
  <xsl:include href="headers_footers.xsl"/>
  <xsl:include href="labels.xsl"/>
  <xsl:include href="lists.xsl"/>
  <xsl:include href="markers.xsl"/>
  <xsl:include href="misc.xsl"/>
  <xsl:include href="pagesetup.xsl"/>
  <xsl:include href="sections.xsl"/> 
  <xsl:include href="tables.xsl"/>
  <xsl:include href="titles.xsl"/>
  <xsl:include href="toc.xsl"/>
  <xsl:include href="xep.xsl"/>
  
</xsl:stylesheet>
