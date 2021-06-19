import math

def millerToXY (latlon):
    lat, lon = latlon
    """
    经纬度转平面
    :param lon: 经度
    :param lat: 纬度
    :return:
    """
    xy_coordinate = []
    L = 6381372*math.pi*2    # 地球周长
    W = L                    # 平面展开，将周长视为X轴
    H = L/2                  # Y轴约等于周长一半
    mill = 2.3               # 米勒投影中的一个常数，范围大约在正负2.3之间  
    y = lon*math.pi/180      # 将经度从度数转换为弧度
    #print(x)
    x = lat*math.pi/180      # 将纬度从度数转换为弧度 
    #print(y)
    x = 1.25*math.log(math.tan(0.25*math.pi+0.4*x))  #这里是米勒投影的转换 
    
    # 这里将弧度转为实际距离 ，转换结果的单位是公里
    y = (W/2)+(W/(2*math.pi))*y
    x = (H/2)-(H/(2*mill))*x
    xy_coordinate = [int(round(x)),int(round(y))]
    return xy_coordinate

def xy_to_coor(x, y):
    lonlat_coordinate = []
    L = 6381372 * math.pi*2
    W = L
    H = L/2
    mill = 2.3
    lat = ((H/2-x)*2*mill)/(1.25*H)
    lat = ((math.atan(math.exp(lat))-0.25*math.pi)*180)/(0.4*math.pi)
    lon = (y-W/2)*360/W
    # TODO 最终需要确认经纬度保留小数点后几位
    lonlat_coordinate = [round(lat,7),round(lon,7)]
    return lonlat_coordinate

# 船舶不能到达区域
def warningline(first,second):
    '''
    不能到达区域
    '''
    A=second[1]-first[1]
    B=first[0]-second[0]
    C=second[0]*first[1]-first[0]*second[1]
    a = [A,B,C]
    return a

def to_origin(ori_xy, latlon):
    '''
    将目标点的经纬度转换到以原点为坐标系的平面坐标
    '''
    latlon_xy = millerToXY(latlon)
    a = latlon_xy[0] - ori_xy[0]
    b = latlon_xy[1] - ori_xy[1]
    return [a,b]