xquery version "3.1";
declare namespace functx = "http://www.functx.com";
declare namespace acdh="https://vocabs.acdh.oeaw.ac.at/schema#";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $result := 
<rdf:RDF
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/schema#"
        xml:base="https://id.acdh.oeaw.ac.at/">
{

for $x in distinct-values(data(collection($app:editions)//tei:person/@xml:id))
    let $person := collection($app:indices)//id($x)
    let $title := $person//tei:forename/text()||' '||$person//tei:surname/text()
    let $id := "https://id.acdh.oeaw.ac.at/pmb/"||$x
    return
        <acdh:Person rdf:about="{$id}">
            <acdh:hasTitle lang="und">{normalize-space($title)}</acdh:hasTitle>
        </acdh:Person>
}
</rdf:RDF>

return $result
