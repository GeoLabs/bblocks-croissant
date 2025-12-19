
# Croissant FileObject (Schema)

`mlc.croissant.fileobject` *v1.0*

Represents an individual file that is part of a Croissant dataset

[*Status*](http://www.opengis.net/def/status): Under development

## Description

## Croissant FileObject

A FileObject represents an individual file that is part of a Croissant dataset. It is a fundamental building block for describing the distribution (resources) within a dataset.

### Key Features

- **Schema.org Inheritance**: FileObject inherits from schema.org's CreativeWork, making it compatible with existing web standards
- **Checksums**: Supports SHA-256 and MD5 checksums for file integrity verification
- **Archive Support**: Files can be nested within archives using the `containedIn` property
- **Multiple Formats**: Can reference alternative versions of the same content via `sameAs`

### Properties

#### Required Properties
- `@type`: Must be `cr:FileObject`
- `@id`: Unique identifier within the dataset

#### Core Properties
- `name`: Filename (should match the downloaded filename including extension)
- `contentUrl`: URL to download the file
- `contentSize`: Human-readable file size (e.g., "1.5 MB", "2GB")
- `encodingFormat`: MIME type of the file

#### Integrity Properties
- `sha256`: SHA-256 checksum (recommended for versioned datasets)
- `md5`: MD5 checksum (alternative to SHA-256)

#### Relationship Properties
- `containedIn`: Reference to a parent FileObject or FileSet (for archived files)
- `sameAs`: Links to the same content in different formats

### Usage Patterns

#### Standalone Files
Simple files directly downloadable from a URL:
```json
{
  "@type": "cr:FileObject",
  "@id": "train-data",
  "contentUrl": "https://example.com/train.csv",
  "encodingFormat": "text/csv"
}
```

#### Archive Members
Files extracted from archives (zip, tar, etc.):
```json
{
  "@type": "cr:FileObject",
  "@id": "archive",
  "contentUrl": "https://example.com/data.zip",
  "encodingFormat": "application/zip"
},
{
  "@type": "cr:FileObject",
  "@id": "csv-in-archive",
  "contentUrl": "data/file.csv",
  "containedIn": { "@id": "archive" },
  "encodingFormat": "text/csv"
}
```

#### With Checksums (Recommended)
For reproducibility and data integrity:
```json
{
  "@type": "cr:FileObject",
  "@id": "verified-file",
  "contentUrl": "https://example.com/data.csv",
  "encodingFormat": "text/csv",
  "sha256": "0b033707ea49365a5ffdd14615825511a1b2c3d4e5f6..."
}
```

### Best Practices

1. **Always include encodingFormat**: Helps tools process files correctly
2. **Use checksums for stable datasets**: Enables verification and reproducibility
3. **Reflect actual filenames in `name`**: Makes it easier to match downloaded files
4. **Use `containedIn` for archives**: Properly models hierarchical file structures
5. **Avoid checksums for live datasets**: Files that update frequently shouldn't have checksums

### Related Building Blocks

- **FileSet**: For collections of homogeneous files
- **Dataset**: Uses FileObject in its `distribution` property
- **DataSource**: References FileObject when defining field sources

## Examples

### Simple CSV File
#### json
```json
{
  "@type": "cr:FileObject",
  "@id": "data.csv",
  "name": "data.csv",
  "contentUrl": "https://example.com/data.csv",
  "encodingFormat": "text/csv",
  "sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
}

```

#### jsonld
```jsonld
{
  "@context": "https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/fileobject/context.jsonld",
  "@type": "cr:FileObject",
  "@id": "data.csv",
  "name": "data.csv",
  "contentUrl": "https://example.com/data.csv",
  "encodingFormat": "text/csv",
  "sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
}
```

#### ttl
```ttl
@prefix : <https://schema.org/> .
@prefix cr: <http://mlcommons.org/croissant/> .
@prefix ns1: <sc:> .

<file:///github/workspace/data.csv> a cr:FileObject ;
    :name "data.csv" ;
    ns1:contentUrl "https://example.com/data.csv" ;
    ns1:encodingFormat "text/csv" ;
    ns1:sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" .


```


### Image File with Checksum
#### json
```json
{
  "@type": "cr:FileObject",
  "@id": "cat.jpg",
  "name": "cat.jpg",
  "contentUrl": "https://example.com/images/cat.jpg",
  "encodingFormat": "image/jpeg",
  "contentSize": "524288",
  "sha256": "a1b2c3d4e5f6789012345678901234567890123456789012345678901234abcd"
}

```

#### jsonld
```jsonld
{
  "@context": "https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/fileobject/context.jsonld",
  "@type": "cr:FileObject",
  "@id": "cat.jpg",
  "name": "cat.jpg",
  "contentUrl": "https://example.com/images/cat.jpg",
  "encodingFormat": "image/jpeg",
  "contentSize": "524288",
  "sha256": "a1b2c3d4e5f6789012345678901234567890123456789012345678901234abcd"
}
```

#### ttl
```ttl
@prefix : <https://schema.org/> .
@prefix cr: <http://mlcommons.org/croissant/> .
@prefix ns1: <sc:> .

<file:///github/workspace/cat.jpg> a cr:FileObject ;
    :name "cat.jpg" ;
    ns1:contentSize "524288" ;
    ns1:contentUrl "https://example.com/images/cat.jpg" ;
    ns1:encodingFormat "image/jpeg" ;
    ns1:sha256 "a1b2c3d4e5f6789012345678901234567890123456789012345678901234abcd" .


```

## Schema

```yaml
$schema: https://json-schema.org/draft/2020-12/schema
title: Croissant FileObject
description: 'Represents an individual file that is part of a Croissant dataset.

  FileObject inherits from schema.org CreativeWork.

  '
type: object
required:
- '@type'
- '@id'
properties:
  '@type':
    type: string
    const: cr:FileObject
    description: Must be cr:FileObject
  '@id':
    type: string
    description: Unique identifier for this FileObject within the dataset
  name:
    type: string
    description: 'The name of the file. Should reflect the name of the file as downloaded,

      including the file extension (e.g., "images.zip")

      '
  contentUrl:
    type: string
    format: uri
    description: URL to the actual bytes of the file
    x-jsonld-id: sc:contentUrl
  contentSize:
    type: string
    description: 'File size in (mega/kilo/...)bytes. Defaults to bytes if a unit is
      not specified.

      Examples: "1024", "1.5 MB", "2GB"

      '
    x-jsonld-id: sc:contentSize
  encodingFormat:
    type: string
    description: The format of the file, given as a MIME type (e.g., "text/csv", "image/jpeg")
    x-jsonld-id: sc:encodingFormat
  sha256:
    type: string
    pattern: ^[a-fA-F0-9]{64}$
    description: SHA-256 checksum for the file contents (64 hexadecimal characters)
    x-jsonld-id: sc:sha256
  md5:
    type: string
    pattern: ^[a-fA-F0-9]{32}$
    description: MD5 checksum for the file contents (32 hexadecimal characters)
    x-jsonld-id: http://mlcommons.org/croissant/md5
  containedIn:
    description: 'Another FileObject or FileSet that this one is contained in, e.g.,
      in the case

      of a file extracted from an archive. When this property is present, the contentUrl

      is evaluated as a relative path within the container object.

      '
    oneOf:
    - type: object
      required:
      - '@id'
      properties:
        '@id':
          type: string
          description: Reference to the container FileObject or FileSet
    - type: array
      items:
        type: object
        required:
        - '@id'
        properties:
          '@id':
            type: string
    x-jsonld-id: http://mlcommons.org/croissant/containedIn
  description:
    type: string
    description: Human-readable description of the file
  sameAs:
    description: 'URL (or local name) of a FileObject with the same content, but in
      a different format

      '
    oneOf:
    - type: string
      format: uri
    - type: array
      items:
        type: string
        format: uri
    x-jsonld-id: sc:sameAs
examples:
- title: Simple CSV file
  content: A single CSV file with metadata
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:FileObject\",\n  \"@id\": \"metadata.csv\",\n  \"name\":
      \"metadata.csv\",\n  \"contentUrl\": \"https://example.com/data/metadata.csv\",\n
      \ \"encodingFormat\": \"text/csv\",\n  \"contentSize\": \"1024 KB\",\n  \"sha256\":
      \"0b033707ea49365a5ffdd14615825511\"\n}\n"
- title: Archive file
  content: A tar archive containing dataset files
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:FileObject\",\n  \"@id\": \"dataset-archive\",\n  \"name\":
      \"dataset.tar.gz\",\n  \"contentUrl\": \"https://example.com/dataset.tar.gz\",\n
      \ \"encodingFormat\": \"application/x-tar\",\n  \"contentSize\": \"10 GB\",\n
      \ \"sha256\": \"f4f87af4327fd1a66dd7944b9f59cbcc\"\n}\n"
- title: File extracted from archive
  content: A file contained within an archive
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:FileObject\",\n  \"@id\": \"readme-file\",\n  \"name\":
      \"README.txt\",\n  \"contentUrl\": \"README.txt\",\n  \"containedIn\": { \"@id\":
      \"dataset-archive\" },\n  \"encodingFormat\": \"text/plain\"\n}\n"
x-jsonld-vocab: https://schema.org/
x-jsonld-prefixes:
  cr: http://mlcommons.org/croissant/

```

Links to the schema:

* YAML version: [schema.yaml](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/fileobject/schema.json)
* JSON version: [schema.json](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/fileobject/schema.yaml)


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
    "cr": "http://mlcommons.org/croissant/",
    "@version": 1.1
  }
}
```

You can find the full JSON-LD context here:
[context.jsonld](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/fileobject/context.jsonld)

## Sources

* [Croissant Format Specification v1.0 - FileObject](https://docs.mlcommons.org/croissant/docs/croissant-spec.html#fileobject)

# For developers

The source code for this Building Block can be found in the following repository:

* URL: [https://github.com/GeoLabs/bblocks-croissant](https://github.com/GeoLabs/bblocks-croissant)
* Path: `_sources/fileobject`

