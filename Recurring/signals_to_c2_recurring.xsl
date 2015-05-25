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
            <xsl:element name="head" >
                        <xsl:element name="title" >C2 Signal Sender</xsl:element>
                        <xsl:element name="script" >
                            <xsl:attribute name="type">text/javascript</xsl:attribute>
                             
                             <xsl:text>var estTimeZoneShift = </xsl:text>
                             <xsl:value-of select="root/setup/estTimeZoneShift" />
                             <xsl:text>;</xsl:text>
                            
                            <xsl:text>
                                // From strings "2015-05-15" and "01:05:15" in local time to UTC
                                function localDateTimeToUTC(localDate, localTime) {
                                    var localDateTimeUTCUnix = Date.parse(localDate + "T" + localTime);
                                    var dateTime = new Date();
                                    var localTimZoneOffset = 0; dateTime.getTimezoneOffset(); // in minutes, should respect DST
                                    return new Date(localDateTimeUTCUnix + localTimZoneOffset * 60000);
                                }
                                
                                // Date shifted by seconds
                                function shiftedDate(localDate, localTime, shift) {
                                    var date = localDateTimeToUTC(localDate, localTime);
                                    return new Date(date.getTime() + shift * 1000);
                                }

                                // Date shifted by seconds and converted to EST. 
                                // - date is a Date object (UTC)
                                // - ESTTimeZoneShift is in minutes. For example -360 or +360 are valid values (-6 hours and +6 hours)
                                function shiftedDateEST(localDate, localTime, shift, ESTTimeZoneShift) {
                                    var date = shiftedDate(localDate, localTime, shift);
                                    return new Date(date.getTime() + estTimeZoneShift * 60000);
                                }
                                
                                // Format date time for Collective2 "parkuntildatetime" 
                                function formatC2ParkUntil(datetime){
                                    function pad(n) {return (n &lt; 10) ? ("0" + n) : n;} ;     
                                    var result = datetime.getFullYear().toString() +
                                               pad(datetime.getMonth() + 1).toString() + 
                                               pad(datetime.getDate()).toString() +
                                               pad(datetime.getHours()).toString() +
                                               pad(datetime.getMinutes()).toString() +
                                               pad(datetime.getSeconds()).toString();
                                    return result;                                   
                                }
                                
                            </xsl:text>
                         </xsl:element> 
            
            </xsl:element>

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

         <xsl:call-template name="row">
                <xsl:with-param name="pTimes" select="/root/session/repeat"/>
         </xsl:call-template>
 
    </xsl:template>
    
    
    <!-- One signal row -->
    <xsl:template name="row">
        <xsl:param name="pTimes" select="0"/>
        <xsl:element name="tr">
            <xsl:element name="td">
                <xsl:element name="span">
                    
                    <!-- Signal API link -->
                    
                    <!-- Entries - park until in EST time in seconds -->
                        <xsl:element name="script" >
                            <xsl:if test="@action = 'BTO' or @action = 'STO'"> 
                                <xsl:attribute name="type">text/javascript</xsl:attribute>
                                <xsl:text>&#13;&#10;</xsl:text>
                                <xsl:text>var parkUntil = formatC2ParkUntil(shiftedDateEST(&#39;</xsl:text>
                                <xsl:value-of select="/root/session/startDate" />
                                <xsl:text>&#39; ,&#39;</xsl:text>
                                 <xsl:value-of select="/root/session/entryTime" />
                                <xsl:text>&#39; ,</xsl:text>
                                <xsl:value-of select="concat( 84600, '* (',  /root/session/repeat, ' - ', $pTimes, ')' )" />
                                <xsl:text> ));</xsl:text>
                                <xsl:text>&#13;&#10;</xsl:text>
                            </xsl:if>
                            <xsl:if test="@action = 'STC' or @action = 'BTC'"> 
                                <xsl:attribute name="type">text/javascript</xsl:attribute>
                                <xsl:text>&#13;&#10;</xsl:text>
                                <xsl:text>var parkUntil = formatC2ParkUntil(shiftedDateEST(&#39;</xsl:text>
                                <xsl:value-of select="/root/session/startDate" />
                                <xsl:text>&#39; ,&#39;</xsl:text>
                                 <xsl:value-of select="/root/session/exitTime" />
                                <xsl:text>&#39; ,</xsl:text>
                                <xsl:value-of select="concat( 84600, '* (',  /root/session/repeat, ' - ', $pTimes, ')' )" />
                                <xsl:text> ));</xsl:text>
                                <xsl:text>&#13;&#10;</xsl:text>
                            </xsl:if>

                            <xsl:text>var link = &#39;</xsl:text>
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
                                  
                                <xsl:text>&#39; + &#39;&amp;parkuntildatetime=&#39; + parkUntil.toString();</xsl:text>
                                <xsl:text>&#13;&#10;</xsl:text> 

                        <!-- Signal API link target -->
                         <xsl:text>var target = &#39;</xsl:text>
                         <xsl:value-of select="@symbol" />
                         <xsl:value-of select="@action" />
                         <xsl:value-of select="position()"/>                            
                         <xsl:value-of select="$pTimes"/>                            
                         <xsl:text>&#39;;&#13;&#10;</xsl:text>
 
                        <!-- Link text -->
                         <xsl:text>var linkText = &#39;</xsl:text>
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
                        <xsl:text>&#39; ;&#13;&#10;</xsl:text> 
                        <xsl:text>
                         document.write( '&lt;a href="' + link + '" target="' + target +  '"&gt;' + linkText + '&lt;/a&gt;'); 
                        </xsl:text>   
                      </xsl:element>
                    

                    <!-- Entries - park until in local time -->
                    <xsl:if test="@action = 'BTO' or @action = 'STO'"> 
                        <xsl:element name="br" />
                        <xsl:text> Park until your time: </xsl:text>
                        <xsl:element name="script" >
                            <xsl:attribute name="type">text/javascript</xsl:attribute>
                            <xsl:text>document.write( shiftedDate(&#39;</xsl:text>
                            <xsl:value-of select="/root/session/startDate" />
                            <xsl:text>&#39; ,&#39;</xsl:text>
                             <xsl:value-of select="/root/session/entryTime" />
                            <xsl:text>&#39; ,</xsl:text>
                            <xsl:value-of select="concat( 84600, '* (',  /root/session/repeat, ' - ', $pTimes, ')' )" />
                            <xsl:text> ).toLocaleString());</xsl:text>
                         </xsl:element>
                         
                        <!-- Entries - park until in EST -->
                        <xsl:element name="br" />
                        <xsl:text> Park until EST time: </xsl:text>
                        <xsl:element name="script" >
                            <xsl:attribute name="type">text/javascript</xsl:attribute>
                            <xsl:text>document.write( shiftedDateEST(&#39;</xsl:text>
                            <xsl:value-of select="/root/session/startDate" />
                            <xsl:text>&#39; ,&#39;</xsl:text>
                             <xsl:value-of select="/root/session/entryTime" />
                            <xsl:text>&#39; ,</xsl:text>
                            <xsl:value-of select="concat( 84600, '* (',  /root/session/repeat, ' - ', $pTimes, ')' )" />
                            <xsl:text> ).toLocaleString());</xsl:text>
                         </xsl:element>
                    </xsl:if>
                    
                    <!-- Exits - park until in local time-->
                    <xsl:if test="@action = 'STC' or @action = 'BTC'"> 
                        <xsl:element name="br" />
                        <xsl:text> Park until your time: </xsl:text>
                        <xsl:element name="script" >
                            <xsl:attribute name="type">text/javascript</xsl:attribute>
                            <xsl:text>document.write( shiftedDate(&#39;</xsl:text>
                            <xsl:value-of select="/root/session/startDate" />
                            <xsl:text>&#39; ,&#39;</xsl:text>
                             <xsl:value-of select="/root/session/exitTime" />
                            <xsl:text>&#39; ,</xsl:text>
                            <xsl:value-of select="concat( 84600, '* (',  /root/session/repeat, ' - ', $pTimes, ')' )" />
                            <xsl:text> ).toLocaleString());</xsl:text>
                         </xsl:element>
                         
                        <!-- Exits - park until in EST -->
                        <xsl:element name="br" />
                        <xsl:text> Park until EST time: </xsl:text>
                        <xsl:element name="script" >
                            <xsl:attribute name="type">text/javascript</xsl:attribute>
                            <xsl:text>document.write( shiftedDateEST(&#39;</xsl:text>
                            <xsl:value-of select="/root/session/startDate" />
                            <xsl:text>&#39; ,&#39;</xsl:text>
                             <xsl:value-of select="/root/session/exitTime" />
                            <xsl:text>&#39; ,</xsl:text>
                            <xsl:value-of select="concat( 84600, '* (',  /root/session/repeat, ' - ', $pTimes, ')' )" />
                            <xsl:text> ).toLocaleString());</xsl:text>
                         </xsl:element>
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
                  <xsl:value-of select="$pTimes"/>                            
                </xsl:attribute>
                    <xsl:element name="iframe">
                        <xsl:attribute name="name">
                  <xsl:value-of select="@symbol" />
                  <xsl:value-of select="@action" />
                  <xsl:value-of select="position()"/>                            
                  <xsl:value-of select="$pTimes"/>                            
                </xsl:attribute>
                        <xsl:attribute name="width">400</xsl:attribute>
                        <xsl:attribute name="height">60</xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:element> <!-- td -->
        </xsl:element> <!-- tr -->

        <xsl:if test="$pTimes > 1">
            <xsl:call-template name="row">
                 <xsl:with-param name="pTimes" select="$pTimes -1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
