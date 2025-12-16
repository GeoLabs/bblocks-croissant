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
