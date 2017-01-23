<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
        exclude-result-prefixes="dc oai_dc">
    <xsl:template match="oai_dc:dc">
      <r>
        <xsl:apply-templates/>
      </r>
    </xsl:template>
    <xsl:template match="dc:*">
        <xsl:element name="{substring(local-name(.),1,1)}">
            <xsl:value-of select="."/>
       </xsl:element>
    </xsl:template>
</xsl:stylesheet>
