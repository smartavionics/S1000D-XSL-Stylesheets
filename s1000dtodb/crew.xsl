<?xml version="1.0" encoding="UTF-8"?>

<!-- ********************************************************************

     This file is part of the S1000D XSL stylesheet distribution.
     
     Copyright (C) 2010-2011 Smart Avionics Ltd.
     
     See ../COPYING for copyright details and other information.

     ******************************************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://docbook.org/ns/docbook"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  version="1.0">

  <xsl:template match="dmodule[contains(@xsi:noNamespaceSchemaLocation, 'crew.xsd')]">
    <xsl:element name="chapter">
      <xsl:attribute name="xml:id">
        <xsl:call-template name="get.dmcode"/>
      </xsl:attribute>
      <xsl:variable name="info.code">
        <xsl:call-template name="get.infocode"/>
      </xsl:variable>
      <xsl:apply-templates select="identAndStatusSection"/>
      <xsl:call-template name="content.refs"/>
      <xsl:apply-templates select="content/crew"/>
    </xsl:element>    
  </xsl:template>

  <xsl:template match="crew">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="descrCrew">
    <bridgehead renderas="centerhead">Crew/operator content</bridgehead>
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
