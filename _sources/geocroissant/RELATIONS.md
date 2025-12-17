# GeoCroissant Building Block Relations

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    MLCommons Croissant                       │
│                  (Base ML Dataset Format)                    │
└──────────────────────┬──────────────────────────────────────┘
                       │ extends
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              mlc.croissant.geocroissant                      │
│         (Geospatial Extension for ML Datasets)               │
└─────┬────────────────┬───────────────┬──────────────────────┘
      │                │               │
      │ depends on     │ relates to    │ compatible with
      ▼                ▼               ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────────┐
│ OGC Building │  │   GeoDCAT    │  │      STAC        │
│    Blocks    │  │   Profile    │  │   Spec v1.x      │
└──────────────┘  └──────────────┘  └──────────────────┘
```

## Building Block Dependencies

### Direct Dependencies
- **mlc.croissant.dataset** - Base Croissant dataset schema
- **ogc.geo.common.data_types.geojson** - GeoJSON geometry types
- **ogc.geo.common.data_types.bounding_box** - Bounding box definitions

### Related Standards (seeAlso)
- **ogc.contrib.stac.collection** - STAC Collection schema
- **ogc.geo.geodcat.geodcat** - GeoDCAT profile
- **ogc.geo.geodcat.stac.geodcat-stac-collection** - STAC to GeoDCAT mapping
- **ogc.api.records.v1.schemas.time** - Temporal extent from OGC API Records

## Conversion Pathways

```
                    GeoCroissant
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
    STAC Item      GeoDCAT RDF     OGC API Records
        │                │                │
        ├────────────────┴────────────────┤
        │                                 │
        ▼                                 ▼
  STAC Collection              GeoDCAT-STAC Mapping
                                          │
                                          ▼
                                   NASA UMM-G
                                   OGC TDML
```

## Namespace Relationships

| Prefix | Namespace URI | Source |
|--------|---------------|--------|
| `geocr:` | http://mlcommons.org/geocroissant/ | This extension |
| `cr:` | http://mlcommons.org/croissant/ | MLCommons Croissant |
| `geo:` | http://www.opengis.net/ont/geosparql# | OGC GeoSPARQL |
| `dct:` | http://purl.org/dc/terms/ | Dublin Core |
| `dcat:` | http://www.w3.org/ns/dcat# | W3C DCAT |
| `sc:` | https://schema.org/ | Schema.org |

## Property Mappings

### Spatial Properties
| GeoCroissant | OGC/GeoJSON | GeoDCAT | STAC |
|--------------|-------------|---------|------|
| `geocr:boundingBox` | `ogc:bbox` | `dct:spatial` | `bbox` |
| `geocr:spatialCoverage` | GeoJSON geometry | `dcat:spatialResolutionInMeters` | `geometry` |
| `geo:hasGeometry` | GeoJSON | `geo:hasGeometry` | - |
| `geocr:crs` | - | `dct:conformsTo` | `proj:epsg` |

### Temporal Properties
| GeoCroissant | OGC API | GeoDCAT | STAC |
|--------------|---------|---------|------|
| `geocr:temporalExtent` | `time` schema | `dct:temporal` | `datetime` |
| `dct:start` | `start` | `dcat:startDate` | `start_datetime` |
| `dct:end` | `end` | `dcat:endDate` | `end_datetime` |

## Integration Examples

### With STAC Collection
```json
{
  "@context": ["croissant", "geocroissant"],
  "name": "Sentinel-2 Dataset",
  "geocr:boundingBox": [-180, -90, 180, 90],
  "geocr:stacVersion": "1.1.0",
  "geocr:stacExtensions": [
    "https://stac-extensions.github.io/projection/v1.1.0/schema.json"
  ]
}
```

### With GeoDCAT
```json
{
  "@context": ["croissant", "geocroissant"],
  "name": "Earth Observation Dataset",
  "geocr:spatialCoverage": {
    "type": "Polygon",
    "coordinates": [[...]]
  },
  "dct:conformsTo": "http://www.opengis.net/def/crs/EPSG/0/4326"
}
```

### With OGC API Records
```json
{
  "@context": ["croissant", "geocroissant"],
  "name": "Training Dataset",
  "geocr:temporalExtent": {
    "start": "2020-01-01T00:00:00Z",
    "end": "2020-12-31T23:59:59Z"
  }
}
```
