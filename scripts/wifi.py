import os
import json
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("action")
args = parser.parse_args()

def find_ssid_in_net_list(net_list, ssid):
    for i in range(len(net_list)):
        if net_list[i]["ssid"] == ssid:
            return i
    return -1


"""
get the avilable networks info in the form of 
an array of objects
"""
def get_net_info():
    networks = []
    command = "nmcli -t -f SSID,SIGNAL,SECURITY device wifi list"

    with os.popen(command) as res:
        for line in res:
            line = line.strip("\n")
            line = line.split(":")
            if len(line) == 3:
             ssid = line[0]
             if (len(ssid) < 1):
                 continue
    
             strength = int(line[1])
             security = line[2]
    
             in_list = find_ssid_in_net_list(networks, ssid) 
             if in_list == -1:
                 networks.append({
                     "ssid": ssid,
                     "strength": strength,
                     "security": security
                     })
             else:
                 if networks[in_list]["strength"] < strength:
                     networks[in_list]["strength"] = strength
    print(json.dumps(networks))
    

"""
get the ssid and the strength of the currentyly connected network
in a json format
"""
def get_cur_net():
    command = "nmcli -t -f SSID,SIGNAL,ACTIVE device wifi list | grep sí" 
    with os.popen(command) as res:
            for line in res:
             line = line.strip("\n")
             line = line.split(":")
             
             strength = line[1]
             if len(strength) == 0:
                 strength = 0
             else:
                 strength = int(strength)
    
             ssid = line[0]
             if len(ssid) == 0:
                 ssid = "?"
    
             print(json.dumps({
                     "ssid": ssid, 
                     "strength": strength
                 }))
             return

    print(json.dumps({
            "ssid": "?", 
            "strength": 0 
        }))

if args.action == "net_info":
    get_net_info()
elif args.action == "cur_net":
    get_cur_net() 

