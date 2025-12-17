# GeoCroissant to GeoDCAT conversion
# Based on ZOO-Project/dcai geocroissant_to_geodcat.py
# Converts GeoCroissant metadata to GeoDCAT/DCAT RDF JSON-LD format

if ."@type" == "Dataset" or .conformsTo then
  
  . as $gc |
  
  # Extract spatial coverage (could be object or array)
  ($gc["geocr:spatialCoverage"] // $gc.spatialCoverage // $gc["geocr:BoundingBox"] // null) as $spatialRaw |
  
  # Determine if it's already a bbox array or an object with bbox/geometry
  (if $spatialRaw and ($spatialRaw | type == "object") then $spatialRaw else {} end) as $spatial |
  
  # Extract bounding box (support multiple formats)
  (if $spatialRaw and ($spatialRaw | type == "array") and ($spatialRaw | length == 4) then
    # Direct array bbox
    $spatialRaw
  elif $spatial["geocr:boundingBox"] then
    $spatial["geocr:boundingBox"]
  elif $spatial.boundingBox then
    $spatial.boundingBox
  elif $gc["geocr:BoundingBox"] and ($gc["geocr:BoundingBox"] | type == "array") then
    $gc["geocr:BoundingBox"]
  else null end) as $bbox |
  
  # Extract temporal and creator info
  ($gc["geocr:temporalExtent"] // $gc.temporalExtent // $gc["dct:temporal"] // {}) as $temporal |
  ($gc.creator // {}) as $creator |
  (if ($creator | type) == "array" then $creator[0] else $creator end) as $creator_obj |
  
  # Build GeoDCAT Dataset
  {
    "@context": {
      "@vocab": "http://www.w3.org/ns/dcat#",
      dcat: "http://www.w3.org/ns/dcat#",
      dct: "http://purl.org/dc/terms/",
      foaf: "http://xmlns.com/foaf/0.1/",
      schema: "https://schema.org/",
      geo: "http://www.opengis.net/ont/geosparql#",
      locn: "http://www.w3.org/ns/locn#",
      xsd: "http://www.w3.org/2001/XMLSchema#",
      spdx: "http://spdx.org/rdf/terms#",
      adms: "http://www.w3.org/ns/adms#",
      prov: "http://www.w3.org/ns/prov#"
    },
    "@type": "dcat:Dataset",
    "@id": ($gc."@id" // $gc.identifier // ("urn:dataset:" + ($gc.name | gsub(" "; "-") | ascii_downcase))),
    "dct:title": $gc.name,
    "dct:description": $gc.description,
    "dct:identifier": ($gc.identifier // $gc."@id"),
    
    # License
    "dct:license": (
      if $gc.license then
        {
          "@id": (if $gc.license | startswith("http") then $gc.license
                 elif $gc.license == "CC-BY-4.0" then "http://creativecommons.org/licenses/by/4.0/"
                 elif $gc.license == "MIT" then "https://opensource.org/licenses/MIT"
                 else $gc.license end)
        }
      else null end
    ),
    
    # Version
    "adms:version": ($gc.version // "1.0.0"),
    
    # Keywords
    "dcat:keyword": ($gc.keywords // []),
    
    # Spatial coverage
    "dct:spatial": (
      if $bbox or $spatial then
        {
          "@type": "dct:Location",
          "locn:geometry": (
            if $bbox and ($bbox | type) == "array" and ($bbox | length == 4) then
              # Create GeoJSON Polygon from bbox
              {
                "@type": "https://www.iana.org/assignments/media-types/application/vnd.geo+json",
                "@value": ({
                  type: "Polygon",
                  coordinates: [[
                    [$bbox[0], $bbox[1]],
                    [$bbox[0], $bbox[3]],
                    [$bbox[2], $bbox[3]],
                    [$bbox[2], $bbox[1]],
                    [$bbox[0], $bbox[1]]
                  ]]
                } | tojson)
              }
            elif $spatial["geocr:geometry"] then
              {
                "@type": "https://www.iana.org/assignments/media-types/application/vnd.geo+json",
                "@value": ($spatial["geocr:geometry"] | tojson)
              }
            else null end
          ),
          "geo:asWKT": (
            if $bbox and ($bbox | type) == "array" and ($bbox | length == 4) then
              {
                "@type": "geo:wktLiteral",
                "@value": ("POLYGON((" +
                  ([$bbox[0], $bbox[1]] | join(" ")) + "," +
                  ([$bbox[0], $bbox[3]] | join(" ")) + "," +
                  ([$bbox[2], $bbox[3]] | join(" ")) + "," +
                  ([$bbox[2], $bbox[1]] | join(" ")) + "," +
                  ([$bbox[0], $bbox[1]] | join(" ")) +
                  "))")
              }
            else null end
          )
        }
      else null end
    ),
    
    # Temporal coverage
    "dct:temporal": (
      if $temporal and ($temporal["geocr:start"] or $temporal.start or $temporal.startDate) then
        {
          "@type": "dct:PeriodOfTime",
          "dcat:startDate": {
            "@value": ($temporal["geocr:start"] // $temporal.start // $temporal.startDate),
            "@type": "xsd:dateTime"
          },
          "dcat:endDate": {
            "@value": ($temporal["geocr:end"] // $temporal.end // $temporal.endDate // ($temporal["geocr:start"] // $temporal.start)),
            "@type": "xsd:dateTime"
          }
        }
      else null end
    ),
    
    # Publication dates
    "dct:issued": (
      if $gc.datePublished then
        { "@value": $gc.datePublished, "@type": "xsd:dateTime" }
      else null end
    ),
    "dct:modified": (
      if $gc.dateModified then
        { "@value": $gc.dateModified, "@type": "xsd:dateTime" }
      else null end
    ),
    
    # Creator/Publisher
    "dct:creator": (
      if $creator_obj then
        {
          "@type": (if $creator_obj."@type" then $creator_obj."@type" else "foaf:Organization" end),
          "foaf:name": $creator_obj.name,
          "foaf:homepage": (if $creator_obj.url then { "@id": $creator_obj.url } else null end)
        }
      else null end
    ),
    "dct:publisher": (
      if $gc.publisher then
        (if ($gc.publisher | type) == "object" then
          {
            "@type": "foaf:Organization",
            "foaf:name": $gc.publisher.name,
            "foaf:homepage": (if $gc.publisher.url then { "@id": $gc.publisher.url } else null end)
          }
        else
          { "@type": "foaf:Organization", "foaf:name": $gc.publisher }
        end)
      else null end
    ),
    
    # Landing page
    "dcat:landingPage": (
      if $gc.url then { "@id": $gc.url } else null end
    ),
    
    # Distributions
    "dcat:distribution": (
      if $gc["cr:distribution"] or $gc.distribution then
        (($gc["cr:distribution"] // $gc.distribution) |
          if type == "array" then
            map({
              "@type": "dcat:Distribution",
              "@id": (."@id" // .name // "dist"),
              "dct:title": (.name // ."@id"),
              "dct:description": (.description // ""),
              "dcat:accessURL": {
                "@id": (."sc:contentUrl" // .contentUrl // .url)
              },
              "dcat:downloadURL": (
                if (."sc:contentUrl" // .contentUrl // .url) | test("^http|^s3://") then
                  { "@id": (."sc:contentUrl" // .contentUrl // .url) }
                else null end
              ),
              "dct:format": (."sc:encodingFormat" // .encodingFormat // "application/octet-stream"),
              "dcat:mediaType": (."sc:encodingFormat" // .encodingFormat // "application/octet-stream"),
              "spdx:checksum": (
                if .sha256 then
                  {
                    "@type": "spdx:Checksum",
                    "spdx:algorithm": { "@id": "spdx:checksumAlgorithm_sha256" },
                    "spdx:checksumValue": .sha256
                  }
                else null end
              ),
              "dcat:byteSize": (.contentSize // null)
            })
          else [] end)
      else [] end
    ),
    
    # Contact point
    "dcat:contactPoint": (
      if $gc.contactPoint then
        {
          "@type": "vcard:Organization",
          "vcard:fn": ($gc.contactPoint.name // $gc.contactPoint),
          "vcard:hasEmail": (if $gc.contactPoint.email then { "@id": ("mailto:" + $gc.contactPoint.email) } else null end)
        }
      else null end
    ),
    
    # Provenance
    "dct:provenance": (
      if $gc.isBasedOn or $gc.prov_was_derived_from then
        {
          "@type": "dct:ProvenanceStatement",
          "prov:wasDerivedFrom": (
            if $gc.isBasedOn then
              (if ($gc.isBasedOn | type) == "array" then
                $gc.isBasedOn | map(if type == "object" then ."@id" else . end)
              elif ($gc.isBasedOn | type) == "object" then
                [$gc.isBasedOn."@id"]
              else [$gc.isBasedOn] end)
            else [] end
          )
        }
      else null end
    )
    
  } | 
  # Remove null values and empty arrays
  walk(if type == "object" then 
    with_entries(select(.value != null and .value != "" and .value != [] and .value != {}))
  else . end)
  
else . end
