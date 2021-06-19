import math
import random as rd
import time
import json
pi = math.pi
# 弧度转角度
degree = pi / 180

class Obj:
    def __init__(self,flag = False, obj_type=1,mode=2,xy_pos=[0.0,0.0,0], alpha=0.0,v=0.0,a = 0,dt = 1):
        self.xy_pos = xy_pos
        self.alpha = alpha
        self.v = v
        self.a = a
        self.dt = dt
        self.obj_type = obj_type
        self.mode = mode
        self.flag = flag
        
        
    def get_random_value(self):
        
        # 目标的类型(1:船，2:飞机)
        obj_type = rd.choice([1,2])
        
        # 目标的运动模型(1:静止2:匀速3:匀加速)
        if(obj_type == 2):
            mode = rd.choice([2,3])
            z = rd.randint(5,30)
        else:
            mode = rd.choice([1,2,3])
            z = 0
        
        # 起始坐标            

        x = y = 0.0
        while(x<28000 and y < 20000):
            x = rd.randint(0,30000)
            y = rd.randint(0,50000)
        
        # 随机初速度(m/s)
        if(obj_type == 2):
            v0 = rd.uniform(100,200)
        else:
            v0 = rd.uniform(12,20)        
        
        # 方位角alpha
        alpha = rd.randint(0, 360) * degree
        
        # 匀加速
        if(mode == 3):
            a1 = rd.uniform(-5, 2)
            a2 = rd.uniform(2, 5)
            a = rd.choice([a1, a2])
        # 匀速
        if(mode == 2):
            a = 0.0
        # 静止
        if(mode == 1):
            a = v0 = 0
        
        self.obj_type = obj_type
        self.mode = mode
        self.xy_pos = [x,y,z]
        self.a = a
        self.alpha = alpha
        self.v = v0
        
        print(self.obj_type,self.xy_pos)
        # print(self.obj_type,self.mode,self.xy_pos,self.v,self.a,self.alpha)
        
        
    def move(self):
        dt = self.dt

        print(self.v, self.xy_pos, self.alpha*(180/pi))
        
        x,y,z = self.xy_pos

        if(self.v < 0):
            self.v = 0.0
            self.a = -self.a

        #超过最大速度匀速
        if(self.obj_type == 1):
            if(self.v > 20):
                self.v = 20
                self.mode = 2
                self.a = 0.0

        if(self.obj_type == 2):
            if(self.v > 200):
                self.v = 200
                self.mode = 2
                self.a = 0.0
        
        # 不能到达区域
        if((x<28000 and y < 20000) or x < 0 or y < 0):
            if(self.flag == False):
                self.alpha = 180*degree + self.alpha
                self.flag = True
            self.mode = 2
            self.a = 0.0
            if(self.obj_type == 1):
                self.v = rd.uniform(10,17)
            else:
                self.v = rd.uniform(100,200)

            x = x + self.v*math.cos(self.alpha)*dt
            y = y + self.v*math.sin(self.alpha)*dt
            self.xy_pos = [x,y,z]
            
        else:
            self.flag = False
            x = x + self.v*math.cos(self.alpha)*dt
            y = y + self.v*math.sin(self.alpha)*dt
            self.xy_pos = [x,y,z]
            self.v = self.v + self.a*dt
            
        return self.xy_pos
    
    #------------------#
    # 直角坐标转极坐标
    #------------------#
    def rec2pol(self, xt, yt, zt):
        Rt = math.sqrt(xt*xt + yt*yt + zt*zt)
        alpha_t = math.atan(yt / xt)
        beta_t = math.asin(zt / Rt)
  
        return self.positon_pol


