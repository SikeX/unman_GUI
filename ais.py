# coding=UTF-8
import utils.Coor as coor
from utils.ais import Ais
from utils.obj import Ais_obj
import random as rd
import json
from PyQt5.QtCore import QObject, pyqtSlot 
import sys

class Ais_det(QObject):
    def __init__(self,ip_p="127.0.0.1/6789",aisdata=None,ais=None,ais_obj=None,obj_num=0):
        super().__init__()
        self.ip_p = ip_p
        self.aisdata = aisdata
        self.ais = ais
        self.ais_obj = ais_obj
        self.obj_num = obj_num

    @pyqtSlot(str,result=str)
    def ais_set(self,ip_p):
        self.ip_p = ip_p
        # 设定坐标原点（地图左上角）
        ori = (35.958385067108026, 120.04422809586613)
        global ori_xy
        ori_xy = coor.millerToXY(ori)
        
        ais_obj = {}
        obj_num = rd.randint(6,10)
            
        for i in range(obj_num):
            ais_obj[i] = Ais_obj()
            ais_obj[i].get_random_value()
            #print("第{}个目标的初始状态：坐标{}".format(i,a[2]))
            #print('----------------')

        #--------读取想定---------------
        with open("ais.txt", "r") as f:  # 打开文件
            aisdata = eval(f.read())  # 读取文件
            
        ais = {}
        for k in range(len(aisdata)):
            ais[k+1] = Ais(ori_xy, coor.to_origin(ori_xy, aisdata['ais{}'.format(k+1)]))

        self.aisdata = aisdata
        self.ais = ais
        self.ais_obj = ais_obj
        self.obj_num = obj_num

        # print(self.ais)
        # print("AIS初始化成功\n" + "AIS个数:" + str(len(aisdata)) + "\n" + "目标个数:" + str(obj_num))
        
        return "AIS初始化成功\n" + "AIS个数:" + str(len(aisdata)) + "\n" + "目标个数:" + str(obj_num) 
            
    @pyqtSlot(result=str)
    def ais_det(self):
        aisdata = self.aisdata
        ais = self.ais
        ais_obj = self.ais_obj
        obj_num = self.obj_num

        for k in range(len(aisdata)):
            #print('AIS{}在第{}秒的检测结果'.format(k+1,t))
            #print('----------------')
            ais[k+1].run([ais_obj[i].move() for i in range(obj_num)], self.ip_p)