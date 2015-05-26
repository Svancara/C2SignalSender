<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    exclude-result-prefixes="msxsl">

    <xsl:output method="text" encoding="ascii" />

    <xsl:variable name="c2SignalsApi">
      <xsl:text>https://www.collective2.com/cgi-perl/signal.mpl?cmd=signal</xsl:text>
    </xsl:variable> 

    <xsl:template match="/">
           <xsl:apply-templates select="root" />
           <xsl:apply-templates select="/root/signals" />
    </xsl:template>


    <xsl:template match="root">
        <xsl:text>rem This set of commands is generated from signals_to_c2.xml using signals_to_c2_curl.xsl</xsl:text>
    </xsl:template>

    <xsl:template match="signal">

        <xsl:value-of select="/root/setup/curlpath" />

        <!-- space and double quotes -->
        <xsl:text> &#34;</xsl:text>

        <!-- C2 Signal API URL -->
        <xsl:value-of select="$c2SignalsApi" />
        <xsl:text>&amp;systemid=</xsl:text>
        <xsl:value-of select="/root/setup/systemid" />
        <xsl:text>&amp;pw=</xsl:text>
        <xsl:value-of select="/root/setup/password" />
        <xsl:text>&amp;symbol=</xsl:text>
        <xsl:value-of select="@symbol" />
        <xsl:text>&amp;action=</xsl:text>
        <xsl:value-of select="@action" />
        <xsl:text>&amp;quant=</xsl:text>
        <xsl:value-of select="@quant" />
        <xsl:text>&amp;instrument=</xsl:text>
        <xsl:value-of select="@instrument" />
      
        <!-- Limit if not empty -->
        <xsl:if test='normalize-space(@limit)'>
          <xsl:text>&amp;limit=</xsl:text>
          <xsl:value-of select="@limit" />
        </xsl:if>

        <!-- Stop if not empty -->
        <xsl:if test='normalize-space(@stop)'>
          <xsl:text>&amp;stop=</xsl:text>
          <xsl:value-of select="@stop" />
        </xsl:if>

         <!-- ParkUntil if not empty -->
        <xsl:if test='normalize-space(@parkuntildatetime)'>
          <xsl:text>&amp;parkuntildatetime=</xsl:text>
          <xsl:value-of select="translate(translate(translate(@parkuntildatetime,':',''),'-',''),' ','')" />
        </xsl:if>
        
        <!-- double quotes -->
        <xsl:text>&#34;</xsl:text>
        
        <!-- Responses to files like "c2response_symbol_action_1.txt" -->
        <xsl:text> -o c2_response_</xsl:text>
        <xsl:value-of select="@symbol" />
        <xsl:text>_</xsl:text>
        <xsl:value-of select="@action" />
        <xsl:text>_</xsl:text>
        <xsl:value-of select="position()"/>  
        <xsl:text>.txt</xsl:text>
 
        
    </xsl:template>
</xsl:stylesheet>
