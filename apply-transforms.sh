#!/usr/bin/env bash

# Script to apply JQ transforms to example files and generate transform outputs
# This creates the files expected by the OGC Building Blocks viewer UI

# Don't use set -e to allow error collection
# set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCES_DIR="$SCRIPT_DIR/_sources/geocroissant"
TRANSFORMS_DIR="$SOURCES_DIR/transforms"
TEST_INPUTS_DIR="$SOURCES_DIR/test-inputs"

# Use 'build' directory if it exists (GitHub Actions), otherwise 'build-local'
if [ -d "$SCRIPT_DIR/build" ]; then
    OUTPUT_DIR="$SCRIPT_DIR/build/tests/croissant/geocroissant"
else
    OUTPUT_DIR="$SCRIPT_DIR/build-local/tests/croissant/geocroissant"
fi

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== GeoCroissant Transform Application ===${NC}"
echo ""
echo "Script directory: $SCRIPT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo ""

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed. Please install it first:${NC}"
    echo "  macOS: brew install jq"
    echo "  Linux: apt-get install jq or yum install jq"
    exit 1
fi

# Create output directory structure
echo -e "${YELLOW}Creating output directory structure...${NC}"
mkdir -p "$OUTPUT_DIR/transforms"

# Define transform mappings
# Transform definitions mapping: transform_id:jq_file:input_example:example_number:input_dir
# Note: Example numbers correspond to position in examples.yaml (1-indexed)
# Examples 1-3 are GeoCroissant examples (use for inverse transforms)
# Examples 4-9 are source formats for forward transforms
TRANSFORM_MAPPINGS=(
    # Inverse transforms from GeoCroissant examples (examples 1-3)
    "geocroissant-to-stac:geocroissant-to-stac.jq:bbox-example.json:1:examples"
    "geocroissant-to-geodcat:geocroissant-to-geodcat.jq:bbox-example.json:1:examples"
    "geocroissant-to-stac:geocroissant-to-stac.jq:point-example.json:2:examples"
    "geocroissant-to-geodcat:geocroissant-to-geodcat.jq:point-example.json:2:examples"
    "geocroissant-to-stac:geocroissant-to-stac.jq:polygon-example.json:3:examples"
    "geocroissant-to-geodcat:geocroissant-to-geodcat.jq:polygon-example.json:3:examples"
)

