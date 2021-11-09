xquery version "3.1";

import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";

declare namespace acdh="https://vocabs.acdh.oeaw.ac.at/schema#";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=no indent=yes";

declare function local:get_entity_id($item as node()){
    let $pmb_uri := data($item/@xml:id)
    let $pmb_id := substring-after($pmb_uri, 'pmb')
    let $arche_uri := "https://id.acdh.oeaw.ac.at/pmb/"||$pmb_id
    let $gnd := $item/tei:idno[@type="gnd"][1]/text()
    let $result := if ($gnd) then $gnd else $arche_uri

    return
        $result
};


let $sample := collection($app:editions)//tei:TEI[.//tei:person[@xml:id]]

let $res :=
    for $item in $sample
        let $doc_id := $item/@xml:base||'/'||$item/@xml:id
        let $ent_ids := $item//tei:back//tei:listPerson/tei:person[@xml:id]/@xml:id
        return 
        <acdh:Resource rdf:about="{$doc_id}">
        {
        for $ent in $ent_ids
            let $ent_node := collection($app:indices)/id($ent)
            let $res_id := if ($ent_node ) then local:get_entity_id($ent_node) else false()
            let $hasTitle := $ent_node//tei:forename[1]/text()||" "||$ent_node//tei:surname[1]/text()
            where $res_id
            return
                <acdh:hasActor>
                    <acdh:Person rdf:about="{$res_id}">
                        <acdh:hasTitle xml:lang="und">{$hasTitle}</acdh:hasTitle>
                    </acdh:Person>
                </acdh:hasActor>
               
        }
        </acdh:Resource>
return 
    <rdf:RDF
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/schema#"
        xml:base="https://id.acdh.oeaw.ac.at/">
        {$res}
    </rdf:RDF>