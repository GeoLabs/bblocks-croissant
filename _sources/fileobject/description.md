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
