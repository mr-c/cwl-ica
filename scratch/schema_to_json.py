#!/usr/bin/env python3

"""
For now just print all possible jsons
"""

from tempfile import NamedTemporaryFile
from subprocess import run
import json
from typing import List


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

    cwl_tool_file = NamedTemporaryFile(prefix=cwl_yaml_path + "tool.cwl")

    with open(cwl_tool_file.name) as cwl_tool_file_h:
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

    cwltool_pack_proc = run(["cwltool", "--pack", cwl_tool_file], capture_output=True)

    cwl_packed = json.loads(cwltool_pack_proc.stdout.decode())

    cwl_types = cwl_packed.get("requirements")[0].get("types")[0]

    return cwl_types
