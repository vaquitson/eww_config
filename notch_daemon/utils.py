import os
import json

EWW_CMD = "/home/narval/r_repos/eww/target/release/eww"
EXPECTED_JSON_FIELDS = {"type": int, "body": str}

TYPE_WIDGET = 0
TYPE_NOTIFICATION = 1

error = ""

def update_eww(widget):
    with os.popen(f'{EWW_CMD} update literal_widget="{widget}"') as res:
        for line in res:
            print(line)



def msg_to_json(msg):
    try:
        json_msg = json.loads(msg)
    except json.JSONDecodeError as e:
        error = e
        return None

    for key, expected_type in EXPECTED_JSON_FIELDS.items():
        if key not in json_msg:
            error = f"key {key} not specified"
            return None
        if not isinstance(json_msg[key], expected_type):
            error = f"key {key} is not the correct type, expected {expected_type} get {json_msg[key]}"
            return None
    return json_msg



