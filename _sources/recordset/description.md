## Croissant RecordSet

A RecordSet describes a collection of structured data records with a defined schema. It's the core abstraction for representing data structure in Croissant, supporting everything from simple tabular data to complex hierarchical structures.

### Key Features

- **Flexible Schema**: Defines fields with data types and sources
- **Flat & Hierarchical**: Supports both simple tables and nested data
- **Primary Keys**: Can define unique identifiers for records
- **Foreign Keys**: Fields can reference other RecordSets
- **Inline Data**: Small RecordSets can embed data directly
- **Semantic Types**: Records can have semantic meanings (e.g., GeoCoordinates, Split)

### Properties

#### Required Properties
- `@type`: Must be `cr:RecordSet`
- `@id`: Unique identifier within the dataset
- `field`: Array of Field definitions (at least one)

#### Core Properties
- `name`: Human-readable name
- `description`: What these records represent
- `key`: Field(s) that uniquely identify records

#### Data Properties
- `data`: Inline record data for small enumerations
- `examples`: Sample records to illustrate structure
- `dataType`: Semantic type(s) of records

### Common Patterns

#### Tabular Data (CSV/TSV)
Most common use case - representing table rows:
```json
{
  "@type": "cr:RecordSet",
  "@id": "transactions",
  "field": [
    {
      "@id": "transactions/date",
      "dataType": "sc:Date",
      "source": {
        "fileObject": { "@id": "data.csv" },
        "extract": { "column": "transaction_date" }
      }
    },
    {
      "@id": "transactions/amount",
      "dataType": "sc:Float",
      "source": {
        "fileObject": { "@id": "data.csv" },
        "extract": { "column": "amount_usd" }
      }
    }
  ]
}
```

#### Image Records
Each image as a record:
```json
{
  "@type": "cr:RecordSet",
  "@id": "images",
  "key": { "@id": "images/filename" },
  "field": [
    {
      "@id": "images/filename",
      "dataType": "sc:Text",
      "source": {
        "fileSet": { "@id": "image-files" },
        "extract": { "fileProperty": "filename" }
      }
    },
    {
      "@id": "images/content",
      "dataType": "sc:ImageObject",
      "source": {
        "fileSet": { "@id": "image-files" },
        "extract": { "fileProperty": "content" }
      }
    }
  ]
}
```

#### Enumerations
Small sets of categorical values:
```json
{
  "@type": "cr:RecordSet",
  "@id": "categories",
  "dataType": "sc:Enumeration",
  "key": { "@id": "categories/id" },
  "field": [
    { "@id": "categories/id", "dataType": "sc:Integer" },
    { "@id": "categories/name", "dataType": "sc:Text" }
  ],
  "data": [
    { "categories/id": 1, "categories/name": "cat" },
    { "categories/id": 2, "categories/name": "dog" }
  ]
}
```

#### With Foreign Keys
Linking to other RecordSets:
```json
{
  "@type": "cr:RecordSet",
  "@id": "reviews",
  "field": [
    {
      "@id": "reviews/product_id",
      "dataType": "sc:Integer",
      "references": { "@id": "products/id" },
      "source": { ... }
    },
    {
      "@id": "reviews/rating",
      "dataType": "sc:Integer",
      "source": { ... }
    }
  ]
}
```

### Key Concepts

#### Primary Keys
Use `key` to specify which field(s) uniquely identify records:
```json
"key": { "@id": "users/user_id" }
```

For composite keys:
```json
"key": [
  { "@id": "orders/customer_id" },
  { "@id": "orders/order_number" }
]
```

#### Semantic Types
Apply meaning to entire RecordSets:
```json
{
  "@type": "cr:RecordSet",
  "@id": "locations",
  "dataType": "sc:GeoCoordinates",
  "field": [
    { "@id": "locations/latitude", "dataType": "sc:Float" },
    { "@id": "locations/longitude", "dataType": "sc:Float" }
  ]
}
```

Common semantic types:
- `sc:Enumeration`: Categorical values
- `cr:Split`: ML data splits (train/val/test)
- `cr:Label`: Annotation/label data
- `sc:GeoCoordinates`: Geographic locations
- Wikidata URLs (e.g., `wd:Q48277` for gender)

### Advanced Features

#### Nested Fields
Fields can contain subfields for hierarchical data:
```json
{
  "@id": "records/address",
  "dataType": "sc:PostalAddress",
  "subField": [
    { "@id": "records/address/street" },
    { "@id": "records/address/city" }
  ]
}
```

#### Repeated Fields
Fields that contain lists:
```json
{
  "@id": "articles/authors",
  "dataType": "sc:Text",
  "repeated": true
}
```

### Best Practices

1. **Choose meaningful IDs**: Use descriptive identifiers like `users/email` not `field1`
2. **Define keys**: Always specify keys for RecordSets that will be referenced
3. **Use appropriate data types**: Select types that match your data semantics
4. **Document with descriptions**: Help users understand what records represent
5. **Inline small enumerations**: Use `data` for categories, labels, etc.
6. **Reference, don't duplicate**: Use foreign keys instead of duplicating data

### Related Building Blocks

- **Field**: Defines individual columns/attributes in records
- **DataSource**: Specifies where field data comes from
- **FileObject/FileSet**: Sources that RecordSets extract data from
- **Dataset**: Contains RecordSets in its `recordSet` property
