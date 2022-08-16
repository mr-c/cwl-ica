#!/usr/bin/env python

"""
Aims:
Convert a CWL schema (in yaml format) to a TypeScript interface.
"""

# Imports
from pathlib import Path
from cwl_utils.parser_v1_1 import RecordSchema
from ruamel import yaml
from pprint import pprint

import logging
from typing import Dict
from tempfile import NamedTemporaryFile
from subprocess import run
import json
from typing import List


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

TEST_CWL_SCHEMA_FILE_PATHS: List[Path] = list(Path.rglob(
    Path("../schemas/"), "**/*.yaml"
))


def import_cwl_yaml(cwl_file_path):
    # Read in the cwl file from a yaml
    with open(cwl_file_path, "r") as cwl_h:
        yaml_obj = yaml.main.round_trip_load(cwl_h, preserve_quotes=True)

    return RecordSchema(yaml_obj.get("fields"))


def is_optional(input_type):
    if isinstance(input_type, List):
        input_type = input_type.copy()
        if "null" in input_type:
            _ = input_type.pop(input_type.index("null"))
            return input_type, True
        else:
            return input_type, False
    if isinstance(input_type, Dict):
        input_type = input_type.copy()
        # FIXME don't know how to set null input type for dict type
        return input_type, False
    if isinstance(input_type, str):
        if input_type.endswith("?"):
            return input_type.rstrip("?"), True
        else:
            return input_type, False


def is_array(input_type):
    if isinstance(input_type, List):
        return input_type, False  # The irony
    if isinstance(input_type, Dict):
        if input_type.get("type", None) is not None and input_type.get("type").lower() == "array":
            return input_type.get("items"), True
        else:
            # FIXME - don't have an example here
            return input_type, False
    if isinstance(input_type, str):
        if input_type.endswith("[]"):
            return input_type.rstrip("[]"), True
        else:
            return input_type, False


def collect_types(input_type, cwl_file_path):
    input_type = input_type.copy()
    if isinstance(input_type, Dict):
        # One of record, enum or $import
        if "$import" in input_type.keys():
            # Resolve path  # TODO - update to python 3.9, use is_relative_to
            import_path = Path(input_type["$import"].split("#", 1)[0])  # Strips '#'
            abs_path = (cwl_file_path.parent / import_path).resolve()

            # elif Path(cwl_file_path).is_absolute():
            #     abs_path = cwl_file_path
            # else:
            #     logger.error(f"Couldn't resolve {Path(cwl_file_path)}")
            #     raise ValueError

            # Load object
            return import_cwl_yaml(abs_path).type, False, True

        if input_type.get("type", None) == "record":
            return input_type.get("fields"), True, False

        return input_type, False, False

    if isinstance(input_type, List):
        # One of
        logger.error("Not expecting a list here!")
        raise ValueError


def create_packed_schema_json(cwl_yaml_path) -> List:
    """
    Created the folllowing file and runs cwltool --pack to generate the output schema

    cwlVersion: v1.1
    class: CommandLineTool

    requirements:
      SchemaDefRequirement:
        types:
          - $import: cwl_yaml_path

    inputs: {}
    outputs: {}

    :param cwl_yaml_path:
    :return:
    """

    cwl_tool_file = NamedTemporaryFile(prefix=str(cwl_yaml_path.stem) + ".tool.cwl")

    with open(cwl_tool_file.name, "w") as cwl_tool_file_h:
        cwl_tool_file_h.write(
            "cwlVersion: v1.1" + "\n" +
            "" + "\n" +
            "class: CommandLineTool" + "\n" +
            "" + "\n" +
            "requirements:" + "\n" +
            "  SchemaDefRequirement:" + "\n" +
            "    types:" + "\n" +
            f"     - $import: {cwl_yaml_path.absolute()}" + "\n" +
            "inputs: {}\n" +
            "outputs: {}\n"
        )

    cwltool_pack_proc = run(["cwltool", "--pack", cwl_tool_file.name], capture_output=True)

    cwl_packed = json.loads(cwltool_pack_proc.stdout.decode())

    cwl_types = cwl_packed.get("requirements")[0].get("types")[0]

    return cwl_types


def show_examples(obj_type):
    obj_name = str(obj_type)
    print(f"# {obj_name} Examples")
    dup_list = []
    packed_list = []

    for test_schema_path in TEST_CWL_SCHEMA_FILE_PATHS:
        test_schema_obj: RecordSchema = import_cwl_yaml(test_schema_path)

        test_schema_type = test_schema_obj.type
        field_name: str
        field_obj: Dict
        for field_name, field_obj in test_schema_type.items():
            if field_obj.get("type") in dup_list:
                continue
            if test_schema_path not in packed_list:
                packed_list.append(test_schema_path)
            if isinstance(field_obj.get("type"), obj_type):
                print(f"#### {test_schema_path.name}/{field_name}")
                print("```json")
                pprint(field_obj.get("type"), indent=4)
                print("```")
                print("* Is optional?")
                input_type, optional = is_optional(field_obj.get("type"))
                input_type, array = is_array(input_type)
                print(f"* Optional = {optional}")
                print(f"* Array {array};")
                if optional or array:
                    print("New input type detected post eval:")
                    print("```")
                    pprint(input_type)
                    print("```")

                input_types = []
                if isinstance(input_type, Dict):
                    new_input_type, export_interface, import_interface = collect_types(input_type, Path(test_schema_path.parent) / Path(test_schema_path.name))
                    input_types.append(new_input_type)
                    print(f"Add extra interface: {export_interface}")
                    print(f"Import of interface required {import_interface}")
                if isinstance(input_type, List):
                    for _input_type in input_type:
                        new_input_type, export_interface, import_interface = collect_types(_input_type, Path(test_schema_path.parent) / Path(test_schema_path.name))
                        print(f"Add extra interface: {export_interface}")
                        print(f"Import of interface required {import_interface}")
                if isinstance(input_type, str):
                    input_types = [input_types]

                print("------------------\n")
                dup_list.append(field_obj.get("type"))
    print(f"### End {obj_name} EXAMPLES ###")


obj_type = Dict,
show_examples(obj_type)

obj_type = List
show_examples(obj_type)

obj_str = str
show_examples(obj_str)

for test_schema_path in TEST_CWL_SCHEMA_FILE_PATHS:
    print(f"This is the output from the schema_to_json script for {test_schema_path}")
    print("```json")
    pprint(create_packed_schema_json(test_schema_path))
    print("```")

print("## This is the end of the packed schema examples")
