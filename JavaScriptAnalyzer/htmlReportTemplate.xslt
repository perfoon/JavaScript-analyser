<?xml version="1.0" encoding="utf-8"?>
<xsl:transform
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
	exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes" />
 
<xsl:template match="/">
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
			<title>JavaScript analyzer report</title>
			<style media="screen" type="text/css">
				body {
					color: #05154d;
				}
				#wrapper {
					border: solid 1px #2e4375;
					padding-left: 30px;
					padding-right: 20px;
					padding-bottom: 20px;
				}
				h1 {
					line-height: 32px;
					font-size: 22px;
				}
				h2 {
					line-height: 12px;
					font-size: 18px;
				}
				.red {
					color: red;
				}
				table
				{
					border-collapse:collapse;
				}
				table, th, td
				{
					padding: 5px;
				}
				.badstyleheader
				{
					padding: 1px;
					text-align: right;
				}
				.badstyle
				{
					color: red;
					padding: 1px;
					text-align: left;
				}
				th
				{
					border-bottom: 2px solid #153073;
					padding: 5px;
				}
				td
				{
					border-bottom: 1px solid #7a96b0;
					text-align:center;
				}
				.risk1
				{
					background-color: #e3fea5;
				}
				.risk2
				{
					background-color: #f7fc2c;
				}
				.risk3
				{
					background-color: #ffac11;
				}
				.risk4
				{
					background-color: #fe510a;
				}
				#globalInfo label
				{
					display: inline-block;
					width: 120px;
					text-align: right;
				}
				#globalInfo p
				{
					margin-top: 5px;
					margin-top: 0;
					display: inline-block;
					text-align: left;
				}
			</style>
		</head>
		<body>
		<div id="wrapper">
			<div id="header">
				<h1>JavaScript analyzer report</h1>
			</div>
			<h2>Overview</h2>
			<div id="globalInfo">
				<xsl:for-each select="//results/elementCount/count">
					<label><xsl:value-of select="translate(@name,'_',' ')" />:</label>
					<p><xsl:value-of select="." /></p><br/>
				</xsl:for-each>
				<xsl:for-each select="//results/elementCount/syntaxerror">
					<label>syntax error: </label>
					<p class="red">
						<xsl:value-of select="@name" />
					</p>
					
				</xsl:for-each>
			</div>
			<h2>Functions</h2>
			
			<table>
				<tr>
					<th>function name</th>
					<xsl:for-each select="//results/functions/function[1]/count">
						<th><xsl:value-of select="translate(@name,'_',' ')" /></th>
					</xsl:for-each>
					<xsl:for-each select="//results/functions/function[1]/metric">
						<th><xsl:value-of select="translate(@name,'_',' ')" /></th>
					</xsl:for-each>
				</tr>
				
				<xsl:for-each select="//results/functions/function">
					<tr>
						<td>
							<xsl:attribute name="rowspan">
								<xsl:value-of select="1+count(badstyle)" />
							</xsl:attribute>
							<xsl:value-of select="@name" />
						</td>
						<xsl:for-each select="count">
							<td >
								<xsl:value-of select="." />
							</td>
						</xsl:for-each>	
						<xsl:for-each select="metric">
							<td >
							<xsl:attribute name="class">
								risk<xsl:value-of select="@risk_level" />
							</xsl:attribute>
								<xsl:value-of select="@result" />
							</td>
						</xsl:for-each>	
					</tr>
					
					<xsl:for-each select="badstyle">
						<tr>
							<td class="badstyleheader">Bad style:</td>
							<td class="badstyle">
								<xsl:attribute name="colspan">
									<xsl:value-of select="count(parent::*/metric) + count(parent::*/count) - 1" /> />
								</xsl:attribute>
								<xsl:value-of select="@description" />
							</td>
						</tr>
					</xsl:for-each>	


				</xsl:for-each>	
			</table>
		</div>
		<div id="footer"></div>
		</body>
	</html>
</xsl:template>
	
</xsl:transform>

