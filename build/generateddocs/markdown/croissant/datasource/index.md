
# Croissant DataSource (Schema)

`mlc.croissant.datasource` *v1.0*

Specifies how to extract and transform data from files for Croissant fields

[*Status*](http://www.opengis.net/def/status): Under development

## Description

## Croissant DataSource

DataSource specifies how to extract, transform, and format data from files to populate fields in a RecordSet. It's a powerful abstraction that handles the complexity of reading data from heterogeneous sources.

### Key Features

- **Multiple Source Types**: CSV, JSON, FileSet, FileObject, other RecordSets
- **Flexible Extraction**: Column names, file properties, JSONPath expressions
- **Data Transformations**: Regex, string splitting, replacements
- **Type Parsing**: Format strings for dates, numbers, coordinates

### Structure

A DataSource consists of three main parts:

1. **Source**: What to read from (`fileObject`, `fileSet`, or `recordSet`)
2. **Extract**: How to get the data (column, file property, JSONPath)
3. **Transform** (optional): How to modify the data (regex, delimiter)
4. **Format** (optional): How to parse into typed values

### Source Types

#### FileObject Source
Read from a specific file:
```json
{
  "fileObject": { "@id": "data.csv" }
}
```

#### FileSet Source
Read from each file in a collection:
```json
{
  "fileSet": { "@id": "image-files" }
}
```

#### RecordSet Source
Reference another RecordSet (for joins):
```json
{
  "recordSet": { "@id": "metadata" }
}
```

### Extraction Methods

Different extraction methods for different source types:

#### CSV/TSV Files
```json
{
  "fileObject": { "@id": "data.csv" },
  "extract": { "column": "column_name" }
}
```

#### File Properties
For FileObject or FileSet:

```json
{
  "fileSet": { "@id": "images" },
  "extract": { "fileProperty": "filename" }
}
```

Available file properties:
- `fullpath`: Complete path (e.g., `train/images/img001.jpg`)
- `filename`: Just the name (e.g., `img001.jpg`)
- `content`: Binary/text content
- `lines`: Content split by newlines
- `lineNumbers`: Line numbers (0-indexed)

#### JSON Data
```json
{
  "fileObject": { "@id": "annotations.json" },
  "extract": { "jsonPath": "$.images[*].id" }
}
```

### Transformations

Apply operations to extracted data:

#### Regex Extraction
Extract parts of strings using regular expressions:
```json
{
  "extract": { "fileProperty": "filename" },
  "transform": { "regex": "image_([0-9]+)\\.jpg" }
}
```

Captures the number from `image_123.jpg` → `123`

#### String Splitting
Convert delimited strings to arrays:
```json
{
  "extract": { "column": "tags" },
  "transform": { "delimiter": "," }
}
```

Converts `"tag1,tag2,tag3"` → `["tag1", "tag2", "tag3"]`

#### String Replacement
Replace patterns in strings:
```json
{
  "transform": {
    "replace": {
      "pattern": "old_value",
      "replacement": "new_value"
    }
  }
}
```

#### Multiple Transformations
Apply transformations in sequence:
```json
{
  "transform": [
    { "regex": "^(train|val)/" },
    { "replace": { "pattern": "val", "replacement": "validation" } }
  ]
}
```

### Format Strings

Parse typed values from text:

#### Dates and Times
```json
{
  "extract": { "column": "created_at" },
  "format": "yyyy-MM-dd HH:mm:ss"
}
```

Common patterns:
- `yyyy-MM-dd` → `2025-12-16`
- `MM/dd/yyyy` → `12/16/2025`
- `yyyy-MM-dd'T'HH:mm:ss'Z'` → `2025-12-16T10:30:00Z`

#### Numbers
```json
{
  "extract": { "column": "scientific_value" },
  "format": "0.##E0"
}
```

Parses scientific notation like `1.5E10`

#### Bounding Boxes
```json
{
  "extract": { "column": "bbox" },
  "format": "CENTER_XYWH"
}
```

Formats:
- `XYWH`: [x, y, width, height]
- `XYXY`: [x1, y1, x2, y2]
- `CENTER_XYWH`: [center_x, center_y, width, height]

### Common Patterns

#### Simple CSV Column
```json
{
  "fileObject": { "@id": "users.csv" },
  "extract": { "column": "email" }
}
```

#### Image Content
```json
{
  "fileSet": { "@id": "training-images" },
  "extract": { "fileProperty": "content" }
}
```

#### Extract Split from Path
```json
{
  "fileSet": { "@id": "all-images" },
  "extract": { "fileProperty": "fullpath" },
  "transform": { "regex": "^(train|val|test)/" }
}
```

#### Parse Date
```json
{
  "fileObject": { "@id": "events.csv" },
  "extract": { "column": "timestamp" },
  "format": "yyyy-MM-dd"
}
```

#### JSON Nested Data
```json
{
  "fileObject": { "@id": "coco_annotations.json" },
  "extract": { "jsonPath": "$.annotations[*].bbox" }
}
```

### Best Practices

1. **Keep transforms simple**: Complex logic should be pre-processing
2. **Document regex patterns**: Add comments explaining what they match
3. **Use appropriate formats**: Match format strings to actual data
4. **Test extractions**: Verify patterns work on sample data
5. **Prefer standard formats**: Use ISO 8601 for dates when possible

### Performance Considerations

- **Large files**: JSONPath on huge files can be slow
- **Complex regex**: Keep patterns simple for performance
- **Multiple transforms**: Each adds processing time

### Error Handling

What happens when:
- **Column not found**: Error - column must exist
- **Regex no match**: Returns empty/null
- **Format mismatch**: Error - data must match format
- **JSONPath no results**: Returns empty array

### Related Building Blocks

- **Field**: Uses DataSource to specify where data comes from
- **FileObject**: Common source for DataSource
- **FileSet**: Used when extracting from file collections
- **RecordSet**: Contains fields that use DataSources

## Schema

```yaml
$schema: https://json-schema.org/draft/2020-12/schema
title: Croissant DataSource
description: 'DataSource describes how to extract and optionally transform data from
  files

  to populate RecordSet fields. It specifies the source, extraction method,

  transformations, and parsing formats.

  '
type: object
properties:
  fileObject:
    type: object
    required:
    - '@id'
    properties:
      '@id':
        type: string
        description: Reference to the source FileObject
    x-jsonld-id: http://mlcommons.org/croissant/fileObject
  fileSet:
    type: object
    required:
    - '@id'
    properties:
      '@id':
        type: string
        description: Reference to the source FileSet
    x-jsonld-id: http://mlcommons.org/croissant/fileSet
  recordSet:
    type: object
    required:
    - '@id'
    properties:
      '@id':
        type: string
        description: Reference to another RecordSet as source
    x-jsonld-id: http://mlcommons.org/croissant/recordSet
  extract:
    type: object
    description: 'Specifies how to extract data from the source. Different properties

      are used depending on the source type (CSV, JSON, file properties, etc.)

      '
    properties:
      column:
        type: string
        description: Column name for CSV/TSV files
        x-jsonld-id: http://mlcommons.org/croissant/column
      fileProperty:
        type: string
        enum:
        - fullpath
        - filename
        - content
        - lines
        - lineNumbers
        description: 'Property of FileObject/FileSet to extract:

          - fullpath: Full path to the file (e.g., "data/train/img.jpg")

          - filename: Just the filename (e.g., "img.jpg")

          - content: Binary/text content of the file

          - lines: Content split by lines

          - lineNumbers: Line numbers (0-indexed)

          '
        x-jsonld-id: http://mlcommons.org/croissant/fileProperty
      jsonPath:
        type: string
        description: JSONPath expression for extracting from JSON files
        x-jsonld-id: http://mlcommons.org/croissant/jsonPath
    x-jsonld-id: http://mlcommons.org/croissant/extract
  transform:
    type: object
    description: 'Transformations to apply to extracted data.

      '
    properties:
      regex:
        type: string
        description: 'Regular expression to extract or parse data.

          Captured groups are returned. If no groups, the entire match is returned.

          '
        x-jsonld-id: http://mlcommons.org/croissant/regex
      delimiter:
        type: string
        description: Character to split strings into arrays
        x-jsonld-id: http://mlcommons.org/croissant/delimiter
      jsonQuery:
        type: string
        description: JSON query to evaluate on JSON data
      replace:
        type: object
        description: String replacement
        properties:
          pattern:
            type: string
          replacement:
            type: string
      separator:
        type: string
        description: Deprecated - use delimiter instead
        x-jsonld-id: http://mlcommons.org/croissant/separator
    x-jsonld-id: http://mlcommons.org/croissant/transform
  format:
    type: string
    description: 'Format string for parsing extracted values into typed data.

      Examples:

      - Date/DateTime: "yyyy-MM-dd", "MM/dd/yyyy HH:mm:ss"

      - Numbers: "0.##E0" (scientific notation)

      - BoundingBox: "CENTER_XYWH", "XYXY"

      '
    x-jsonld-id: http://mlcommons.org/croissant/format
examples:
- title: Extract CSV column
  content: Basic extraction from a CSV file
  snippets:
  - language: json
    code: "{\n  \"fileObject\": { \"@id\": \"data.csv\" },\n  \"extract\": { \"column\":
      \"user_name\" }\n}\n"
- title: Extract filename from FileSet
  content: Get filenames from a collection of files
  snippets:
  - language: json
    code: "{\n  \"fileSet\": { \"@id\": \"images\" },\n  \"extract\": { \"fileProperty\":
      \"filename\" }\n}\n"
- title: Regex transformation
  content: Extract part of a filename using regex
  snippets:
  - language: json
    code: "{\n  \"fileSet\": { \"@id\": \"images\" },\n  \"extract\": { \"fileProperty\":
      \"filename\" },\n  \"transform\": {\n    \"regex\": \"img_([0-9]+)\\\\.jpg\"\n
      \ }\n}\n"
- title: Extract with date parsing
  content: Parse a date column with specific format
  snippets:
  - language: json
    code: "{\n  \"fileObject\": { \"@id\": \"events.csv\" },\n  \"extract\": { \"column\":
      \"event_date\" },\n  \"format\": \"yyyy-MM-dd\"\n}\n"
- title: JSONPath extraction
  content: Extract nested values from JSON
  snippets:
  - language: json
    code: "{\n  \"fileObject\": { \"@id\": \"metadata.json\" },\n  \"extract\": {
      \"jsonPath\": \"$.annotations[*].category\" }\n}\n"
- title: Multiple transformations
  content: Apply several transformations in sequence
  snippets:
  - language: json
    code: "{\n  \"fileSet\": { \"@id\": \"images\" },\n  \"extract\": { \"fileProperty\":
      \"fullpath\" },\n  \"transform\": [\n    { \"regex\": \"^(train|val|test)/\"
      },\n    { \"replace\": { \"pattern\": \"val\", \"replacement\": \"validation\"
      } }\n  ]\n}\n"
- title: Split string into array
  content: Convert delimited string to array
  snippets:
  - language: json
    code: "{\n  \"fileObject\": { \"@id\": \"tags.csv\" },\n  \"extract\": { \"column\":
      \"tag_list\" },\n  \"transform\": { \"delimiter\": \",\" }\n}\n"
x-jsonld-vocab: https://schema.org/
x-jsonld-prefixes:
  cr: http://mlcommons.org/croissant/

```

Links to the schema:

* YAML version: [schema.yaml](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/datasource/schema.json)
* JSON version: [schema.json](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/datasource/schema.yaml)


# JSON-LD Context

```jsonld
{
  "@context": {
    "@vocab": "https://schema.org/",
    "fileObject": {
      "@context": {
        "@id": {
          "@context": {}
        }
      },
      "@id": "cr:fileObject"
    },
    "fileSet": {
      "@context": {
        "@id": {
          "@context": {}
        }
      },
      "@id": "cr:fileSet"
    },
    "recordSet": {
      "@context": {
        "@id": {
          "@context": {}
        }
      },
      "@id": "cr:recordSet"
    },
    "extract": {
      "@context": {
        "column": "cr:column",
        "fileProperty": "cr:fileProperty",
        "jsonPath": "cr:jsonPath"
      },
      "@id": "cr:extract"
    },
    "transform": {
      "@context": {
        "regex": "cr:regex",
        "delimiter": "cr:delimiter",
        "jsonQuery": {},
        "pattern": {},
        "replacement": {},
        "replace": {},
        "separator": "cr:separator"
      },
      "@id": "cr:transform"
    },
    "format": "cr:format",
    "cr": "http://mlcommons.org/croissant/",
    "@version": 1.1
  }
}
```

You can find the full JSON-LD context here:
[context.jsonld](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/datasource/context.jsonld)

## Sources

* [Croissant Format Specification v1.0 - DataSource](https://docs.mlcommons.org/croissant/docs/croissant-spec.html#datasource)

# For developers

The source code for this Building Block can be found in the following repository:

* URL: [https://github.com/GeoLabs/bblocks-croissant](https://github.com/GeoLabs/bblocks-croissant)
* Path: `_sources/datasource`

