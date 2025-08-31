import os
import json

EWW_CMD = "/home/narval/r_repos/eww/target/release/eww"
EXPECTED_JSON_FIELDS = {"type": int}

TYPE_WIDGET = 0
TYPE_NOTIFICATION = 1

err = ""

def update_eww(widget):
    with os.popen(f'{EWW_CMD} update literal_widget="{widget}"') as res:
        for line in res:
            print(line)


def msg_to_json(msg):
    try:
        json_msg = json.loads(msg)
    except json.JSONDecodeError as e:
        err = e
        return None

    for key, expected_type in EXPECTED_JSON_FIELDS.items():
        if key not in json_msg:
            err = f"key {key} not specified"
            return None
        if not isinstance(json_msg[key], expected_type):
            err = f"key {key} is not the correct type, expected {expected_type} get {json_msg[key]}"
            return None

    if "body" not in json_msg:
        return None


    return json_msg


def make_notification(json_msg):
    notification_desc = json_msg["body"]
    
    if not isinstance(notification_desc, dict):
        err = f"incorrect notification description: in body, spected a dict but get a {type(notification_desc)} insted"
        return None

    if "title" not in notification_desc:
        err = f"incorrect notification: title was not provided"
        return None
    if not isinstance(notification_desc["title"], str):
        err = f"incorrect notification: title got {type(notification_desc['title'])} spected str"
        return None
    notification_title = notification_desc["title"]

    if "body" not in notification_desc:
        notification_body = ""
    if not isinstance(notification_desc["body"], str):
        err = f"incorrect notification: body got {type(notification_desc['body'])} spected str"
        return None
    notification_body = notification_desc["body"]

    if "urgency" not in notification_desc:
        notification_urgency = 3 
    if not isinstance(notification_desc["urgency"], int):
        err = f"incorrect notification: urgency got {type(notification_desc['urgency'])} spected int"
        return None
    notification_urgency = notification_desc["urgency"]

    widget = f"""
        (notification :title '{notification_desc['title']}'
                      :body '{notification_body}'
                      :urgency {notification_urgency}
        )
    """
    print(widget)

    return widget
