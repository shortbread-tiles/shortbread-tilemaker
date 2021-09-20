#! /usr/bin/env python3

import argparse
import json
import sys

def compare_layer_lists(vector_layers, tilestats_layers):
    layers1 = [ l["id"] for l in vector_layers ].sort()
    layers2 = [ l["layer"] for l in tilestats_layers ].sort()
    return layers1 == layers2


parser = argparse.ArgumentParser(description="Convert a metadata.json file created by Tilelive/Tessera into a metadata.json file needed by GDAL's MVT driver.")
parser.add_argument("input_file", type=argparse.FileType("r"), help="Input metadata.json file")
parser.add_argument("tilestats_file", type=argparse.FileType("r"), help="Geometry definitions for layers (contains a JSON with a tileStats field)")
args = parser.parse_args()

# Read input file
input_data = json.load(args.input_file)
try:
    # Double json.load because the field "json" is JSON encoded as string
    json_data = json.loads(input_data["json"])
except KeyError as e:
    sys.stderr.write("Cannot find member 'json' in input metadata.json file\n")
    exit(1)

if "tilestats" not in json_data:
    # Read tilestats_file
    tilestats = json.load(args.tilestats_file)
    if "tilestats" not in tilestats:
        sys.stderr.write("Tilestats file misses 'tilestats' member.\n")
        exit(1)
    json_data["tilestats"] = tilestats["tilestats"]
    if len(json_data["tilestats"]["layers"]) != json_data["tilestats"]["layerCount"]:
        sys.stderr.write("Length of tilestats.layers does not match tilestats.layerCount!\n")
        exit(1)
    if not compare_layer_lists(json_data["vector_layers"], json_data["tilestats"]["layers"]):
        sys.stderr.write("Layer lists of vector_layers and tilestats.layers differ.\n")
        exit(1)
else:
    sys.stderr.write("Ignoring tilestats file because input file contains a tilestats property already\n")

input_data["json"] = json.dumps(json_data)

sys.stdout.write(json.dumps(input_data))
