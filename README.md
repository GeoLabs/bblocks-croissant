# OGC Building Blocks for Croissant ML Dataset Metadata

This repository contains [OGC Building Blocks](https://ogcincubator.github.io/bblocks-docs/) implementing the [Croissant Format Specification v1.0](https://docs.mlcommons.org/croissant/docs/croissant-spec.html), developed by MLCommons.

## What is Croissant?

Croissant is a metadata format that simplifies how data is used by ML models. It provides a vocabulary for dataset attributes, streamlining how data is loaded across ML frameworks such as PyTorch, TensorFlow, or JAX. The format addresses key challenges in the ML ecosystem:

- **Discoverability**: Makes datasets findable by search engines regardless of where they're published
- **Portability**: Enables loading datasets with just a few lines of code across different ML frameworks  
- **Reproducibility**: Standardized format ensures consistent interpretation across tools
- **Responsible AI**: Provides machine-readable metadata for automated RAI metrics computation

## Building Blocks

This register currently includes:

### Croissant Dataset (`mlc.croissant.dataset`)

The core building block implementing a complete Croissant dataset description. It extends [schema.org/Dataset](https://schema.org/Dataset) with ML-specific features including:

- **Distribution**: FileObject and FileSet for describing dataset resources
- **RecordSets**: Structured description of data records with typed fields
- **ML Features**: Splits, categorical data, labels, bounding boxes, and segmentation masks
- **Transformations**: Data extraction and transformation pipelines
- **Versioning**: Semantic versioning with checksums for reproducibility

## Getting Started

### Prerequisites

To work with this repository locally, you'll need:

- Python 3.8+
- The OGC Building Blocks postprocessor

### Local Development

1. Clone this repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Follow the [local build process](https://ogcincubator.github.io/bblocks-docs/build/local) to test your changes.

3. Make modifications to building blocks in the `_sources/` directory.

4. Commit and push your changes. GitHub Actions will automatically process and publish the building blocks.

## Usage Examples

### Computer Vision Dataset (PASS)

The PASS example demonstrates:
- Large-scale image collections
- File archives (tar) with FileSet extraction
- Joining structured metadata (CSV) with unstructured data (images)
- Field transformations using regex

See: `_sources/dataset/examples/pass-simple.json`

### Tabular Dataset (Titanic)

The Titanic example demonstrates:
- CSV data loading
- Categorical data with Wikidata semantic types
- Label fields for supervised learning
- Typed columns (Integer, Float, Text)

See: `_sources/dataset/examples/titanic.json`

## Contributing

Contributions are welcome! To contribute:

1. Fork this repository
2. Create a new branch for your feature
3. Make your changes following the [Building Block structure](https://ogcincubator.github.io/bblocks-docs/create/structure)
4. Test locally using the build process
5. Submit a pull request

## Resources

### Croissant Specification
- [Croissant Format Specification v1.0](https://docs.mlcommons.org/croissant/docs/croissant-spec.html)
- [MLCommons Croissant Project](https://mlcommons.org/croissant/)
- [Croissant GitHub Repository](https://github.com/mlcommons/croissant)
- [Croissant Editor](https://huggingface.co/spaces/MLCommons/croissant-editor)

### OGC Building Blocks
- [Building Blocks Documentation](https://ogcincubator.github.io/bblocks-docs/)
- [Creating Building Blocks](https://ogcincubator.github.io/bblocks-docs/create)
- [Building Block Template](https://github.com/opengeospatial/bblock-template)

### Schema.org
- [Schema.org Dataset](https://schema.org/Dataset)
- [Schema.org Structured Data](https://developers.google.com/search/docs/appearance/structured-data/dataset)

## License

This work is licensed under the Apache License 2.0, consistent with the Croissant specification.

## Authors

Building Blocks implementation by the community, based on the Croissant Format Specification v1.0 authored by:
- Omar Benjelloun (Google)
- Elena Simperl (King's College London & ODI)
- Pierre Marcenac (Google)
- Pierre Ruyssen (Google)
- And many other contributors from MLCommons

## Status

This is an initial implementation of Croissant as OGC Building Blocks. The building blocks are currently under development and follow the Croissant v1.0 specification published on 2024-03-01.

## Contact

For questions about this Building Blocks register:
- Open an issue in this repository
- Refer to the [MLCommons Croissant project](https://mlcommons.org/croissant/)

For questions about OGC Building Blocks in general:
- See the [Building Blocks documentation](https://ogcincubator.github.io/bblocks-docs/)
