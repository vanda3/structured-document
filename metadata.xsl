<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:foaf="http://xmlns.com/foaf/0.1/"
xmlns:r="http://www.dcc.fc.up.pt/~vanda/receitas/">
    <xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
				xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
				xmlns:r="http://www.dcc.fc.up.pt/~vanda/receitas/" xml:base="http://www.dcc.fc.up.pt/~vanda/receitas">	
            
			<!-- RDFS -->
			<rdfs:Class rdf:about="Hierarquia">
			</rdfs:Class>
			<rdfs:Class rdf:about="Parte">
				<rdfs:subClassOf rdf:resource="indice"/>
			</rdfs:Class>
			<rdfs:Class rdf:about="Seccao">
				<rdfs:subClassOf rdf:resource="indice"/>
			</rdfs:Class>
			<rdfs:Class rdf:about="Subseccao">
				<rdfs:subClassOf rdf:resource="indice"/>
			</rdfs:Class>
            <rdfs:Class rdf:about="Receita">
				<rdfs:subClassOf rdf:resource="indice"/>
			</rdfs:Class>

            <rdfs:Property rdf:about="nome">
				<rdfs:domain rdf:resource="Hierarquia"/>
				<rdfs:range rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
			</rdfs:Property>

            <rdfs:Property rdf:about="indice">
				<rdfs:domain rdf:resource="Hierarquia"/>
                <rdfs:range rdf:resource="Hierarquia"/>
			</rdfs:Property>

            <!-- RDF -->
            <rdf:Description rdf:about="Livro de Receitas">
				<rdf:type rdf:resource="Colecao"/>
				<xsl:apply-templates select="colecao/cabecalho"/>
				<xsl:apply-templates select="colecao/hierarquia"/>
			</rdf:Description>	
		</rdf:RDF>
	</xsl:template>

	<!-- CABECALHO -->
    <xsl:template match="cabecalho">
		<dc:title>Livro de Receitas</dc:title>
        <dc:description><xsl:value-of select="resumo"/></dc:description>
		<dc:date><xsl:value-of select="data"/></dc:date>
		<xsl:apply-templates select="autor"/>
    </xsl:template>

	<xsl:template match="autor">
		<dc:creator><xsl:value-of select="text()"/></dc:creator>
		<foaf:name><xsl:value-of select="text()"/></foaf:name>
	</xsl:template>

    <!-- TABELA DE CONTEUDOS -->
	<xsl:template match="hierarquia">
		<xsl:apply-templates select="parte"/>
		<xsl:apply-templates select="seccao"/>
		<xsl:apply-templates select="receita"/>
	</xsl:template>

	<xsl:template match="parte">
		<r:indice>
			<r:Parte>
				<r:nome><xsl:value-of select="@titulo"/></r:nome>
				<xsl:apply-templates select="seccao"/>
			</r:Parte>
		</r:indice>
	</xsl:template>

	<xsl:template match="seccao">
		<r:indice>
			<r:Seccao>
				<r:nome><xsl:value-of select="@titulo"/></r:nome>
				<xsl:apply-templates select="subseccao"/>
			</r:Seccao>
		</r:indice>
	</xsl:template>

	<xsl:template match="subseccao">
		<r:indice>
			<r:Subseccao>
				<r:nome><xsl:value-of select="@titulo"/></r:nome>
				<xsl:apply-templates select="receita"/>
			</r:Subseccao>
		</r:indice>
	</xsl:template>

	<xsl:template match="receita">
		<r:indice>
			<r:Receita>
				<r:nome><xsl:value-of select="@nome"/></r:nome>
			</r:Receita>
		</r:indice>
	</xsl:template>
	
	<xsl:apply-templates/>
</xsl:stylesheet>