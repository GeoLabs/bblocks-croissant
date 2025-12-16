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
