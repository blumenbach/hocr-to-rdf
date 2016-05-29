# TEI TO RDF

## Premise:
* TEI-XML has many limitations in the representation of the "enriched text".  
* The XML element encapsulates a node's properties as attributes, but (unlike RDF) XML attributes (as properties) 
cannot be inherited by its descendents. 
* There are no classes in XML.  
* The grouping of parent-child elements in XML is an non-transitive hierarchy that does not allow inference.  
* Querying XML for the relationships of these nodes is done with XQuery, which requires explicit path referencing.  
* Transitive relationships cannot be inferred with XQuery, unlike SPARQL.  
* The sequences that represent a text are not defined by the XML, and still must be inferred by the reader.
* Dereferencing an element in the XML from its context requires either an xpath or xpointer fragment designation.
* TEI-XML cannot express everything that needs to be said about an element.  It has severe spatial and semantic constraints.

## RDF Structured Text Concept:
* An RDF structured text is a list of lists (where a list is defined as a ordered sequence) with the character being its base unit.  
* A word is a list of characters, a line is a list of words, a division is a list of lines, a chapter is a list of divisions.  
* A page unit is defined by a list of lines first, because the delimitation of a page is not necessarily constrained by the division.
* The line is also a key externally referenceable resource

### A JSON-LD representation of a text page could look like this:
```jsonld
{
  "@context": "http://structured-text.org/context.json",
  "@id": "http://example.org/fcrepo/rest/edition/0003/page/p001",
  "@type": "st:TextPage",
  "label": "Seite 1",
  "lines": [
       {
            "@id": "http://example.org/fcrepo/rest/edition/0003/line/ln00001",
            "@type": "st:TextLine"         
       },
       {
           "@id": "http://example.org/fcrepo/rest/edition/0003/line/ln00002",
           "@type": "st:TextLine"
       }      
   ]
}   
   
```  

### The representation of a line in RDF:
```turtle
<http://localhost:8080/fcrepo/rest/edition/00027/line/ln001> <http://structured-text.org#hasWords> _:c002 .  
_:c002 <http://www.w3.org/1999/02/22-rdf-syntax-ns#first> <http://localhost:8080/fcrepo/rest/edition/00027/word/w000001> .  
_:c002 <http://www.w3.org/1999/02/22-rdf-syntax-ns#rest> _:c005 .  
_:c005 <http://www.w3.org/1999/02/22-rdf-syntax-ns#first> <http://localhost:8080/fcrepo/rest/edition/00027/word/w000002> .  
_:c005 <http://www.w3.org/1999/02/22-rdf-syntax-ns#rest> _:c008 .
```

* and so on... until the last statement which would look like this:  
```turtle
_:c0050 <http://www.w3.org/1999/02/22-rdf-syntax-ns#first> <http://localhost:8080/fcrepo/rest/edition/00027/word/w00020> .  
_:c0050 <http://www.w3.org/1999/02/22-rdf-syntax-ns#rest><http://www.w3.org/1999/02/22-rdf-syntax-ns#nil>
```

### Representation of a division in RDF:
* Constructing a division is the same as the page, except it would look like this:   
```turtle
<http://localhost:8080/fcrepo/rest/edition/00027/div/d001> <http://structured-text.org#hasLines> _:d002 .  
_:d002 <http://www.w3.org/1999/02/22-rdf-syntax-ns#first> <http://localhost:8080/fcrepo/rest/edition/00027/line/ln001> .  
_:d002 <http://www.w3.org/1999/02/22-rdf-syntax-ns#rest> _:d005 .  
_:d005 <http://www.w3.org/1999/02/22-rdf-syntax-ns#first> <http://localhost:8080/fcrepo/rest/edition/00027/line/ln002> .  
_:d005 <http://www.w3.org/1999/02/22-rdf-syntax-ns#rest> <http://www.w3.org/1999/02/22-rdf-syntax-ns#nil>
```

### About Blank Nodes
* The use of blank nodes is integral to the concept of list sequences in RDF, 
* The JSON-LD representation of a RDF list is an array that when normalized, must include these blank nodes.
* This is the only mechanism where the resource can be dereferenced from the list structure and still retain the order of the list.
* In Fedora, when a blank node is inserted, an uuid is generated for it and it is put in the '.well-known' container.
  * example: .well-known/genid/ae/22/a3/25/ae22a325-d89f-4948-8de7-4f698e44c844

### Every word is an RDF resource!  
* Infinite space for statements
* Expanding on the word resource, for example: 
```turtle
<http://localhost:8080/fcrepo/rest/edition/00027/word/w000001> rdfs:label "In"@de .  
<http://localhost:8080/fcrepo/rest/edition/00027/word/w000001> tei:rendition tei:center 
``` 
etc...

* The enrichment of TEI annotations is retained as statements about the resource.

### About Word groups
* a word group (or phrase) can also be represented as resource
* for example, "J.F. Blumenbach" is two words that represent one resource entity.
* The construction of the word group is the same as the line.

### Why Construct Texts as RDF?
* The objective is to integrate the presentation of digital resources with the presentation of the annotation list metadata.
* The digital resources are stored in Fedora.
* The resources in an annotation list typically include a transcription of the text.
* Indexing this text in association with the presentation object is important for discovery.
  * If the text is kept as TEI, the TEI needs to explicitly reference the image resource (with a hard link).  And, the indexing of the TEI
  has to be done separately.  (Not optimal!)
* enabling powerful SPARQL queries to create dynamic resource presentations based on the annotation encoding criteria is a possibility.
  

