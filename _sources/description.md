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
