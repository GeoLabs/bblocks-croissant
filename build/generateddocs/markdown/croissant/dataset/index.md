
# Croissant Dataset (Schema)

`mlc.croissant.dataset` *v1.0*

Metadata format for ML dataset description following the Croissant specification

[*Status*](http://www.opengis.net/def/status): Under development

## Description

# Croissant Dataset Building Block

## Overview

The Croissant Dataset Building Block implements the [Croissant Format Specification v1.0](https://docs.mlcommons.org/croissant/docs/croissant-spec.html) developed by MLCommons. Croissant is a metadata format that simplifies how data is used by ML models by providing a vocabulary for dataset attributes and streamlining how data is loaded across ML frameworks such as PyTorch, TensorFlow, or JAX.

## Purpose

Croissant addresses several key challenges in the ML ecosystem:

- **Discoverability**: Dataset search engines can parse Croissant metadata, allowing users to find datasets no matter where they're published
- **Portability**: Provides sufficient information for ML tools to load datasets with just a few lines of code
- **Reproducibility**: Standardized format ensures consistent interpretation across different tools
- **Responsible AI**: Machine-readable way to capture and publish metadata about ML datasets, enabling automated RAI metrics

## Structure

A Croissant dataset description consists of:

### 1. Dataset-level Information

Based on [schema.org/Dataset](https://schema.org/Dataset) with additional Croissant-specific properties:

**Required properties:**
- `@context`: JSON-LD context definitions
- `@type`: Must be `sc:Dataset`
- `conformsTo`: Must be `http://mlcommons.org/croissant/1.0`
- `name`: Dataset name
- `description`: Dataset description
- `url`: Dataset URL (typically the web page)
- `license`: License URL(s)
- `creator`: Dataset creator(s)
- `datePublished`: Publication date

**Recommended properties:**
- `version`: Following semantic versioning (MAJOR.MINOR.PATCH)
- `keywords`: Associated keywords
- `publisher`: Dataset publisher
- `citeAs`: Citation (preferably in bibtex format)
- `isLiveDataset`: Boolean indicating if the dataset updates continuously

### 2. Distribution (Resources)

Describes the files and file collections in the dataset:

- **FileObject**: Individual files with properties like `contentUrl`, `encodingFormat`, `sha256` checksum
- **FileSet**: Homogeneous collections of files (e.g., directories of images) with inclusion/exclusion patterns

### 3. RecordSets

Define the structure of data records:

- **RecordSet**: A set of structured records with fields
- **Field**: Individual data elements with data types and sources
- **DataSource**: Specifies where field data comes from, with extraction and transformation options

### 4. ML-Specific Features

- **Splits**: Training/validation/test data splits
- **Categorical Data**: Enumerations for classification
- **Labels**: Annotated data
- **Bounding Boxes**: Computer vision annotations
- **Segmentation Masks**: Pixel-level annotations

## Key Concepts

### Namespaces

Croissant uses the following namespaces:
- `cr:` - http://mlcommons.org/croissant/ (Croissant vocabulary)
- `sc:` - https://schema.org/ (Schema.org, used as default)
- `dct:` - http://purl.org/dc/terms/ (Dublin Core)
- `wd:` - http://www.wikidata.org/wiki/ (Wikidata)

### Data Types

Croissant supports:

**Atomic types:**
- `sc:Boolean`, `sc:Date`, `sc:Float`, `sc:Integer`, `sc:Text`

**ML-specific types:**
- `sc:ImageObject` - Image content
- `cr:BoundingBox` - Bounding box coordinates
- `cr:Split` - Data split designation
- `cr:Label` - Label/annotation data

### Data Transformations

Fields can extract and transform data:
- **Extract**: Get specific parts (columns, file properties, JSON paths)
- **Transform**: Apply regex, delimiters, JSON queries
- **Format**: Parse dates, numbers, etc.

### References and Joins

Fields can reference other fields, enabling joins between RecordSets (similar to foreign keys in databases).

## Example Use Cases

1. **Computer Vision Datasets**: Image collections with annotations, bounding boxes, and segmentation masks
2. **NLP Datasets**: Text corpora with metadata, splits, and labels
3. **Tabular Datasets**: CSV/TSV files with typed columns and relationships
4. **Multi-modal Datasets**: Combining images, text, and structured data

## Benefits

- **Standardization**: Consistent format across the ML ecosystem
- **Interoperability**: Works with multiple ML frameworks
- **Documentation**: Built-in metadata for understanding datasets
- **Automation**: Enables automatic loading, validation, and metric computation
- **Extensibility**: Modular design supports custom extensions

## Version History

The current implementation follows Croissant Format Specification v1.0 (published 2024-03-01).

## References

- [Croissant Format Specification](https://docs.mlcommons.org/croissant/docs/croissant-spec.html)
- [MLCommons Croissant](https://mlcommons.org/croissant/)
- [Schema.org Dataset](https://schema.org/Dataset)
- [Croissant GitHub Repository](https://github.com/mlcommons/croissant)

## Examples

### Titanic Dataset
#### json
```json
{
  "@context": {
    "@language": "en",
    "@vocab": "https://schema.org/",
    "citeAs": "cr:citeAs",
    "column": "cr:column",
    "conformsTo": "dct:conformsTo",
    "cr": "http://mlcommons.org/croissant/",
    "rai": "http://mlcommons.org/croissant/RAI/",
    "data": {
      "@id": "cr:data",
      "@type": "@json"
    },
    "dataType": {
      "@id": "cr:dataType",
      "@type": "@vocab"
    },
    "dct": "http://purl.org/dc/terms/",
    "examples": {
      "@id": "cr:examples",
      "@type": "@json"
    },
    "extract": "cr:extract",
    "field": "cr:field",
    "fileProperty": "cr:fileProperty",
    "fileObject": "cr:fileObject",
    "fileSet": "cr:fileSet",
    "format": "cr:format",
    "includes": "cr:includes",
    "isLiveDataset": "cr:isLiveDataset",
    "jsonPath": "cr:jsonPath",
    "key": "cr:key",
    "md5": "cr:md5",
    "parentField": "cr:parentField",
    "path": "cr:path",
    "recordSet": "cr:recordSet",
    "references": "cr:references",
    "regex": "cr:regex",
    "repeated": "cr:repeated",
    "replace": "cr:replace",
    "sc": "https://schema.org/",
    "separator": "cr:separator",
    "source": "cr:source",
    "subField": "cr:subField",
    "transform": "cr:transform",
    "wd": "https://www.wikidata.org/wiki/"
  },
  "@type": "sc:Dataset",
  "name": "Titanic",
  "description": "The original Titanic dataset, describing the status of individual passengers on the Titanic.\n\n The titanic data does not contain information from the crew, but it does contain actual ages of half of the passengers.",
  "conformsTo": "http://mlcommons.org/croissant/1.0",
  "citeAs": "The principal source for data about Titanic passengers is the Encyclopedia Titanica (http://www.encyclopedia-titanica.org/).",
  "license": "afl-3.0",
  "url": "https://www.openml.org/d/40945",
  "version": "1.0.0",
  "distribution": [
    {
      "@type": "cr:FileObject",
      "@id": "passengers.csv",
      "name": "passengers.csv",
      "contentSize": "117743 B",
      "contentUrl": "data/titanic.csv",
      "encodingFormat": "text/csv",
      "sha256": "c617db2c7470716250f6f001be51304c76bcc8815527ab8bae734bdca0735737"
    }
  ],
  "recordSet": [
    {
      "@type": "cr:RecordSet",
      "@id": "passengers",
      "name": "passengers",
      "description": "The list of passengers. Does not include crew members.",
      "field": [
        {
          "@type": "cr:Field",
          "@id": "passengers/name",
          "name": "passengers/name",
          "description": "Name of the passenger",
          "dataType": "sc:Text",
          "source": {
            "fileObject": {
              "@id": "passengers.csv"
            },
            "extract": {
              "column": "name"
            }
          }
        },
        {
          "@type": "cr:Field",
          "@id": "passengers/survived",
          "name": "passengers/survived",
          "description": "Survival status of passenger (0: Lost, 1: Saved)",
          "dataType": "sc:Integer",
          "source": {
            "fileObject": {
              "@id": "passengers.csv"
            },
            "extract": {
              "column": "survived"
            }
          }
        }
      ]
    }
  ]
}

```

#### jsonld
```jsonld
{
  "@context": [
    "https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/dataset/context.jsonld",
    {
      "@language": "en",
      "@vocab": "https://schema.org/",
      "citeAs": "cr:citeAs",
      "column": "cr:column",
      "conformsTo": "dct:conformsTo",
      "cr": "http://mlcommons.org/croissant/",
      "rai": "http://mlcommons.org/croissant/RAI/",
      "data": {
        "@id": "cr:data",
        "@type": "@json"
      },
      "dataType": {
        "@id": "cr:dataType",
        "@type": "@vocab"
      },
      "dct": "http://purl.org/dc/terms/",
      "examples": {
        "@id": "cr:examples",
        "@type": "@json"
      },
      "extract": "cr:extract",
      "field": "cr:field",
      "fileProperty": "cr:fileProperty",
      "fileObject": "cr:fileObject",
      "fileSet": "cr:fileSet",
      "format": "cr:format",
      "includes": "cr:includes",
      "isLiveDataset": "cr:isLiveDataset",
      "jsonPath": "cr:jsonPath",
      "key": "cr:key",
      "md5": "cr:md5",
      "parentField": "cr:parentField",
      "path": "cr:path",
      "recordSet": "cr:recordSet",
      "references": "cr:references",
      "regex": "cr:regex",
      "repeated": "cr:repeated",
      "replace": "cr:replace",
      "sc": "https://schema.org/",
      "separator": "cr:separator",
      "source": "cr:source",
      "subField": "cr:subField",
      "transform": "cr:transform",
      "wd": "https://www.wikidata.org/wiki/"
    }
  ],
  "@type": "sc:Dataset",
  "name": "Titanic",
  "description": "The original Titanic dataset, describing the status of individual passengers on the Titanic.\n\n The titanic data does not contain information from the crew, but it does contain actual ages of half of the passengers.",
  "conformsTo": "http://mlcommons.org/croissant/1.0",
  "citeAs": "The principal source for data about Titanic passengers is the Encyclopedia Titanica (http://www.encyclopedia-titanica.org/).",
  "license": "afl-3.0",
  "url": "https://www.openml.org/d/40945",
  "version": "1.0.0",
  "distribution": [
    {
      "@type": "cr:FileObject",
      "@id": "passengers.csv",
      "name": "passengers.csv",
      "contentSize": "117743 B",
      "contentUrl": "data/titanic.csv",
      "encodingFormat": "text/csv",
      "sha256": "c617db2c7470716250f6f001be51304c76bcc8815527ab8bae734bdca0735737"
    }
  ],
  "recordSet": [
    {
      "@type": "cr:RecordSet",
      "@id": "passengers",
      "name": "passengers",
      "description": "The list of passengers. Does not include crew members.",
      "field": [
        {
          "@type": "cr:Field",
          "@id": "passengers/name",
          "name": "passengers/name",
          "description": "Name of the passenger",
          "dataType": "sc:Text",
          "source": {
            "fileObject": {
              "@id": "passengers.csv"
            },
            "extract": {
              "column": "name"
            }
          }
        },
        {
          "@type": "cr:Field",
          "@id": "passengers/survived",
          "name": "passengers/survived",
          "description": "Survival status of passenger (0: Lost, 1: Saved)",
          "dataType": "sc:Integer",
          "source": {
            "fileObject": {
              "@id": "passengers.csv"
            },
            "extract": {
              "column": "survived"
            }
          }
        }
      ]
    }
  ]
}
```

#### ttl
```ttl
@prefix cr: <http://mlcommons.org/croissant/> .
@prefix dct: <http://purl.org/dc/terms/> .
@prefix sc: <https://schema.org/> .

<file:///github/workspace/passengers> a cr:RecordSet ;
    cr:field <file:///github/workspace/passengers/name>,
        <file:///github/workspace/passengers/survived> ;
    sc:description "The list of passengers. Does not include crew members."@en ;
    sc:name "passengers"@en .

<file:///github/workspace/passengers/name> a cr:Field ;
    cr:dataType sc:Text ;
    cr:source [ cr:extract [ cr:column "name"@en ] ;
            cr:fileObject <file:///github/workspace/passengers.csv> ] ;
    sc:description "Name of the passenger"@en ;
    sc:name "passengers/name"@en .

<file:///github/workspace/passengers/survived> a cr:Field ;
    cr:dataType sc:Integer ;
    cr:source [ cr:extract [ cr:column "survived"@en ] ;
            cr:fileObject <file:///github/workspace/passengers.csv> ] ;
    sc:description "Survival status of passenger (0: Lost, 1: Saved)"@en ;
    sc:name "passengers/survived"@en .

<file:///github/workspace/passengers.csv> a cr:FileObject ;
    sc:contentSize "117743 B"@en ;
    sc:contentUrl "data/titanic.csv"@en ;
    sc:encodingFormat "text/csv"@en ;
    sc:name "passengers.csv"@en ;
    sc:sha256 "c617db2c7470716250f6f001be51304c76bcc8815527ab8bae734bdca0735737"@en .

[] a sc:Dataset ;
    cr:citeAs "The principal source for data about Titanic passengers is the Encyclopedia Titanica (http://www.encyclopedia-titanica.org/)."@en ;
    cr:recordSet <file:///github/workspace/passengers> ;
    dct:conformsTo "http://mlcommons.org/croissant/1.0"@en ;
    sc:description """The original Titanic dataset, describing the status of individual passengers on the Titanic.

 The titanic data does not contain information from the crew, but it does contain actual ages of half of the passengers."""@en ;
    sc:distribution <file:///github/workspace/passengers.csv> ;
    sc:license "afl-3.0"@en ;
    sc:name "Titanic"@en ;
    sc:url "https://www.openml.org/d/40945"@en ;
    sc:version "1.0.0"@en .


```


### COCO 2014 Mini
#### json
```json
{
  "@context": {
    "@language": "en",
    "@vocab": "https://schema.org/",
    "citeAs": "cr:citeAs",
    "column": "cr:column",
    "conformsTo": "dct:conformsTo",
    "cr": "http://mlcommons.org/croissant/",
    "rai": "http://mlcommons.org/croissant/RAI/",
    "data": {
      "@id": "cr:data",
      "@type": "@json"
    },
    "dataType": {
      "@id": "cr:dataType",
      "@type": "@vocab"
    },
    "dct": "http://purl.org/dc/terms/",
    "examples": {
      "@id": "cr:examples",
      "@type": "@json"
    },
    "extract": "cr:extract",
    "field": "cr:field",
    "fileProperty": "cr:fileProperty",
    "fileObject": "cr:fileObject",
    "fileSet": "cr:fileSet",
    "format": "cr:format",
    "includes": "cr:includes",
    "isLiveDataset": "cr:isLiveDataset",
    "jsonPath": "cr:jsonPath",
    "key": "cr:key",
    "md5": "cr:md5",
    "parentField": "cr:parentField",
    "path": "cr:path",
    "recordSet": "cr:recordSet",
    "references": "cr:references",
    "regex": "cr:regex",
    "repeated": "cr:repeated",
    "replace": "cr:replace",
    "sc": "https://schema.org/",
    "separator": "cr:separator",
    "source": "cr:source",
    "subField": "cr:subField",
    "transform": "cr:transform",
    "wd": "https://www.wikidata.org/wiki/"
  },
  "@type": "sc:Dataset",
  "name": "Mini-COCO",
  "description": "Smaller downloadable version of COCO to be used in unit tests.",
  "conformsTo": "http://mlcommons.org/croissant/1.0",
  "citeAs": "None",
  "license": "cc-by-4.0",
  "url": "None",
  "version": "1.0.0",
  "distribution": [
    {
      "@type": "cr:FileObject",
      "@id": "train2014.zip",
      "name": "train2014.zip",
      "contentSize": " B",
      "contentUrl": "data/train2014.zip",
      "encodingFormat": "application/zip",
      "sha256": "d010037fee9416bdcc187a37a4aec7bef798316147da2753bd86e78fc0d469a5"
    },
    {
      "@type": "cr:FileSet",
      "@id": "image-files",
      "name": "image-files",
      "containedIn": {
        "@id": "train2014.zip"
      },
      "encodingFormat": "image/jpeg",
      "includes": "*.jpg"
    }
  ],
  "recordSet": [
    {
      "@type": "cr:RecordSet",
      "@id": "images",
      "name": "images",
      "key": {
        "@id": "img_id"
      },
      "field": [
        {
          "@type": "cr:Field",
          "@id": "images/image_filename",
          "name": "images/image_filename",
          "description": "The filename of the image. eg: COCO_train2014_000000000003.jpg",
          "dataType": "sc:Text",
          "source": {
            "fileSet": {
              "@id": "image-files"
            },
            "extract": {
              "fileProperty": "filename"
            }
          }
        },
        {
          "@type": "cr:Field",
          "@id": "images/image_content",
          "name": "images/image_content",
          "description": "The content of the image.",
          "dataType": "sc:ImageObject",
          "source": {
            "fileSet": {
              "@id": "image-files"
            },
            "extract": {
              "fileProperty": "content"
            }
          }
        }
      ]
    }
  ]
}

```

#### jsonld
```jsonld
{
  "@context": [
    "https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/dataset/context.jsonld",
    {
      "@language": "en",
      "@vocab": "https://schema.org/",
      "citeAs": "cr:citeAs",
      "column": "cr:column",
      "conformsTo": "dct:conformsTo",
      "cr": "http://mlcommons.org/croissant/",
      "rai": "http://mlcommons.org/croissant/RAI/",
      "data": {
        "@id": "cr:data",
        "@type": "@json"
      },
      "dataType": {
        "@id": "cr:dataType",
        "@type": "@vocab"
      },
      "dct": "http://purl.org/dc/terms/",
      "examples": {
        "@id": "cr:examples",
        "@type": "@json"
      },
      "extract": "cr:extract",
      "field": "cr:field",
      "fileProperty": "cr:fileProperty",
      "fileObject": "cr:fileObject",
      "fileSet": "cr:fileSet",
      "format": "cr:format",
      "includes": "cr:includes",
      "isLiveDataset": "cr:isLiveDataset",
      "jsonPath": "cr:jsonPath",
      "key": "cr:key",
      "md5": "cr:md5",
      "parentField": "cr:parentField",
      "path": "cr:path",
      "recordSet": "cr:recordSet",
      "references": "cr:references",
      "regex": "cr:regex",
      "repeated": "cr:repeated",
      "replace": "cr:replace",
      "sc": "https://schema.org/",
      "separator": "cr:separator",
      "source": "cr:source",
      "subField": "cr:subField",
      "transform": "cr:transform",
      "wd": "https://www.wikidata.org/wiki/"
    }
  ],
  "@type": "sc:Dataset",
  "name": "Mini-COCO",
  "description": "Smaller downloadable version of COCO to be used in unit tests.",
  "conformsTo": "http://mlcommons.org/croissant/1.0",
  "citeAs": "None",
  "license": "cc-by-4.0",
  "url": "None",
  "version": "1.0.0",
  "distribution": [
    {
      "@type": "cr:FileObject",
      "@id": "train2014.zip",
      "name": "train2014.zip",
      "contentSize": " B",
      "contentUrl": "data/train2014.zip",
      "encodingFormat": "application/zip",
      "sha256": "d010037fee9416bdcc187a37a4aec7bef798316147da2753bd86e78fc0d469a5"
    },
    {
      "@type": "cr:FileSet",
      "@id": "image-files",
      "name": "image-files",
      "containedIn": {
        "@id": "train2014.zip"
      },
      "encodingFormat": "image/jpeg",
      "includes": "*.jpg"
    }
  ],
  "recordSet": [
    {
      "@type": "cr:RecordSet",
      "@id": "images",
      "name": "images",
      "key": {
        "@id": "img_id"
      },
      "field": [
        {
          "@type": "cr:Field",
          "@id": "images/image_filename",
          "name": "images/image_filename",
          "description": "The filename of the image. eg: COCO_train2014_000000000003.jpg",
          "dataType": "sc:Text",
          "source": {
            "fileSet": {
              "@id": "image-files"
            },
            "extract": {
              "fileProperty": "filename"
            }
          }
        },
        {
          "@type": "cr:Field",
          "@id": "images/image_content",
          "name": "images/image_content",
          "description": "The content of the image.",
          "dataType": "sc:ImageObject",
          "source": {
            "fileSet": {
              "@id": "image-files"
            },
            "extract": {
              "fileProperty": "content"
            }
          }
        }
      ]
    }
  ]
}
```

#### ttl
```ttl
@prefix cr: <http://mlcommons.org/croissant/> .
@prefix dct: <http://purl.org/dc/terms/> .
@prefix sc: <https://schema.org/> .

<file:///github/workspace/images> a cr:RecordSet ;
    cr:field <file:///github/workspace/images/image_content>,
        <file:///github/workspace/images/image_filename> ;
    cr:key <file:///github/workspace/img_id> ;
    sc:name "images"@en .

<file:///github/workspace/images/image_content> a cr:Field ;
    cr:dataType sc:ImageObject ;
    cr:source [ cr:extract [ cr:fileProperty "content"@en ] ;
            cr:fileSet <file:///github/workspace/image-files> ] ;
    sc:description "The content of the image."@en ;
    sc:name "images/image_content"@en .

<file:///github/workspace/images/image_filename> a cr:Field ;
    cr:dataType sc:Text ;
    cr:source [ cr:extract [ cr:fileProperty "filename"@en ] ;
            cr:fileSet <file:///github/workspace/image-files> ] ;
    sc:description "The filename of the image. eg: COCO_train2014_000000000003.jpg"@en ;
    sc:name "images/image_filename"@en .

<file:///github/workspace/train2014.zip> a cr:FileObject ;
    sc:contentSize " B"@en ;
    sc:contentUrl "data/train2014.zip"@en ;
    sc:encodingFormat "application/zip"@en ;
    sc:name "train2014.zip"@en ;
    sc:sha256 "d010037fee9416bdcc187a37a4aec7bef798316147da2753bd86e78fc0d469a5"@en .

<file:///github/workspace/image-files> a cr:FileSet ;
    cr:includes "*.jpg"@en ;
    sc:containedIn <file:///github/workspace/train2014.zip> ;
    sc:encodingFormat "image/jpeg"@en ;
    sc:name "image-files"@en .

[] a sc:Dataset ;
    cr:citeAs "None"@en ;
    cr:recordSet <file:///github/workspace/images> ;
    dct:conformsTo "http://mlcommons.org/croissant/1.0"@en ;
    sc:description "Smaller downloadable version of COCO to be used in unit tests."@en ;
    sc:distribution <file:///github/workspace/image-files>,
        <file:///github/workspace/train2014.zip> ;
    sc:license "cc-by-4.0"@en ;
    sc:name "Mini-COCO"@en ;
    sc:url "None"@en ;
    sc:version "1.0.0"@en .


```


### PASS Dataset
#### json
```json
{
  "@context": {
    "@language": "en",
    "@vocab": "https://schema.org/",
    "citeAs": "cr:citeAs",
    "column": "cr:column",
    "conformsTo": "dct:conformsTo",
    "cr": "http://mlcommons.org/croissant/",
    "rai": "http://mlcommons.org/croissant/RAI/",
    "data": {
      "@id": "cr:data",
      "@type": "@json"
    },
    "dataType": {
      "@id": "cr:dataType",
      "@type": "@vocab"
    },
    "dct": "http://purl.org/dc/terms/",
    "examples": {
      "@id": "cr:examples",
      "@type": "@json"
    },
    "extract": "cr:extract",
    "field": "cr:field",
    "fileProperty": "cr:fileProperty",
    "fileObject": "cr:fileObject",
    "fileSet": "cr:fileSet",
    "format": "cr:format",
    "includes": "cr:includes",
    "isLiveDataset": "cr:isLiveDataset",
    "jsonPath": "cr:jsonPath",
    "key": "cr:key",
    "md5": "cr:md5",
    "parentField": "cr:parentField",
    "path": "cr:path",
    "recordSet": "cr:recordSet",
    "references": "cr:references",
    "regex": "cr:regex",
    "repeated": "cr:repeated",
    "replace": "cr:replace",
    "sc": "https://schema.org/",
    "separator": "cr:separator",
    "source": "cr:source",
    "subField": "cr:subField",
    "transform": "cr:transform"
  },
  "@type": "sc:Dataset",
  "name": "PASS",
  "description": "PASS is a large-scale image dataset that does not include any humans and which can be used for high-quality pretraining while significantly reducing privacy concerns.",
  "conformsTo": "http://mlcommons.org/croissant/1.0",
  "citeAs": "@Article{asano21pass, author = \"Yuki M. Asano and Christian Rupprecht and Andrew Zisserman and Andrea Vedaldi\", title = \"PASS: An ImageNet replacement for self-supervised pretraining without humans\", journal = \"NeurIPS Track on Datasets and Benchmarks\", year = \"2021\" }",
  "license": "cc-by-4.0",
  "url": "https://www.robots.ox.ac.uk/~vgg/data/pass/",
  "distribution": [
    {
      "@type": "cr:FileObject",
      "@id": "metadata",
      "name": "metadata",
      "contentUrl": "https://zenodo.org/record/6615455/files/pass_metadata.csv",
      "encodingFormat": "text/csv",
      "sha256": "0b033707ea49365a5ffdd14615825511"
    },
    {
      "@type": "cr:FileSet",
      "@id": "image-files",
      "name": "image-files",
      "containedIn": [
        {
          "@id": "pass0"
        }
      ],
      "encodingFormat": "image/jpeg",
      "includes": "*.jpg"
    }
  ],
  "recordSet": [
    {
      "@type": "cr:RecordSet",
      "@id": "images",
      "name": "images",
      "key": {
        "@id": "hash"
      },
      "field": [
        {
          "@type": "cr:Field",
          "@id": "images/hash",
          "name": "images/hash",
          "description": "The hash of the image, as computed from YFCC-100M.",
          "dataType": "sc:Text",
          "source": {
            "fileSet": {
              "@id": "image-files"
            },
            "extract": {
              "fileProperty": "filename"
            },
            "transform": {
              "regex": "([^\\/]*)\\.jpg"
            }
          }
        },
        {
          "@type": "cr:Field",
          "@id": "images/image_content",
          "name": "images/image_content",
          "description": "The content of the image.",
          "dataType": "sc:ImageObject",
          "source": {
            "fileSet": {
              "@id": "image-files"
            },
            "extract": {
              "fileProperty": "content"
            }
          }
        }
      ]
    }
  ]
}

```

#### jsonld
```jsonld
{
  "@context": [
    "https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/dataset/context.jsonld",
    {
      "@language": "en",
      "@vocab": "https://schema.org/",
      "citeAs": "cr:citeAs",
      "column": "cr:column",
      "conformsTo": "dct:conformsTo",
      "cr": "http://mlcommons.org/croissant/",
      "rai": "http://mlcommons.org/croissant/RAI/",
      "data": {
        "@id": "cr:data",
        "@type": "@json"
      },
      "dataType": {
        "@id": "cr:dataType",
        "@type": "@vocab"
      },
      "dct": "http://purl.org/dc/terms/",
      "examples": {
        "@id": "cr:examples",
        "@type": "@json"
      },
      "extract": "cr:extract",
      "field": "cr:field",
      "fileProperty": "cr:fileProperty",
      "fileObject": "cr:fileObject",
      "fileSet": "cr:fileSet",
      "format": "cr:format",
      "includes": "cr:includes",
      "isLiveDataset": "cr:isLiveDataset",
      "jsonPath": "cr:jsonPath",
      "key": "cr:key",
      "md5": "cr:md5",
      "parentField": "cr:parentField",
      "path": "cr:path",
      "recordSet": "cr:recordSet",
      "references": "cr:references",
      "regex": "cr:regex",
      "repeated": "cr:repeated",
      "replace": "cr:replace",
      "sc": "https://schema.org/",
      "separator": "cr:separator",
      "source": "cr:source",
      "subField": "cr:subField",
      "transform": "cr:transform"
    }
  ],
  "@type": "sc:Dataset",
  "name": "PASS",
  "description": "PASS is a large-scale image dataset that does not include any humans and which can be used for high-quality pretraining while significantly reducing privacy concerns.",
  "conformsTo": "http://mlcommons.org/croissant/1.0",
  "citeAs": "@Article{asano21pass, author = \"Yuki M. Asano and Christian Rupprecht and Andrew Zisserman and Andrea Vedaldi\", title = \"PASS: An ImageNet replacement for self-supervised pretraining without humans\", journal = \"NeurIPS Track on Datasets and Benchmarks\", year = \"2021\" }",
  "license": "cc-by-4.0",
  "url": "https://www.robots.ox.ac.uk/~vgg/data/pass/",
  "distribution": [
    {
      "@type": "cr:FileObject",
      "@id": "metadata",
      "name": "metadata",
      "contentUrl": "https://zenodo.org/record/6615455/files/pass_metadata.csv",
      "encodingFormat": "text/csv",
      "sha256": "0b033707ea49365a5ffdd14615825511"
    },
    {
      "@type": "cr:FileSet",
      "@id": "image-files",
      "name": "image-files",
      "containedIn": [
        {
          "@id": "pass0"
        }
      ],
      "encodingFormat": "image/jpeg",
      "includes": "*.jpg"
    }
  ],
  "recordSet": [
    {
      "@type": "cr:RecordSet",
      "@id": "images",
      "name": "images",
      "key": {
        "@id": "hash"
      },
      "field": [
        {
          "@type": "cr:Field",
          "@id": "images/hash",
          "name": "images/hash",
          "description": "The hash of the image, as computed from YFCC-100M.",
          "dataType": "sc:Text",
          "source": {
            "fileSet": {
              "@id": "image-files"
            },
            "extract": {
              "fileProperty": "filename"
            },
            "transform": {
              "regex": "([^\\/]*)\\.jpg"
            }
          }
        },
        {
          "@type": "cr:Field",
          "@id": "images/image_content",
          "name": "images/image_content",
          "description": "The content of the image.",
          "dataType": "sc:ImageObject",
          "source": {
            "fileSet": {
              "@id": "image-files"
            },
            "extract": {
              "fileProperty": "content"
            }
          }
        }
      ]
    }
  ]
}
```

#### ttl
```ttl
@prefix cr: <http://mlcommons.org/croissant/> .
@prefix dct: <http://purl.org/dc/terms/> .
@prefix sc: <https://schema.org/> .

<file:///github/workspace/images> a cr:RecordSet ;
    cr:field <file:///github/workspace/images/hash>,
        <file:///github/workspace/images/image_content> ;
    cr:key <file:///github/workspace/hash> ;
    sc:name "images"@en .

<file:///github/workspace/images/hash> a cr:Field ;
    cr:dataType sc:Text ;
    cr:source [ cr:extract [ cr:fileProperty "filename"@en ] ;
            cr:fileSet <file:///github/workspace/image-files> ;
            cr:transform [ cr:regex "([^\\/]*)\\.jpg"@en ] ] ;
    sc:description "The hash of the image, as computed from YFCC-100M."@en ;
    sc:name "images/hash"@en .

<file:///github/workspace/images/image_content> a cr:Field ;
    cr:dataType sc:ImageObject ;
    cr:source [ cr:extract [ cr:fileProperty "content"@en ] ;
            cr:fileSet <file:///github/workspace/image-files> ] ;
    sc:description "The content of the image."@en ;
    sc:name "images/image_content"@en .

<file:///github/workspace/metadata> a cr:FileObject ;
    sc:contentUrl "https://zenodo.org/record/6615455/files/pass_metadata.csv"@en ;
    sc:encodingFormat "text/csv"@en ;
    sc:name "metadata"@en ;
    sc:sha256 "0b033707ea49365a5ffdd14615825511"@en .

<file:///github/workspace/image-files> a cr:FileSet ;
    cr:includes "*.jpg"@en ;
    sc:containedIn <file:///github/workspace/pass0> ;
    sc:encodingFormat "image/jpeg"@en ;
    sc:name "image-files"@en .

[] a sc:Dataset ;
    cr:citeAs "@Article{asano21pass, author = \"Yuki M. Asano and Christian Rupprecht and Andrew Zisserman and Andrea Vedaldi\", title = \"PASS: An ImageNet replacement for self-supervised pretraining without humans\", journal = \"NeurIPS Track on Datasets and Benchmarks\", year = \"2021\" }"@en ;
    cr:recordSet <file:///github/workspace/images> ;
    dct:conformsTo "http://mlcommons.org/croissant/1.0"@en ;
    sc:description "PASS is a large-scale image dataset that does not include any humans and which can be used for high-quality pretraining while significantly reducing privacy concerns."@en ;
    sc:distribution <file:///github/workspace/image-files>,
        <file:///github/workspace/metadata> ;
    sc:license "cc-by-4.0"@en ;
    sc:name "PASS"@en ;
    sc:url "https://www.robots.ox.ac.uk/~vgg/data/pass/"@en .


```

## Schema

```yaml
$schema: https://json-schema.org/draft/2020-12/schema
title: Croissant Dataset
description: 'A Croissant dataset description following the MLCommons Croissant Format
  Specification v1.0.

  This extends schema.org/Dataset with ML-specific metadata.

  '
type: object
required:
- '@context'
- '@type'
- conformsTo
- name
- description
- url
- distribution
- license
allOf:
- $ref: '#/$defs/SchemaOrgDataset'
- properties:
    '@context':
      oneOf:
      - type: object
        properties:
          '@language':
            type: string
            default: en
          '@vocab':
            type: string
            const: https://schema.org/
      - type: array
    '@type':
      type: string
      const: sc:Dataset
    conformsTo:
      type: string
      const: http://mlcommons.org/croissant/1.0
      description: Declaration that this dataset conforms to Croissant v1.0
      x-jsonld-id: http://purl.org/dc/terms/conformsTo
    name:
      type: string
      description: The name of the dataset
    description:
      type: string
      description: Description of the dataset
    url:
      type: string
      format: uri
      description: The URL of the dataset (generally the Web page)
    license:
      oneOf:
      - type: string
        format: uri
      - type: array
        items:
          type: string
          format: uri
      description: License URL(s), preferably from https://spdx.org/licenses/
    creator:
      oneOf:
      - $ref: '#/$defs/OrganizationOrPerson'
      - type: array
        items:
          $ref: '#/$defs/OrganizationOrPerson'
      description: The creator(s) of the dataset
    datePublished:
      type: string
      format: date
      description: The date the dataset was published
    distribution:
      type: array
      description: FileObject or FileSet resources in the dataset
      items:
        oneOf:
        - $ref: '#/$defs/FileObject'
        - $ref: '#/$defs/FileSet'
    recordSet:
      type: array
      description: RecordSets defining the structure of the data
      items:
        $ref: '#/$defs/RecordSet'
      x-jsonld-id: http://mlcommons.org/croissant/recordSet
    citeAs:
      type: string
      description: Citation for the dataset (preferably bibtex format)
      x-jsonld-id: http://mlcommons.org/croissant/citeAs
    isLiveDataset:
      type: boolean
      description: Whether the dataset is a live dataset
      x-jsonld-id: http://mlcommons.org/croissant/isLiveDataset
    version:
      oneOf:
      - type: string
      - type: number
      description: Dataset version (recommended format MAJOR.MINOR.PATCH)
    keywords:
      type: array
      description: Keywords associated with the dataset
      items:
        type: string
    publisher:
      oneOf:
      - $ref: '#/$defs/OrganizationOrPerson'
      - type: array
        items:
          $ref: '#/$defs/OrganizationOrPerson'
$defs:
  SchemaOrgDataset:
    type: object
    description: Base schema.org Dataset properties
  OrganizationOrPerson:
    oneOf:
    - type: object
      properties:
        '@type':
          type: string
          enum:
          - Organization
          - Person
        name:
          type: string
    - type: string
  FileObject:
    type: object
    required:
    - '@type'
    - '@id'
    properties:
      '@type':
        type: string
        const: cr:FileObject
      '@id':
        type: string
        description: Unique identifier for this FileObject
      name:
        type: string
        description: Name of the file (should reflect downloaded filename)
      contentUrl:
        type: string
        format: uri
        description: URL to the actual file
      contentSize:
        type: string
        description: File size (with or without unit)
      encodingFormat:
        type: string
        description: MIME type of the file
      sha256:
        type: string
        description: SHA-256 checksum of file contents
      containedIn:
        oneOf:
        - type: object
          properties:
            '@id':
              type: string
        - type: array
          items:
            type: object
            properties:
              '@id':
                type: string
        description: Another FileObject/FileSet this is contained in
  FileSet:
    type: object
    required:
    - '@type'
    - '@id'
    - containedIn
    properties:
      '@type':
        type: string
        const: cr:FileSet
      '@id':
        type: string
        description: Unique identifier for this FileSet
      name:
        type: string
      description:
        type: string
      containedIn:
        oneOf:
        - type: object
          properties:
            '@id':
              type: string
        - type: array
          items:
            type: object
            properties:
              '@id':
                type: string
        description: Source of data (e.g., an archive)
      includes:
        oneOf:
        - type: string
        - type: array
          items:
            type: string
        description: Glob pattern(s) for files to include
        x-jsonld-id: http://mlcommons.org/croissant/includes
      excludes:
        oneOf:
        - type: string
        - type: array
          items:
            type: string
        description: Glob pattern(s) for files to exclude
      encodingFormat:
        type: string
        description: MIME type of files in the set
  RecordSet:
    type: object
    required:
    - '@type'
    - '@id'
    - field
    properties:
      '@type':
        type: string
        const: cr:RecordSet
      '@id':
        type: string
        description: Unique identifier for this RecordSet
      name:
        type: string
      description:
        type: string
      field:
        type: array
        description: Fields (columns) in this RecordSet
        items:
          $ref: '#/$defs/Field'
        x-jsonld-id: http://mlcommons.org/croissant/field
      key:
        oneOf:
        - type: object
          properties:
            '@id':
              type: string
        - type: array
          items:
            type: object
            properties:
              '@id':
                type: string
        description: Field(s) that uniquely identify records
        x-jsonld-id: http://mlcommons.org/croissant/key
      data:
        type: array
        description: Inline data for small enumerations
        x-jsonld-id: http://mlcommons.org/croissant/data
        x-jsonld-type: '@json'
      dataType:
        oneOf:
        - type: string
        - type: array
          items:
            type: string
        description: Semantic type of records in this RecordSet
        x-jsonld-id: http://mlcommons.org/croissant/dataType
        x-jsonld-type: '@vocab'
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
        description: Unique identifier for this Field
      name:
        type: string
      description:
        type: string
      dataType:
        oneOf:
        - type: string
        - type: array
          items:
            type: string
        description: Data type(s) of field values
        x-jsonld-id: http://mlcommons.org/croissant/dataType
        x-jsonld-type: '@vocab'
      source:
        oneOf:
        - $ref: '#/$defs/DataSource'
        - type: object
          additionalProperties: false
          required:
          - '@id'
          properties:
            '@id':
              type: string
        description: Source of data for this field
        x-jsonld-id: http://mlcommons.org/croissant/source
      references:
        type: object
        properties:
          '@id':
            type: string
        description: Foreign key reference to another Field
        x-jsonld-id: http://mlcommons.org/croissant/references
      repeated:
        type: boolean
        description: Whether this field contains a list of values
        x-jsonld-id: http://mlcommons.org/croissant/repeated
      subField:
        type: array
        description: Nested fields
        items:
          $ref: '#/$defs/Field'
        x-jsonld-id: http://mlcommons.org/croissant/subField
  DataSource:
    type: object
    additionalProperties: false
    properties:
      fileObject:
        type: object
        properties:
          '@id':
            type: string
        x-jsonld-id: http://mlcommons.org/croissant/fileObject
      fileSet:
        type: object
        properties:
          '@id':
            type: string
        x-jsonld-id: http://mlcommons.org/croissant/fileSet
      recordSet:
        type: object
        properties:
          '@id':
            type: string
        x-jsonld-id: http://mlcommons.org/croissant/recordSet
      extract:
        type: object
        description: Extraction method from source
        properties:
          column:
            type: string
            x-jsonld-id: http://mlcommons.org/croissant/column
          fileProperty:
            type: string
            enum:
            - fullpath
            - filename
            - content
            - lines
            - lineNumbers
            x-jsonld-id: http://mlcommons.org/croissant/fileProperty
          jsonPath:
            type: string
            x-jsonld-id: http://mlcommons.org/croissant/jsonPath
        x-jsonld-id: http://mlcommons.org/croissant/extract
      transform:
        type: object
        description: Transformation to apply
        properties:
          regex:
            type: string
            x-jsonld-id: http://mlcommons.org/croissant/regex
          delimiter:
            type: string
          jsonQuery:
            type: string
        x-jsonld-id: http://mlcommons.org/croissant/transform
      format:
        type: string
        description: Format string for parsing values
        x-jsonld-id: http://mlcommons.org/croissant/format
x-jsonld-extra-terms:
  column: http://mlcommons.org/croissant/column
  examples:
    x-jsonld-id: http://mlcommons.org/croissant/examples
    x-jsonld-type: '@json'
  extract: http://mlcommons.org/croissant/extract
  fileProperty: http://mlcommons.org/croissant/fileProperty
  fileObject: http://mlcommons.org/croissant/fileObject
  fileSet: http://mlcommons.org/croissant/fileSet
  format: http://mlcommons.org/croissant/format
  jsonPath: http://mlcommons.org/croissant/jsonPath
  md5: http://mlcommons.org/croissant/md5
  parentField: http://mlcommons.org/croissant/parentField
  path: http://mlcommons.org/croissant/path
  references: http://mlcommons.org/croissant/references
  regex: http://mlcommons.org/croissant/regex
  repeated: http://mlcommons.org/croissant/repeated
  replace: http://mlcommons.org/croissant/replace
  separator: http://mlcommons.org/croissant/separator
  source: http://mlcommons.org/croissant/source
  subField: http://mlcommons.org/croissant/subField
  transform: http://mlcommons.org/croissant/transform
x-jsonld-vocab: https://schema.org/
x-jsonld-prefixes:
  cr: http://mlcommons.org/croissant/
  dct: http://purl.org/dc/terms/
  sc: https://schema.org/
  geocr: http://mlcommons.org/geocroissant/
  rai: http://mlcommons.org/croissant/RAI/
  geo: http://www.opengis.net/ont/geosparql#

```

Links to the schema:

* YAML version: [schema.yaml](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/dataset/schema.json)
* JSON version: [schema.json](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/dataset/schema.yaml)


# JSON-LD Context

```jsonld
{
  "@context": {
    "@vocab": {
      "@context": {}
    },
    "@language": {
      "@context": {}
    },
    "@context": {
      "@context": {}
    },
    "@type": {
      "@context": {}
    },
    "conformsTo": "dct:conformsTo",
    "name": {},
    "description": {},
    "url": {},
    "license": {},
    "creator": {},
    "datePublished": {},
    "@id": {
      "@context": {}
    },
    "contentUrl": {},
    "contentSize": {},
    "encodingFormat": {},
    "sha256": {},
    "containedIn": {},
    "includes": "cr:includes",
    "excludes": {},
    "distribution": {},
    "recordSet": {
      "@context": {
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
            },
            "source": {
              "@context": {
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
                "transform": {
                  "@context": {
                    "delimiter": {},
                    "jsonQuery": {}
                  },
                  "@id": "cr:transform"
                },
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
        "dataType": {
          "@id": "cr:dataType",
          "@type": "@vocab"
        }
      },
      "@id": "cr:recordSet"
    },
    "citeAs": "cr:citeAs",
    "isLiveDataset": "cr:isLiveDataset",
    "version": {},
    "keywords": {},
    "publisher": {},
    "column": "cr:column",
    "examples": {
      "@id": "cr:examples",
      "@type": "@json"
    },
    "extract": "cr:extract",
    "fileProperty": "cr:fileProperty",
    "fileObject": "cr:fileObject",
    "fileSet": "cr:fileSet",
    "format": "cr:format",
    "jsonPath": "cr:jsonPath",
    "md5": "cr:md5",
    "parentField": "cr:parentField",
    "path": "cr:path",
    "references": "cr:references",
    "regex": "cr:regex",
    "repeated": "cr:repeated",
    "replace": "cr:replace",
    "separator": "cr:separator",
    "source": "cr:source",
    "subField": "cr:subField",
    "transform": "cr:transform",
    "cr": "http://mlcommons.org/croissant/",
    "dct": "http://purl.org/dc/terms/",
    "sc": "https://schema.org/",
    "geocr": "http://mlcommons.org/geocroissant/",
    "rai": "cr:RAI/",
    "geo": "http://www.opengis.net/ont/geosparql#",
    "@version": 1.1
  }
}
```

You can find the full JSON-LD context here:
[context.jsonld](https://geolabs.github.io/bblocks-croissant/build/annotated/croissant/dataset/context.jsonld)

## Sources

* [Croissant Format Specification v1.0](https://docs.mlcommons.org/croissant/docs/croissant-spec.html)
* [MLCommons Croissant](https://mlcommons.org/croissant/)

# For developers

The source code for this Building Block can be found in the following repository:

* URL: [https://github.com/GeoLabs/bblocks-croissant](https://github.com/GeoLabs/bblocks-croissant)
* Path: `_sources/dataset`

