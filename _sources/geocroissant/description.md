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