class Ais_obj(Obj):
    def __init__(self, mode=2, ais_info=[], ais_result={},xy_pos=[0.0,0.0],flag=False,alpha=0.0,v=0.0,a=0,dt=1):
        super(Ais_obj,self).__init__(obj_type=1,mode=2,xy_pos=[0.0,0.0,0],flag=False,alpha=0.0,v=0.0,a = 0,dt = 1)
        self.flag = flag
        self.ais_info = ais_info
        self.ais_result = ais_result
        
    def get_random_value(self):
        
        channel = rd.choice(['A','B'])
        mmsiId = str(rd.randint(100000000,999999999))
        IMO = str(rd.randint(100000,999999))
        callNum = str(rd.randint(10000000000,99999999999))
        supplierId = str(rd.randint(10000, 99999))
        destination = rd.choice(["青岛港","上海港","董家口港","台湾高雄港"])
        boat = {"dfh":{"name":"东方红2","type":"调查船","size":"A=20 B=12 C=5 D=6","maxStaticDraught":10.0},
                "cma":{"name":"CMA CGM PUGET","type":"运货船","size":"A=20 B=12 C=5 D=6","maxStaticDraught":10.0},
                "ty":{"name":"TONG YU 11","type":"油轮","size":"A=20 B=12 C=5 D=6","maxStaticDraught":10.0},
                'cv':{"name":"CEMTEX VENTURE","type":"散货船","size":"A=20 B=12 C=5 D=6","maxStaticDraught":10.0}
               }
        boatName = rd.choice(['dfh','cma','ty','cv'])
        boatIfo = boat[boatName]
        
        # 目标的运动模型(1:静止2:匀速3:匀加速)
        mode = rd.choice([1,2,3])
        
        if(mode == 1):
            navigationStatus = "静止"
        else:
            navigationStatus = "航行中"
        
        # 起始坐标
        x = y = 0.0

        # 设置warn函数
        #print('{},{}'.format(len(self.warnline),self.warnline))
        # for i in range(len(self.warnline)):
        #     A,B,C = self.warnline[i]
            #print(A,B,C)
        while(x<28000 and y < 20000):
            x = rd.randint(0,30000)
            y = rd.randint(0,50000)
        
        # 随机初速度(m/s)
        v0 = rd.uniform(0,20)        
        
        # 方位角alpha
        alpha = rd.randint(0, 360) * degree
        
        # 匀加速
        if(mode == 3):
            a1 = rd.uniform(-5, -2)
            a2 = rd.uniform(2, 5)
            a = rd.choice([a1, a2])
        if(mode == 2):
            a = 0.0
        elif(mode == 1):
            a=v0=0

        ais_info = [channel, mmsiId, navigationStatus, IMO, callNum, supplierId, destination, boatIfo]

        self.mode = mode
        self.xy_pos = [x,y]
        self.v = v0
        self.a = a
        self.alpha = alpha
        self.ais_info = ais_info
        #print("目标的初始状态"+str(self.origin_value))
    
    def move(self):
        """
        运动轨迹模拟
        a为初始加速度，b为加加速度
        model为运动模型，1：静止 2:匀速 3:匀加速 4:变加速
        """
        if(self.v > 20):
            self.v = 20
            self.a = 0
            self.mode = 2
        
        if(self.v < 0):
            self.v = 0.0
            self.a = -self.a
        
        # 速度换算成节
        kts = 0.5144444
        ais_info = self.ais_info
        mode = self.mode
        x,y = self.xy_pos
        v = self.v 
        a = self.a
        dt = self.dt
        alpha = self.alpha

        channel, mmsiId, navigationStatus, IMO, callNum, supplierId, destination, boatIfo = ais_info
        
        updateTime = time.strftime('%Y-%m-%d %H:%M:%S')
                
        # 对地航速
        sog = (v+a*dt)*kts
        
        # 航向
        cog = alpha / degree - 90
        if(cog < 0):
            cog = 360 - alpha / degree
        
        # 不能到达区域
        if((x<28000 and y < 20000) or x < 0 or y < 0):
            if(self.flag == False):
                self.alpha = 180*degree + self.alpha
                self.flag = True
            self.mode = 2
            self.a = 0.0
            self.v = rd.uniform(10,17)

            x = x + self.v*math.cos(self.alpha)*dt
            y = y + self.v*math.sin(self.alpha)*dt
            self.xy_pos = [x,y]
            
        else:
            self.alpha = False
            x = x + self.v*math.cos(self.alpha)*dt
            y = y + self.v*math.sin(self.alpha)*dt
            self.xy_pos = [x,y]
            self.v = self.v + self.a*dt
        
        ais_result = {"channel":channel,"mmsiId":mmsiId, "IMO":IMO, "navigationStatus":navigationStatus, 
                      "supplierId":supplierId, "destination":destination,"name":boatIfo["name"],
                      "type":boatIfo["type"], "size":boatIfo["size"],
                      "maxStaticDraught":boatIfo["maxStaticDraught"],
                      "sog":sog,
                      "cog":cog,
                      "longitude":x,
                      "latitude":y,
                      "updateTime":updateTime
                     }
        #print(ais_result)

        self.ais_result = ais_result
        #print("目标在第"+str(t)+"秒的坐标")
        
        return self.ais_result