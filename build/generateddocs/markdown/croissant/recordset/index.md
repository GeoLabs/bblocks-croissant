
# Croissant RecordSet (Schema)

`mlc.croissant.recordset` *v1.0*

Describes a set of structured records with typed fields in a Croissant dataset

[*Status*](http://www.opengis.net/def/status): Under development

## Description

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

## Examples

### Simple Tabular RecordSet
#### json
```json
{
  "@type": "cr:RecordSet",
  "@id": "users",
  "name": "User records",
  "field": [
    {
      "@type": "cr:Field",
      "@id": "users/id",
      "name": "id",
      "dataType": "sc:Integer"
    },
    {
      "@type": "cr:Field",
      "@id": "users/name",
      "name": "name",
      "dataType": "sc:Text"
    }
  ]
}

```

#### jsonld
```jsonld
{
  "@context": "https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/recordset/context.jsonld",
  "@type": "cr:RecordSet",
  "@id": "users",
  "name": "User records",
  "field": [
    {
      "@type": "cr:Field",
      "@id": "users/id",
      "name": "id",
      "dataType": "sc:Integer"
    },
    {
      "@type": "cr:Field",
      "@id": "users/name",
      "name": "name",
      "dataType": "sc:Text"
    }
  ]
}
```

#### ttl
```ttl
@prefix : <https://schema.org/> .
@prefix cr: <http://mlcommons.org/croissant/> .

<file:///github/workspace/users> a cr:RecordSet ;
    cr:field <file:///github/workspace/users/id>,
        <file:///github/workspace/users/name> ;
    :name "User records" .

<file:///github/workspace/users/id> a cr:Field ;
    cr:dataType <sc:Integer> ;
    :name "id" .

<file:///github/workspace/users/name> a cr:Field ;
    cr:dataType <sc:Text> ;
    :name "name" .


```


### RecordSet with Primary Key
#### json
```json
{
  "@type": "cr:RecordSet",
  "@id": "movies",
  "name": "Movie catalog",
  "key": { "@id": "movies/movie_id" },
  "field": [
    {
      "@type": "cr:Field",
      "@id": "movies/movie_id",
      "name": "movie_id",
      "dataType": "sc:Integer"
    },
    {
      "@type": "cr:Field",
      "@id": "movies/title",
      "name": "title",
      "dataType": "sc:Text"
    }
  ]
}

```

#### jsonld
```jsonld
{
  "@context": "https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/recordset/context.jsonld",
  "@type": "cr:RecordSet",
  "@id": "movies",
  "name": "Movie catalog",
  "key": {
    "@id": "movies/movie_id"
  },
  "field": [
    {
      "@type": "cr:Field",
      "@id": "movies/movie_id",
      "name": "movie_id",
      "dataType": "sc:Integer"
    },
    {
      "@type": "cr:Field",
      "@id": "movies/title",
      "name": "title",
      "dataType": "sc:Text"
    }
  ]
}
```

#### ttl
```ttl
@prefix : <https://schema.org/> .
@prefix cr: <http://mlcommons.org/croissant/> .

<file:///github/workspace/movies> a cr:RecordSet ;
    cr:field <file:///github/workspace/movies/movie_id>,
        <file:///github/workspace/movies/title> ;
    cr:key <file:///github/workspace/movies/movie_id> ;
    :name "Movie catalog" .

<file:///github/workspace/movies/title> a cr:Field ;
    cr:dataType <sc:Text> ;
    :name "title" .

<file:///github/workspace/movies/movie_id> a cr:Field ;
    cr:dataType <sc:Integer> ;
    :name "movie_id" .


```

## Schema

```yaml
$schema: https://json-schema.org/draft/2020-12/schema
title: Croissant RecordSet
description: 'A RecordSet describes a set of structured records with typed fields.

  It can represent flat data (like CSV rows) or nested/hierarchical data (like JSON
  structures).

  '
type: object
required:
- '@type'
- '@id'
- field
properties:
  '@type':
    type: string
    const: cr:RecordSet
    description: Must be cr:RecordSet
  '@id':
    type: string
    description: Unique identifier for this RecordSet within the dataset
  name:
    type: string
    description: Human-readable name for this record collection
  description:
    type: string
    description: Description of what these records represent
  field:
    type: array
    description: 'Fields (columns) that appear in the records of this RecordSet.

      Each field describes one data element.

      '
    minItems: 1
    items:
      $ref: '#/$defs/Field'
    x-jsonld-id: http://mlcommons.org/croissant/field
  key:
    description: 'Field(s) whose values uniquely identify each record in the RecordSet.

      Similar to primary keys in relational databases.

      '
    oneOf:
    - type: object
      required:
      - '@id'
      properties:
        '@id':
          type: string
          description: Reference to the key field
    - type: array
      items:
        type: object
        required:
        - '@id'
        properties:
          '@id':
            type: string
      description: Composite key (multiple fields)
    x-jsonld-id: http://mlcommons.org/croissant/key
  data:
    type: array
    description: 'Inline data for small RecordSets (typically enumerations).

      Each array element is a record with keys matching field @id values.

      '
    items:
      type: object
    x-jsonld-id: http://mlcommons.org/croissant/data
    x-jsonld-type: '@json'
  examples:
    description: 'Example records or reference to a data source containing examples.

      Helps users understand the RecordSet without downloading full data.

      '
    oneOf:
    - type: array
      items:
        type: object
    - type: string
      format: uri
    x-jsonld-id: http://mlcommons.org/croissant/examples
    x-jsonld-type: '@json'
  dataType:
    description: 'Semantic type(s) of records in this RecordSet (e.g., sc:GeoCoordinates,
      cr:Split).

      When specified, fields may be mapped to properties of this type.

      '
    oneOf:
    - type: string
      format: uri
    - type: array
      items:
        type: string
        format: uri
    x-jsonld-id: http://mlcommons.org/croissant/dataType
    x-jsonld-type: '@vocab'
$defs:
  Field:
    type: object
    required:
    - '@type'
    - '@id'
    properties:
      '@type':
        type: string
        const: cr:Field
      '@id':
        type: string
        description: Unique identifier for this field
      name:
        type: string
        description: Field name
      description:
        type: string
        description: Field description
      dataType:
        description: Data type(s) of field values
        oneOf:
        - type: string
        - type: array
          items:
            type: string
        x-jsonld-id: http://mlcommons.org/croissant/dataType
        x-jsonld-type: '@vocab'
      source:
        description: Source of data for this field
        oneOf:
        - type: object
        - type: object
          properties:
            '@id':
              type: string
      references:
        type: object
        properties:
          '@id':
            type: string
        description: Foreign key reference to another field
      repeated:
        type: boolean
        description: Whether this field contains a list of values
      subField:
        type: array
        description: Nested fields for hierarchical data
        items:
          $ref: '#/$defs/Field'
examples:
- title: Simple tabular RecordSet
  content: RecordSet for CSV data with basic fields
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:RecordSet\",\n  \"@id\": \"users\",\n  \"name\": \"User
      records\",\n  \"field\": [\n    {\n      \"@type\": \"cr:Field\",\n      \"@id\":
      \"users/id\",\n      \"name\": \"id\",\n      \"dataType\": \"sc:Integer\",\n
      \     \"source\": {\n        \"fileObject\": { \"@id\": \"users.csv\" },\n        \"extract\":
      { \"column\": \"user_id\" }\n      }\n    },\n    {\n      \"@type\": \"cr:Field\",\n
      \     \"@id\": \"users/name\",\n      \"name\": \"name\",\n      \"dataType\":
      \"sc:Text\",\n      \"source\": {\n        \"fileObject\": { \"@id\": \"users.csv\"
      },\n        \"extract\": { \"column\": \"full_name\" }\n      }\n    }\n  ]\n}\n"
- title: RecordSet with primary key
  content: Defining a unique key for records
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:RecordSet\",\n  \"@id\": \"movies\",\n  \"name\":
      \"Movie catalog\",\n  \"key\": { \"@id\": \"movies/movie_id\" },\n  \"field\":
      [\n    {\n      \"@type\": \"cr:Field\",\n      \"@id\": \"movies/movie_id\",\n
      \     \"dataType\": \"sc:Integer\"\n    },\n    {\n      \"@type\": \"cr:Field\",\n
      \     \"@id\": \"movies/title\",\n      \"dataType\": \"sc:Text\"\n    }\n  ]\n}\n"
- title: Enumeration RecordSet
  content: Small RecordSet with inline data
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:RecordSet\",\n  \"@id\": \"categories\",\n  \"name\":
      \"Product categories\",\n  \"dataType\": \"sc:Enumeration\",\n  \"key\": { \"@id\":
      \"categories/code\" },\n  \"field\": [\n    {\n      \"@type\": \"cr:Field\",\n
      \     \"@id\": \"categories/code\",\n      \"dataType\": \"sc:Text\"\n    },\n
      \   {\n      \"@type\": \"cr:Field\",\n      \"@id\": \"categories/label\",\n
      \     \"dataType\": \"sc:Text\"\n    }\n  ],\n  \"data\": [\n    { \"categories/code\":
      \"A\", \"categories/label\": \"Electronics\" },\n    { \"categories/code\":
      \"B\", \"categories/label\": \"Books\" }\n  ]\n}\n"
x-jsonld-vocab: https://schema.org/
x-jsonld-prefixes:
  cr: http://mlcommons.org/croissant/

```

Links to the schema:

* YAML version: [schema.yaml](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/recordset/schema.json)
* JSON version: [schema.json](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/recordset/schema.yaml)


# JSON-LD Context

```jsonld
{
  "@context": {
    "@vocab": "https://schema.org/",
    "@type": {
      "@context": {}
    },
    "@id": {
      "@context": {}
    },
    "field": {
      "@context": {
        "@type": {
          "@context": {}
        },
        "@id": {
          "@context": {}
        }
      },
      "@id": "cr:field"
    },
    "key": {
      "@context": {
        "@id": {
          "@context": {}
        }
      },
      "@id": "cr:key"
    },
    "data": {
      "@id": "cr:data",
      "@type": "@json"
    },
    "examples": {
      "@id": "cr:examples",
      "@type": "@json"
    },
    "dataType": {
      "@id": "cr:dataType",
      "@type": "@vocab"
    },
    "cr": "http://mlcommons.org/croissant/",
    "@version": 1.1
  }
}
```

You can find the full JSON-LD context here:
[context.jsonld](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/recordset/context.jsonld)

## Sources

* [Croissant Format Specification v1.0 - RecordSet](https://docs.mlcommons.org/croissant/docs/croissant-spec.html#recordset)

# For developers

The source code for this Building Block can be found in the following repository:

* URL: [https://github.com/GeoLabs/bblocks-croissant](https://github.com/GeoLabs/bblocks-croissant)
* Path: `_sources/recordset`

