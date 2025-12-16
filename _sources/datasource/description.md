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
