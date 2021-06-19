python 所需模块
json
random
socket
math
ctypes
pyqt5
	
目录结构
├── Qt5MultimediaQuick.dll pyqt多媒体插件
├── ReadMe.txt
├── Json.hpp c++ json头文件，用于c++处理json
├── __pycache__ 不用管
│   ├── ais.cpython-38.pyc
│   └── radar.cpython-38.pyc
├── .vscode 我的vscode配置，你们可以配置自己的
├── ais.py
├── ais.txt ais的想定 个数和位置
├── ais_result.json ais的检测结果，供界面读取
├── images 界面所需图标
│   ├── activate.png
│   ├── airplane.png
│   ├── ais.png
│   ......
├── main.cpp udp接受无人设备组的json串
├── main.py 界面主程序py
├── main.qml 界面主程序qml
├── qmls qml功能模块，写在一个qml里太挤，代码太多看的累
│   ├── Ais.qml
│   ├── Connection.qml
│   ├── Device.qml
│   ├── Headbutton.qml
│   ├── MyIconButton.qml
│   ├── MyIconButton.qmlc
│   ├── Plane.qml
│   ├── Radar.qml
│   ├── Radar.qmlc
│   ├── slide.qml
│   ├── supose.qml
│   ├── test.qml
│   └── test.qmlc
├── radar.py 雷达检测主程序
├── radar.txt 雷达想定（个数和位置）
├── radar_result.json 雷达检测结果（供界面读取）
└── utils目标运动模拟功能模块
    ├── Coor.py 坐标相关函数
    ├── Json.h 不用管
    ├── __pycache__ 不用管
    ├── ais.py ais检测模块
    ├── inet.h 不用管
    ├── obj.py 目标运动模块
    └── radar.py 雷达检测模块