# coding=UTF-8
import utils.Coor as coor
from utils.obj import Obj
from utils.radar import Radar
import random as rd
import json
from PyQt5.QtCore import QObject, pyqtSlot 
import sys

class Radar_det(QObject):
    def __init__(self,ip="127.0.0.1/6789",radardata=None,radar=None,obj=None,obj_num=0):
        super().__init__()
        self.ip = ip
        self.radardata = radardata
        self.radar = radar
        self.obj = obj
        self.obj_num = obj_num

    @pyqtSlot(str,result=str)
    def radar_set(self,ip_p):
        self.ip_p = ip_p
        # 设定坐标原点（地图左上角）
        ori = (35.958385067108026, 120.04422809586613)
        global ori_xy
        ori_xy = coor.millerToXY(ori)
            
        obj = {}
        obj_num = rd.randint(4,10)
        #ori_value['obj_num'] = obj_num
        # print('目标的初始状态')
        #print('----------------')
        for i in range(obj_num):
            obj[i] = Obj()
            obj[i].get_random_value()

        #--------读取想定---------------
        with open("radar.txt", "r") as f:  # 打开文件
            radardata = eval(f.read())  # 读取文件
            
        # print('目标的初始状态')
        #print('----------------')

        radar = {}
        for k in range(len(radardata)):
            radar[k+1] = Radar(ori_xy, coor.to_origin(ori_xy, radardata['radar{}'.format(k+1)]))

        self.radardata = radardata
        self.radar = radar
        self.obj = obj
        self.obj_num = obj_num

        return "雷达初始化成功\n" + "雷达个数:" + str(len(radardata)) + "\n" + "目标个数:" + str(obj_num) 

        print("雷达初始化成功")
        print("雷达个数",len(radardata))
        print("目标个数",obj_num)

    @pyqtSlot(result=str)
    def radar_detect(self):
        radardata = self.radardata
        radar = self.radar
        obj = self.obj
        obj_num = self.obj_num

        for k in range(len(radardata)):
            #print('radar{}:'.format(k+1))
            #print('----------------')
            return radar[k+1].run([obj[i].move() for i in range(obj_num)],self.ip_p)


    