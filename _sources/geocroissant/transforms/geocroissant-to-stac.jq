# GeoCroissant to STAC Item conversion
# Based on ZOO-Project/dcai geocroissant_to_stac.py
# Converts GeoCroissant metadata to STAC Item format

if ."@type" == "Dataset" or .conformsTo then
  
  # Extract basic metadata
  . as $gc |
  
  # Extract spatial coverage (could be object or array)
  ($gc["geocr:spatialCoverage"] // $gc.spatialCoverage // $gc["geocr:BoundingBox"] // null) as $spatialRaw |
  
  # Determine if it's already a bbox array or an object with bbox/geometry
  (if $spatialRaw and ($spatialRaw | type == "object") then $spatialRaw else {} end) as $spatial |
  
  # Extract bounding box (support multiple field name formats)
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
  
  # Build geometry from bbox or geometry field
  (if $spatial["geocr:geometry"] then
    $spatial["geocr:geometry"]
  elif $spatial.geometry then
    $spatial.geometry
  elif $gc["geocr:geometry"] then
    $gc["geocr:geometry"]
  elif $gc.geometry then
    $gc.geometry
  elif $bbox and ($bbox | type == "array") and ($bbox | length == 4) then
    # Convert bbox [west, south, east, north] to Polygon
    {
      type: "Polygon",
      coordinates: [[
        [$bbox[0], $bbox[1]],  # SW
        [$bbox[0], $bbox[3]],  # NW
        [$bbox[2], $bbox[3]],  # NE
        [$bbox[2], $bbox[1]],  # SE
        [$bbox[0], $bbox[1]]   # close polygon
      ]]
    }
  else null end) as $geometry |
  
  # Extract temporal extent (support multiple formats)
  ($gc["geocr:temporalExtent"] // $gc.temporalExtent // $gc["dct:temporal"] // {}) as $temporal |
  (if $temporal["geocr:start"] then $temporal["geocr:start"]
   elif $temporal.start then $temporal.start
   elif $temporal.startDate then $temporal.startDate
   else null end) as $start_datetime |
  (if $temporal["geocr:end"] then $temporal["geocr:end"]
   elif $temporal.end then $temporal.end
   elif $temporal.endDate then $temporal.endDate
   else $start_datetime end) as $end_datetime |
  
  # Calculate midpoint for datetime
  ($start_datetime // (now | todate)) as $datetime |
  
  # Extract creator info
  ($gc.creator // {}) as $creator |
  (if $creator and ($creator | type) == "array" and ($creator | length) > 0 then $creator[0]
   elif $creator and ($creator | type) == "object" then $creator
   elif $creator and ($creator | type) == "string" then {name: $creator}
   else {} end) as $creator_obj |
  
  # Build STAC Item
  {
    type: "Feature",
    stac_version: "1.1.0",
    stac_extensions: [],
    id: ($gc."@id" // $gc.identifier // $gc.name // "unknown-id"),
    geometry: $geometry,
    bbox: $bbox,
    properties: {
      title: $gc.name,
      description: $gc.description,
      license: ($gc.license // "proprietary"),
      datetime: $datetime,
      start_datetime: $start_datetime,
      end_datetime: $end_datetime,
      keywords: ($gc.keywords // []),
      created: ($gc.dateCreated // $gc.datePublished),
      updated: ($gc.dateModified // $gc.datePublished),
      providers: (if $creator_obj then [{
        name: ($creator_obj.name // "Unknown"),
        roles: ["producer"],
        url: ($creator_obj.url // "")
      }] else [] end)
    },
    links: (
      [
        # Self link
        (if $gc.url then {
          rel: "self",
          href: $gc.url,
          type: "application/geo+json"
        } else null end),
        # Documentation link
        (if $gc.url then {
          rel: "about",
          href: $gc.url,
          type: "text/html",
          title: "Dataset Documentation"
        } else null end),
        # References
        (if $gc.references then
          ($gc.references | 
            if type == "array" then
              map(
                if type == "object" then
                  (. as $ref |
                   if $ref.url then
                    (($ref.url // "") as $refUrl |
                     ($ref.name // "") as $refName |
                     {
                       rel: (if $refUrl | contains("github") then "about"
                            elif ($refUrl | contains("parent")) or ($refName | contains("parent")) then "parent"
                            elif ($refUrl | contains("root")) or ($refName | contains("root")) then "root"
                            else "related" end),
                       href: $refUrl,
                       type: ($ref.encodingFormat // "application/json"),
                       title: ($refName // "Related resource")
                     })
                  else empty end)
                else empty end
              )
            else [] end)
        else [] end)
      ] | flatten | map(select(. != null))
    ),
    assets: (
      if $gc["cr:distribution"] or $gc.distribution then
        (($gc["cr:distribution"] // $gc.distribution) | 
          if type == "array" then
            map(
              if type == "object" then
                (. as $dist |
                 (."sc:contentUrl" // .contentUrl // .url // "") as $href |
                 {
                   key: (."@id" // .name // "asset"),
                   value: {
                     href: $href,
                     title: (.name // ."@id" // ""),
                     description: (.description // ""),
                     type: (."sc:encodingFormat" // .encodingFormat // "application/octet-stream"),
                     roles: (if $href and ($href | contains("git")) then ["metadata"]
                            else ["data"] end)
                   }
                 })
              else empty end
            ) | from_entries
          else {} end)
      else {} end
    )
  } | 
  # Remove null values
  walk(if type == "object" then with_entries(select(.value != null and .value != "" and .value != [])) else . end)
  
else . end
