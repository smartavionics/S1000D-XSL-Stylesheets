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

  <xsl:template match="dmodule[contains(@xsi:noNamespaceSchemaLocation, 'fault.xsd')]">
    <xsl:element name="chapter">
      <xsl:attribute name="xml:id">
	<xsl:call-template name="get.dmcode"/>
      </xsl:attribute>
      <xsl:if test="content/faultIsolation/faultIsolationProcedure"> 
        <xsl:call-template name="fault.codes.table"/>
      </xsl:if>
      <xsl:apply-templates select="identAndStatusSection"/>
      <xsl:call-template name="content.refs"/>
      <xsl:apply-templates select="content/faultReporting|content/faultIsolation"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="fault.codes.table">
    <bridgehead role='before.toc' renderas="sidehead0">Fault Codes</bridgehead>
    <informaltable role='before.toc' pgwide="1" frame="topbot" colsep="0">
      <tgroup cols="2" align="left">
        <colspec colwidth="1*"/>
        <colspec colwidth="3*"/>
        <thead>
          <row>
            <entry>Fault code</entry>
            <entry>Fault description</entry>
          </row>
        </thead>
        <tbody rowsep="0">
          <xsl:for-each select="content/faultIsolation/faultIsolationProcedure">
            <row>
              <entry><xsl:value-of select="fault/@faultCode"/></entry>
              <entry><xsl:apply-templates select="faultDescr/descr/text()"/></entry>
            </row>
          </xsl:for-each>
        </tbody>
      </tgroup>
    </informaltable>      
  </xsl:template>

  <xsl:template match="faultIsolation">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="faultIsolationProcedure">
    <xsl:apply-templates select="isolationProcedure"/>
  </xsl:template>

  <xsl:template match="isolationProcedure">
    <xsl:apply-templates select="preliminaryRqmts"/>
    <xsl:apply-templates select="isolationMainProcedure"/>
    <xsl:apply-templates select="closeRqmts"/>
  </xsl:template>

  <xsl:template match="isolationProcedure/closeRqmts/reqCondGroup">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="isolationProcedure/closeRqmts/reqCondGroup/noConds">
    <para><xsl:text>None.</xsl:text></para>
  </xsl:template>

  <xsl:template match="isolationMainProcedure">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="centerhead">Fault isolation procedure</bridgehead>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="isolationStep">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="isolationProcedureEnd">
    <xsl:apply-templates/>
    <para><emphasis role="bold">Goto Requirements after job completion</emphasis></para>
  </xsl:template>

  <xsl:template name="isolation.item.number">
    <xsl:number count="action|isolationStepQuestion" from="isolationProcedure" level="any"/>
  </xsl:template>
  
  <xsl:template match="action">
    <xsl:param name="prefix"/>
    <xsl:call-template name="labelled.para">
      <xsl:with-param name="label">
        <xsl:value-of select="$prefix"/><xsl:call-template name="isolation.item.number"/>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="isolationStepQuestion">
    <xsl:param name="prefix"/>
    <xsl:call-template name="labelled.para">
      <xsl:with-param name="label">
        <xsl:value-of select="$prefix"/><xsl:call-template name="isolation.item.number"/>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="isolationStepAnswer">
    <xsl:param name="prefix"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="listOfChoices">
    <xsl:param name="prefix"/>
    <xsl:apply-templates>
      <xsl:with-param name="prefix">
	<xsl:call-template name="isolation.item.number"/>
	<xsl:text>.</xsl:text>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="isolation.procedure.question">
    <xsl:param name="number"/>
    <xsl:param name="question"/>
    <xsl:variable name="next.action.ref.id" select="@nextActionRefId"/>
    <xsl:call-template name="labelled.para">
      <xsl:with-param name="label">
      	<xsl:value-of select="$number"/>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:value-of select="$question"/>
        <xsl:text>: Go to </xsl:text>
        <xsl:for-each select="//*[@id=$next.action.ref.id]">
	  <xsl:variable name="num">
	    <xsl:call-template name="isolation.item.number"/>
	  </xsl:variable>
	  <xsl:value-of select="$num + 1"/>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="choice">
    <xsl:param name="prefix"/>
    <xsl:call-template name="isolation.procedure.question">
      <xsl:with-param name="number"><xsl:value-of select="$prefix"/><xsl:number/></xsl:with-param>
      <xsl:with-param name="question"><xsl:apply-templates select="text()"/></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="yesNoAnswer">
    <xsl:param name="prefix"/>
    <xsl:apply-templates>
      <xsl:with-param name="prefix">
	<xsl:call-template name="isolation.item.number"/>
	<xsl:text>.</xsl:text>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="yesAnswer">
    <xsl:param name="prefix"/>
    <xsl:call-template name="isolation.procedure.question">
      <xsl:with-param name="number"><xsl:value-of select="$prefix"/>1</xsl:with-param>
      <xsl:with-param name="question">Yes</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="noAnswer">
    <xsl:param name="prefix"/>
    <xsl:call-template name="isolation.procedure.question">
      <xsl:with-param name="number"><xsl:value-of select="$prefix"/>2</xsl:with-param>
      <xsl:with-param name="question">No</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>