# Function to apply a transform
apply_transform() {
    local transform_id="$1"
    local transform_file="$2"
    local input_file="$3"
    local example_num="$4"
    local input_dir="${5:-test-inputs}"  # Default to test-inputs if not specified
    
    local transform_path="$TRANSFORMS_DIR/$transform_file"
    local input_path="$SOURCES_DIR/$input_dir/$input_file"
    local output_file="example_${example_num}_1.${transform_id}.json"
    local output_path="$OUTPUT_DIR/transforms/$output_file"
    
    echo -e "${YELLOW}Transform: ${transform_id}${NC}"
    
    # Check if transform file exists
    if [ ! -f "$transform_path" ]; then
        echo -e "${RED}  ✗ Transform not found: $transform_path${NC}"
        return 1
    fi
    
    # Check if input file exists
    if [ ! -f "$input_path" ]; then
        echo -e "${YELLOW}  ⚠ Input example not found: $input_file${NC}"
        echo -e "${YELLOW}    Creating placeholder for demonstration...${NC}"
        
        # Create a minimal placeholder based on transform type
        case "$transform_id" in
            stac-to-geocroissant)
                cat > "$input_path" <<'EOF'
{
  "type": "Collection",
  "id": "example-collection",
  "stac_version": "1.1.0",
  "description": "Example STAC Collection for GeoCroissant transformation",
  "license": "CC-BY-4.0",
  "extent": {
    "spatial": {
      "bbox": [[-180, -90, 180, 90]]
    },
    "temporal": {
      "interval": [["2020-01-01T00:00:00Z", "2024-12-31T23:59:59Z"]]
    }
  },
  "links": [
    {
      "rel": "root",
      "href": "./collection.json",
      "type": "application/json"
    }
  ],
  "assets": {
    "data": {
      "href": "https://example.org/data.tif",
      "type": "image/tiff; application=geotiff",
      "roles": ["data"]
    }
  }
}
EOF
                ;;
            nasa-umm-to-geocroissant)
                cat > "$input_path" <<'EOF'
{
  "EntryTitle": "Example NASA UMM-G Dataset",
  "ShortName": "EXAMPLE_UMM",
  "Abstract": "Example UMM-G metadata for GeoCroissant transformation",
  "SpatialExtent": {
    "HorizontalSpatialDomain": {
      "Geometry": {
        "BoundingRectangles": [{
          "WestBoundingCoordinate": -180,
          "SouthBoundingCoordinate": -90,
          "EastBoundingCoordinate": 180,
          "NorthBoundingCoordinate": 90
        }]
      }
    }
  },
  "TemporalExtents": [{
    "RangeDateTimes": [{
      "BeginningDateTime": "2020-01-01T00:00:00Z",
      "EndingDateTime": "2024-12-31T23:59:59Z"
    }]
  }],
  "RelatedUrls": [{
    "URL": "https://example.org/data.nc",
    "Type": "GET DATA"
  }],
  "ScienceKeywords": [{
    "Category": "EARTH SCIENCE",
    "Topic": "ATMOSPHERE",
    "Term": "TEMPERATURE"
  }],
  "DataCenters": [{
    "ShortName": "NASA",
    "LongName": "National Aeronautics and Space Administration"
  }]
}
EOF
                ;;
            ceda-to-geocroissant)
                cat > "$input_path" <<'EOF'
{
  "stac_attributes": {
    "properties": {
      "title": "Example CEDA CMIP6 Dataset",
      "description": "Example CEDA metadata for GeoCroissant transformation",
      "start_datetime": "2020-01-01T00:00:00Z",
      "end_datetime": "2024-12-31T23:59:59Z",
      "bbox": [-180, -90, 180, 90],
      "institution_id": "MOHC",
      "source_id": "HadGEM3-GC31-LL",
      "experiment_id": "historical",
      "variable_id": "tas",
      "frequency": "mon",
      "realm": "atmos"
    }
  },
  "links": [{
    "rel": "item",
    "href": "https://example.org/data.zarr",
    "type": "application/json"
  }]
}
EOF
                ;;
            datacube-to-geocroissant)
                cat > "$input_path" <<'EOF'
{
  "attrs": {
    "title": "Example DataCube Dataset",
    "description": "Example RDF DataCube for GeoCroissant transformation",
    "geospatial_lon_min": -180,
    "geospatial_lon_max": 180,
    "geospatial_lat_min": -90,
    "geospatial_lat_max": 90,
    "geospatial_lon_resolution": 0.5,
    "geospatial_lat_resolution": 0.5,
    "time_coverage_start": "2020-01-01T00:00:00Z",
    "time_coverage_end": "2024-12-31T23:59:59Z",
    "source_url": "https://example.org/data.zarr"
  },
  "dims": {
    "time": 60,
    "lat": 360,
    "lon": 720
  },
  "data_vars": {
    "temperature": {
      "dims": ["time", "lat", "lon"],
      "attrs": {
        "units": "K",
        "long_name": "Air Temperature",
        "standard_name": "air_temperature"
      }
    }
  }
}
EOF
                ;;
            tdml-to-geocroissant)
                cat > "$input_path" <<'EOF'
{
  "id": "example-training-dataset",
  "name": "Example TDML Training Dataset",
  "description": "Example OGC TDML for GeoCroissant transformation",
  "license": "CC-BY-4.0",
  "extent": {
    "spatial": [-180, -90, 180, 90],
    "temporal": {
      "start": "2020-01-01T00:00:00Z",
      "end": "2024-12-31T23:59:59Z"
    }
  },
  "data": [
    {"id": 1, "label": "class_a", "geometry": {"type": "Point", "coordinates": [0, 0]}},
    {"id": 2, "label": "class_b", "geometry": {"type": "Point", "coordinates": [1, 1]}}
  ],
  "dataSources": [{
    "id": "imagery",
    "source": "https://example.org/imagery.tif",
    "format": "image/tiff"
  }]
}
EOF
                ;;
            geodcat-to-geocroissant)
                cat > "$input_path" <<'EOF'
{
  "@context": {
    "dcat": "http://www.w3.org/ns/dcat#",
    "dct": "http://purl.org/dc/terms/",
    "foaf": "http://xmlns.com/foaf/0.1/",
    "locn": "http://www.w3.org/ns/locn#"
  },
  "@type": "dcat:Dataset",
  "dct:title": "Example GeoDCAT Dataset",
  "dct:description": "Example GeoDCAT metadata for GeoCroissant transformation",
  "dct:license": {"@id": "http://creativecommons.org/licenses/by/4.0/"},
  "dct:spatial": {
    "@type": "dct:Location",
    "locn:geometry": {
      "@type": "https://www.iana.org/assignments/media-types/application/vnd.geo+json",
      "@value": "{\"type\":\"Polygon\",\"coordinates\":[[[-180,-90],[-180,90],[180,90],[180,-90],[-180,-90]]]}"
    }
  },
  "dct:temporal": {
    "@type": "dct:PeriodOfTime",
    "dcat:startDate": "2020-01-01",
    "dcat:endDate": "2024-12-31"
  },
  "dcat:distribution": [{
    "@type": "dcat:Distribution",
    "dcat:accessURL": {"@id": "https://example.org/data"},
    "dct:format": "application/x-netcdf"
  }],
  "dct:creator": {
    "@type": "foaf:Organization",
    "foaf:name": "Example Organization"
  },
  "dcat:keyword": ["example", "geodcat", "geospatial"]
}
EOF
                ;;
        esac
    fi
    
    # Apply the transform
    echo -e "${BLUE}  → Applying transform...${NC}"
    if jq -f "$transform_path" "$input_path" > "$output_path" 2>/dev/null; then
        echo -e "${GREEN}  ✓ Success: $output_file${NC}"
        echo -e "${GREEN}    Output: $output_path${NC}"
        return 0
    else
        echo -e "${RED}  ✗ Failed to apply transform${NC}"
        # Try to get error details
        jq -f "$transform_path" "$input_path" 2>&1 | head -5 | sed 's/^/    /'
        return 1
    fi
}

