import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtPositioning 5.9
import QtLocation 5.9
import Qt.labs.settings 1.0
import QtQuick.XmlListModel 2.0
import QtMultimedia 5.10

import "./qmls"

 Window {
    id:root
    visible: true
    width: 1600
    height: 900
    color: "#55423d"
    title: qsTr("无人装备体系态势仿真系统")
    // flags: Qt.Window | Qt.FramelessWindowHint
    
    property point  clickPos: "0,0"

    property string ip_p

    property bool menu1:false
    property bool menu2:false
    property bool menu3:false
    property bool menu4:false
    property bool menu5:false

    property var obj_info
    property var radardata

    property var ais_obj_info
    property var ais_data

    property var deviceinfo
    property var devicedata

    property bool radarStatus:false

    ColumnLayout{
        id: layout
        anchors.fill:parent
        spacing:2
        // Rectangle{
        //     id:head
        //     // Layout.alignment: Qt.AlignTop
        //     color: "blue"
        //     Layout.preferredHeight: 20
        //     Layout.fillWidth:true
        //     //Layout.fillHeight:true
        //     //处理鼠标移动后窗口坐标逻辑
        //     MouseArea{
        //         anchors.fill: parent
        //         acceptedButtons: Qt.LeftButton  //只处理鼠标左键
        //         onPressed: {    //鼠标左键按下事件
        //             clickPos = Qt.point(mouse.x, mouse.y)
        //         }
        //         onPositionChanged: {    //鼠标位置改变
        //             //计算鼠标移动的差值
        //             var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
        //             //设置窗口坐标
        //             root.setX(root.x + delta.x)
        //             root.setY(root.y + delta.y)
        //         }
        //     }
        //     Image {
        //         id: closeButton
        //         x:0
        //         anchors.right: parent.right
        //         width: parent.height
        //         height: width            
        //         source: "images/close.png"
            
        //         MouseArea{
        //             anchors.fill: parent
        //             onClicked: {
        //                 Qt.quit()//退出程序
        //             }
        //         }        
        //     }
        //     Image {
        //         id: maxButton
        //         x:0
        //         anchors.right: closeButton.right
        //         anchors.rightMargin: 2
        //         width: parent.height
        //         height: width            
        //         source: "images/max.png"
            
        //         MouseArea{
        //             anchors.fill: parent
        //             onClicked: {
        //                 root.showMaximized()//最大化程序
        //             }
        //         }        
        //     }
        //     Image {
        //         id: minButton
        //         x:0
        //         anchors.right: maxButton.right
        //         anchors.rightMargin: 2
        //         width: parent.height
        //         height: width            
        //         source: "images/max.png"
            
        //         MouseArea{
        //             anchors.fill: parent
        //             onClicked: {
        //                 root.showMinimized()//最大化程序
        //             }
        //         }        
        //     }
        // }
        Rectangle{
            id:headLabel
            color: "transparent"
            Layout.preferredHeight: 40
            Layout.fillWidth:true
            Text{
                anchors.centerIn: parent
                font{family:"微软雅黑";pixelSize:28;bold:true}
                text:"无人装备体系态势仿真系统"
                color:"white"
            }
        }
        Rectangle{
            id: middelArea
            color: "white"
            Layout.preferredHeight:600
            Layout.fillWidth:true
            Layout.fillHeight:true
            Layout.minimumHeight:500
            Layout.maximumHeight:700

            Map{
                id:map
                anchors.fill:parent
                activeMapType:map.supportedMapTypes[1]
                center: QtPositioning.coordinate(35.83123032953472, 120.31367215583474)
                zoomLevel:12
                plugin:Plugin{
                    name:"esri"
                }
                MouseArea{
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: {
                        var coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y),false)

                        dataText.text +="coordPosition: " + coordinate.latitude.toFixed(6)
                                                    + ", " + coordinate.longitude.toFixed(6) + "\n"
                    }
                }
                Plane{
                    id:ori
                    type:0
                    coordinate: QtPositioning.coordinate(35.958385067108026, 120.04422809586613)
                }
                // 雷达检测
                MapItemView{
                    model: mymodel
                    delegate: mydelegate
                    Component.onCompleted: {
                    }    
                }
                // ais检测
                MapItemView{
                    model: aisModel
                    delegate: aisdelegate
                    Component.onCompleted: {
                    }    
                }
                // 无人设备检测
                MapItemView{
                    model: deviceModel
                    delegate: devicedelegate
                    Component.onCompleted: {
                    }   
                }
                // 菜单内容页
                ColumnLayout{
                    id:menuContent
                    anchors.left:parent.left
                    anchors.top:parent.top
                    anchors.bottom:parent.bottom
                    Connection{
                        id: menu1Con
                        visible: menu1 ? true : false
                        Layout.fillHeight:true

                        onClickCnt:{
                            ip_p = targetIp + "/" + targetPort
                            dataText.text += "正在连接到目标IP:" + targetIp + "目标端口:"+ targetPort + "\n"
                            // console.log(ip_p)
                        }
                    }
                    Connection{
                        id: menu2Con
                        visible:menu2 ? true : false
                        Layout.fillHeight:true
                        color: "black"
                        Text{
                            text:"ha\nha\nha\nha\nha\n"
                            color:"white"
                        }
                    }
                    Connection{
                        id: menu3Con
                        visible:menu2 ? true : false
                        Layout.fillHeight:true
                        color: "black"
                        Text{
                            text:"ha\nha\nha\nha\nha\n"
                            color:"white"
                        }
                    }   
                } 
                
                ColumnLayout{
                    id:slideMenu
                    anchors.left:parent.left
                    anchors.top:parent.top
                    anchors.bottom:parent.bottom
                    // 连接按钮
                    MyIconButton{
                        id:connctionBtn
                        Layout.fillHeight:true
                        img_src: "images/connect.png"
                        btn_txt: "连接"
                        onClickedLeft:{
                            menu1 = onMenu(menu1)
                            menu2 = false

                            }
                        }
                    // 想定按钮
                    MyIconButton{
                        id:scrptBtn
                        Layout.fillHeight:true
                        img_src: "images/suppose.png"
                        btn_txt: "想定"
                        onClickedLeft:{
                            // menu2 = onMenu(menu2)
                            // menu1 = false
                            deviceTimer.start()
                            dataText.text += "无人设备初始化成功\n"
                            }
                        }
                    // 雷达按钮
                    MyIconButton{
                        id:radarBtn
                        Layout.fillHeight:true
                        img_src: "images/radar.png"
                        btn_txt: "雷达"
                        onClickedLeft:{
                            radarshow.visible = !radarshow.visible
                            dataText.text += Radar_det.radar_set(ip_p) +"\n"
                            }
                        }
                    // ais按钮
                    MyIconButton{
                        id:aisBtn
                        Layout.fillHeight:true
                        img_src: "images/boat.png"
                        btn_txt: "AIS"
                        onClickedLeft:{
                            dataText.text += Ais_det.ais_set() + "\n"
                            }
                        }
                    // 启动按钮
                    MyIconButton{
                        id:activateBtn
                        Layout.fillHeight:true
                        img_src: "images/activate.png"
                        btn_txt: "启动"
                        onClickedLeft:{
                            myTimer.start()
                            dataText.text += "无人设备已启动\n雷达已启动\nAIS已启动\n"
                            }
                        }

                    transform: Translate{
                        id: menuTranslate
                        x: 0
                        Behavior on x {
                            NumberAnimation{
                                duration: 400
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
                //无人设备模块
                Component{
                    id: devicedelegate
                    Device{
                        type: deviceType
                        coordinate: QtPositioning.coordinate(lat,lon)
                    }
                }
                // 雷达检测代理
                Component{
                    id: mydelegate
                    Plane{
                        type: signType
                        coordinate: QtPositioning.coordinate(lat,lng)
                    }
                }
                // Ais检测代理
                Component{
                    id: aisdelegate
                    Ais{
                        coordinate: QtPositioning.coordinate(lat,lng)
                        MouseArea{
                            anchors.fill: parent
                            onClicked:{
                                aisText.text = "channel:"+channel+"\n"+
                                    "mmsiId:"+ mmsiId + "\n" +
                                    "IMO:" + IMO + "\n" + 
                                    "navigationStatus:" + navigationStatus + "\n"+
                                    "supplierId:" + supplierId + "\n" +
                                    "destination:" + destination + "\n" +
                                    "name:" + name + "\n" +
                                    "type:" + type + "\n" +
                                    "size:" + size + "\n" +
                                    "maxStaticDraught:" + maxStaticDraught + "\n" +
                                    "sog:" + sog + "\n" +
                                    "cog:" + cog + "\n" +
                                    "latitude:" + lat + "\n"+
                                    "longitude:" + lng + "\n"+
                                    "updateTime:" + updateTime
                            }
                        }
                    }
                }
                ListModel{
                    id: deviceModel
                    dynamicRoles: false
                }
                ListModel{
                    id:mymodel
                    dynamicRoles: false
                }
                ListModel{
                    id: aisModel
                    dynamicRoles: false
                }
                Radar{
                    id: radarshow
                    visible:false
                    anchors.right: map.right
                }
            }
        }
        // 底部信息区
        Rectangle{
            id:infoArea
            color:Qt.rgba(30/255, 30/255, 30/255,0.5)
            Layout.fillHeight:true
            Layout.fillWidth:true
            Layout.preferredHeight:200
            Layout.maximumHeight:400
            
            RowLayout{
                anchors.fill:parent
                Rectangle{
                    id:video
                    border.width: 2
                    border.color: Qt.rgba(8/255, 38/255, 49/255,1)
                    color: Qt.rgba(30/255, 30/255, 30/255,0)
                    Layout.fillHeight:true
                    Layout.fillWidth:true

                    Video{
                        id:videoPlay
                        anchors.fill:parent
                        source:"boat.mp4"

                        MouseArea{
                            anchors.fill:parent
                            onClicked:{
                                videoPlay.play()
                            }
                        }
                    }

                }
                Rectangle{
                    id:log
                    color: Qt.rgba(232/255, 228/255, 230/255,0)
                    border.width: 2
                    border.color: Qt.rgba(8/255, 38/255, 49/255,1)
                    Layout.fillHeight:true
                    Layout.fillWidth:true

                    ScrollView{
                    id: view
                    anchors.fill: parent

                    TextArea {
                        id: dataText
                        property int preContentHeight: 0
                        cursorVisible: false
                        readOnly: true
                        wrapMode: TextEdit.Wrap
                        focus: false
                        textFormat: TextEdit.AutoText
                        selectByMouse: true
                        selectionColor: "gray"
                        selectByKeyboard: false
                        text : "Log Info\n"
                        font{family:"微软雅黑";pixelSize:15}
                        color: "white"
                        // onContentHeightChanged:{
                        //     console.log(contentHeight)
                        //     console.log(view.flickableItem.contentY)
                             
                        //     // = contentHeight
                        //     }
                        }
                        
                        // Component.onCompleted:{
                        //     flickableItem.contentY = flickableItem.contentHeight
                        //     flickableItem.contentX = flickableItem.contentWidth
                        // }
                    }
        
                }
                
                Rectangle{
                    id:ais
                    color: Qt.rgba(232/255, 228/255, 230/255,0)
                    border.width: 2
                    border.color: Qt.rgba(8/255, 38/255, 49/255,1)
                    Layout.fillHeight:true
                    Layout.fillWidth:true

                    ScrollView{
                    id: aisView
                    anchors.fill: parent

                    TextArea {
                        id: aisText
                        font{family:"微软雅黑"}
                        text : "AIS Info"
                        color: "white"
                        }
                    }
                }
            }
        }
        Rectangle{
            id: bottomarea
            Layout.minimumHeight: 15
            Layout.preferredHeight:20
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "#55423d"
            //anchors.fill: parent
            // anchors.bottom: parent.bottom
            Text {
                anchors.margins: 5
                anchors.left: bottomarea.left
                id: bottomleft
                text: qsTr("仿真系统")
                color: "white"
            }
        }
    }

    // 功能区
    //封装自定义属性
    QtObject{
	id:attrs;
        property int counter;
        Component.onCompleted: {
            attrs.counter=0;
        }
    }
    Timer{
        id:deviceTimer
        interval: 2000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            deviceinfo = Djson.readJsonFile("pretty.json")
            devicedata = deviceinfo.param
            
            for(var i in devicedata){
                deviceModel.append(
                    {"deviceType":devicedata[i].deviceType,
                    "name":devicedata[i].name,
                    "lat":devicedata[i].lat,
                    "lon":devicedata[i].lon})
            }
        }
        
    }

    Timer{
        id:myTimer
        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            mymodel.clear()
            aisModel.clear()
            attrs.counter++
            // dataText.text += "\n" + attrs.counter
            dataText.text += Radar_det.radar_detect() + "\n"
            ais_obj_info = Djson.readJsonFile("ais_result.json")
            Ais_det.ais_det()
            obj_info = Djson.readJsonFile("radar_result.json")
            radardata = obj_info.param.target
            ais_data = ais_obj_info.param.aisInfo

            for(var i in radardata){
                mymodel.append({"signType":radardata[i].signType,"lat":radardata[i].lat,"lng":radardata[i].lng})
                // console.log(mymodel.length)
            }
            for(var i in ais_data){
                aisModel.append({
                    "channel":ais_data[i].channel,
                    "mmsiId":ais_data[i].mmsiId,
                    "IMO":ais_data[i].IMO,
                    "navigationStatus":ais_data[i].navigationStatus,
                    "supplierId":ais_data[i].supplierId,
                    "destination":ais_data[i].destination,
                    "name":ais_data[i].name,
                    "type":ais_data[i].type,
                    "lat":ais_data[i].latitude,
                    "lng":ais_data[i].longitude,
                    "size":ais_data[i].size,
                    "maxStaticDraught":ais_data[i].maxStaticDraught,
                    "sog":ais_data[i].sog,
                    "cog":ais_data[i].cog,
                    "updateTime":ais_data[i].updateTime
                    })
            }
        }
    }            

    function onMenu(menu){
        menuTranslate.x = menu ? 0 : 600
        return !menu
        }
 }