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


def _check_json_entry(json_entry, key, spected_type):
    if key not in json_entry:
        return None

    if not isinstance(json_entry[key], spected_type):
        return None

    return json_entry[key]

def make_notification(json_msg):
    notification_desc = json_msg["body"]
    
    if not isinstance(notification_desc, dict):
        err = f"incorrect notification description: in body, spected a dict but get a {type(notification_desc)} insted"
        return None

    notification_title = _check_json_entry(notification_desc, "title", str);
    if notification_title == None:
        return None

    notification_urgency = _check_json_entry(notification_desc, "urgency", int);
    if notification_urgency == None:
        notification_urgency = 3;

    notification_icon = _check_json_entry(notification_desc, "icon_path", str);
    if notification_icon == None:
        notification_icon = ""

    notification_icon_color = _check_json_entry(notification_desc, "icon_color", str);
    if notification_icon_color == None:
        notification_icon_color = "#89dceb"

    widget = f"""
        (notification :title '{notification_title}'
                      :icon_path '{notification_icon}'
                      :icon_color '{notification_icon_color}'
                      :urgency {notification_urgency}
        )
    """
    print(widget)

    return widget
