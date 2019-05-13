<?xml version="1.0" encoding="UTF-8"?>

<!-- Documento XML para CSS
	 Vanda Filipa Bernardo Azevedo
	 201305778 -->
	 
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8"/>
    <xsl:key name="receita" match="//*[local-name()='receita']" use="@id"/>
    <xsl:key name="ingrediente" match="//*[local-name()='ingrediente']" use="@id"/>
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE HTML&gt;</xsl:text>
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="receitas.css"/>
                <title>                    Livro de Receitas                </title>
            </head>
            <body>
                <xsl:apply-templates select="//*[local-name()='cabecalho']"/>
                
                <!--  TABELA DE CONTEUDOS -->
                <div class="tabela">
                    <h3 class="menu">MENU</h3>
                    <div class="tab_list">
                        <ul>
                            <xsl:if test="//hierarquia/parte">
                                <xsl:for-each select="//hierarquia/parte">
                                    <li>
                                        <a href="#{@id}">
                                            <xsl:value-of select="@titulo"/>
                                        </a>
                                    </li>
                                    <ul>
                                        <xsl:for-each select="seccao">
                                            <li>
                                                <a href="#{@id}">
                                                    <xsl:value-of select="@titulo"/>
                                                </a>
                                            </li>
                                            <ul>
                                                <xsl:for-each select="subseccao">
                                                    <li>
                                                        <a href="#{@id}">
                                                            <xsl:value-of select="@titulo"/>
                                                        </a>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:if test="//*[local-name()='hierarquia']/*[local-name()='seccao']">
                                <xsl:for-each select="//*[local-name()='hierarquia']/*[local-name()='seccao']">
                                    <li>
                                        <a href="#{@id}">
                                            <xsl:value-of select="@titulo"/>
                                        </a>
                                    </li>
                                    <ul>
                                        <xsl:for-each select="*[local-name()='subseccao']">
                                            <li>
                                                <a href="#{@id}" class="tab_subseccao">
                                                    <xsl:value-of select="@titulo"/>
                                                </a>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:for-each>
                            </xsl:if>
                        </ul>
                    </div>
                </div>
                <xsl:apply-templates select="//*[local-name()='hierarquia']"/>
                
                <!-- VALIDACAO -->
                <!-- Seleccionar todos IDs de ingredientes e garantir que foram todos referidos. -->
                <xsl:if test="//*[local-name()='ingrediente']/@id[not(.=(//*[local-name()='ingrediente_ref']/@id))]">
                    <xsl:message terminate="no">
                        <xsl:text>Os ingredientes </xsl:text>
                        <xsl:for-each select="//*[local-name()='ingrediente']/@id[not(.=(//*[local-name()='ingrediente_ref']/@id))]">
                            <xsl:value-of select="key('ingrediente',.)/@nome"/>
                            <xsl:if test="position() &lt; last()-1">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:if test="position() = last()-1">
                                <xsl:text> e </xsl:text>
                            </xsl:if>
                            <xsl:if test="position() = last()">
                                <xsl:text></xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:text> foram declarados mas nao referidos!</xsl:text>
                    </xsl:message>
                </xsl:if>
                <!-- Verificar se alguma ingrediente_ref referencia receita -->
                <xsl:if test="//*[local-name()='ingrediente_ref']/@id = //*[local-name()='receita']/@id">
                    <xsl:message terminate="no">
                        <xsl:text>Algumas referencias a ingredientes referenciam receitas!</xsl:text>
                    </xsl:message>
                </xsl:if>
                <!-- Verificar se alguma receita_ref referencia ingrediente -->
                <xsl:if test="//*[local-name()='receita_ref']/@id = //*[local-name()='ingrediente']/@id">
                    <xsl:message terminate="no">
                        <xsl:text>Algumas referencias a receitas referenciam ingredientes!</xsl:text>
                    </xsl:message>
                </xsl:if>
            </body>
        </html>
    </xsl:template>
    
    <!-- CABECALHO -->
    <xsl:template match="//*[local-name()='cabecalho']">
        <div class="head">
            <div>
                <p class="title">
                    <xsl:value-of select="*[local-name()='titulo']/text()"/>
                </p>
            </div>
            <div class="inside_head">
                <div class="resumo">
                    <xsl:value-of select="*[local-name()='resumo']/text()"/>
                </div>
                <div>       Autores: 		                                                                                                                                                                                                                                                                                                                                                    
                    <xsl:for-each select="*[local-name()='autor']">
                        <xsl:sort select="text()"/>
                        <xsl:value-of select="text()"/>
                        <xsl:if test="position() &lt; last()-1">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <xsl:if test="position() = last()-1">
                            <xsl:text> e </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </div>
                <div>		Data:                  			                    
                    <xsl:choose>
                        <xsl:when test="//*[local-name()='data']/*[local-name()='ano']">
                            <xsl:if test="//*[local-name()='dia']">
                                <xsl:value-of select="//*[local-name()='dia']"/>
                                <xsl:text> de </xsl:text>
                            </xsl:if>
                            <xsl:if test="//*[local-name()='mes']">
                                <xsl:value-of select="//*[local-name()='mes']"/>
                            </xsl:if>
                            <xsl:if test="//*[local-name()='ano']">
                                <xsl:text> de </xsl:text>
                                <xsl:value-of select="//*[local-name()='ano']"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="//*[local-name()='data']/text()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </div>
        </div>
    </xsl:template>
    
    <!-- COLECAO -->
    <xsl:template match="//*[local-name()='hierarquia']">
        <!-- PARTES -->
        <xsl:for-each select="*[local-name()='parte']">
            <div ID="{@id}">
                <div class="parte">
                    <h1 class="s_titulo">
                        <xsl:value-of select="@titulo"/>
                    </h1>
                    <div class="info_parte">
                        <xsl:if test="@intro">
                            <xsl:value-of select="@intro"/>
                        </xsl:if>
                        <xsl:if test="@ilustracao">
                            <br/>
                            <img src="{@ilustracao}" class="img"/>
                        </xsl:if>
                    </div>
                </div>
                <xsl:apply-templates select="*[local-name()='seccao']"/>
            </div>
        </xsl:for-each>
        <xsl:apply-templates select="*[local-name()='seccao']"/>
    </xsl:template>
    
    <!-- SECCAO -->
    <xsl:template match="*[local-name()='seccao']">
        <div ID="{@id}">
            <div class="seccao">
                <h2 class="s_titulo">
                    <xsl:value-of select="@titulo"/>
                </h2>
                <div class="info_seccao">
                    <xsl:if test="@intro">
                        <xsl:value-of select="@intro"/>
                    </xsl:if>
                    <xsl:if test="@ilustracao">
                        <br/>
                        <img src="{@ilustracao}" class="img"/>
                    </xsl:if>
                </div>
            </div>
            <!-- SUBSECCAO -->
            <xsl:for-each select="*[local-name()='subseccao']">
                <div ID="{@id}">
                    <div class="subseccao">
                        <h3 class="ss_titulo">
                            <xsl:value-of select="@titulo"/>
                        </h3>
                        <div class="info_subseccao">
                            <xsl:if test="@intro">
                                <xsl:value-of select="@intro"/>
                            </xsl:if>
                            <xsl:if test="@ilustracao">
                                <br/>
                                <img src="{@ilustracao}" class="img"/>
                            </xsl:if>
                        </div>
                        <br/>
                    </div>
                    <xsl:apply-templates select="*[local-name()='receita']"/>
                </div>
            </xsl:for-each>
            <hr></hr>
        </div>
    </xsl:template>
    
    <!-- RECEITA -->
    <xsl:template match="*[local-name()='receita']">
        <div ID="{@id}">
            <b>
                <h4 class="nome_rec">
                    <xsl:value-of select="@nome"/>
                </h4>
            </b>
            <div class="def_receita">
                <ul>
                    <xsl:if test="@categoria">
                        <li>
                            <p>Categoria:                                                     
                                <xsl:value-of select="@categoria"/>
                            </p>
                        </li>
                    </xsl:if>
                    <xsl:if test="@dificuldade">
                        <li>
                            <p>Dificuldade:                                                     
                                <xsl:value-of select="@dificuldade"/>
                            </p>
                        </li>
                    </xsl:if>
                    <xsl:if test="@tempo">
                        <li>
                            <p>Tempo:                                                     
                                <xsl:value-of select="@tempo"/>
                                <xsl:text> minutos</xsl:text>
                            </p>
                        </li>
                    </xsl:if>
                    <xsl:if test="@custo">
                        <li>
                            <p>Custo:                                                     
                                <xsl:value-of select="@custo"/>
                            </p>
                        </li>
                    </xsl:if>
                    <xsl:if test="@calorias">
                        <li>
                            <p>Calorias:                                                     
                                <xsl:value-of select="@calorias"/>
                            </p>
                        </li>
                    </xsl:if>
                    <xsl:if test="@dose">
                        <li>
                            <p>Dose:                                                     
                                <xsl:value-of select="@dose"/> pessoas                                            
                            </p>
                        </li>
                    </xsl:if>
                </ul>
                <xsl:if test="@ilustracao">
                    <xsl:value-of select="@ilustracao"/>
                    <br/>
                </xsl:if>
                <div>
                    <b>
                        <h4 class="ingredientes">Ingredientes</h4>
                    </b>
                    <ul>
                        <xsl:for-each select="*[local-name()='ingrediente']">
                            <li>
                                <xsl:value-of select="@nome"/>
                                <xsl:text> (</xsl:text>
                                <xsl:value-of select="@quantidade"/>
                                <xsl:text></xsl:text>
                                <xsl:value-of select="@unidade"/>
                                <xsl:text>)</xsl:text>
                            </li>
                        </xsl:for-each>
                    </ul>
                </div>
                <div>
                    <xsl:apply-templates select="*[local-name()='descricao']"/>
                </div>
                <br/>
            </div>
        </div>
    </xsl:template>
    
    <!-- DESCRICAO -->
    <xsl:template match="*[local-name()='descricao']">
        <div class="prep">
            <b>
                <h4>Preparação</h4>
            </b>
            <xsl:choose>
                <xsl:when test="*[local-name()='passo']">
                    <ol>
                        <xsl:for-each select="*[local-name()='passo']">
                            <li>
                                <xsl:apply-templates/>
                                <xsl:if test="@ilustracao">
                                    <br/>
                                    <img src="{@ilustracao}" class="img"/>
                                </xsl:if>
                                <br/>
                            </li>
                        </xsl:for-each>
                    </ol>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <!-- INGREDIENTE_REF -->
    <xsl:template match="*[local-name()='ingrediente_ref']">
        <b>
            <xsl:value-of select="key('ingrediente', @id)/@nome"/>
        </b>
    </xsl:template>
    
    <!-- RECEITA_REF -->
    <xsl:template match="*[local-name()='receita_ref']">
        <b>
            <a href="#{@id}">
                <xsl:value-of select="key('receita', @id)/@nome"/>
            </a>
        </b>
    </xsl:template>
</xsl:stylesheet>