# Apply all transforms
echo ""
success_count=0
fail_count=0

for mapping in "${TRANSFORM_MAPPINGS[@]}"; do
    IFS=':' read -r transform_id transform_file input_file example_num input_dir <<< "$mapping"
    echo ""
    if apply_transform "$transform_id" "$transform_file" "$input_file" "$example_num" "$input_dir"; then
        success_count=$((success_count + 1))
    else
        fail_count=$((fail_count + 1))
    fi
done

# Summary
echo ""
echo -e "${BLUE}=== Summary ===${NC}"
echo -e "${GREEN}✓ Successful: $success_count${NC}"
if [ $fail_count -gt 0 ]; then
    echo -e "${RED}✗ Failed: $fail_count${NC}"
fi
echo ""

# List generated files
if [ $success_count -gt 0 ]; then
    echo -e "${BLUE}Generated transform outputs:${NC}"
    ls -lh "$OUTPUT_DIR/transforms/" 2>/dev/null | grep -v "^total" | sed 's/^/  /' || true
    echo ""
fi

echo -e "${GREEN}Transform application complete!${NC}"
echo -e "View results at: ${BLUE}http://localhost:9090/register/bblock/mlc.croissant.geocroissant${NC}"

# Exit with proper code
if [ $fail_count -gt 0 ]; then
    exit 1
fi
exit 0
