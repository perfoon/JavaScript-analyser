<?xml version="1.0" encoding="utf-8"?>
<xsl:transform
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
	exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes" />
  
  <xsl:template match="/">
	<results>
		<elementCount>
		  <count name="global_functions">
			<xsl:value-of select="count(/PROGRAM/FUNCTION)" /> 
		  </count>
		  <count name="global_variables">
			<xsl:value-of select="count(/PROGRAM/VAR)" />
		  </count>
		  <count name="total_variables">
			<xsl:value-of select="count(.//VAR)" />
		  </count>
		  <xsl:call-template name="syntax_errors" />
		</elementCount>
		
		<functions>
			<xsl:for-each select="/PROGRAM/FUNCTION">
				<function name="{IDENTIFIER/@value}">
					<count name="variables">
						<xsl:value-of select="count(.//VAR)" />
					</count>
					<xsl:call-template name="cyclomatic_complexity" />
					<xsl:call-template name="strict_cyclomatic_complexity" />
					<xsl:call-template name="depth_of_conditional_nesting" />
					<xsl:call-template name="depth_of_looping" />
					
					<xsl:call-template name="unoptimized_loops" />
				</function>
			</xsl:for-each>
		</functions>
	</results>
  </xsl:template>
  
  <xsl:template name="cyclomatic_complexity">
	<xsl:variable name="branchings" select="count(.//IF | .//CASE |
		.//FOR | .//DOWHILE | .//WHILE | .//CATCH | .//CONDITONALOPERATOR)" />
	<xsl:variable name="cyclomatic_complexity" select="$branchings+1"/>
	
	<metric name="cyclomatic_complexity">
		<xsl:attribute name="result">
			<xsl:value-of select="$cyclomatic_complexity" />
		</xsl:attribute>
		<xsl:attribute name="risk_level">
			<xsl:choose>
				<xsl:when test="$cyclomatic_complexity &gt; 50">4</xsl:when>
				<xsl:when test="$cyclomatic_complexity &gt; 20">3</xsl:when>
				<xsl:when test="$cyclomatic_complexity &gt; 10">2</xsl:when>
				<xsl:when test="$cyclomatic_complexity &gt; 5">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</metric>
  </xsl:template>
  
  <xsl:template name="strict_cyclomatic_complexity">
	<xsl:variable name="branchings" select="count(.//IF | .//CASE |
		.//FOR | .//DOWHILE | .//WHILE | .//CATCH | .//CONDITONALOPERATOR)" />
	<xsl:variable name="logic_branchings" select="count(.//OPERATOR[@value='||'] | 
		.//OPERATOR[@value='&amp;&amp;'])" />
	<xsl:variable name="strict_cyclomatic_complexity" select="$branchings+$logic_branchings+1"/>
	
	<metric name="strict_cyclomatic_complexity">
		<xsl:attribute name="result">
			<xsl:value-of select="$strict_cyclomatic_complexity" />
		</xsl:attribute>
		<xsl:attribute name="risk_level">
			<xsl:choose>
				<xsl:when test="$strict_cyclomatic_complexity &gt; 50">4</xsl:when>
				<xsl:when test="$strict_cyclomatic_complexity &gt; 20">3</xsl:when>
				<xsl:when test="$strict_cyclomatic_complexity &gt; 10">2</xsl:when>
				<xsl:when test="$strict_cyclomatic_complexity &gt; 5">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</metric>
  </xsl:template>
  
  <xsl:template name="depth_of_conditional_nesting">
	<xsl:variable name="depth_of_conditional_nesting" select="count(.//*[count(child::*) = 0]
		/ancestor::*[IF|CASE|FOR|DOWHILE|WHILE|CATCH|CONDITIONALOPERATOR])" />
	
	<metric name="depth_of_conditional_nesting">
		<xsl:attribute name="result">
			<xsl:value-of select="$depth_of_conditional_nesting" />
		</xsl:attribute>
		<xsl:attribute name="risk_level">
			<xsl:choose>
				<xsl:when test="$depth_of_conditional_nesting &gt; 5">4</xsl:when>
				<xsl:when test="$depth_of_conditional_nesting &gt; 4">2</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</metric>
  </xsl:template>
  
  <xsl:template name="depth_of_looping">
	<xsl:variable name="depth_of_looping" select="count(.//*[count(child::*) = 0]
		/ancestor::*[FOR|DOWHILE|WHILE])" />
	
	<metric name="depth_of_looping">
		<xsl:attribute name="result">
			<xsl:value-of select="$depth_of_looping" />
		</xsl:attribute>
		<xsl:attribute name="risk_level">
			<xsl:choose>
				<xsl:when test="$depth_of_looping &gt; 2">4</xsl:when>
				<xsl:when test="$depth_of_looping &gt; 1">2</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</metric>
  </xsl:template>
  
  <xsl:template name="unoptimized_loops">
	<xsl:for-each select=".//FOR">
		<xsl:if test="count(./CONDITION/OPERATOR//PROPERTY)">
			<badstyle name="unoptimized_loop">
				<xsl:variable name="loop_type" select="name(.)" />
				<xsl:variable name="property_name" select="./CONDITION/OPERATOR//PROPERTY/IDENTIFIER/@value" />
			
				<xsl:attribute name="loop_type">
					<xsl:value-of select="$loop_type" />
				</xsl:attribute>
				<xsl:attribute name="property_name">
					<xsl:value-of select="$property_name" />
				</xsl:attribute>
				<xsl:attribute name="description">Unoptimized loop <xsl:value-of select="$loop_type" />. Create additional variable for <xsl:value-of select="$property_name" /> value in pre-loop statement.</xsl:attribute>
			</badstyle>
		</xsl:if>
	</xsl:for-each>
	<xsl:for-each select=".//DOWHILE | .//WHILE">
		<xsl:if test="count(./OPERATOR//PROPERTY)">
			<xsl:variable name="loop_type" select="name(.)" />
			<xsl:variable name="property_name" select="./OPERATOR//PROPERTY/IDENTIFIER/@value" />
	
			<badstyle name="unoptimized_loop" >
				<xsl:attribute name="loop_type">
					<xsl:value-of select="$loop_type" />
				</xsl:attribute>
				<xsl:attribute name="property_name">
					<xsl:value-of select="$property_name" />
				</xsl:attribute>
				<xsl:attribute name="description">Unoptimized loop <xsl:value-of select="$loop_type" />. Create additional variable for <xsl:value-of select="$property_name" /> value in pre-loop statement.</xsl:attribute>
			</badstyle>
		</xsl:if>
	</xsl:for-each>
  </xsl:template>
  
  <xsl:template name="syntax_errors">
	<xsl:for-each select=".//ERROR">
		<syntaxerror>
			<xsl:attribute name="name">
				<xsl:value-of select="@value" />
			</xsl:attribute>
			<xsl:attribute name="parentfunction">
				<xsl:value-of select="ancestor::*[1]" />
			</xsl:attribute>
		</syntaxerror>
	</xsl:for-each>
  </xsl:template>
  
</xsl:transform>

