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
  
  <!-- tables ********************************************************** -->
  
  <xsl:template name="table.cell.block.properties">
    <xsl:if test="ancestor::d:thead or ancestor::d:tfoot">
      <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:if>
    <xsl:attribute name="space-before">2pt</xsl:attribute>
    <xsl:attribute name="space-after">2pt</xsl:attribute>
  </xsl:template>

  <xsl:template match="d:table|d:informaltable">
    <xsl:variable name="start.indent">
      <xsl:choose>
        <xsl:when test="@pgwide=1">0pt</xsl:when>
        <xsl:otherwise>$body.start.indent</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="descendant::d:footnote">
        <fo:block start-indent="{$start.indent}"
          border-bottom="{$table.frame.border.color} {$table.frame.border.style} {$table.frame.border.thickness}">
          <xsl:apply-imports/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-imports/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="table.layout">  
    <xsl:param name="table.content"/>  

    <xsl:choose>
      <xsl:when test="$xep.extensions = 0 or self::d:informaltable">  
        <xsl:copy-of select="$table.content"/>
      </xsl:when>
      <xsl:otherwise>
        <fo:table rx:table-omit-initial-header="true" width="100%">  
          <fo:table-header start-indent="0pt">
            <fo:table-row>
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="formal.title.properties">  
                  <xsl:apply-templates select="." mode="object.title.markup"/>
                  <fo:inline font-style="italic">
                    <xsl:text> (continued) </xsl:text>  
                  </fo:inline>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body start-indent="0pt">
            <fo:table-row>
              <fo:table-cell>
                <xsl:copy-of select="$table.content"/>  
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>    

  <xsl:attribute-set name="table.properties">
    <xsl:attribute name="keep-together.within-column">auto</xsl:attribute> 
  </xsl:attribute-set>

</xsl:stylesheet>
