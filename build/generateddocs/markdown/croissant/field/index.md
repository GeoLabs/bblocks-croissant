
# Croissant Field (Schema)

`mlc.croissant.field` *v1.0*

Represents a data element (column) within a Croissant RecordSet

[*Status*](http://www.opengis.net/def/status): Under development

## Description

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

## Schema

```yaml
$schema: https://json-schema.org/draft/2020-12/schema
title: Croissant Field
description: 'A Field is a data element within a RecordSet. It may represent a column
  of a table,

  a nested data structure, or even a nested RecordSet for hierarchical data.

  '
type: object
required:
- '@type'
- '@id'
properties:
  '@type':
    type: string
    const: cr:Field
    description: Must be cr:Field
  '@id':
    type: string
    description: 'Unique identifier for this field. Should be prefixed with the RecordSet
      @id

      (e.g., "users/email" for an email field in the users RecordSet)

      '
  name:
    type: string
    description: Human-readable name for this field
  description:
    type: string
    description: Description of what this field represents
  dataType:
    description: 'Data type(s) of field values. Can be atomic types (sc:Integer, sc:Text,
      etc.)

      or semantic types (sc:ImageObject, cr:BoundingBox, etc.).

      Multiple types can be specified for richer semantics.

      '
    oneOf:
    - type: string
      description: Single data type URI
    - type: array
      items:
        type: string
      description: Multiple data types
    x-jsonld-id: http://mlcommons.org/croissant/dataType
    x-jsonld-type: '@vocab'
  source:
    description: 'The data source of the field. Can be a reference to another field
      (@id),

      or omitted if data source is defined elsewhere.

      '
    type: object
    required:
    - '@id'
    properties:
      '@id':
        type: string
        description: Reference to another field or RecordSet
    x-jsonld-id: http://mlcommons.org/croissant/source
  references:
    type: object
    required:
    - '@id'
    properties:
      '@id':
        type: string
    description: 'Foreign key reference to another field in another RecordSet.

      Similar to foreign keys in relational databases.

      '
    x-jsonld-id: http://mlcommons.org/croissant/references
  repeated:
    type: boolean
    default: false
    description: 'If true, this field contains a list of values of the specified dataType,

      rather than a single value.

      '
    x-jsonld-id: http://mlcommons.org/croissant/repeated
  equivalentProperty:
    description: 'Maps this field to a property of the RecordSet''s dataType.

      Used when the field @id doesn''t match the property name.

      '
    oneOf:
    - type: string
      format: uri
    - type: array
      items:
        type: string
        format: uri
    x-jsonld-id: http://mlcommons.org/croissant/equivalentProperty
examples:
- title: Simple text field
  content: A basic field with text data type
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:Field\",\n  \"@id\": \"users/name\",\n  \"name\":
      \"name\",\n  \"description\": \"User's full name\",\n  \"dataType\": \"sc:Text\"\n}\n"
- title: Field with foreign key reference
  content: A field that references another RecordSet
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:Field\",\n  \"@id\": \"orders/customer_id\",\n  \"name\":
      \"customer_id\",\n  \"dataType\": \"sc:Integer\",\n  \"source\": { \"@id\":
      \"customers/id\" },\n  \"references\": { \"@id\": \"customers/id\" }\n}\n"
- title: Image content field
  content: Field containing image data
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:Field\",\n  \"@id\": \"images/content\",\n  \"name\":
      \"content\",\n  \"description\": \"The image pixels\",\n  \"dataType\": \"sc:ImageObject\"\n}\n"
- title: Repeated field (list)
  content: A field containing multiple values
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:Field\",\n  \"@id\": \"articles/tags\",\n  \"name\":
      \"tags\",\n  \"dataType\": \"sc:Text\",\n  \"repeated\": true\n}\n"
x-jsonld-extra-terms:
  subField: http://mlcommons.org/croissant/subField
  parentField: http://mlcommons.org/croissant/parentField
x-jsonld-vocab: https://schema.org/
x-jsonld-prefixes:
  cr: http://mlcommons.org/croissant/

```

Links to the schema:

* YAML version: [schema.yaml](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/field/schema.json)
* JSON version: [schema.json](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/field/schema.yaml)


# JSON-LD Context

```jsonld
{
  "@context": {
    "@vocab": "https://schema.org/",
    "subField": "cr:subField",
    "parentField": "cr:parentField",
    "@type": {
      "@context": {}
    },
    "@id": {
      "@context": {}
    },
    "dataType": {
      "@id": "cr:dataType",
      "@type": "@vocab"
    },
    "source": {
      "@context": {
        "@id": {
          "@context": {}
        }
      },
      "@id": "cr:source"
    },
    "references": {
      "@context": {
        "@id": {
          "@context": {}
        }
      },
      "@id": "cr:references"
    },
    "repeated": "cr:repeated",
    "equivalentProperty": "cr:equivalentProperty",
    "cr": "http://mlcommons.org/croissant/",
    "@version": 1.1
  }
}
```

You can find the full JSON-LD context here:
[context.jsonld](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/field/context.jsonld)

## Sources

* [Croissant Format Specification v1.0 - Field](https://docs.mlcommons.org/croissant/docs/croissant-spec.html#field)

# For developers

The source code for this Building Block can be found in the following repository:

* URL: [https://github.com/GeoLabs/bblocks-croissant](https://github.com/GeoLabs/bblocks-croissant)
* Path: `_sources/field`

