
# Croissant Metadata Format (Schema)

`mlc.croissant` *v1.0*

MLCommons Croissant metadata format for responsible AI datasets

[*Status*](http://www.opengis.net/def/status): Under development

## Description

# Croissant Metadata Format

## Overview

Croissant is a high-level format for machine learning datasets developed by MLCommons. It provides a standardized way to describe ML datasets with:

- **Metadata**: Dataset attribution, licensing, and provenance
- **Resources**: File descriptions and locations
- **Structure**: Data organization and record schemas
- **Semantics**: ML-specific annotations and default interpretations

## Components

This building block collection includes:

- **Dataset**: Main container for dataset metadata
- **FileObject**: Individual file representations
- **FileSet**: Collections of files with glob patterns
- **RecordSet**: Structured data records with typed fields
- **Field**: Individual data elements within records
- **DataSource**: Data extraction and transformation specifications

## Use Cases

- Publishing ML datasets with comprehensive metadata
- Discovering and citing datasets for research
- Understanding dataset structure before download
- Automating ML pipeline integration
- Ensuring responsible AI practices through proper attribution

## References

- [Croissant Format Specification](https://github.com/mlcommons/croissant)
- [Croissant v1.0 JSON Schema](https://mlcommons.github.io/croissant/json-schema/1.0/schema.json)
- [MLCommons](https://mlcommons.org/)

## Schema

```yaml
$schema: https://json-schema.org/draft/2020-12/schema
title: Croissant Dataset
description: 'Complete Croissant metadata format for machine learning datasets.

  Extends schema.org/Dataset with ML-specific vocabulary.

  '
type: object
required:
- '@context'
- '@type'
- name
- description
- distribution
properties:
  '@context':
    description: JSON-LD context
    oneOf:
    - type: string
      format: uri
    - type: object
    - type: array
  '@type':
    const: sc:Dataset
    description: Must be sc:Dataset
  '@id':
    type: string
    description: Unique identifier for the dataset
  name:
    type: string
    description: Dataset name
  description:
    type: string
    description: Dataset description
  url:
    type: string
    format: uri
    description: Dataset homepage or repository URL
  distribution:
    type: array
    description: FileObjects and FileSets describing dataset files
    items:
      oneOf:
      - $ref: '#/$defs/FileObject'
      - $ref: '#/$defs/FileSet'
  recordSet:
    type: array
    description: Structured data records within the dataset
    items:
      $ref: '#/$defs/RecordSet'
  conformsTo:
    type: string
    format: uri
    description: Version of Croissant specification (e.g., http://mlcommons.org/croissant/1.0)
  license:
    description: License under which the dataset is released
    oneOf:
    - type: string
      format: uri
    - type: string
  creator:
    description: Dataset author(s) or organization(s)
    oneOf:
    - $ref: '#/$defs/PersonOrOrganization'
    - type: array
      items:
        $ref: '#/$defs/PersonOrOrganization'
  citation:
    description: Scholarly citation for the dataset
    oneOf:
    - type: string
    - type: object
$defs:
  FileObject:
    $ref: https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/fileobject/schema.yaml
  FileSet:
    $ref: https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/fileset/schema.yaml
  RecordSet:
    $ref: https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/recordset/schema.yaml
  Field:
    $ref: https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/field/schema.yaml
  DataSource:
    $ref: https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/datasource/schema.yaml
  PersonOrOrganization:
    oneOf:
    - type: object
      properties:
        '@type':
          const: sc:Person
        name:
          type: string
        email:
          type: string
          format: email
        url:
          type: string
          format: uri
    - type: object
      properties:
        '@type':
          const: sc:Organization
        name:
          type: string
        url:
          type: string
          format: uri
examples:
- title: Minimal Croissant Dataset
  content: Basic dataset with file and record structure
  snippets:
  - language: json
    code: "{\n  \"@context\": \"http://mlcommons.org/croissant/1.0\",\n  \"@type\":
      \"sc:Dataset\",\n  \"name\": \"Example ML Dataset\",\n  \"description\": \"A
      simple example dataset\",\n  \"license\": \"https://creativecommons.org/licenses/by/4.0/\",\n
      \ \"url\": \"https://example.com/dataset\",\n  \"distribution\": [\n    {\n
      \     \"@type\": \"cr:FileObject\",\n      \"@id\": \"data.csv\",\n      \"name\":
      \"data.csv\",\n      \"contentUrl\": \"https://example.com/data.csv\",\n      \"encodingFormat\":
      \"text/csv\"\n    }\n  ],\n  \"recordSet\": [\n    {\n      \"@type\": \"cr:RecordSet\",\n
      \     \"@id\": \"examples\",\n      \"field\": [\n        {\n          \"@type\":
      \"cr:Field\",\n          \"@id\": \"examples/id\",\n          \"name\": \"id\",\n
      \         \"dataType\": \"sc:Integer\"\n        },\n        {\n          \"@type\":
      \"cr:Field\",\n          \"@id\": \"examples/text\",\n          \"name\": \"text\",\n
      \         \"dataType\": \"sc:Text\"\n        }\n      ]\n    }\n  ]\n}\n"

```

Links to the schema:

* YAML version: [schema.yaml](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/schema.json)
* JSON version: [schema.json](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/schema.yaml)


# JSON-LD Context

```jsonld
{
  "@context": {
    "@context": {
      "@context": {}
    },
    "@type": {
      "@context": {}
    },
    "@id": {
      "@context": {}
    },
    "name": {},
    "description": {},
    "url": {},
    "@vocab": "https://schema.org/",
    "contentUrl": "sc:contentUrl",
    "contentSize": "sc:contentSize",
    "encodingFormat": "sc:encodingFormat",
    "sha256": "sc:sha256",
    "md5": "cr:md5",
    "containedIn": {
      "@context": {
        "@id": {
          "@context": {}
        }
      },
      "@id": "cr:containedIn"
    },
    "sameAs": "sc:sameAs",
    "includes": "cr:includes",
    "excludes": "cr:excludes",
    "distribution": {},
    "field": {
      "@context": {
        "@type": {
          "@context": {}
        },
        "@id": {
          "@context": {}
        },
        "source": {},
        "references": {},
        "repeated": {},
        "subField": {}
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
    "recordSet": {},
    "conformsTo": {},
    "license": {},
    "email": {},
    "creator": {},
    "citation": {},
    "cr": "http://mlcommons.org/croissant/",
    "@version": 1.1
  }
}
```

You can find the full JSON-LD context here:
[context.jsonld](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/context.jsonld)

## Sources

* [MLCommons Croissant Specification v1.0](https://github.com/mlcommons/croissant)

# For developers

The source code for this Building Block can be found in the following repository:

* URL: [https://github.com/GeoLabs/bblocks-croissant](https://github.com/GeoLabs/bblocks-croissant)
* Path: `_sources`

