import socket
import os
import argparse
from utils import *

'''
 '{"title": "test notification", "icon_path": "/home/narval/.config/eww/icons/bell.svg", "icon_color": "#f38ba8", "urgency": 1}'
'''

parser = argparse.ArgumentParser(
                    prog='Notch daemon util',
                    description='A util for communcication with the notch daemon')

parser.add_argument('-n', '--notification') 
parser.add_argument('-t', '--test', action='store_true') 

args = parser.parse_args()

if args.notification:
    socket_path = "/home/narval/.config/eww/notch_daemon/notch_daemon.sock"

    client_sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    client_sock.connect(socket_path)

    widget = f'''
        {{
            "type": 1,
            "body": {args.notification}
        }}
    '''

    client_sock.send(widget.encode("utf-8"))

elif args.test:
   update_eww('''
    (notification :title 'Test'
                      :icon_path '/home/narval/.config/eww/icons/charging_battery.svg'
                      :icon_color '#a6e3a1'
                      :urgency 3
    )
   ''') 
