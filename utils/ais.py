from utils.radar import Radar
import utils.Coor as coor
import json

class Ais(Radar):    
    def __init__(self, ori_xy, position, range=900000, status=True):
        super(Ais, self).__init__(ori_xy, position, range=900000, status=True)
        
    def run(self,obj):
        result_val = []
        result = {}
        ori_xy = self.ori_xy
        for i in range(len(obj)):
            if((obj[i]["latitude"]-self.position[0])**2 + 
                   (obj[i]["longitude"]-self.position[1])**2 < self.range**2):
                obj[i]["latitude"], obj[i]["longitude"] = coor.xy_to_coor(ori_xy[0]+obj[i]["latitude"],ori_xy[1]+obj[i]["longitude"])      
                result_val.append(obj[i])
                #print("AISinfo:{}".format(obj[i]))
            else:
                break
                #print("未检测到目标!")
        #print('--------------')
        temp = {}
        result['cmd'] = 'ais_status'
        result['param'] = temp
        temp['aisInfo'] = result_val
        ais_result = json.dumps(result,indent=1,ensure_ascii = False)
        with open("ais_result.json",'w',encoding='utf-8') as f:
            f.write(ais_result)
        # print(ais_result)
        