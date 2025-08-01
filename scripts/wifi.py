import os
import json
import argparse

parser = argparse.ArgumentParser(description="Wi-Fi SSID Tool")
subparsers = parser.add_subparsers(dest="action", required=True)

parser_check = subparsers.add_parser("CB_network_button", help="If the network is saved on the system connect to the ssid, else return the form widget")
parser_check.add_argument("-n", "--network", required=True)

subparsers.add_parser("net_info", help="Check the avialable SSID's")
subparsers.add_parser("cur_net", help="Check the currently active network")
subparsers.add_parser("wlan0_state", help="Check the currently active network")

args = parser.parse_args()

def find_ssid_in_net_list(net_list, ssid):
    for i in range(len(net_list)):
        if net_list[i]["ssid"] == ssid:
            return i
    return -1


"""
get a list with the names (ssid) of the saved networks on
the sistem
"""
def _get_saved_networks_list():
    networks = []
    saved_networks_cmd = "nmcli -t -f NAME connection show"
    with os.popen(saved_networks_cmd) as res:
        for line in res:
            networks.append(line.strip("\n"))
    return networks


"""
get the avilable networks info in the form of 
an array of objects
"""
def get_net_info():
    network_info_cmd = "nmcli -t -f SSID,SIGNAL,SECURITY device wifi list"

    networks = []
    saved_networks = _get_saved_networks_list()
 
    with os.popen(network_info_cmd) as res:
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
                 net = {
                     "ssid": ssid,
                     "strength": strength,
                     "security": security,
                     "saved": ssid in saved_networks 
                     }
                 networks.append(net)
             else:
                 if networks[in_list]["strength"] < strength:
                     networks[in_list]["strength"] = strength
    print(json.dumps(networks))
    

"""
get the ssid and the strength of the currentyly connected network
in a json format
"""
def get_cur_net():
    # mi sistem is in esp so change the sí with yes in eng systems
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



def wlan0_state():
    wlan0_state_cmd = "nmcli -t -f GENERAL.STATE device show wlan0"
    with os.popen(wlan0_state_cmd) as res:
        for line in res:
            line = line.split(":")[1]
            line = line.split(" ")[0]
    print(line)


def check_previosly_used_networks(ssid):
    command = "nmcli -t -f NAME connection show"
    with os.popen(command) as res:
        for line in res:
            line = line.strip("\n")
            if line == ssid:
                return True
    return False

   
if args.action == "net_info":
    get_net_info()
elif args.action == "cur_net":
    get_cur_net()
elif args.action == "CB_network_button":
    res = check_previosly_used_networks(args.ssid)
elif args.action == "wlan0_state":
    wlan0_state()


