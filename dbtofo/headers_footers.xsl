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
  
  <!-- Headers/Footers ***************************************************************** -->

  <xsl:template name="initial.page.number">1</xsl:template>

  <xsl:template name="header.content">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="position" select="''"/>
    <xsl:param name="gentext-key" select="''"/>

    <!--
    <fo:block>
      <xsl:value-of select="$pageclass"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="$sequence"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="$position"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="$gentext-key"/>
    </fo:block>
    -->

    <fo:block xsl:use-attribute-sets="root.properties" font-weight="bold"
      font-size="11pt">
      <!-- pageclass can be front, body, back -->
      <!-- sequence can be odd, even, first, blank -->
      <!-- position can be left, center, right -->
      <xsl:choose>
        <xsl:when test="$pageclass = 'titlepage'">
          <!-- nop; no header on title pages -->
        </xsl:when>

        <xsl:when test="$sequence = 'blank'">
          <!-- nop; don't mark blank pages at end of chapters -->
        </xsl:when>

        <xsl:when
          test="$double.sided != 0 and $sequence = 'even' and $position='left'">
          <fo:block text-align-last="left" margin-bottom="20pt">
            <fo:retrieve-marker retrieve-class-name="chapter.publication.code"
              retrieve-position="first-including-carryover"
              retrieve-boundary="page-sequence"/>
          </fo:block>
        </xsl:when>

        <xsl:when
          test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first')
          and $position='right'">
          <fo:block text-align-last="right" margin-bottom="20pt">
            <fo:retrieve-marker retrieve-class-name="chapter.publication.code"
              retrieve-position="first-including-carryover"
              retrieve-boundary="page-sequence"/>
          </fo:block>
        </xsl:when>

        <xsl:when
          test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first')
          and $position='left'">
	  <fo:block text-align-last="left">
	    <fo:retrieve-marker retrieve-class-name="page.header.logo"
              retrieve-position="first-including-carryover"
              retrieve-boundary="page-sequence"/>
	  </fo:block>
        </xsl:when>

        <xsl:when
          test="$double.sided != 0 and $sequence = 'even' and $position='right'">
	  <fo:block text-align-last="right">
	    <fo:retrieve-marker retrieve-class-name="page.header.logo"
              retrieve-position="first-including-carryover"
              retrieve-boundary="page-sequence"/>
	  </fo:block>
        </xsl:when>

        <xsl:when test="$position='center'">
          <fo:block text-align-last="center">
            <fo:retrieve-marker retrieve-class-name="chapter.classification"
              retrieve-position="first-including-carryover"
              retrieve-boundary="page-sequence"/>
          </fo:block>
        </xsl:when>

        <xsl:when test="$sequence='blank'">
          <xsl:choose>
            <xsl:when test="$double.sided != 0 and $position = 'left'">
              <fo:page-number/>
            </xsl:when>
            <xsl:when test="$double.sided = 0 and $position = 'center'">
              <fo:page-number/>
            </xsl:when>
            <xsl:otherwise>
              <!-- nop -->
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:otherwise>
          <!-- nop -->
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <xsl:template name="footer.table">
    <xsl:param name="pageclass" select="''"/>
    <xsl:param name="sequence" select="''"/>
    <xsl:param name="gentext-key" select="''"/>

    <xsl:choose>
      <xsl:when test="$pageclass = 'index'">
        <xsl:attribute name="margin-{$direction.align.start}">0pt</xsl:attribute>
      </xsl:when>
    </xsl:choose>

    <xsl:variable name="candidate">
      <!-- top row -->
      <fo:table width="100%" xsl:use-attribute-sets="footer.table.properties root.properties"
        padding-top="1mm" border-collapse="separate">
        <xsl:call-template name="foot.sep.rule">
          <xsl:with-param name="pageclass" select="$pageclass"/>
          <xsl:with-param name="sequence" select="$sequence"/>
          <xsl:with-param name="gentext-key" select="$gentext-key"/>
        </xsl:call-template>
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-body>
          <fo:table-row height="20pt">
            <fo:table-cell text-align="left">
              <!-- top left -->
              <xsl:choose>
                <xsl:when test="$sequence = 'first' or $sequence = 'odd'">
                  <fo:block font-size="10pt" font-weight="normal">
                    <xsl:text>Applicable to: </xsl:text>
                    <fo:retrieve-marker retrieve-class-name="chapter.applicability"
                      retrieve-position="first-including-carryover"
                      retrieve-boundary="page-sequence"/>
                  </fo:block>
                </xsl:when>
                <xsl:otherwise>
                  <fo:block font-size="11pt" font-weight="bold">
                    <fo:retrieve-marker retrieve-class-name="chapter.data.module.code"
                      retrieve-position="first-including-carryover"
                      retrieve-boundary="page-sequence"/>
                  </fo:block>
                </xsl:otherwise>
              </xsl:choose>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <!-- top right -->
              <xsl:choose>
                <xsl:when test="$sequence = 'first' or $sequence = 'odd'">
                  <fo:block font-size="11pt" font-weight="bold">
                    <fo:retrieve-marker retrieve-class-name="chapter.data.module.code"
                      retrieve-position="first-including-carryover"
                      retrieve-boundary="page-sequence"/>
                  </fo:block>
                </xsl:when>
                <xsl:otherwise>
                  <fo:block font-size="10pt" font-weight="normal">
                    <xsl:text>Applicable to: </xsl:text>
                    <fo:retrieve-marker retrieve-class-name="chapter.applicability"
                      retrieve-position="first-including-carryover"
                      retrieve-boundary="page-sequence"/>
                  </fo:block>
                </xsl:otherwise>
              </xsl:choose>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
      <!-- bottom row -->
      <fo:table width="100%" xsl:use-attribute-sets="footer.table.properties root.properties">
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell text-align="left">
              <!-- bottom left -->
              <xsl:choose>
                <xsl:when test="$sequence = 'first' or $sequence = 'odd'">
                  <fo:block>
                    <!-- nothing -->
                  </fo:block>
                </xsl:when>
                <xsl:otherwise>
                  <fo:block font-size="11pt" font-weight="bold">
                    <xsl:text>Page </xsl:text>
                    <fo:page-number/>
                    <xsl:text> </xsl:text>
                    <fo:retrieve-marker retrieve-class-name="chapter.issue.date"
                      retrieve-position="first-including-carryover"
                      retrieve-boundary="page-sequence"/>
                  </fo:block>
                </xsl:otherwise>
              </xsl:choose>
            </fo:table-cell>
            <fo:table-cell text-align="center">
	      <fo:block font-size="11pt" font-weight="bold">
                <fo:retrieve-marker retrieve-class-name="chapter.classification"
                  retrieve-position="first-including-carryover"
                  retrieve-boundary="page-sequence"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <!-- bottom right -->
              <xsl:choose>
                <xsl:when test="$sequence = 'first' or $sequence = 'odd'">
                  <fo:block font-size="11pt" font-weight="bold">
                    <fo:retrieve-marker retrieve-class-name="chapter.issue.date"
                      retrieve-position="first-including-carryover"
                      retrieve-boundary="page-sequence"/>
                    <xsl:text> Page </xsl:text>
                    <fo:page-number/>
                  </fo:block>
                </xsl:when>
                <xsl:otherwise>
                  <fo:block>
                    <!-- nothing -->
                  </fo:block>
                </xsl:otherwise>
              </xsl:choose>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </xsl:variable>
    
    <!-- Really output a footer? -->
    <xsl:choose>
      <xsl:when test="$pageclass='titlepage' and $gentext-key='book'
        and $sequence='first'">
        <!-- no, book titlepages have no footers at all -->
      </xsl:when>
      <xsl:when test="$sequence = 'blank' and $footers.on.blank.pages = 0">
        <!-- no output -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$candidate"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>