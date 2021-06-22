import utils.Coor as coor
import math
import random as rd
import json
import time
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

class Radar:
    pi = math.pi
    # 弧度转角度
    degree = pi / 180
    
    
    def __init__(self, ori_xy, position, status=True, range=1000000):
        #self.name = name
        self.ori_xy = ori_xy
        self.status = status
        self.position = position
        self.range = range
        #self.objNum = objNum
        
    def run(self,obj,ip_p):
        result = {}
        result_val = []
        result['cmd'] = 'detected_info'
        ori_xy = self.ori_xy
        for i in range(len(obj)):
            temp = {}
            if((obj[i][0]-self.position[0])**2 + 
                   (obj[i][1]-self.position[1])**2 < self.range**2):
                if(obj[i][2] == 0):
                    temp['signType'] = 2
                    temp['signName'] = '可疑水上目标{}'.format(i+1)
                else:
                    temp['signType'] = 3
                    temp['signName'] = '可疑空中目标{}'.format(i+1)
                obj_latlon = coor.xy_to_coor(ori_xy[0]+obj[i][0],ori_xy[1]+obj[i][1])
                # obj_latlon.append(obj[i][2])

                temp['createdTime'] = time.strftime('%Y-%m-%d %H:%M:%S')
                temp['updateTime'] = time.strftime('%Y-%m-%d %H:%M:%S')
                temp['lat'] = obj_latlon[0]
                temp['lng'] = obj_latlon[1]
                result_val.append(temp)
                #print("type:{},position:{}".format(type,obj_latlon))
            else:
                break

        #print(result_val)
        target = {}
        target['target'] = result_val
        result['param'] = target
        radar_result = json.dumps(result,indent=1,ensure_ascii = False)

        ip,port = ip_p.split("/")
        port = int(port)

        with open("radar_result.json",'w',encoding='utf-8') as f:
            f.write(radar_result)

        if(ip == "127.0.0.1"):
            return "radar本地地址"
        else:
            s.sendto(str(radar_result).encode('utf-8'),(ip,port))
            revData = s.recv(1024).decode('utf-8')
            print(revData)
            return revData
        
        
        #print(radar_result)
                #print("未检测到目标!")