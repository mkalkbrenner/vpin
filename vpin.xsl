<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">
  <xsl:param name="use.id.as.filename" select="1"/>
  <xsl:param name="admon.graphics" select="1"/>
  <xsl:param name="admon.graphics.path">images/</xsl:param>
  <xsl:param name="navig.graphics" select="1"/>
  <xsl:param name="navig.graphics.path">images/</xsl:param>
  <xsl:param name="navig.graphics.extension">.png</xsl:param>
  <xsl:param name="html.stylesheet">css/featherlight.min.css css/vpin.css</xsl:param>
  <xsl:param name="html.stylesheet.type">text/css</xsl:param>
  <xsl:param name="html.script">js/jquery-1.11.2.min.js js/featherlight.min.js js/vpin.js</xsl:param>
  <xsl:param name="html.script.type">text/javascript</xsl:param>
  <xsl:param name="section.autolabel" select="1"/>
  <xsl:param name="section.label.includes.component.label" select="1"/>
  <xsl:param name="chunk.section.depth" select="2"/>
  <xsl:param name="chunk.first.sections" select="1"/>
  <xsl:template name="user.header.navigation">
    <xsl:apply-templates select="//articleinfo/title" mode="titlepage.mode"/>
  </xsl:template>
  <xsl:template name="user.footer.content">
<hr/>    
<div id="license-footer">
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons Lizenzvertrag" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />Dieses Werk ist lizenziert unter einer <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Namensnennung - Nicht-kommerziell - Weitergabe unter gleichen Bedingungen 4.0 International Lizenz</a>.
</div>
  </xsl:template>
</xsl:stylesheet>
