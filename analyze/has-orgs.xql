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
    let $gnd := $item/tei:idno[@type="geonames"][1]/text()
    let $result := if ($gnd) then $gnd else $arche_uri

    return
        $result
};

declare function local:latLong($item as node()*){
    let $coords := tokenize($item//tei:geo)
    let $result := if (count($coords) eq 2)
        then (<acdh:hasLatitude>{$coords[1]}</acdh:hasLatitude>, <acdh:hasLongitude>{$coords[2]}</acdh:hasLongitude>) else false()
        return
            $result
            
};


let $sample := collection($app:editions)//tei:TEI[.//tei:place[@xml:id]]
let $res :=
    for $item in $sample
        let $doc_id := $item/@xml:base||'/'||$item/@xml:id
        let $ent_ids := $item//tei:back//tei:listPlace/tei:place[@xml:id]/@xml:id
        return 
        <acdh:Resource rdf:about="{$doc_id}">
        {
        for $ent in $ent_ids
            let $ent_node := collection($app:indices)/id($ent)
            let $res_id := if ($ent_node ) then local:get_entity_id($ent_node) else false()
            let $hasTitle := $ent_node//tei:placeName[1]/text()
            let $coords := local:latLong($ent_node)
            where $res_id
            return
                <acdh:hasSpatialCoverage>
                    <acdh:Place rdf:about="{$res_id}">
                        <acdh:hasTitle xml:lang="und">{$hasTitle}</acdh:hasTitle>
                        {$coords}
                    </acdh:Place>
                </acdh:hasSpatialCoverage>
               
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