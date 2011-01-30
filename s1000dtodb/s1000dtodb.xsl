<?xml version="1.0" encoding="UTF-8"?>

<!-- ********************************************************************

     This file is part of the S1000D XSL stylesheet distribution.
     
     Copyright (C) 2010-2011 Smart Avionics Ltd.
     
     See ../COPYING for copyright details and other information.

     ******************************************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://docbook.org/ns/docbook"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="1.0">
  
  <xsl:param name="date.time"/>
  
  <xsl:param name="want.producedby.blurb">yes</xsl:param>
  
  <xsl:param name="want.inwork.blurb">yes</xsl:param>
  
  <xsl:param name="publication.code">UNKNOWN PUBLICATION CODE</xsl:param>

  <xsl:param name="body.start.indent">20mm</xsl:param>
  
  <xsl:param name="show.unimplemented.markup">1</xsl:param>

  <xsl:output indent="no" method="xml"/>

  <xsl:include href="crew.xsl"/>
  <xsl:include href="descript.xsl"/>
  <xsl:include href="fault.xsl"/>
  <xsl:include href="proced.xsl"/>

  <xsl:variable name="all.dmodules" select="/*/dmodule"/>

  <xsl:template match="publication">
    <book>
      <xsl:apply-templates select="pm"/>
    </book>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:message>Unhandled: <xsl:call-template name="element.name"/></xsl:message>
    <xsl:if test="$show.unimplemented.markup != 0 and ancestor-or-self::dmodule">
      <fo:block color="red">
        <xsl:apply-templates select="." mode="literal"/>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="literal">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:for-each select="@*">
      <xsl:text> </xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:text>=&quot;</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>&quot;</xsl:text>
    </xsl:for-each>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates mode="literal"/>
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>
  
  <xsl:template name="element.name">
    <xsl:for-each select="parent::*">
      <xsl:call-template name="element.name"/>
      <xsl:text>/</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="name()"/>
  </xsl:template>

  <xsl:template match="fo:*">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="pm">
    <xsl:for-each select="content/pmEntry//dmRef">
      <xsl:variable name="dm.ref.dm.code">
	<xsl:apply-templates select="dmRefIdent/dmCode"/>
      </xsl:variable>
      <xsl:for-each select="$all.dmodules">
	<xsl:variable name="dm.code">
	  <xsl:call-template name="get.dmcode"/>
	</xsl:variable>
	<xsl:if test="$dm.ref.dm.code = $dm.code">
	<!--
          <xsl:message>
            <xsl:text>Data module: </xsl:text>
            <xsl:value-of select="$dm.code"/>
          </xsl:message>
        -->
          <xsl:apply-templates select="."/>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="get.dmcode">
    <xsl:for-each select="ancestor-or-self::dmodule">
      <xsl:apply-templates select="identAndStatusSection/dmAddress/dmIdent/dmCode"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="get.infocode">
    <xsl:for-each select="ancestor-or-self::dmodule">
      <xsl:apply-templates select="identAndStatusSection/dmAddress/dmIdent/dmCode/@infoCode"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="copy.id">
    <xsl:if test="./@id">
      <xsl:variable name="id" select="./@id"/>
      <xsl:attribute name="xml:id">
        <xsl:call-template name="get.dmcode"/>
        <xsl:text>-</xsl:text>
	<xsl:value-of select="$id"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dmodule">
    <chapter>
      <xsl:choose>
        <xsl:when test="@xsi:noNamespaceSchemaLocation">
          <title>Unimplemented dmodule: <xsl:value-of select="@xsi:noNamespaceSchemaLocation"/></title>
        </xsl:when>
        <xsl:otherwise>
          <title>Unknown dmodule type</title>
        </xsl:otherwise>
      </xsl:choose>
    </chapter>
  </xsl:template>

  <xsl:template match="techName|infoName">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="get.applicability.string">
    <xsl:choose>
      <xsl:when test="dmStatus/applic/displayText/simplePara">
        <xsl:apply-templates select="dmStatus/applic/displayText/simplePara/node()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>All</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="identAndStatusSection">
    <info>
      <xsl:variable name="info.code">
        <xsl:call-template name="get.infocode"/>
      </xsl:variable>
      <title>
        <xsl:call-template name="tech.name"/>
      </title>
      <subtitle>
        <xsl:call-template name="info.name"/>
      </subtitle>
      <date>
        <xsl:apply-templates select=".//issueDate"/>
      </date>
      <bibliomisc role="publication.title">
        <xsl:apply-templates select="/*/pm/identAndStatusSection/pmAddress/pmAddressItems/pmTitle/text()"/>
      </bibliomisc>
      <bibliomisc role="publication.author">
        <xsl:apply-templates select="/*/pm/identAndStatusSection/pmStatus/responsiblePartnerCompany/enterpriseName/text()"/>
      </bibliomisc>
      <bibliomisc role="page.header.logo">
        <xsl:apply-templates select="(dmAddress/dmStatus/logo|/*/pm/identAndStatusSection/pmStatus/logo)[1]"/>
      </bibliomisc>
      <xsl:if test="number(dmAddress/dmIdent/issueInfo/@inWork) != 0 and $want.inwork.blurb = 'yes'">
        <bibliomisc role="inwork.blurb">
          This is a draft copy of issue <xsl:value-of select="dmAddress/dmIdent/issueInfo/@issueNumber"/>-<xsl:value-of
          select="dmAddress/dmIdent/issueInfo/@inWork"/>.
          <xsl:if test="$date.time != ''">
            Printed <xsl:value-of select="$date.time"/>.
          </xsl:if>
        </bibliomisc>
      </xsl:if>
      <xsl:if test="dmStatus/responsiblePartnerCompany/enterpriseName and $want.producedby.blurb = 'yes'">
        <bibliomisc role="producedby.blurb">
          Produced by: <xsl:value-of select="dmStatus/responsiblePartnerCompany/enterpriseName"/>
        </bibliomisc>
      </xsl:if>
      <xsl:if test="$info.code = '001'">
        <!-- title page -->
        <bibliomisc role="no.chapter.title"/>
      </xsl:if>
      <bibliomisc role="data.module.code">
        <xsl:apply-templates select="dmAddress/dmIdent/dmCode"/>
      </bibliomisc>
      <bibliomisc role="publication.code">
        <xsl:choose>
          <xsl:when test="/*/pm">
            <xsl:apply-templates select="/*/pm/identAndStatusSection/pmAddress/pmIdent/pmCode"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$publication.code"/>
          </xsl:otherwise>
        </xsl:choose>
      </bibliomisc>
      <bibliomisc role="classification">
        <xsl:choose>
          <xsl:when test="*/security/@securityClassification = '01'">
            <xsl:text>Unclassified</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Classified: </xsl:text>
            <xsl:value-of select="*/security/@securityClassification"/>
          </xsl:otherwise>
        </xsl:choose>
      </bibliomisc>
      <bibliomisc role="applicability">
        <xsl:call-template name="get.applicability.string"/>
      </bibliomisc>
    </info>
  </xsl:template>

  <xsl:template name="content.refs">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="centerhead">References</bridgehead>
    <table pgwide="1" frame="topbot" colsep="0">
      <title>References</title>
      <tgroup cols="2" align="left">
        <thead>
          <row>
            <entry>Data Module/Technical publication</entry>
            <entry>Title</entry>
          </row>
        </thead>
        <tbody rowsep="0">
	  <xsl:if test="not(content/refs)">
	    <row>
	      <entry>None</entry>
	      <entry></entry>
	    </row>
	  </xsl:if>
	  <xsl:for-each select="content/refs/dmRef">
	    <row>
	      <entry><xsl:apply-templates select="."/></entry>
	      <entry>
	        <xsl:if test="dmRefAddressItems/dmTitle">
		  <xsl:apply-templates select="dmRefAddressItems/dmTitle/techName"/>
		  <xsl:if test="dmRefAddressItems/dmTitle/infoName">
		    <xsl:text> - </xsl:text>
		    <xsl:apply-templates select="dmRefAddressItems/dmTitle/infoName"/>
		  </xsl:if>
	        </xsl:if>
	      </entry>
	    </row>
	  </xsl:for-each>
	  <xsl:for-each select="content/refs/externalPubRef">
	    <row>
	      <entry>
	        <xsl:if test="externalPubRefIdent/externalPubCode">
		  <xsl:if test="externalPubRefIdent/externalPubCode/@pubCodingScheme">
		    <xsl:value-of select="externalPubRefIdent/externalPubCode/@pubCodingScheme"/>
		    <xsl:text> </xsl:text>
	          </xsl:if>
		  <xsl:value-of select="externalPubRefIdent/externalPubCode"/>
	        </xsl:if>
	      </entry>
	      <entry>
	        <xsl:if test="externalPubRefIdent/externalPubTitle">
		  <xsl:value-of select="externalPubRefIdent/externalPubTitle"/>
	        </xsl:if>
	      </entry>
	    </row>
	  </xsl:for-each>
        </tbody>
      </tgroup>
    </table>      
  </xsl:template>

  <xsl:template match="*" mode="number">
    <xsl:number level="any" from="dmodule"/>
  </xsl:template>

  <xsl:template name="labelled.para">
    <xsl:param name="label"/>
    <xsl:param name="content"/>
    <xsl:element name="para">
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <fo:list-block start-indent="0mm" provisional-distance-between-starts="{$body.start.indent}">
        <fo:list-item>
	  <fo:list-item-label start-indent="0mm" end-indent="label-end()" text-align="start">
	    <fo:block>
	      <xsl:copy-of select="$label"/>
	    </fo:block>
	  </fo:list-item-label>
	  <fo:list-item-body start-indent="body-start()">
	    <fo:block>
	      <xsl:copy-of select="$content"/>
	    </fo:block>
	  </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="levelledPara" mode="number">
    <xsl:if test="parent::levelledPara">
      <xsl:apply-templates select="parent::levelledPara" mode="number"/>
      <xsl:text>.</xsl:text>
    </xsl:if>
    <xsl:number level="single"/>
  </xsl:template>
  
  <xsl:template match="proceduralStep" mode="number">
    <xsl:if test="parent::proceduralStep">
      <xsl:apply-templates select="parent::proceduralStep" mode="number"/>
      <xsl:text>.</xsl:text>
    </xsl:if>
    <xsl:number level="single"/>
  </xsl:template>
  
  <xsl:template match="internalRef">
    <xsl:variable name="id" select="@internalRefId"/>
    <xsl:variable name="target" select="ancestor-or-self::dmodule//*[@id = $id]"/>
    <xsl:variable name="linkend">
      <xsl:call-template name="get.dmcode"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="$id"/>
    </xsl:variable>
    <xsl:choose>
      <!-- 
        special case tables because the numbering of the authored tables doesn't
        start at 1 and we leave it up to the xref processing to work out the correct
        table number
      -->
      <xsl:when test="name($target[1]) = 'table'">
        <xsl:element name="xref">
	  <xsl:attribute name="linkend">
	    <xsl:value-of select="$linkend"/>
	  </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="link">
	  <xsl:attribute name="linkend">
	    <xsl:value-of select="$linkend"/>
	  </xsl:attribute>
	  <xsl:choose>
	    <xsl:when test="name($target[1]) = 'levelledPara'">
	      <xsl:for-each select="$target">
	        <xsl:text>Para&#160;</xsl:text>
	        <xsl:apply-templates select="." mode="number"/>
	      </xsl:for-each>
	    </xsl:when>
	    <xsl:when test="name($target[1]) = 'figure'">
	      <xsl:for-each select="$target">
	        <xsl:text>Fig&#160;</xsl:text>
	        <xsl:apply-templates select="." mode="number"/>
	      </xsl:for-each>
	    </xsl:when>
	    <xsl:when test="name($target[1]) = 'proceduralStep'">
	      <xsl:attribute name="xrefstyle">select:nopage</xsl:attribute>
	      <xsl:for-each select="$target">
	        <xsl:text>Step&#160;</xsl:text>
	        <xsl:apply-templates select="." mode="number"/>
	      </xsl:for-each>
	    </xsl:when>
	    <xsl:when test="name($target[1]) = 'hotspot'">
	      <xsl:for-each select="$target">
	        <xsl:text>Fig&#160;</xsl:text>
	        <xsl:for-each select="parent::*">
		  <xsl:apply-templates select="." mode="number"/>
	        </xsl:for-each>
	        <xsl:if test="@applicationStructureName">
		  <xsl:text>&#160;[</xsl:text>
		  <xsl:value-of select="@applicationStructureName"/>
		  <xsl:text>]</xsl:text>
	        </xsl:if>
	      </xsl:for-each>
	    </xsl:when>
	    <xsl:when test="$target/name">
	      <xsl:apply-templates select="$target/name/text()"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:message>Can't generate link target type for: <xsl:value-of select="name($target[1])"/>(<xsl:value-of select="$id"/>)</xsl:message>
	      <xsl:value-of select="$id"/>
	    </xsl:otherwise>
	  </xsl:choose>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dmRef">
    <xsl:variable name="dm.ref.dm.code">
      <xsl:apply-templates select="dmRefIdent/dmCode"/>
    </xsl:variable>
    <xsl:variable name="result">
      <xsl:for-each select="$all.dmodules">
        <xsl:variable name="dm.code">
          <xsl:call-template name="get.dmcode"/>
        </xsl:variable>
        <xsl:if test="$dm.ref.dm.code = $dm.code">
          <xsl:element name="link">
            <xsl:attribute name="linkend">
              <xsl:value-of select="$dm.ref.dm.code"/>
            </xsl:attribute>
            <xsl:value-of select="$dm.ref.dm.code"/>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$result != ''">
        <xsl:copy-of select="$result"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dm.ref.dm.code"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dmCode">
    <xsl:value-of select="./@modelIdentCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@systemDiffCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@systemCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@subSystemCode"/>
    <xsl:value-of select="./@subSubSystemCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@assyCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@disassyCode"/>
    <xsl:value-of select="./@disassyCodeVariant"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@infoCode"/>
    <xsl:value-of select="./@infoCodeVariant"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@itemLocationCode"/>
  </xsl:template>

  <xsl:template match="pmCode">
    <xsl:value-of select="./@modelIdentCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@pmIssuer"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@pmNumber"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="./@pmVolume"/>
  </xsl:template>
  
  <xsl:template name="tech.name">
    <xsl:apply-templates select="dmAddress/dmAddressItems/dmTitle/techName"/>
  </xsl:template>
  
  <xsl:template name="info.name">
    <xsl:apply-templates select="dmAddress/dmAddressItems/dmTitle/infoName"/>
  </xsl:template>
  
  <xsl:template match="issueDate">
    <xsl:value-of select="@year"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@month"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@day"/>
  </xsl:template>

  <xsl:template match="levelledPara">
    <xsl:element name="section">
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="commonInfo">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <xsl:choose>
      <xsl:when test="title">
        <bridgehead renderas="centerhead"><xsl:value-of select="title"/></bridgehead>
      </xsl:when>
      <xsl:otherwise>
        <bridgehead renderas="centerhead">Common Information</bridgehead>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="figure|note|para|commonInfoDescrPara"/>
  </xsl:template>
  
  <xsl:template match="preliminaryRqmts">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="centerhead">Preliminary requirements</bridgehead>
    <xsl:apply-templates select="reqCondGroup"/>
    <xsl:apply-templates select="reqPersons"/>
    <xsl:apply-templates select="reqSupportEquips"/>
    <xsl:apply-templates select="reqSupplies"/>
    <xsl:apply-templates select="reqSpares"/>
    <xsl:apply-templates select="reqSafety"/>
  </xsl:template>

  <xsl:template match="closeRqmts">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="centerhead">Requirements after job completion</bridgehead>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="required.conditions">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="sidehead0">Required conditions</bridgehead>
    <table pgwide="1" frame="topbot" colsep="0">
      <title>Required conditions</title>
      <tgroup cols="2" align="left">
        <thead>
          <row>
            <entry>Action/Condition</entry>
            <entry>Data module/Technical publication</entry>
          </row>
        </thead>
        <tbody rowsep="0">
          <xsl:for-each select="*">
            <row>
              <xsl:choose>
                <xsl:when test="name() = 'noConds'">
                  <entry>None</entry>
                  <entry></entry>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="."/>
                </xsl:otherwise>
              </xsl:choose>
            </row>
          </xsl:for-each>
        </tbody>
      </tgroup>
    </table>      
  </xsl:template>

  <xsl:template match="preliminaryRqmts/reqCondGroup">
    <xsl:call-template name="required.conditions"/>
  </xsl:template>

  <xsl:template match="reqCondNoRef">
    <entry><xsl:apply-templates/></entry>
    <entry></entry>
  </xsl:template>
  
  <xsl:template match="reqCondExternalPub">
    <entry><xsl:apply-templates select="reqCond"/></entry>
    <entry><xsl:apply-templates select="externalPubRef"/></entry>
  </xsl:template>

  <xsl:template match="reqCondDm">
    <entry><xsl:apply-templates select="reqCond"/></entry>
    <entry><xsl:apply-templates select="dmRef"/></entry>
  </xsl:template>

  <xsl:template match="reqCond">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="externalPubRef">
    <xsl:choose>
      <xsl:when test="@xlink:href" xmlns:xlink="http://www.w3.org/1999/xlink">
        <xsl:element name="link">
	  <xsl:attribute name="xlink:href">
	    <xsl:value-of select="@xlink:href"/>
	  </xsl:attribute>
	  <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="externalPubRefIdent|externalPubTitle">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="estimatedTime">
    <xsl:apply-templates/>
    <xsl:if test="@unitOfMeasure">
      <xsl:text> </xsl:text>
      <xsl:value-of select="@unitOfMeasure"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="reqPersons">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="sidehead0">Required persons</bridgehead>
    <table pgwide="1" frame="topbot" colsep="0">
      <title>Required persons</title>
      <tgroup cols="5" align="left">
        <thead>
          <row>
            <entry>Person</entry>
            <entry>Category</entry>
            <entry>Skill Level</entry>
            <entry>Trade/Trade code</entry>
            <entry>Estimated time</entry>
          </row>
        </thead>
        <tbody rowsep="0">
	  <xsl:choose>
	    <xsl:when test="person|personnel">
	      <xsl:for-each select="person">
	        <row>
		  <entry><xsl:text>Man </xsl:text><xsl:value-of select="@man"/></entry>
		  <entry><xsl:value-of select="personCategory/@personCategoryCode"/></entry>
		  <entry><xsl:apply-templates select="personSkill/@skillLevelCode"/></entry>
		  <entry><xsl:value-of select="trade"/></entry>
		  <entry><xsl:apply-templates select="estimatedTime"/></entry>
	        </row>
	      </xsl:for-each>
	      <xsl:for-each select="personnel">
	        <xsl:choose>
		  <xsl:when test="*">
		    <row>
		      <entry>As required</entry>
		      <entry><xsl:value-of select="personCategory/@personCategoryCode"/></entry>
		      <entry>
		        <xsl:apply-templates select="personSkill/@skillLevelCode"/>
		        <xsl:if test="@numRequired">
			  <xsl:text> (</xsl:text>
			    <xsl:value-of select="@numRequired"/>
			  <xsl:text>)</xsl:text>
		        </xsl:if>
		      </entry>
		      <entry><xsl:value-of select="trade"/></entry>
		      <entry><xsl:apply-templates select="estimatedTime"/></entry>
		    </row>
		  </xsl:when>
		  <xsl:otherwise>
		    <row>
		      <entry>As required</entry>
		    </row>
		  </xsl:otherwise>
	        </xsl:choose>
	      </xsl:for-each>
	    </xsl:when>
	    <xsl:otherwise>
	      <row>
	        <entry>As required</entry>
	      </row>
	    </xsl:otherwise>
	  </xsl:choose>
        </tbody>
      </tgroup>
    </table>      
  </xsl:template>

  <xsl:template match="reqQuantity">
    <xsl:apply-templates/>
    <xsl:if test="@unitOfMeasure != 'EA'">
      <xsl:text> </xsl:text>
      <xsl:value-of select="@unitOfMeasure"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="identNumber">
    <xsl:value-of select="manufacturerCode"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="partAndSerialNumber/partNumber"/>
  </xsl:template>

  <xsl:template match="reqSupportEquips">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="sidehead0">Support equipment</bridgehead>
    <table pgwide="1" frame="topbot" colsep="0">
      <title>Support equipment</title>
      <tgroup cols="4" align="left">
        <colspec colnum="1" colwidth="10*"/>
        <colspec colnum="2" colwidth="10*"/>
        <colspec colnum="3" colwidth="5*"/>
        <colspec colnum="4" colwidth="10*"/>
        <thead>
          <row>
            <entry>Name</entry>
            <entry>Identification/Reference</entry>
            <entry>Quantity</entry>
            <entry>Remark</entry>
          </row>
        </thead>
        <tbody rowsep="0">
          <xsl:choose>
            <xsl:when test="noSupportEquips or not(supportEquipDescrGroup/supportEquipDescr)">
              <row>
                <entry>None</entry>
              </row>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="supportEquipDescrGroup/supportEquipDescr">
                <xsl:variable name="id" select="./@id"/>
                <xsl:element name="row">
		  <xsl:element name="entry">
		    <xsl:if test="./@id">
		      <xsl:attribute name="xml:id">
		        <xsl:call-template name="get.dmcode"/>
		        <xsl:text>-</xsl:text>
		        <xsl:value-of select="$id"/>
		      </xsl:attribute>
		    </xsl:if>
		    <xsl:value-of select="name"/>
		  </xsl:element>
                  <entry><xsl:apply-templates select="catalogSeqNumberRef|natoStockNumber|identNumber|toolRef"/></entry>
                  <entry><xsl:apply-templates select="reqQuantity"/></entry>
                  <entry><xsl:apply-templates select="remarks"/></entry>
                </xsl:element>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </tbody>
      </tgroup>
    </table>      
  </xsl:template>

  <xsl:template match="reqSupplies">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="sidehead0">Consumables, materials and expendables</bridgehead>
    <table pgwide="1" frame="topbot" colsep="0">
      <title>Consumables, materials and expendables</title>
      <tgroup cols="4" align="left">
        <colspec colnum="1" colwidth="10*"/>
        <colspec colnum="2" colwidth="10*"/>
        <colspec colnum="3" colwidth="5*"/>
        <colspec colnum="4" colwidth="10*"/>
        <thead>
          <row>
            <entry>Name</entry>
            <entry>Identification/Reference</entry>
            <entry>Quantity</entry>
            <entry>Remark</entry>
          </row>
        </thead>
        <tbody rowsep="0">
          <xsl:choose>
            <xsl:when test="noSupplies or not(supplyDescrGroup/supplyDescr)">
              <row>
                <entry>None</entry>
              </row>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="supplyDescrGroup/supplyDescr">
                <xsl:variable name="id" select="./@id"/>
                <xsl:element name="row">
                  <xsl:element name="entry">
		    <xsl:if test="./@id">
		      <xsl:attribute name="xml:id">
		        <xsl:call-template name="get.dmcode"/>
		        <xsl:text>-</xsl:text>
		        <xsl:value-of select="$id"/>
		      </xsl:attribute>
		    </xsl:if>
		    <xsl:value-of select="name"/>
		  </xsl:element>
                  <entry><xsl:apply-templates select="catalogSeqNumberRef|natoStockNumber|identNumber|supplyRqmtRef"/></entry>
                  <entry><xsl:apply-templates select="reqQuantity"/></entry>
                  <entry><xsl:apply-templates select="remarks"/></entry>
                </xsl:element>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </tbody>
      </tgroup>
    </table>      
  </xsl:template>

  <xsl:template match="reqSpares">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="sidehead0">Spares</bridgehead>
    <table pgwide="1" frame="topbot" colsep="0">
      <title>Spares</title>
      <tgroup cols="4" align="left">
        <colspec colnum="1" colwidth="10*"/>
        <colspec colnum="2" colwidth="10*"/>
        <colspec colnum="3" colwidth="5*"/>
        <colspec colnum="4" colwidth="10*"/>
        <thead>
          <row>
            <entry>Name</entry>
            <entry>Identification/Reference</entry>
            <entry>Quantity</entry>
            <entry>Remark</entry>
          </row>
        </thead>
        <tbody rowsep="0">
          <xsl:choose>
            <xsl:when test="noSpares or not(spareDescrGroup/spareDescr)">
              <row>
                <entry>None</entry>
              </row>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="spareDescrGroup/spareDescr">
                <xsl:variable name="id" select="./@id"/>
                <xsl:element name="row">
                  <xsl:element name="entry">
		    <xsl:if test="./@id">
		      <xsl:attribute name="xml:id">
		        <xsl:call-template name="get.dmcode"/>
		        <xsl:text>-</xsl:text>
		        <xsl:value-of select="$id"/>
		      </xsl:attribute>
		    </xsl:if>
		    <xsl:value-of select="name"/>
		  </xsl:element>
                  <entry><xsl:apply-templates select="catalogSeqNumberRef|natoStockNumber|identNumber|functionalItemRef"/></entry>
                  <entry><xsl:apply-templates select="reqQuantity"/></entry>
                  <entry><xsl:apply-templates select="remarks"/></entry>
                </xsl:element>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </tbody>
      </tgroup>
    </table>      
  </xsl:template>

  <xsl:template match="reqSafety">
    <xsl:processing-instruction name="dbfo-need">
      <xsl:text>height="2cm"</xsl:text>
    </xsl:processing-instruction>
    <bridgehead renderas="sidehead0">Safety Conditions</bridgehead>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="noSafety">
    <para>
      <xsl:text>None</xsl:text>
    </para>
  </xsl:template>

  <xsl:template match="safetyRqmts">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="warning|caution|note">
    <xsl:element name="{name()}">
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="para|warningAndCautionPara|notePara|simplePara|commonInfoDescrPara">
    <xsl:element name="para">
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="figure">
    <xsl:element name="figure">
      <xsl:call-template name="copy.id"/>
      <xsl:call-template name="revisionflag"/>
      <xsl:attribute name="label">
	<xsl:number level="any" from="dmodule"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="title">
    <title><xsl:apply-templates/></title>
  </xsl:template>

  <xsl:template name="make.imageobject" xmlns:ier="InfoEntityResolver">
    <xsl:variable name="entity" select="@infoEntityIdent"/>
    <xsl:variable name="fileref">
      <xsl:choose>
        <xsl:when test="function-available('ier:resolve')">
	  <xsl:value-of select="ier:resolve($entity)"/>
        </xsl:when>
        <xsl:otherwise>
	  <xsl:value-of select="$entity"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--
    <xsl:message>    Graphic: <xsl:value-of select="$entity"/></xsl:message>
    <xsl:if test="$fileref != $entity">
      <xsl:message>         Is: <xsl:value-of select="$fileref"/></xsl:message>
    </xsl:if>
    -->
    <imageobject xsl:exclude-result-prefixes="ier">
      <xsl:element name="imagedata">
        <xsl:attribute name="align">center</xsl:attribute>
        <xsl:attribute name="fileref">
	  <xsl:value-of select="$fileref"/>
        </xsl:attribute>
        <xsl:if test="@reproductionWidth">
	  <xsl:attribute name="width">
	    <xsl:value-of select="@reproductionWidth"/>
	  </xsl:attribute>
        </xsl:if>
        <xsl:if test="@reproductionHeight">
	  <xsl:attribute name="depth">
	    <xsl:value-of select="@reproductionHeight"/>
	  </xsl:attribute>
        </xsl:if>
        <xsl:if test="@reproductionScale">
	  <xsl:attribute name="scale">
	    <xsl:value-of select="@reproductionScale"/>
	  </xsl:attribute>
        </xsl:if>
      </xsl:element>
    </imageobject>
  </xsl:template>

  <xsl:template match="graphic">
    <mediaobject>
      <xsl:call-template name="make.imageobject"/>
    </mediaobject>
    <caption>
      <para><xsl:value-of select="@infoEntityIdent"/></para>
    </caption>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="symbol">
    <inlinemediaobject>
      <xsl:call-template name="make.imageobject"/>
    </inlinemediaobject>
  </xsl:template>

  <xsl:template match="hotspot">
    <xsl:element name="anchor">
      <xsl:call-template name="copy.id"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="logo">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="randomList">
    <xsl:element name="itemizedlist">
      <xsl:call-template name="revisionflag"/>
      <xsl:if test="@listItemPrefix = 'pf01'">
        <!-- "simple list" -->
        <xsl:attribute name="mark">
	  <xsl:text>none</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sequentialList">
    <xsl:element name="orderedlist">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="definitionList">
    <xsl:element name="variablelist">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="definitionListHeader|definitionListItem">
    <xsl:element name="varlistentry">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="termTitle">
    <xsl:element name="term">
      <xsl:call-template name="revisionflag"/>    
      <emphasis role="bold">
        <emphasis role="underline">
	  <xsl:apply-templates/>
        </emphasis>
      </emphasis>
    </xsl:element>
  </xsl:template>

  <xsl:template match="definitionTitle">
    <xsl:element name="listitem">
      <xsl:call-template name="revisionflag"/>
      <emphasis role="bold">
        <emphasis role="underline">
	  <xsl:apply-templates/>
        </emphasis>
      </emphasis>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="listItemTerm">
    <xsl:element name="term">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="listItem|listItemDefinition">
    <xsl:element name="listitem">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="table">
    <xsl:element name="table">
      <xsl:call-template name="copy.id"/>
      <xsl:if test="descendant-or-self::*[@changeMark = '1']">
        <xsl:call-template name="revisionflag">
          <xsl:with-param name="change.mark">1</xsl:with-param>
          <!-- there could be multiple modifications of differing types so lets just mark the table as modified -->
          <xsl:with-param name="change.type">modify</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:attribute name="frame">topbot</xsl:attribute>
      <xsl:attribute name="colsep">0</xsl:attribute>
      <xsl:for-each select="@*">
        <xsl:if test="name(.) != 'id'">
	  <xsl:copy/>
        </xsl:if>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tbody">
    <xsl:element name="tbody">
      <xsl:attribute name="rowsep">0</xsl:attribute>
      <xsl:for-each select="@*">
	<xsl:copy/>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tgroup|thead|colspec|row|entry">
    <xsl:element name="{name()}">
      <xsl:call-template name="copy.id"/>
      <xsl:for-each select="@*">
        <xsl:choose>
	  <xsl:when test="name(.) = 'id'">
	    <!-- ignore it -->
	  </xsl:when>
	  <xsl:when test="name(.) = 'colwidth' and string(number(.))!='NaN'">
	  <!-- colwidth is just a plain number so suffix with '*' -->
	  <xsl:attribute name="colwidth">
	    <xsl:value-of select="."/>
	    <xsl:text>*</xsl:text>
	    </xsl:attribute>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:copy/>
	  </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="emphasis">
    <xsl:element name="emphasis">
      <xsl:attribute name="role">
        <xsl:choose>
          <xsl:when test="@emphasisType = 'em02'">italic</xsl:when>
          <xsl:when test="@emphasisType = 'em03'">underline</xsl:when>
          <xsl:when test="@emphasisType = 'em05'">strikethrough</xsl:when>
          <xsl:otherwise>bold</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="verbatimText">
    <xsl:choose>
      <xsl:when test="not(@verbatimStyle)">
        <programlisting><xsl:apply-templates/></programlisting>
      </xsl:when>
      <xsl:when test="@verbatimStyle = 'vs23'">
        <screen><xsl:apply-templates/></screen>
      </xsl:when>
      <xsl:when test="@verbatimStyle = 'vs24'">
        <programlisting><xsl:apply-templates/></programlisting>
      </xsl:when>
      <xsl:otherwise>
        <literal><xsl:apply-templates/></literal>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="footnote">
    <xsl:element name="footnote">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="subScript">
    <subscript><xsl:apply-templates/></subscript>
  </xsl:template>

  <xsl:template match="superScript">
    <superscript><xsl:apply-templates/></superscript>
  </xsl:template>

  <xsl:template name="revisionflag">
    <xsl:param name="change.mark">
      <xsl:value-of select="@changeMark"/>
    </xsl:param>
    <xsl:param name="change.type">
      <xsl:value-of select="@changeType"/>
    </xsl:param>
    <xsl:if test="$change.mark = '1'">
      <xsl:attribute name="revisionflag">
        <xsl:choose>
	  <xsl:when test="$change.type = 'add'">
	    <xsl:text>added</xsl:text>
	  </xsl:when>
	  <xsl:when test="$change.type = 'delete'">
	    <xsl:text>deleted</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>changed</xsl:text>
	  </xsl:otherwise>      
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="changeInline">
    <xsl:element name="phrase">
      <xsl:call-template name="revisionflag"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="gen.lodm">
    <para>The listed documents are included in issue
      <xsl:value-of select="/*/pm/identAndStatusSection/pmAddress/pmIdent/issueInfo/@issueNumber"/>, dated
      <xsl:apply-templates select="/*/pm/identAndStatusSection/pmAddress/pmAddressItems/issueDate"/>, of this publication.
    </para>
    <para>C = Changed data module</para>
    <para>N = New data module</para>
    <informaltable pgwide="1" frame="topbot" colsep="0" rowsep="0">
      <tgroup cols="6" align="left">
        <colspec colnum="3" colwidth="1.5em" align="center"/>
        <colspec colnum="4" colwidth="6em"/>
        <colspec colnum="5" colwidth="4em"/>
        <thead rowsep="1">
          <row>
            <entry>Document title</entry>
            <entry>Data module code</entry>
            <entry></entry>
            <entry>Issue date</entry>
            <entry>No. of pages</entry>
            <entry>Applicable to</entry>
          </row>
        </thead>
        <tbody>
	  <xsl:if test="not(/*/pm/content/pmEntry//dmRef)">
	    <row>
	      <entry>None</entry>
	    </row>
	  </xsl:if>
          <xsl:for-each select="/*/pm/content/pmEntry//dmRef">
            <xsl:variable name="dm.ref.dm.code">
              <xsl:apply-templates select="dmRefIdent/dmCode"/>
            </xsl:variable>
            <xsl:for-each select="$all.dmodules">
              <xsl:variable name="dm.code">
                <xsl:call-template name="get.dmcode"/>
              </xsl:variable>
              <xsl:if test="$dm.ref.dm.code = $dm.code">
                <row>
                  <entry>
                    <xsl:apply-templates select="identAndStatusSection//dmTitle/techName"/>
                    <xsl:if test="identAndStatusSection//dmTitle/infoName">
                      <xsl:text> - </xsl:text>
                      <xsl:apply-templates select="identAndStatusSection//dmTitle/infoName"/>
                    </xsl:if>
                  </entry>
                  <entry>
                    <xsl:element name="link">
                      <xsl:attribute name="linkend">
                        <xsl:call-template name="get.dmcode"/>
                      </xsl:attribute>
                      <xsl:call-template name="get.dmcode"/>
                    </xsl:element>
                  </entry>
                  <entry>
                    <xsl:choose>
                      <xsl:when test="identAndStatusSection/dmStatus/@issueType='new'">
                        <xsl:text>N</xsl:text>
                      </xsl:when>
                      <xsl:when test="identAndStatusSection/dmStatus/@issueType='changed'">
                        <xsl:text>C</xsl:text>
                      </xsl:when>
                    </xsl:choose>
                  </entry>
                  <entry>
                    <xsl:apply-templates select="identAndStatusSection/dmAddress/dmAddressItems/issueDate"/>
                  </entry>
                  <entry>
                    <para>
                      <fo:page-number-citation-last ref-id="{$dm.code}-end"/>
                    </para>
                  </entry>
                  <entry>
                    <xsl:for-each select="identAndStatusSection">
                      <xsl:call-template name="get.applicability.string"/>
                    </xsl:for-each>
                  </entry>
                </row>
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each>
        </tbody>
      </tgroup>
    </informaltable>
  </xsl:template>

</xsl:stylesheet>