import socket
import os

socket_path = "/home/narval/.config/eww/notch_daemon/notch_daemon.sock"

client_sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
client_sock.connect(socket_path)

widget = '''
    {
    "type": 1, 
    "body": "toruga"
    }
'''

client_sock.send(widget.encode("utf-8"))

