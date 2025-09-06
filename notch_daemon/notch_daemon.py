import socket
import os
import time
from config import *

from utils import *

socket_path = "/home/narval/.config/eww/notch_daemon/notch_daemon.sock"


if os.path.exists(socket_path):
    os.remove(socket_path)


with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as serv_s:
    serv_s.bind(socket_path)
    serv_s.listen()
    print(f"server listening on {socket_path} unix socket")

    while True:
        comunication_soket, adress =  serv_s.accept()
        print(f'open conection with {adress}')

        msg = comunication_soket.recv(1024).decode("utf-8") 
        json_msg = msg_to_json(msg)

        if (json_msg != None):
            if json_msg["type"] == TYPE_NOTIFICATION: 
                notification_widget = make_notification(json_msg) 
                if (notification_widget != None):
                    print("updating")
                    update_eww(notification_widget)
                else:
                    print(error)
                time.sleep(1.5)
                update_eww(defoutl_widget) 

        else:
            print("json faild")
            print(err)
        print(msg)
        
