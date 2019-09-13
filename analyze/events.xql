xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/mrptestapp/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/mrptestapp/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
(:declare option exist:serialize "method=xml";:)
(:declare option exist:serialize "method=html5 media-type=text/html";:)
declare option exist:serialize "method=xml media-type=text/xml";

let $notBefores := collection($app:editions)//tei:TEI//*[@notBefore castable as xs:date]
let $whens := collection($app:editions)//tei:TEI//tei:date[@when castable as xs:date]
let $dates := ($notBefores, $whens)

    let $collection := request:get-parameter("collection", "")
    let $baseurl := "https://hw.oeaw.ac.at/ministerrat/serie-1/"
    let $docs := if ($collection)
        then
            collection(concat($config:app-root, '/data/', $collection, '/'))//tei:TEI
        else
            collection(concat($config:app-root, '/data/editions/'))//tei:TEI
            
    let $data :=
    <TEI xmlns="http://www.tei-c.org/ns/1.0">
    <teiHeader>
        <fileDesc>
            <titleStmt>
                <title>listEvent Ministerratsprotokolle 1848-1867</title>
            </titleStmt>
            <publicationStmt>
                <publisher>ÖAW INZ</publisher>
                <address>
                    <placeName>Wien</placeName>
                </address>
                <date when="2019-09-18">2019-09-18</date>
                <distributor>
                    <persName ref="http://d-nb.info/gnd/13281899X">
                        <forename>Stephan</forename> <surname>Kurz</surname>
                    </persName>
                    <idno type="ORCID">https://orcid.org/0000-0003-2546-2570</idno>
                </distributor>
                <availability>
                    <licence target="https://creativecommons.org/licenses/by/4.0/">
                        <p>The CC BY 4.0 license applies to this document.</p>
                    </licence>
                </availability>
            </publicationStmt>
            <sourceDesc>
                <p>Generated using events.xql from unpublished TEI derivates of generic XML data available on <ref target="https://hw.oeaw.ac.at/ministerrat/">https://hw.oeaw.ac.at/ministerrat/</ref>.</p>
		<p>At the time of exporting, the parsing of what should indeed be saved in the tei:abstract as tei:listPerson was not yet finished; expect listPersons to show up in a later release.</p>
            </sourceDesc>
        </fileDesc>
    </teiHeader>
    <text>
        <body>
        <p>Work in progress with a rudimentary display, see <ref target="/exist/restxq/mrptestapp/api/collections/indices/mrptestapp_analyze_events.xql.xml">source</ref> for details. No listPerson yet included for the time being.</p>
    <listEvent type="generated">{        
    for $title in $docs
        where count($title//tei:meeting/tei:list/tei:item) > 0 
        let $id := concat('mrp-events-', $title//tei:body/tei:div/@xml:id[1])
        let $link2doc := if ($collection)
            then
                <a href="{app:hrefToDoc($title, $collection)}">{app:getHWDocName($title)}</a>
            else
                <a href="{app:hrefToDoc($title)}">{app:getHWDocName($title)}</a>
        let $datum := if ($title//tei:titleStmt[1]//tei:date[1]/@when)
            then data($title//tei:titleStmt[1]//tei:date[1]/@when)(:/format-date(xs:date(@when), '[D02].[M02].[Y0001]')):)
            else data($title//tei:publicationStmt//tei:date[1]/@when) (: picks date from print edition :)
        let $date := normalize-space(string-join($title//tei:div/tei:head/tei:title//text(), ' '))
        let $texts := for $x in $title//tei:meeting/tei:list/tei:item
                    return
                        <event type="agenda_item" ref="{concat($baseurl, $link2doc, '#', $x//tei:label/tei:num)}" when="{$datum}" where="Wien" xml:id="{concat($id, '-', translate($x//tei:label/tei:num, '][ ', ''))}"><label>Tagesordnungspunkt im österreichischen Ministerrat: {concat($x//tei:num/text(), ' ', $x//tei:ref/text())}</label></event>
        let $abt := data($title//tei:titleStmt//tei:title[@level='s']/@n)
        let $vol := data($title//tei:titleStmt//tei:title[@level='m']/@n)
        let $editor := normalize-space($title//tei:titleStmt/tei:editor/tei:persName[1])
        let $timespan := normalize-space($title//tei:titleStmt/tei:title[@level='m'][@type='sub'])
        
        return
        
            <event xml:id="{$id}" ref="{concat($baseurl,$link2doc)}" when="{$datum}" where="Wien" type="session">
            <head>{$date}</head>
            <label>Ministerratssitzung <date when="{$datum}">{$datum}</date>, aus Band {$abt}/{$vol}, {$timespan}</label>
                <desc>
                    <listEvent type="generated">
                        {$texts}
                    </listEvent>
                </desc>
            </event>
        }
        </listEvent>
        </body>
        </text>
        </TEI>
        
return $data
        (:<tr>
            <td>{$abt}</td>
            <td title="Hrsg.: {$editor}, {$timespan}">{$vol}</td>
           <td>{$date}<ul>{$texts}</ul></td>
           <td>{$datum}</td>
            <td>
                {$link2doc}
            </td>
        </tr>:)
