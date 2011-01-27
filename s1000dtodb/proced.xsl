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

  <xsl:template match="dmodule[contains(@xsi:noNamespaceSchemaLocation, 'proced.xsd')]">
    <xsl:element name="chapter">
      <xsl:attribute name="xml:id">
	<xsl:call-template name="get.dmcode"/>
      </xsl:attribute>
      <xsl:apply-templates select="identAndStatusSection"/>
      <xsl:call-template name="content.refs"/>
      <xsl:apply-templates select="content/procedure"/>
    </xsl:element>    
  </xsl:template>

  <xsl:template match="procedure">
    <xsl:apply-templates select="preliminaryRqmts"/>
    <xsl:apply-templates select="mainProcedure"/>
    <xsl:apply-templates select="closeRqmts"/>
  </xsl:template>

  <xsl:template match="mainProcedure">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="centerhead">Procedure</bridgehead>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="proceduralStep/title">
    <emphasis role="bold">
      <xsl:apply-templates/>
    </emphasis>
  </xsl:template>
  
  <xsl:template match="proceduralStep">
    <xsl:call-template name="labelled.para">
      <xsl:with-param name="label">
        <xsl:apply-templates select="." mode="number"/>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:apply-templates select="*[not(self::proceduralStep)]"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="proceduralStep"/>
  </xsl:template>

  <xsl:template match="proceduralStep/para">
    <xsl:choose>
      <xsl:when test="position() = 1">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<para><xsl:apply-templates/></para>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="procedure/closeRqmts/reqCondGroup">
    <xsl:call-template name="required.conditions"/>
  </xsl:template>

</xsl:stylesheet>