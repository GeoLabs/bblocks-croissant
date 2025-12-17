
# GeoCroissant Extension (Schema)

`mlc.croissant.geocroissant` *v1.0*

Geospatial extension for Croissant metadata format enabling spatial and temporal data description

[*Status*](http://www.opengis.net/def/status): Under development

## Description

# GeoCroissant Extension

## Overview

GeoCroissant is a geospatial extension for the [Croissant metadata format](https://docs.mlcommons.org/croissant/docs/croissant-spec.html), developed to enable standardized description of spatiotemporal machine learning datasets. This extension was created by the ZOO-Project team to facilitate interoperability between ML dataset metadata and geospatial standards.

## Purpose

GeoCroissant addresses the need for:

- **Spatial Data Description**: Add geographic bounding boxes, coordinate reference systems, and geometries to Croissant datasets
- **Temporal Coverage**: Describe the temporal extent of datasets with start/end dates
- **Geospatial Interoperability**: Enable conversion between Croissant and standards like:
  - STAC (SpatioTemporal Asset Catalog)
  - GeoDCAT (Geospatial extension of DCAT)
  - OGC Training Data Markup Language (TDML)
  - NASA UMM-G (Unified Metadata Model for Geospatial)
- **CRS Support**: Specify coordinate reference systems using EPSG codes, WKT, PROJ JSON, or URIs

## Namespace

GeoCroissant uses the namespace:
- **URI**: `http://mlcommons.org/geocroissant/`
- **Prefix**: `geocr:`

Related namespaces:
- `geo:` - http://www.opengis.net/ont/geosparql# (GeoSPARQL)
- `dct:` - http://purl.org/dc/terms/ (Dublin Core Terms)

## Key Properties

### Spatial Coverage

**boundingBox** (`geocr:boundingBox`)
- Geographic bounding box in WGS84 coordinates
- Format: `[west, south, east, north]`
- Example: `[-125.0, 24.0, -66.0, 50.0]` (Continental USA)

**spatialCoverage** (`geocr:spatialCoverage`)
- GeoJSON geometry representation
- Supports: Point, LineString, Polygon, Multi* types
- Example:
  ```json
  {
    "type": "Polygon",
    "coordinates": [[[-180, -90], [180, -90], [180, 90], [-180, 90], [-180, -90]]]
  }
  ```

**geometry** (`geo:hasGeometry`)
- GeoSPARQL-compatible geometry
- Aligns with OGC GeoSPARQL standard

**wkt** (`geo:asWKT`)
- Well-Known Text representation
- Example: `"POLYGON((-180 -90, 180 -90, 180 90, -180 90, -180 -90))"`

### Temporal Coverage

**temporalExtent** (`geocr:temporalExtent`)
- Temporal extent with start and end dates
- ISO 8601 format
- Example:
  ```json
  {
    "start": "2020-01-01T00:00:00Z",
    "end": "2020-12-31T23:59:59Z"
  }
  ```

**temporalCoverage** (`dct:temporal`)
- Dublin Core temporal coverage
- Compatible with DCAT standards

### Coordinate Reference Systems

**coordinateReferenceSystem** (`geocr:coordinateReferenceSystem`)
- Full URI to CRS definition
- Example: `"http://www.opengis.net/def/crs/EPSG/0/4326"`

**crs** (`geocr:crs`)
- Short CRS identifier
- Example: `"EPSG:4326"`

**epsgCode** (`geocr:epsgCode`)
- Integer EPSG code
- Example: `4326`

**wkt2** (`geocr:wkt2`)
- WKT2 representation of CRS
- Used for complex CRS definitions

**proj** (`geocr:proj`)
- PROJ JSON representation
- Example:
  ```json
  {
    "type": "GeographicCRS",
    "name": "WGS 84",
    "id": {
      "authority": "EPSG",
      "code": 4326
    }
  }
  ```

### STAC Compatibility

**stacVersion** (`geocr:stacVersion`)
- STAC specification version
- Example: `"1.1.0"`

**stacExtensions** (`geocr:stacExtensions`)
- Array of STAC extension URIs
- Example: `["https://stac-extensions.github.io/projection/v1.1.0/schema.json"]`

## Usage Examples

### Basic Bounding Box

```json
{
  "@context": [
    "http://mlcommons.org/croissant/",
    "http://mlcommons.org/geocroissant/"
  ],
  "@type": "sc:Dataset",
  "name": "Sample Geospatial Dataset",
  "geocr:boundingBox": [-125.0, 24.0, -66.0, 50.0],
  "geocr:temporalExtent": {
    "start": "2020-01-01T00:00:00Z",
    "end": "2020-12-31T23:59:59Z"
  }
}
```

### GeoJSON Geometry

```json
{
  "@context": [
    "http://mlcommons.org/croissant/",
    "http://mlcommons.org/geocroissant/"
  ],
  "@type": "sc:Dataset",
  "name": "Point of Interest Dataset",
  "geocr:spatialCoverage": {
    "type": "Point",
    "coordinates": [-122.4194, 37.7749]
  },
  "geocr:crs": "EPSG:4326"
}
```

### Custom CRS with STAC

```json
{
  "@context": [
    "http://mlcommons.org/croissant/",
    "http://mlcommons.org/geocroissant/"
  ],
  "@type": "sc:Dataset",
  "name": "Sentinel-2 Tile",
  "geocr:boundingBox": [300000, 4000000, 400000, 4100000],
  "geocr:epsgCode": 32610,
  "geocr:stacVersion": "1.1.0",
  "geocr:stacExtensions": [
    "https://stac-extensions.github.io/projection/v1.1.0/schema.json"
  ]
}
```

## Conversion Support

GeoCroissant enables bidirectional conversion with:

| Format | Direction | Notes | Related Building Blocks |
|--------|-----------|-------|------------------------|
| STAC Collection | ↔ | Full support via ZOO-Project converters | [`ogc.contrib.stac.collection`](https://ogcincubator.github.io/bblocks-stac/bblock/ogc.contrib.stac.collection) |
| STAC Item | ↔ | Geometry, temporal, and asset mapping | [`ogc.contrib.stac.item`](https://ogcincubator.github.io/bblocks-stac/bblock/ogc.contrib.stac.item) |
| GeoDCAT | → | RDF/JSON-LD output with DCAT vocabulary | [`ogc.geo.geodcat.geodcat`](https://ogcincubator.github.io/geodcat-ogcapi-records/bblock/ogc.geo.geodcat.geodcat) |
| GeoDCAT-STAC | ↔ | STAC to GeoDCAT mapping | [`ogc.geo.geodcat.stac.geodcat-stac-collection`](https://ogcincubator.github.io/geodcat-ogcapi-records/bblock/ogc.geo.geodcat.stac.geodcat-stac-collection) |
| OGC API Records | → | Records metadata interchange | [`ogc.geo.geodcat.geodcat-records`](https://ogcincubator.github.io/geodcat-ogcapi-records/bblock/ogc.geo.geodcat.geodcat-records) |
| OGC TDML | ↔ | Training dataset metadata interchange | Training Data Markup Language standard |
| NASA UMM-G | → | Earth observation metadata mapping | Unified Metadata Model - Geospatial |
| CEDA UK | → | UK data archive metadata | CEDA Archive format |

## OGC Building Block Dependencies

GeoCroissant leverages the following OGC Building Blocks:

### Core Spatial Types
- **[`ogc.geo.common.data_types.geojson`](https://opengeospatial.github.io/bblocks/register/)** - GeoJSON geometry representations
- **[`ogc.geo.common.data_types.bounding_box`](https://opengeospatial.github.io/bblocks/register/)** - Bounding box definitions

### Related Standards
- **[`ogc.geo.geodcat.geodcat`](https://ogcincubator.github.io/geodcat-ogcapi-records/bblock/ogc.geo.geodcat.geodcat)** - GeoDCAT profile for geospatial datasets
- **[`ogc.contrib.stac.collection`](https://ogcincubator.github.io/bblocks-stac/bblock/ogc.contrib.stac.collection)** - STAC Collection schema
- **[`ogc.api.records.v1.schemas.time`](https://ogcincubator.github.io/bblocks-ogcapi-records/)** - Temporal extent schema from OGC API Records

### Semantic Integration
- **GeoSPARQL** - Uses `geo:hasGeometry` and `geo:asWKT` from OGC GeoSPARQL ontology
- **Dublin Core Terms** - Leverages `dct:temporal`, `dct:start`, `dct:end` for temporal metadata

## Related Resources

- [ZOO-Project GeoCroissant Converters](https://github.com/ZOO-Project/dcai) - Reference implementations
- [Croissant Specification](https://docs.mlcommons.org/croissant/docs/croissant-spec.html) - Base specification
- [STAC Specification](https://stacspec.org/) - Spatiotemporal Asset Catalog
- [GeoDCAT-AP](https://semiceu.github.io/GeoDCAT-AP/) - Geospatial profile of DCAT-AP
- [OGC GeoSPARQL](http://www.opengis.net/doc/IS/geosparql/1.0) - OGC GeoSPARQL standard
- [OGC TDML](https://docs.ogc.org/DRAFTS/17-049r1.html) - Training Data Markup Language
- [OGC Building Blocks](https://opengeospatial.github.io/bblocks/) - OGC Building Blocks register

## Dependencies

GeoCroissant extends the base Croissant Dataset building block (`mlc.croissant.dataset`) and should be used in combination with it. It also depends on OGC common geospatial building blocks for GeoJSON and bounding box representations.

## Examples

### Simple bounding box example
#### json
```json
{
  "@context": {
    "@language": "en",
    "@vocab": "https://schema.org/",
    "cr": "http://mlcommons.org/croissant/",
    "dct": "http://purl.org/dc/terms/",
    "geocr": "https://example.org/geocroissant/",
    "sc": "https://schema.org/"
  },
  "@type": "Dataset",
  "@id": "bbox-example-dataset",
  "conformsTo": "http://mlcommons.org/croissant/1.0",
  "name": "BBox Example Dataset",
  "description": "Example dataset with bounding box spatial coverage for GeoCroissant",
  "license": "https://creativecommons.org/licenses/by/4.0/",
  "url": "https://example.org/datasets/bbox-example",
  "identifier": "bbox-example-dataset",
  "datePublished": "2018-01-01T00:00:00Z",
  "creator": {
    "@type": "Organization",
    "name": "Example Organization",
    "url": "https://example.org"
  },
  "keywords": ["geospatial", "bbox", "example"],
  "geocr:spatialCoverage": [-125.0, 24.0, -66.0, 50.0],
  "geocr:temporalExtent": {
    "start": "2018-01-01T00:00:00Z",
    "end": "2021-12-31T23:59:59Z"
  },
  "geocr:crs": "EPSG:4326",
  "distribution": [
    {
      "@type": "cr:FileObject",
      "@id": "data-file",
      "name": "data-file",
      "description": "Main data file",
      "contentUrl": "https://example.org/data/bbox-example.tif",
      "encodingFormat": "image/tiff; application=geotiff",
      "sha256": "abc123def456"
    }
  ],
  "recordSet": [
    {
      "@type": "cr:RecordSet",
      "@id": "main-records",
      "name": "main-records",
      "description": "Main record set for the dataset",
      "field": [
        {
          "@type": "cr:Field",
          "@id": "main-records/location",
          "name": "location",
          "description": "Geographic location field",
          "dataType": "cr:GeoJSON"
        },
        {
          "@type": "cr:Field",
          "@id": "main-records/timestamp",
          "name": "timestamp",
          "description": "Temporal timestamp",
          "dataType": "sc:DateTime"
        }
      ]
    }
  ]
}

```

#### jsonld
```jsonld
{
  "@context": [
    "https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/geocroissant/context.jsonld",
    {
      "@language": "en",
      "@vocab": "https://schema.org/",
      "cr": "http://mlcommons.org/croissant/",
      "dct": "http://purl.org/dc/terms/",
      "geocr": "https://example.org/geocroissant/",
      "sc": "https://schema.org/"
    }
  ],
  "@type": "Dataset",
  "@id": "bbox-example-dataset",
  "conformsTo": "http://mlcommons.org/croissant/1.0",
  "name": "BBox Example Dataset",
  "description": "Example dataset with bounding box spatial coverage for GeoCroissant",
  "license": "https://creativecommons.org/licenses/by/4.0/",
  "url": "https://example.org/datasets/bbox-example",
  "identifier": "bbox-example-dataset",
  "datePublished": "2018-01-01T00:00:00Z",
  "creator": {
    "@type": "Organization",
    "name": "Example Organization",
    "url": "https://example.org"
  },
  "keywords": [
    "geospatial",
    "bbox",
    "example"
  ],
  "geocr:spatialCoverage": [
    -125.0,
    24.0,
    -66.0,
    50.0
  ],
  "geocr:temporalExtent": {
    "start": "2018-01-01T00:00:00Z",
    "end": "2021-12-31T23:59:59Z"
  },
  "geocr:crs": "EPSG:4326",
  "distribution": [
    {
      "@type": "cr:FileObject",
      "@id": "data-file",
      "name": "data-file",
      "description": "Main data file",
      "contentUrl": "https://example.org/data/bbox-example.tif",
      "encodingFormat": "image/tiff; application=geotiff",
      "sha256": "abc123def456"
    }
  ],
  "recordSet": [
    {
      "@type": "cr:RecordSet",
      "@id": "main-records",
      "name": "main-records",
      "description": "Main record set for the dataset",
      "field": [
        {
          "@type": "cr:Field",
          "@id": "main-records/location",
          "name": "location",
          "description": "Geographic location field",
          "dataType": "cr:GeoJSON"
        },
        {
          "@type": "cr:Field",
          "@id": "main-records/timestamp",
          "name": "timestamp",
          "description": "Temporal timestamp",
          "dataType": "sc:DateTime"
        }
      ]
    }
  ]
}
```

#### ttl
```ttl
@prefix cr: <http://mlcommons.org/croissant/> .
@prefix dcat: <http://www.w3.org/ns/dcat#> .
@prefix dct: <http://purl.org/dc/terms/> .
@prefix geocr: <https://example.org/geocroissant/> .
@prefix ns1: <https://stacspec.org/> .
@prefix sc: <https://schema.org/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<file:///github/workspace/bbox-example-dataset> a dcat:Dataset,
        sc:Dataset,
        ns1:Collection ;
    dct:creator _:Nac8706e082164bbeb5bdcad6323b4090 ;
    dct:description "Example dataset with bounding box spatial coverage for GeoCroissant"@en ;
    dct:issued "2018-01-01T00:00:00Z"@en ;
    dct:license "https://creativecommons.org/licenses/by/4.0/"@en ;
    dct:title "BBox Example Dataset"@en ;
    dcat:distribution <file:///github/workspace/data-file> ;
    dcat:keyword "bbox"@en,
        "example"@en,
        "geospatial"@en ;
    dcat:landingPage "https://example.org/datasets/bbox-example"@en ;
    geocr:crs "EPSG:4326"@en ;
    geocr:spatialCoverage -1.25e+02,
        -6.6e+01,
        2.4e+01,
        5e+01 ;
    geocr:temporalExtent [ sc:end "2021-12-31T23:59:59Z"@en ;
            sc:start "2018-01-01T00:00:00Z"@en ] ;
    sc:conformsTo "http://mlcommons.org/croissant/1.0"@en ;
    sc:creator _:Nac8706e082164bbeb5bdcad6323b4090 ;
    sc:datePublished "2018-01-01T00:00:00Z"@en ;
    sc:description "Example dataset with bounding box spatial coverage for GeoCroissant"@en ;
    sc:distribution <file:///github/workspace/data-file> ;
    sc:identifier "bbox-example-dataset"@en ;
    sc:keywords "bbox"@en,
        "example"@en,
        "geospatial"@en ;
    sc:license "https://creativecommons.org/licenses/by/4.0/"@en ;
    sc:name "BBox Example Dataset"@en ;
    sc:recordSet <file:///github/workspace/main-records> ;
    sc:url "https://example.org/datasets/bbox-example"@en ;
    ns1:assets [ ns1:description "Main data file"@en ;
            ns1:href "https://example.org/data/bbox-example.tif"@en ;
            ns1:title "data-file"@en ;
            ns1:type "image/tiff; application=geotiff"@en ] ;
    ns1:description "Example dataset with bounding box spatial coverage for GeoCroissant"@en ;
    ns1:id "bbox-example-dataset"@en ;
    ns1:license "https://creativecommons.org/licenses/by/4.0/"@en ;
    ns1:title "BBox Example Dataset"@en .

<file:///github/workspace/main-records> a cr:RecordSet ;
    sc:description "Main record set for the dataset"@en ;
    sc:field <file:///github/workspace/main-records/location>,
        <file:///github/workspace/main-records/timestamp> ;
    sc:name "main-records"@en .

<file:///github/workspace/main-records/location> a cr:Field ;
    sc:dataType "cr:GeoJSON"@en ;
    sc:description "Geographic location field"@en ;
    sc:name "location"@en .

<file:///github/workspace/main-records/timestamp> a cr:Field ;
    sc:dataType "sc:DateTime"@en ;
    sc:description "Temporal timestamp"@en ;
    sc:name "timestamp"@en .

<file:///github/workspace/data-file> a cr:FileObject,
        dcat:Distribution ;
    dct:description "Main data file"@en ;
    dct:title "data-file"@en ;
    dcat:accessURL "https://example.org/data/bbox-example.tif"@en ;
    dcat:mediaType "image/tiff; application=geotiff"@en ;
    sc:contentUrl "https://example.org/data/bbox-example.tif"@en ;
    sc:description "Main data file"@en ;
    sc:encodingFormat "image/tiff; application=geotiff"@en ;
    sc:name "data-file"@en ;
    sc:sha256 "abc123def456"@en .

_:Nac8706e082164bbeb5bdcad6323b4090 a sc:Organization ;
    sc:name "Example Organization"@en ;
    sc:url "https://example.org"@en .


```


### Point location
#### json
```json
{
  "@context": {
    "@language": "en",
    "@vocab": "https://schema.org/",
    "cr": "http://mlcommons.org/croissant/",
    "dct": "http://purl.org/dc/terms/",
    "geocr": "https://example.org/geocroissant/",
    "sc": "https://schema.org/"
  },
  "@type": "Dataset",
  "@id": "point-example-dataset",
  "conformsTo": "http://mlcommons.org/croissant/1.0",
  "name": "Point Example Dataset",
  "description": "Example dataset with point geometry spatial coverage for GeoCroissant",
  "license": "https://creativecommons.org/licenses/by/4.0/",
  "url": "https://example.org/datasets/point-example",
  "identifier": "point-example-dataset",
  "datePublished": "2024-01-01T00:00:00Z",
  "creator": {
    "@type": "Organization",
    "name": "Example Organization",
    "url": "https://example.org"
  },
  "keywords": ["geospatial", "point", "location"],
  "geocr:spatialCoverage": {
    "geocr:geometry": {
      "type": "Point",
      "coordinates": [-122.4194, 37.7749]
    },
    "geocr:crs": "EPSG:4326"
  },
  "geocr:temporalExtent": {
    "start": "2024-01-01T00:00:00Z",
    "end": "2024-12-31T23:59:59Z"
  },
  "distribution": [
    {
      "@type": "cr:FileObject",
      "@id": "point-data",
      "name": "point-data",
      "description": "Point location data",
      "contentUrl": "https://example.org/data/point-data.geojson",
      "encodingFormat": "application/geo+json",
      "sha256": "xyz789abc123"
    }
  ],
  "recordSet": [
    {
      "@type": "cr:RecordSet",
      "@id": "point-records",
      "name": "point-records",
      "description": "Point location records",
      "field": [
        {
          "@type": "cr:Field",
          "@id": "point-records/geometry",
          "name": "geometry",
          "description": "Point geometry",
          "dataType": "cr:GeoJSON"
        },
        {
          "@type": "cr:Field",
          "@id": "point-records/properties",
          "name": "properties",
          "description": "Feature properties",
          "dataType": "sc:PropertyValue"
        }
      ]
    }
  ]
}

```

#### jsonld
```jsonld
{
  "@context": [
    "https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/geocroissant/context.jsonld",
    {
      "@language": "en",
      "@vocab": "https://schema.org/",
      "cr": "http://mlcommons.org/croissant/",
      "dct": "http://purl.org/dc/terms/",
      "geocr": "https://example.org/geocroissant/",
      "sc": "https://schema.org/"
    }
  ],
  "@type": "Dataset",
  "@id": "point-example-dataset",
  "conformsTo": "http://mlcommons.org/croissant/1.0",
  "name": "Point Example Dataset",
  "description": "Example dataset with point geometry spatial coverage for GeoCroissant",
  "license": "https://creativecommons.org/licenses/by/4.0/",
  "url": "https://example.org/datasets/point-example",
  "identifier": "point-example-dataset",
  "datePublished": "2024-01-01T00:00:00Z",
  "creator": {
    "@type": "Organization",
    "name": "Example Organization",
    "url": "https://example.org"
  },
  "keywords": [
    "geospatial",
    "point",
    "location"
  ],
  "geocr:spatialCoverage": {
    "geocr:geometry": {
      "type": "Point",
      "coordinates": [
        -122.4194,
        37.7749
      ]
    },
    "geocr:crs": "EPSG:4326"
  },
  "geocr:temporalExtent": {
    "start": "2024-01-01T00:00:00Z",
    "end": "2024-12-31T23:59:59Z"
  },
  "distribution": [
    {
      "@type": "cr:FileObject",
      "@id": "point-data",
      "name": "point-data",
      "description": "Point location data",
      "contentUrl": "https://example.org/data/point-data.geojson",
      "encodingFormat": "application/geo+json",
      "sha256": "xyz789abc123"
    }
  ],
  "recordSet": [
    {
      "@type": "cr:RecordSet",
      "@id": "point-records",
      "name": "point-records",
      "description": "Point location records",
      "field": [
        {
          "@type": "cr:Field",
          "@id": "point-records/geometry",
          "name": "geometry",
          "description": "Point geometry",
          "dataType": "cr:GeoJSON"
        },
        {
          "@type": "cr:Field",
          "@id": "point-records/properties",
          "name": "properties",
          "description": "Feature properties",
          "dataType": "sc:PropertyValue"
        }
      ]
    }
  ]
}
```

#### ttl
```ttl
@prefix cr: <http://mlcommons.org/croissant/> .
@prefix dcat: <http://www.w3.org/ns/dcat#> .
@prefix dct: <http://purl.org/dc/terms/> .
@prefix geocr: <https://example.org/geocroissant/> .
@prefix ns1: <https://stacspec.org/> .
@prefix sc: <https://schema.org/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<file:///github/workspace/point-example-dataset> a dcat:Dataset,
        sc:Dataset,
        ns1:Collection ;
    dct:creator _:N56820da94a554790904fe023bdae76fb ;
    dct:description "Example dataset with point geometry spatial coverage for GeoCroissant"@en ;
    dct:issued "2024-01-01T00:00:00Z"@en ;
    dct:license "https://creativecommons.org/licenses/by/4.0/"@en ;
    dct:title "Point Example Dataset"@en ;
    dcat:distribution <file:///github/workspace/point-data> ;
    dcat:keyword "geospatial"@en,
        "location"@en,
        "point"@en ;
    dcat:landingPage "https://example.org/datasets/point-example"@en ;
    geocr:spatialCoverage [ geocr:crs "EPSG:4326"@en ;
            geocr:geometry [ sc:coordinates -1.224194e+02,
                        3.77749e+01 ;
                    sc:type "Point"@en ] ] ;
    geocr:temporalExtent [ sc:end "2024-12-31T23:59:59Z"@en ;
            sc:start "2024-01-01T00:00:00Z"@en ] ;
    sc:conformsTo "http://mlcommons.org/croissant/1.0"@en ;
    sc:creator _:N56820da94a554790904fe023bdae76fb ;
    sc:datePublished "2024-01-01T00:00:00Z"@en ;
    sc:description "Example dataset with point geometry spatial coverage for GeoCroissant"@en ;
    sc:distribution <file:///github/workspace/point-data> ;
    sc:identifier "point-example-dataset"@en ;
    sc:keywords "geospatial"@en,
        "location"@en,
        "point"@en ;
    sc:license "https://creativecommons.org/licenses/by/4.0/"@en ;
    sc:name "Point Example Dataset"@en ;
    sc:recordSet <file:///github/workspace/point-records> ;
    sc:url "https://example.org/datasets/point-example"@en ;
    ns1:assets [ ns1:description "Point location data"@en ;
            ns1:href "https://example.org/data/point-data.geojson"@en ;
            ns1:title "point-data"@en ;
            ns1:type "application/geo+json"@en ] ;
    ns1:description "Example dataset with point geometry spatial coverage for GeoCroissant"@en ;
    ns1:id "point-example-dataset"@en ;
    ns1:license "https://creativecommons.org/licenses/by/4.0/"@en ;
    ns1:title "Point Example Dataset"@en .

<file:///github/workspace/point-records> a cr:RecordSet ;
    sc:description "Point location records"@en ;
    sc:field <file:///github/workspace/point-records/geometry>,
        <file:///github/workspace/point-records/properties> ;
    sc:name "point-records"@en .

<file:///github/workspace/point-records/geometry> a cr:Field ;
    sc:dataType "cr:GeoJSON"@en ;
    sc:description "Point geometry"@en ;
    sc:name "geometry"@en .

<file:///github/workspace/point-records/properties> a cr:Field ;
    sc:dataType "sc:PropertyValue"@en ;
    sc:description "Feature properties"@en ;
    sc:name "properties"@en .

<file:///github/workspace/point-data> a cr:FileObject,
        dcat:Distribution ;
    dct:description "Point location data"@en ;
    dct:title "point-data"@en ;
    dcat:accessURL "https://example.org/data/point-data.geojson"@en ;
    dcat:mediaType "application/geo+json"@en ;
    sc:contentUrl "https://example.org/data/point-data.geojson"@en ;
    sc:description "Point location data"@en ;
    sc:encodingFormat "application/geo+json"@en ;
    sc:name "point-data"@en ;
    sc:sha256 "xyz789abc123"@en .

_:N56820da94a554790904fe023bdae76fb a sc:Organization ;
    sc:name "Example Organization"@en ;
    sc:url "https://example.org"@en .


```


### Polygon with custom CRS
#### json
```json
{
  "@context": {
    "@language": "en",
    "@vocab": "https://schema.org/",
    "cr": "http://mlcommons.org/croissant/",
    "dct": "http://purl.org/dc/terms/",
    "geocr": "https://example.org/geocroissant/",
    "sc": "https://schema.org/"
  },
  "@type": "Dataset",
  "@id": "polygon-example-dataset",
  "conformsTo": "http://mlcommons.org/croissant/1.0",
  "name": "Polygon Example Dataset",
  "description": "Example dataset with polygon geometry in projected CRS (UTM) for GeoCroissant",
  "license": "https://creativecommons.org/licenses/by/4.0/",
  "url": "https://example.org/datasets/polygon-example",
  "identifier": "polygon-example-dataset",
  "datePublished": "2024-01-01T00:00:00Z",
  "creator": {
    "@type": "Organization",
    "name": "Example Organization",
    "url": "https://example.org"
  },
  "keywords": ["geospatial", "polygon", "utm", "projected"],
  "geocr:spatialCoverage": {
    "geocr:geometry": {
      "type": "Polygon",
      "coordinates": [
        [
          [300000, 4000000],
          [400000, 4000000],
          [400000, 4100000],
          [300000, 4100000],
          [300000, 4000000]
        ]
      ]
    },
    "geocr:crs": "EPSG:32610",
    "geocr:coordinateReferenceSystem": "http://www.opengis.net/def/crs/EPSG/0/32610",
    "geocr:proj": {
      "type": "ProjectedCRS",
      "name": "WGS 84 / UTM zone 10N",
      "id": {
        "authority": "EPSG",
        "code": 32610
      }
    }
  },
  "geocr:temporalExtent": {
    "start": "2024-01-01T00:00:00Z",
    "end": "2024-12-31T23:59:59Z"
  },
  "distribution": [
    {
      "@type": "cr:FileObject",
      "@id": "polygon-data",
      "name": "polygon-data",
      "description": "Polygon area data in UTM projection",
      "contentUrl": "https://example.org/data/polygon-data.geojson",
      "encodingFormat": "application/geo+json",
      "sha256": "def456ghi789"
    }
  ],
  "recordSet": [
    {
      "@type": "cr:RecordSet",
      "@id": "polygon-records",
      "name": "polygon-records",
      "description": "Polygon feature records",
      "field": [
        {
          "@type": "cr:Field",
          "@id": "polygon-records/geometry",
          "name": "geometry",
          "description": "Polygon geometry in UTM coordinates",
          "dataType": "cr:GeoJSON"
        },
        {
          "@type": "cr:Field",
          "@id": "polygon-records/area",
          "name": "area",
          "description": "Polygon area in square meters",
          "dataType": "sc:Number"
        },
        {
          "@type": "cr:Field",
          "@id": "polygon-records/properties",
          "name": "properties",
          "description": "Feature properties",
          "dataType": "sc:PropertyValue"
        }
      ]
    }
  ]
}

```

#### jsonld
```jsonld
{
  "@context": [
    "https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/geocroissant/context.jsonld",
    {
      "@language": "en",
      "@vocab": "https://schema.org/",
      "cr": "http://mlcommons.org/croissant/",
      "dct": "http://purl.org/dc/terms/",
      "geocr": "https://example.org/geocroissant/",
      "sc": "https://schema.org/"
    }
  ],
  "@type": "Dataset",
  "@id": "polygon-example-dataset",
  "conformsTo": "http://mlcommons.org/croissant/1.0",
  "name": "Polygon Example Dataset",
  "description": "Example dataset with polygon geometry in projected CRS (UTM) for GeoCroissant",
  "license": "https://creativecommons.org/licenses/by/4.0/",
  "url": "https://example.org/datasets/polygon-example",
  "identifier": "polygon-example-dataset",
  "datePublished": "2024-01-01T00:00:00Z",
  "creator": {
    "@type": "Organization",
    "name": "Example Organization",
    "url": "https://example.org"
  },
  "keywords": [
    "geospatial",
    "polygon",
    "utm",
    "projected"
  ],
  "geocr:spatialCoverage": {
    "geocr:geometry": {
      "type": "Polygon",
      "coordinates": [
        [
          [
            300000,
            4000000
          ],
          [
            400000,
            4000000
          ],
          [
            400000,
            4100000
          ],
          [
            300000,
            4100000
          ],
          [
            300000,
            4000000
          ]
        ]
      ]
    },
    "geocr:crs": "EPSG:32610",
    "geocr:coordinateReferenceSystem": "http://www.opengis.net/def/crs/EPSG/0/32610",
    "geocr:proj": {
      "type": "ProjectedCRS",
      "name": "WGS 84 / UTM zone 10N",
      "id": {
        "authority": "EPSG",
        "code": 32610
      }
    }
  },
  "geocr:temporalExtent": {
    "start": "2024-01-01T00:00:00Z",
    "end": "2024-12-31T23:59:59Z"
  },
  "distribution": [
    {
      "@type": "cr:FileObject",
      "@id": "polygon-data",
      "name": "polygon-data",
      "description": "Polygon area data in UTM projection",
      "contentUrl": "https://example.org/data/polygon-data.geojson",
      "encodingFormat": "application/geo+json",
      "sha256": "def456ghi789"
    }
  ],
  "recordSet": [
    {
      "@type": "cr:RecordSet",
      "@id": "polygon-records",
      "name": "polygon-records",
      "description": "Polygon feature records",
      "field": [
        {
          "@type": "cr:Field",
          "@id": "polygon-records/geometry",
          "name": "geometry",
          "description": "Polygon geometry in UTM coordinates",
          "dataType": "cr:GeoJSON"
        },
        {
          "@type": "cr:Field",
          "@id": "polygon-records/area",
          "name": "area",
          "description": "Polygon area in square meters",
          "dataType": "sc:Number"
        },
        {
          "@type": "cr:Field",
          "@id": "polygon-records/properties",
          "name": "properties",
          "description": "Feature properties",
          "dataType": "sc:PropertyValue"
        }
      ]
    }
  ]
}
```

#### ttl
```ttl
@prefix cr: <http://mlcommons.org/croissant/> .
@prefix dcat: <http://www.w3.org/ns/dcat#> .
@prefix dct: <http://purl.org/dc/terms/> .
@prefix geocr: <https://example.org/geocroissant/> .
@prefix ns1: <https://stacspec.org/> .
@prefix sc: <https://schema.org/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<file:///github/workspace/polygon-example-dataset> a dcat:Dataset,
        sc:Dataset,
        ns1:Collection ;
    dct:creator _:N29f83604eabf4407806cb6cd10c72e22 ;
    dct:description "Example dataset with polygon geometry in projected CRS (UTM) for GeoCroissant"@en ;
    dct:issued "2024-01-01T00:00:00Z"@en ;
    dct:license "https://creativecommons.org/licenses/by/4.0/"@en ;
    dct:title "Polygon Example Dataset"@en ;
    dcat:distribution <file:///github/workspace/polygon-data> ;
    dcat:keyword "geospatial"@en,
        "polygon"@en,
        "projected"@en,
        "utm"@en ;
    dcat:landingPage "https://example.org/datasets/polygon-example"@en ;
    geocr:spatialCoverage [ geocr:coordinateReferenceSystem "http://www.opengis.net/def/crs/EPSG/0/32610"@en ;
            geocr:crs "EPSG:32610"@en ;
            geocr:geometry [ sc:coordinates "[300000, 4000000]"@en,
                        "[300000, 4100000]"@en,
                        "[400000, 4000000]"@en,
                        "[400000, 4100000]"@en ;
                    sc:type "Polygon"@en ] ;
            geocr:proj [ sc:id [ sc:authority "EPSG"@en ;
                            sc:code 32610 ] ;
                    sc:name "WGS 84 / UTM zone 10N"@en ;
                    sc:type "ProjectedCRS"@en ] ] ;
    geocr:temporalExtent [ sc:end "2024-12-31T23:59:59Z"@en ;
            sc:start "2024-01-01T00:00:00Z"@en ] ;
    sc:conformsTo "http://mlcommons.org/croissant/1.0"@en ;
    sc:creator _:N29f83604eabf4407806cb6cd10c72e22 ;
    sc:datePublished "2024-01-01T00:00:00Z"@en ;
    sc:description "Example dataset with polygon geometry in projected CRS (UTM) for GeoCroissant"@en ;
    sc:distribution <file:///github/workspace/polygon-data> ;
    sc:identifier "polygon-example-dataset"@en ;
    sc:keywords "geospatial"@en,
        "polygon"@en,
        "projected"@en,
        "utm"@en ;
    sc:license "https://creativecommons.org/licenses/by/4.0/"@en ;
    sc:name "Polygon Example Dataset"@en ;
    sc:recordSet <file:///github/workspace/polygon-records> ;
    sc:url "https://example.org/datasets/polygon-example"@en ;
    ns1:assets [ ns1:description "Polygon area data in UTM projection"@en ;
            ns1:href "https://example.org/data/polygon-data.geojson"@en ;
            ns1:title "polygon-data"@en ;
            ns1:type "application/geo+json"@en ] ;
    ns1:description "Example dataset with polygon geometry in projected CRS (UTM) for GeoCroissant"@en ;
    ns1:id "polygon-example-dataset"@en ;
    ns1:license "https://creativecommons.org/licenses/by/4.0/"@en ;
    ns1:title "Polygon Example Dataset"@en .

<file:///github/workspace/polygon-records> a cr:RecordSet ;
    sc:description "Polygon feature records"@en ;
    sc:field <file:///github/workspace/polygon-records/area>,
        <file:///github/workspace/polygon-records/geometry>,
        <file:///github/workspace/polygon-records/properties> ;
    sc:name "polygon-records"@en .

<file:///github/workspace/polygon-records/area> a cr:Field ;
    sc:dataType "sc:Number"@en ;
    sc:description "Polygon area in square meters"@en ;
    sc:name "area"@en .

<file:///github/workspace/polygon-records/geometry> a cr:Field ;
    sc:dataType "cr:GeoJSON"@en ;
    sc:description "Polygon geometry in UTM coordinates"@en ;
    sc:name "geometry"@en .

<file:///github/workspace/polygon-records/properties> a cr:Field ;
    sc:dataType "sc:PropertyValue"@en ;
    sc:description "Feature properties"@en ;
    sc:name "properties"@en .

<file:///github/workspace/polygon-data> a cr:FileObject,
        dcat:Distribution ;
    dct:description "Polygon area data in UTM projection"@en ;
    dct:title "polygon-data"@en ;
    dcat:accessURL "https://example.org/data/polygon-data.geojson"@en ;
    dcat:mediaType "application/geo+json"@en ;
    sc:contentUrl "https://example.org/data/polygon-data.geojson"@en ;
    sc:description "Polygon area data in UTM projection"@en ;
    sc:encodingFormat "application/geo+json"@en ;
    sc:name "polygon-data"@en ;
    sc:sha256 "def456ghi789"@en .

_:N29f83604eabf4407806cb6cd10c72e22 a sc:Organization ;
    sc:name "Example Organization"@en ;
    sc:url "https://example.org"@en .


```

## Schema

```yaml
$schema: https://json-schema.org/draft/2020-12/schema
title: GeoCroissant Extension
description: Geospatial extension for Croissant metadata format
type: object
properties:
  boundingBox:
    description: Geographic bounding box in [west, south, east, north] format (WGS84)
    type: array
    items:
      type: number
    minItems: 4
    maxItems: 4
    example:
    - -180
    - -90
    - 180
    - 90
    x-jsonld-id: http://mlcommons.org/geocroissant/boundingBox
    x-jsonld-type: '@json'
  spatialCoverage:
    description: Spatial coverage of the dataset as GeoJSON geometry
    type: object
    properties:
      type:
        type: string
        enum:
        - Point
        - LineString
        - Polygon
        - MultiPoint
        - MultiLineString
        - MultiPolygon
      coordinates:
        type: array
        description: GeoJSON coordinates array
    required:
    - type
    - coordinates
    example:
      type: Polygon
      coordinates:
      - - - -180
          - -90
        - - 180
          - -90
        - - 180
          - 90
        - - -180
          - 90
        - - -180
          - -90
    x-jsonld-id: http://mlcommons.org/geocroissant/spatialCoverage
    x-jsonld-type: '@json'
  geometry:
    description: GeoSPARQL geometry representation
    type: object
    properties:
      type:
        type: string
      coordinates:
        type: array
    x-jsonld-id: http://www.opengis.net/ont/geosparql#hasGeometry
    x-jsonld-type: '@json'
  temporalExtent:
    description: Temporal extent of the dataset
    type: object
    properties:
      start:
        type: string
        format: date-time
        description: Start date and time in ISO 8601 format
      end:
        type: string
        format: date-time
        description: End date and time in ISO 8601 format
    example:
      start: '2020-01-01T00:00:00Z'
      end: '2020-12-31T23:59:59Z'
    x-jsonld-id: http://mlcommons.org/geocroissant/temporalExtent
    x-jsonld-type: '@json'
  temporalCoverage:
    description: Dublin Core temporal coverage
    type: object
    properties:
      startDate:
        type: string
        format: date-time
        x-jsonld-id: http://purl.org/dc/terms/start
        x-jsonld-type: http://www.w3.org/2001/XMLSchema#dateTime
      endDate:
        type: string
        format: date-time
        x-jsonld-id: http://purl.org/dc/terms/end
        x-jsonld-type: http://www.w3.org/2001/XMLSchema#dateTime
    x-jsonld-id: http://purl.org/dc/terms/temporal
  coordinateReferenceSystem:
    description: Coordinate Reference System URI (e.g., EPSG code)
    type: string
    format: uri
    example: http://www.opengis.net/def/crs/EPSG/0/4326
    x-jsonld-id: http://mlcommons.org/geocroissant/coordinateReferenceSystem
    x-jsonld-type: '@id'
  crs:
    description: Short form CRS identifier
    type: string
    example: EPSG:4326
    x-jsonld-id: http://mlcommons.org/geocroissant/crs
    x-jsonld-type: '@id'
  epsgCode:
    description: EPSG code for the coordinate reference system
    type: integer
    example: 4326
    x-jsonld-id: http://mlcommons.org/geocroissant/epsgCode
  wkt:
    description: Well-Known Text representation of geometry
    type: string
    example: POLYGON((-180 -90, 180 -90, 180 90, -180 90, -180 -90))
    x-jsonld-id: http://www.opengis.net/ont/geosparql#asWKT
  wkt2:
    description: WKT2 representation of CRS or geometry
    type: string
    x-jsonld-id: http://mlcommons.org/geocroissant/wkt2
  stacVersion:
    description: STAC specification version (for STAC-compatible datasets)
    type: string
    pattern: ^[0-9]+\.[0-9]+\.[0-9]+$
    example: 1.1.0
    x-jsonld-id: http://mlcommons.org/geocroissant/stacVersion
  stacExtensions:
    description: List of STAC extension URLs
    type: array
    items:
      type: string
      format: uri
    example:
    - https://stac-extensions.github.io/projection/v1.1.0/schema.json
    x-jsonld-id: http://mlcommons.org/geocroissant/stacExtensions
    x-jsonld-type: '@json'
  proj:
    description: PROJ JSON representation of CRS
    type: object
    properties:
      type:
        type: string
      id:
        type: object
      name:
        type: string
    x-jsonld-id: http://mlcommons.org/geocroissant/proj
allOf:
- oneOf:
  - required:
    - boundingBox
  - required:
    - spatialCoverage
  - required:
    - geometry
  - not:
      anyOf:
      - required:
        - boundingBox
      - required:
        - spatialCoverage
      - required:
        - geometry
x-jsonld-prefixes:
  geocr: http://mlcommons.org/geocroissant/
  geo: http://www.opengis.net/ont/geosparql#
  dct: http://purl.org/dc/terms/

```

Links to the schema:

* YAML version: [schema.yaml](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/geocroissant/schema.json)
* JSON version: [schema.json](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/geocroissant/schema.yaml)


# JSON-LD Context

```jsonld
{
  "@context": {
    "boundingBox": {
      "@id": "geocr:boundingBox",
      "@type": "@json"
    },
    "spatialCoverage": {
      "@context": {
        "type": {},
        "coordinates": {}
      },
      "@id": "geocr:spatialCoverage",
      "@type": "@json"
    },
    "geometry": {
      "@context": {
        "type": {},
        "coordinates": {}
      },
      "@id": "geo:hasGeometry",
      "@type": "@json"
    },
    "temporalExtent": {
      "@context": {
        "start": {},
        "end": {}
      },
      "@id": "geocr:temporalExtent",
      "@type": "@json"
    },
    "temporalCoverage": {
      "@context": {
        "startDate": {
          "@id": "dct:start",
          "@type": "http://www.w3.org/2001/XMLSchema#dateTime"
        },
        "endDate": {
          "@id": "dct:end",
          "@type": "http://www.w3.org/2001/XMLSchema#dateTime"
        }
      },
      "@id": "dct:temporal"
    },
    "coordinateReferenceSystem": {
      "@id": "geocr:coordinateReferenceSystem",
      "@type": "@id"
    },
    "crs": {
      "@id": "geocr:crs",
      "@type": "@id"
    },
    "epsgCode": "geocr:epsgCode",
    "wkt": "geo:asWKT",
    "wkt2": "geocr:wkt2",
    "stacVersion": "geocr:stacVersion",
    "stacExtensions": {
      "@id": "geocr:stacExtensions",
      "@type": "@json"
    },
    "proj": {
      "@context": {
        "type": {},
        "id": {},
        "name": {}
      },
      "@id": "geocr:proj"
    },
    "geocr": "http://mlcommons.org/geocroissant/",
    "geo": "http://www.opengis.net/ont/geosparql#",
    "dct": "http://purl.org/dc/terms/",
    "@version": 1.1
  }
}
```

You can find the full JSON-LD context here:
[context.jsonld](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/geocroissant/context.jsonld)

## Sources

* [ZOO-Project GeoCroissant Converters](https://github.com/ZOO-Project/dcai)
* [Croissant Format Specification v1.0](https://docs.mlcommons.org/croissant/docs/croissant-spec.html)
* [STAC Specification](https://stacspec.org/)
* [GeoDCAT-AP Specification](https://semiceu.github.io/GeoDCAT-AP/)
* [OGC GeoSPARQL](http://www.opengis.net/doc/IS/geosparql/1.0)
* [OGC Training Data Markup Language (TDML)](https://docs.ogc.org/DRAFTS/17-049r1.html)

# For developers

The source code for this Building Block can be found in the following repository:

* URL: [https://github.com/GeoLabs/bblocks-croissant](https://github.com/GeoLabs/bblocks-croissant)
* Path: `_sources/geocroissant`

