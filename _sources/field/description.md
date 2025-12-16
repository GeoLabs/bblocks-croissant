## Croissant Field

A Field represents a single data element (column, attribute, or property) within a RecordSet. Fields define the schema of structured data, specify data types, and describe how to extract and transform values from data sources.

### Key Features

- **Typed Data**: Supports both atomic types (Integer, Text) and semantic types (ImageObject, GeoCoordinates)
- **Data Extraction**: Specifies where field values come from (files, columns, properties)
- **Transformations**: Can apply regex, parsing, and formatting to source data
- **Relationships**: Can reference other fields (foreign keys)
- **Nested Structures**: Supports hierarchical data via subFields
- **Lists**: Can represent repeated values (arrays)

### Properties

#### Required Properties
- `@type`: Must be `cr:Field`
- `@id`: Unique identifier (conventionally prefixed with RecordSet ID)

#### Core Properties
- `name`: Human-readable field name
- `description`: What this field represents
- `dataType`: Type(s) of values (sc:Integer, sc:Text, sc:ImageObject, etc.)

#### Data Properties
- `source`: Where the data comes from (DataSource or field reference)
- `references`: Foreign key to another field/RecordSet
- `repeated`: Boolean indicating if field contains a list
- `subField`: Nested fields for hierarchical data

### Data Types

#### Atomic Types
Common schema.org types:
- `sc:Boolean` - True/false values
- `sc:Integer` - Whole numbers
- `sc:Float` - Decimal numbers
- `sc:Text` - Text strings
- `sc:Date` - Dates
- `sc:DateTime` - Dates with times
- `sc:URL` - URLs

#### Semantic Types
ML and domain-specific types:
- `sc:ImageObject` - Image content (pixels)
- `sc:AudioObject` - Audio content
- `sc:VideoObject` - Video content
- `cr:BoundingBox` - Bounding box coordinates
- `cr:SegmentationMask` - Segmentation masks
- `cr:Label` - Annotation/label data
- `sc:GeoCoordinates` - Geographic locations

#### Multiple Types
Fields can have multiple types for richer semantics:
```json
{
  "@id": "passengers/survived",
  "dataType": ["sc:Integer", "cr:Label"]
}
```

### Common Patterns

#### Simple Column Extraction
```json
{
  "@type": "cr:Field",
  "@id": "users/age",
  "dataType": "sc:Integer",
  "source": {
    "fileObject": { "@id": "data.csv" },
    "extract": { "column": "age" }
  }
}
```

#### File Property Extraction
```json
{
  "@type": "cr:Field",
  "@id": "images/filename",
  "dataType": "sc:Text",
  "source": {
    "fileSet": { "@id": "images" },
    "extract": { "fileProperty": "filename" }
  }
}
```

#### With Regex Transformation
```json
{
  "@type": "cr:Field",
  "@id": "images/split",
  "dataType": "sc:Text",
  "source": {
    "fileSet": { "@id": "images" },
    "extract": { "fileProperty": "fullpath" },
    "transform": { "regex": "^(train|test|val)/" }
  }
}
```

#### Foreign Key Reference
```json
{
  "@type": "cr:Field",
  "@id": "orders/customer_id",
  "dataType": "sc:Integer",
  "references": { "@id": "customers/id" },
  "source": { ... }
}
```

#### Nested Fields
```json
{
  "@type": "cr:Field",
  "@id": "locations/coordinates",
  "dataType": "sc:GeoCoordinates",
  "subField": [
    {
      "@type": "cr:Field",
      "@id": "locations/coordinates/latitude",
      "dataType": "sc:Float"
    },
    {
      "@type": "cr:Field",
      "@id": "locations/coordinates/longitude",
      "dataType": "sc:Float"
    }
  ]
}
```

#### Repeated Field (List)
```json
{
  "@type": "cr:Field",
  "@id": "articles/authors",
  "dataType": "sc:Text",
  "repeated": true,
  "source": { ... }
}
```

### Data Sources

Fields specify their data source through a `source` property, which can be:

1. **Simple reference**: `{ "@id": "other/field" }`
2. **DataSource object** with:
   - `fileObject`, `fileSet`, or `recordSet`: The source
   - `extract`: How to get the data
   - `transform`: Optional transformations
   - `format`: Optional parsing format

#### Extract Methods

For different source types:

| Source Type | Extract Options |
|-------------|----------------|
| CSV/TSV | `column: "column_name"` |
| FileObject/FileSet | `fileProperty: "fullpath"/"filename"/"content"/"lines"/"lineNumbers"` |
| JSON | `jsonPath: "$.path.to.value"` |

#### Transform Options

- `regex`: Extract using regular expression
- `delimiter`: Split string into array
- `jsonQuery`: Query JSON data

#### Format Strings

For parsing typed values:
- Dates: `"yyyy-MM-dd"`, `"MM/dd/yyyy"`
- Numbers: `"0.##E0"` (scientific notation)
- BoundingBoxes: `"CENTER_XYWH"`, `"XYXY"`

### Best Practices

1. **Use descriptive IDs**: Prefix with RecordSet ID (e.g., `users/email`)
2. **Choose precise types**: Select the most specific data type
3. **Document fields**: Always provide `description`
4. **Apply semantic types**: Use types like `cr:Label`, `sc:ImageObject` for ML features
5. **Reference, don't duplicate**: Use `references` for foreign keys
6. **Keep transformations simple**: Complex logic should be pre-processed

### Advanced Features

#### Field Reference (Join)
Instead of a DataSource, directly reference another field:
```json
{
  "@id": "ratings/movie_title",
  "source": { "@id": "movies/title" }
}
```

#### Equivalent Properties
Map fields to semantic properties:
```json
{
  "@id": "locations/lat",
  "equivalentProperty": "sc:latitude"
}
```

This is used when the RecordSet has a `dataType` with known properties.

### Related Building Blocks

- **RecordSet**: Contains Fields to define record schema
- **DataSource**: Detailed specification for field sources
- **FileObject/FileSet**: Source files that fields extract from
- **Dataset**: Top-level container organizing RecordSets with Fields
