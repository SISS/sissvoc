<%@ page import="java.util.*" %>
<%!
	 String serviceTitle = "Open Geospatial Consortium definitions";
	 String serviceName = "api/ogc-def";
	 String title = "SISSVoc - OGC def";
	 String description = "definitions maintained by Open Geospatial Consortium";
	 String exampleLabel = "East";
	 String exampleURI = "http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_DiscreteCoverageObservation";

	 String conceptSchemes = serviceName+"/conceptscheme";
	 String conceptCollections = serviceName+"/collection";
	 String concepts = serviceName+"/concept";
	 String conceptResource = serviceName+"/resource";

	 String sparqlEndPoint = "http://services-test.auscope.org/openrdf-sesame/repositories/ogc-def";
	 
	 String languageChoice = " <option value='en' selected='selected'>en</option>	";

	 //links
	 String related = " <br/><a href='http://xmlns.com/foaf/0.1/'>http://xmlns.com/foaf/0.1/</a>	<br/><a href='http://www.w3.org/2004/02/skos/core'>http://www.w3.org/2004/02/skos/core</a>	<br/><a href='http://www.w3.org/2002/07/owl'>http://www.w3.org/2002/07/owl</a>	";

%>

<html>
	
	<head>
	</head>
	<title><%=title%></title>

	<link rel="stylesheet" href="sissvoc.css" type="text/css" media="all" />  

	<script type="text/javascript">

	function toggle(id) {
   	var div = document.getElementById( id );
	   div.className = (div.className == "show" ? "hide" : "show");
	}

	function go_to(id) {
		window.location = document.getElementById(id).value;
	}

	function navigateTo(conceptSchemeUrl, conceptCollectionUrl, conceptUrl, conceptResourceUrl) {
		applyOptions(conceptSchemeUrl, conceptCollectionUrl, conceptUrl, conceptResourceUrl);
		window.location = getAllResultOptions(conceptUrl);
	}

	function applyOptions(conceptSchemeUrl, conceptCollectionUrl, conceptUrl, conceptResourceUrl) {
		document.getElementById('conceptScheme_url').value = updateAllConceptUrls(conceptSchemeUrl);
		document.getElementById('conceptCollection_url').value = updateAllConceptUrls(conceptCollectionUrl);
		document.getElementById('concept_url').value = updateAllConceptUrls(conceptUrl);

		document.getElementById('conceptLabel_url').href = getAllResultOptions(conceptUrl);
	}
	
	//updates url for "All Concept Scehemes", "All Concept Collections" and "All Concepts"
	function updateAllConceptUrls(url) {
		var lang = getLang();
		var format = getFormat();
		var metadata = getMetadata();
		var pageSize = getPageSize();
		if(metadata !='') metadata = '&'+metadata;
		return url + format +"?"+lang+"&"+pageSize+metadata;
	}

	//constructs getResourceByUri url
	function updateUrl(serviceName) {		
		var resource = getResource();
		var lang = getLang();
		var format = getFormat();
		var relationship = getRelationship();
		var metadata = getMetadata();

		if(metadata !='') metadata = '&'+metadata;
		if(relationship == "") relationship = "resource";
		else relationship = "concept/"+relationship;

		var url = serviceName + "/"+ relationship + format +"?uri="+resource +"&"+lang+metadata;

		window.location = url
	}

	//constructs getConceptByLabel url
	function getAllResultOptions(url) {
		var label = getLabel();
		var relationship = getRelationship();
		var lang = getLang();
		var format = getFormat();
		var pageSize = getPageSize();
		var metadata = getMetadata();

		if(metadata !='') metadata = '&'+metadata;

		var prefix = "";
		var index = url.indexOf("?");

		if(index == -1) //check for other fitlers
			prefix = "?";
		else prefix = "&";

		if(relationship != "") {
			if(index == -1)  // no filters added yet just append relationship
				url = url + "/" + relationship;
			else {
				url = url.substring(0,index) + "/" + relationship + url.substring(index,url.length)
				index = url.indexOf("?"); // have to find the index after appending text to url.
			}
		}

		var resourceIndex = url.indexOf("uri");
		var resource = "";

		if(resourceIndex != -1) {
			resource = url.substring(resourceIndex,url.length);
			pageSize = ""; //_pageSize can only be used with a list endpoint.
			label = "?"; //label not used for resource
		}
		else {
			pageSize = "&" + pageSize;
			label = "?"+label;
		}

		if(index!=-1) url = url.substring(0,index) + format + label +"&"+ resource + prefix+lang+pageSize+metadata;	
		else url = url+format+label+"&"+lang+pageSize+metadata

		return url;
	}

	function getResource() {
		return document.forms['landingPage'].elements['resource'].value;
	}

	function getLabel() {
		var labelMatch = getLabelMatch();
		
		if(labelMatch == "includes")	labelMatch = "labelcontains=";
		else if(labelMatch == "matches") labelMatch = "anylabel=";
		
		var label = document.forms['landingPage'].elements['label'].value;
		if(label) label = labelMatch+label;
		else label = "";
		return label;
	}

	function getLabelMatch() {
		var form = document.forms['landingPage'];
		var labelMatch = "";

		for (var i = 0; i < form.labelMatch.length; i++) {
			if (form.labelMatch[i].checked) {
   	   	break;
	      }
		}
		if(i<form.labelMatch.length) 
			labelMatch = form.labelMatch[i].value;
		
		return labelMatch;
	}

	function getRelationship() {
		var form = document.forms['landingPage'];
		var relationship = "";

		for (var i = 0; i < form.relationship.length; i++) {
			if (form.relationship[i].checked) {
   	   	break;
	      }
		}
		if(i<form.relationship.length) 
			relationship = form.relationship[i].value;
		
		return relationship;
	}

	function getLang() {
		var form = document.forms['landingPage'].elements['language'];
		return "_lang="+form.options[form.selectedIndex].value;
	}

	function getFormat() {
		var form = document.forms['landingPage'].elements['format'];
		return "."+form.options[form.selectedIndex].value;
	}

	function getPageSize() {
		var form = document.forms['landingPage'].elements['pagesize'];
		return "_pageSize="+form.options[form.selectedIndex].value;
	}

	function getMetadata() {
		var form = document.forms['landingPage'];
		var metadata = "";
		for (var i = 0; i < form.metadata.length; i++) {
			if (form.metadata[i].checked) {
				break;
			}
		}
		if(i<form.metadata.length) {
			var metadataValue = form.metadata[i].value;
			if(metadataValue == 'yes') 
				metadata = "_metadata=all";			
		}
		return metadata;		
	}

	</script>


	<body>
	<form id="landingPage">
		<h2><%= serviceTitle %></h2>
		This service provides a <a href="https://www.seegrid.csiro.au/wiki/Siss/SISSvoc3Spec">SISSVoc</a> interface to an RDF representation of <%=description%>
		<br>
		<br>
			<legend>Queries</legend>
			<input type="button" class="styled-buttons" value="All Concept Schemes" onclick="go_to('conceptScheme_url');")><input type="hidden" id="conceptScheme_url" value="<%=conceptSchemes%>" />&nbsp
			<input type="button" class="styled-buttons" value="All Concept Collections" onclick="go_to('conceptCollection_url');"><input type="hidden" id="conceptCollection_url" value="<%=conceptCollections%>"/>&nbsp
			<input type="button" class="styled-buttons" value="All Concepts" onclick="go_to('concept_url')";><input type="hidden" id="concept_url" value="<%=concepts%>"/>&nbsp
			<br>
			<br>
			<a id="conceptLabel_url">Concept whose label</a><input type="radio" name="labelMatch" value="matches" checked="true" />matches <input type="radio" name="labelMatch" value="includes" />includes the text: <input type="text" size="60" name="label" value="<%= exampleLabel %>"/> <input type="button" class="styled-buttons2" value="Go" onclick="navigateTo('<%=conceptSchemes%>','<%=conceptCollections%>','<%=concepts%>','<%=conceptResource%>');"/>
			<br>
			<br>
			<a id="conceptResource_url">Description of</a>: <input type="text" size="92" name="resource" value="<%= exampleURI %>"/> <input type="button" class="styled-buttons2" value="Go" onclick="updateUrl('<%=serviceName%>');"/>	
			<br>
			<br>
			<div STYLE="background-color:#ECF3FF; padding:5px"> 
			<legend>Result Options</legend>
					<a>Concepts: </a>						
					<input type="radio" name="relationship" value="narrowerTransitive" />narrowerTransitive
					<input type="radio" name="relationship" value="narrower" />narrower
					<input type="radio" name="relationship" value="" checked="true" />exact
					<input type="radio" name="relationship" value="broader" />broader
					<input type="radio" name="relationship" value="broaderTransitive" />broaderTransitive
					<br>
					<br>
					<div class="styled-select">
					<a>Report result in</a>
					<select name="language">
						<%= languageChoice %>
					</select>
					<a>Report result in</a>
					<select name="format">
						<option value="html" selected="selected">HTML</option> 
						<option value="rdf" >RDF/XML</option>
						<option value="ttl" >Turtle</option>
						<option value="json" >JSON</option>
						<option value="xml" >XML</option>
					</select>
					<a>Page size</a>
					<select name="pagesize">
						<option value="10" selected="selected">10</option>
						<option value="20">20</option>
						<option value="50">50</option>
					</select>
					</div>
					<br>
					<table border="0" cellspacing="0" cellpadding="0" class="normal">
						<tr>
							<td>Full Metadata <input type="radio" name="metadata" value="no" checked="true" /> No	<input type="radio" name="metadata" value="yes"/> Yes</td>
							<td width="500" align="right"><input type="button" class="styled-buttons2" value="Apply" onclick="applyOptions('<%=conceptSchemes%>','<%=conceptCollections%>','<%=concepts%>','<%=conceptResource%>');"/></td>
						</tr>
					</table>
			</div>
	<br>
	<br>
	<br>
	<h2>SPARQL end-point</h2>
	<%= sparqlEndPoint %>
	<h2>Related ontologies:</h2>
	<%= related %>

</body>

</html>
