import os
import json

networks = []
command = "nmcli -t -f SSID,SIGNAL,SECURITY device wifi list"

def find_ssid_in_net_list(ssid):
    for i in range(len(networks)):
        if networks[i]["ssid"] == ssid:
            return i
    return -1


with os.popen(command) as res:
    for line in res:
        line = line.split(":")
        if len(line) == 3:
            ssid = line[0]
            if (len(ssid) < 1):
                continue

            strength = int(line[1])
            security = line[2]
            
            in_list = find_ssid_in_net_list(ssid) 
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
