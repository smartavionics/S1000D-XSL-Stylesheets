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
  
  <!-- figures ********************************************************************** -->

  <xsl:param name="formal.title.placement">
    figure after
    example before
    equation after
    table before
    procedure before
  </xsl:param>
  
<!--  <xsl:template match="d:mediaobject|d:imageobject|d:imagedata">
    <fo:block border="black solid 1pt">
      <xsl:apply-imports/>
    </fo:block>
  </xsl:template>-->

  <xsl:template match="d:figure/d:caption">
    <fo:block>
      <xsl:attribute name="text-align">right</xsl:attribute>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>