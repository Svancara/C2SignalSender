<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    exclude-result-prefixes="msxsl">

    <xsl:output method="html" encoding="UTF-8" indent="yes" />

    <xsl:variable name="c2SignalsApi">
      <xsl:text>https://www.collective2.com/cgi-perl/signal.mpl?cmd=signal</xsl:text>
    </xsl:variable> 

    <xsl:template match="/">
        <xsl:element name="html">
            <xsl:element name="head" />
            <xsl:element name="title" >C2 Signal Sender</xsl:element>

            <xsl:element name="body">
                <xsl:apply-templates select="root" />
                <xsl:element name="table">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:text>Signal</xsl:text>
                        </xsl:element>
                        <xsl:element name="th">
                            <xsl:text>Response</xsl:text>
                        </xsl:element>
                    </xsl:element>

                    <xsl:apply-templates select="/root/signals" />

                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>


    <xsl:template match="root">
        <xsl:element name="h1">
            <xsl:text>My system id: </xsl:text>
            <xsl:value-of select="/root/setup/systemid" />
        </xsl:element>
    </xsl:template>


    <xsl:template match="signal">

        <xsl:element name="tr">
            <xsl:element name="td">
                <xsl:element name="span">

                    <!-- Signal API link -->
                    <xsl:element name="a">
                        <xsl:attribute name="href">
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
                        </xsl:attribute>

                        <!-- Signal API link target -->
                        <xsl:attribute name="target">
                            <xsl:value-of select="@symbol" />
                            <xsl:value-of select="@action" />
                            <xsl:value-of select="position()"/>                            
                        </xsl:attribute>

                        <!-- Link text -->
                        <xsl:value-of select="@symbol" />
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@action" />
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@quant" />

                        <!-- Market / Limit / Stop -->
                        <xsl:choose>
                            <xsl:when
                                test='not(normalize-space(@limit)) and not(normalize-space(@stop))'>
                                <xsl:text> @ Market</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test='normalize-space(@limit)'>
                                    <xsl:text> @ $</xsl:text>
                                    <xsl:value-of select="@limit" />
                                    <xsl:text> Limit</xsl:text>
                                </xsl:if>
                                <xsl:if test='normalize-space(@stop)'>
                                    <xsl:text> @ $</xsl:text>
                                    <xsl:value-of select="@stop" />
                                    <xsl:text> Stop</xsl:text>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element> <!-- link  -->

                    <!-- Park until -->
                    <xsl:if test='normalize-space(@parkuntildatetime)'>
                        <xsl:element name="br" />
                        <xsl:text> Park until: </xsl:text>
                        <xsl:value-of select="@parkuntildatetime" />
                    </xsl:if>
                </xsl:element> <!-- span -->
            </xsl:element> <!-- td -->

            <!-- Response -->
            <xsl:element name="td">
                <xsl:element name="span">
                    <xsl:attribute name="name">
                  <xsl:value-of select="@symbol" />
                  <xsl:value-of select="@action" />
                  <xsl:value-of select="position()"/>                            
                </xsl:attribute>
                    <xsl:element name="iframe">
                        <xsl:attribute name="name">
                  <xsl:value-of select="@symbol" />
                  <xsl:value-of select="@action" />
                  <xsl:value-of select="position()"/>                            
                </xsl:attribute>
                        <xsl:attribute name="width">400</xsl:attribute>
                        <xsl:attribute name="height">60</xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="br" />
            </xsl:element> <!-- td -->
        </xsl:element> <!-- tr -->
    </xsl:template>
</xsl:stylesheet>
