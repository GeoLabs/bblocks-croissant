
# Croissant FileSet (Schema)

`mlc.croissant.fileset` *v1.0*

Represents a collection of homogeneous files in a Croissant dataset

[*Status*](http://www.opengis.net/def/status): Under development

## Description

## Croissant FileSet

A FileSet describes collections of homogeneous files in a dataset, such as images, videos, or text files, where each file is treated as an individual data item (e.g., as a training example).

### Key Features

- **Glob Patterns**: Flexible file selection using industry-standard glob syntax
- **Multiple Sources**: Can combine files from multiple archives
- **Inclusion/Exclusion**: Fine-grained control over which files are included
- **Homogeneous Collections**: All files in a FileSet share the same encoding format

### Properties

#### Required Properties
- `@type`: Must be `cr:FileSet`
- `@id`: Unique identifier within the dataset
- `containedIn`: Reference to one or more FileObject containers (e.g., archives)

#### Core Properties
- `includes`: Glob pattern(s) for files to include
- `excludes`: Glob pattern(s) for files to exclude
- `encodingFormat`: MIME type shared by all files in the set

### Glob Pattern Syntax

FileSet uses standard glob patterns for file matching:

| Pattern | Matches | Example |
|---------|---------|---------|
| `*.jpg` | All JPG files in root | `image.jpg`, `photo.jpg` |
| `**/*.png` | All PNG files recursively | `dir/sub/image.png` |
| `train/*.jpg` | JPG files in train/ | `train/img1.jpg` |
| `img_[0-9].jpg` | Numbered images | `img_1.jpg`, `img_5.jpg` |

### Usage Patterns

#### Image Collections
Common in computer vision datasets:
```json
{
  "@type": "cr:FileSet",
  "@id": "training-images",
  "containedIn": { "@id": "train2014.zip" },
  "encodingFormat": "image/jpeg",
  "includes": "train2014/*.jpg"
}
```

#### Multi-Directory Selection
Select files from multiple subdirectories:
```json
{
  "@type": "cr:FileSet",
  "@id": "all-languages",
  "containedIn": { "@id": "multilingual-corpus" },
  "encodingFormat": "text/plain",
  "includes": ["en/**/*.txt", "fr/**/*.txt", "de/**/*.txt"]
}
```

#### Exclusion Patterns
Exclude specific files or directories:
```json
{
  "@type": "cr:FileSet",
  "@id": "production-data",
  "containedIn": { "@id": "dataset" },
  "includes": "**/*.json",
  "excludes": ["**/test/**", "**/debug/**"]
}
```

#### Union of Multiple Archives
Combine files from several archives:
```json
{
  "@type": "cr:FileSet",
  "@id": "complete-dataset",
  "containedIn": [
    { "@id": "part1.tar" },
    { "@id": "part2.tar" },
    { "@id": "part3.tar" }
  ],
  "includes": "*.csv"
}
```

### Pattern Evaluation

The FileSet evaluation process:

1. **Apply includes**: Evaluate all `includes` patterns and take their union
2. **Apply excludes**: Remove files matching any `excludes` pattern
3. **Result**: Final set of FileObjects in the FileSet

**Note**: Patterns are evaluated from the root of the `containedIn` archive/directory.

### Best Practices

1. **Be specific with patterns**: Use precise patterns to avoid unintended matches
2. **Document expectations**: Use `description` to clarify what files should be included
3. **Test patterns locally**: Verify glob patterns match expected files before publishing
4. **Consistent encodingFormat**: Ensure all matched files share the same format
5. **Order matters**: Remember that excludes are applied after includes

### Common Use Cases

- **Image datasets**: Collections of photos, training images, or visualizations
- **Text corpora**: Documents, articles, or transcripts organized in directories
- **Audio/video collections**: Media files for multimedia ML tasks
- **Split-based datasets**: Using patterns to separate train/val/test files

### Related Building Blocks

- **FileObject**: Individual file; FileSet containers reference FileObjects
- **Dataset**: Uses FileSets in its `distribution` property
- **RecordSet**: Fields can extract data from FileSets
- **Field/DataSource**: References FileSet to extract field values

## Schema

```yaml
$schema: https://json-schema.org/draft/2020-12/schema
title: Croissant FileSet
description: 'Represents a collection of homogeneous files (e.g., images, videos,
  text files)

  where each file is treated as an individual item. Supports glob patterns for

  inclusion/exclusion of files.

  '
type: object
required:
- '@type'
- '@id'
- containedIn
properties:
  '@type':
    type: string
    const: cr:FileSet
    description: Must be cr:FileSet
  '@id':
    type: string
    description: Unique identifier for this FileSet within the dataset
  name:
    type: string
    description: Human-readable name for this file collection
  description:
    type: string
    description: Description of the file collection
  containedIn:
    description: 'The source of data for the FileSet (e.g., an archive FileObject).

      If multiple values are provided, the union of their contents is taken.

      '
    oneOf:
    - type: object
      required:
      - '@id'
      properties:
        '@id':
          type: string
          description: Reference to a FileObject containing these files
    - type: array
      items:
        type: object
        required:
        - '@id'
        properties:
          '@id':
            type: string
    x-jsonld-id: http://mlcommons.org/croissant/containedIn
  includes:
    description: 'Glob pattern(s) that specify the files to include. Multiple includes
      are

      combined with union. Patterns are evaluated from the root of the containedIn
      contents.

      '
    oneOf:
    - type: string
      description: Single glob pattern (e.g., "*.jpg", "images/**/*.png")
    - type: array
      items:
        type: string
      description: Multiple glob patterns
    x-jsonld-id: http://mlcommons.org/croissant/includes
  excludes:
    description: 'Glob pattern(s) that specify files to exclude. Applied after includes.

      Multiple excludes are combined with union.

      '
    oneOf:
    - type: string
      description: Single glob pattern
    - type: array
      items:
        type: string
      description: Multiple glob patterns
    x-jsonld-id: http://mlcommons.org/croissant/excludes
  encodingFormat:
    type: string
    description: MIME type of the files in this set (e.g., "image/jpeg", "text/plain")
    x-jsonld-id: sc:encodingFormat
examples:
- title: JPEG images in a zip archive
  content: All JPEG images contained in a zip file
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:FileSet\",\n  \"@id\": \"image-files\",\n  \"name\":
      \"Training images\",\n  \"containedIn\": { \"@id\": \"train-archive.zip\" },\n
      \ \"encodingFormat\": \"image/jpeg\",\n  \"includes\": \"*.jpg\"\n}\n"
- title: Images in specific subdirectories
  content: Using patterns to select images from multiple directories
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:FileSet\",\n  \"@id\": \"train-images\",\n  \"name\":
      \"Training set images\",\n  \"containedIn\": { \"@id\": \"dataset-archive\"
      },\n  \"encodingFormat\": \"image/png\",\n  \"includes\": [\"train/**/*.png\",
      \"validation/**/*.png\"]\n}\n"
- title: Files with exclusion patterns
  content: Including all text files except test files
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:FileSet\",\n  \"@id\": \"text-corpus\",\n  \"name\":
      \"Text corpus (excluding tests)\",\n  \"containedIn\": { \"@id\": \"corpus-archive\"
      },\n  \"encodingFormat\": \"text/plain\",\n  \"includes\": \"**/*.txt\",\n  \"excludes\":
      \"**/test/**\"\n}\n"
- title: Multiple source archives
  content: Combining files from multiple archives
  snippets:
  - language: json
    code: "{\n  \"@type\": \"cr:FileSet\",\n  \"@id\": \"all-images\",\n  \"name\":
      \"All dataset images\",\n  \"containedIn\": [\n    { \"@id\": \"part1.zip\"
      },\n    { \"@id\": \"part2.zip\" }\n  ],\n  \"encodingFormat\": \"image/jpeg\",\n
      \ \"includes\": \"*.jpg\"\n}\n"
x-jsonld-vocab: https://schema.org/
x-jsonld-prefixes:
  cr: http://mlcommons.org/croissant/

```

Links to the schema:

* YAML version: [schema.yaml](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/fileset/schema.json)
* JSON version: [schema.json](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/fileset/schema.yaml)


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
    "containedIn": {
      "@context": {
        "@id": {
          "@context": {}
        }
      },
      "@id": "cr:containedIn"
    },
    "includes": "cr:includes",
    "excludes": "cr:excludes",
    "encodingFormat": "sc:encodingFormat",
    "cr": "http://mlcommons.org/croissant/",
    "@version": 1.1
  }
}
```

You can find the full JSON-LD context here:
[context.jsonld](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/fileset/context.jsonld)

## Sources

* [Croissant Format Specification v1.0 - FileSet](https://docs.mlcommons.org/croissant/docs/croissant-spec.html#fileset)

# For developers

The source code for this Building Block can be found in the following repository:

* URL: [https://github.com/GeoLabs/bblocks-croissant](https://github.com/GeoLabs/bblocks-croissant)
* Path: `_sources/fileset`

