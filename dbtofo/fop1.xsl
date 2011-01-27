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
  xmlns:fox="http://xml.apache.org/fop/extensions"
  version="1.0">

  <xsl:template match="*" mode="fop1.outline">
    <xsl:apply-templates select="*" mode="fop1.outline"/>
  </xsl:template>

  <xsl:template match="d:chapter|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:section" mode="fop1.outline">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="bookmark-label">
      <xsl:call-template name="bookmark.label"/>
    </xsl:variable>
    <xsl:if test="$bookmark-label != ''">
      <fo:bookmark internal-destination="{$id}" xsl:exclude-result-prefixes="d fox l">
        <fo:bookmark-title>
          <xsl:value-of select="normalize-space($bookmark-label)"/>
        </fo:bookmark-title>
        <xsl:apply-templates select="*" mode="fop1.outline"/>
      </fo:bookmark>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="d:book" mode="fop1.foxdest">
    <xsl:apply-templates select="*" mode="fop1.foxdest"/>
  </xsl:template>
  
  <xsl:template name="fop1-document-information">
    <xsl:variable name="author" select="(//d:chapter[1]/d:info/d:bibliomisc[@role='publication.author'])"/>
    <xsl:variable name="title" select="(//d:chapter[1]/d:info/d:bibliomisc[@role='publication.title'])"/>

    <fo:declarations>
      <x:xmpmeta xmlns:x="adobe:ns:meta/">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	  <rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">
	    <!-- Dublin Core properties go here -->

	    <!-- Title -->
	    <dc:title><xsl:value-of select="normalize-space($title)"/></dc:title>

	    <!-- Author -->
	    <xsl:if test="$author">
	      <dc:creator><xsl:value-of select="normalize-space($author)"/></dc:creator>
	    </xsl:if>

	    <!-- Subject -->
	    <xsl:if test="//d:subjectterm">
	      <dc:description>
	        <xsl:for-each select="//d:subjectterm">
		  <xsl:value-of select="normalize-space(.)"/>
		  <xsl:if test="position() != last()">
		    <xsl:text>, </xsl:text>
		  </xsl:if>
	        </xsl:for-each>
	      </dc:description>
	    </xsl:if>
	  </rdf:Description>

	  <rdf:Description rdf:about="" xmlns:pdf="http://ns.adobe.com/pdf/1.3/">
	    <!-- PDF properties go here -->

	    <!-- Keywords -->
	    <xsl:if test="//d:keyword">
	      <pdf:Keywords>
	        <xsl:for-each select="//d:keyword">
		  <xsl:value-of select="normalize-space(.)"/>
		  <xsl:if test="position() != last()">
		    <xsl:text>, </xsl:text>
		  </xsl:if>
	        </xsl:for-each>
	      </pdf:Keywords>
	    </xsl:if>
	  </rdf:Description>

	  <rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/">
	    <!-- XMP properties go here -->

	    <!-- Creator Tool -->
	    <xmp:CreatorTool><xsl:value-of select="$creator.tool"/></xmp:CreatorTool>
	  </rdf:Description>

        </rdf:RDF>
      </x:xmpmeta>
    </fo:declarations>
  </xsl:template>

</xsl:stylesheet>
