<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="xml" indent="yes"/>

	<!-- This is an identity template - it copies everything that doesn't match another template -->
	<xsl:template match="@* | node()">
		<xsl:copy>
	    	<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="//listitem">
		<xsl:element name="listitem">
			<xsl:copy-of select=".//para"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="//glossentry">
		<xsl:element name="glossentry">
			<xsl:apply-templates select=".//glossterm"/>
			<xsl:apply-templates select=".//acronym"/>
			<xsl:apply-templates select=".//glossdef"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="glossterm">
		<xsl:element name="glossterm">
			<xsl:element name="para">
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:element>
	</xsl:template>	
	
	<xsl:template match="acronym">
		<xsl:element name="acronym">
			<xsl:element name="para">
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:element>
	</xsl:template>	
	
	<xsl:template match="glossdef">
		<xsl:element name="glossdef">
			<xsl:element name="para">
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:element>
	</xsl:template>	
	


</xsl:stylesheet>
