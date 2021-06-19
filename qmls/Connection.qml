import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

// 连接菜单页

Rectangle{
    id: cntMenu

    property alias targetIp: targetIP.text
    property alias targetPort: targetPORT.text
    
    signal clickCnt()

    color:Qt.rgba(57/255, 48/255, 45/255,0.8)
    smooth: true
    width:600

    Behavior on visible{
        NumberAnimation{
            duration: 200
        }
    }

    ColumnLayout{
        anchors.top:parent.top
        anchors.left:parent.left
        anchors.right:parent.right
        Rectangle{
            Layout.fillWidth:true
            Layout.preferredHeight:60
            color:"transparent"
            Text{
                anchors.centerIn: parent
                text:"客户端连接"
                color: "white"
                font{family:"微软雅黑";pixelSize:30}
            }
        }

        Rectangle{
            color:"transparent"
            Layout.preferredHeight:400
            Layout.fillWidth:true

            GridLayout{
                anchors.fill:parent
                anchors.leftMargin:40
                anchors.rightMargin:100
                columns:2
                rows:3
                rowSpacing:20
                columnSpacing:10
                
                // Label{
                //     text:"本机IP:" 
                //     font{family:"微软雅黑";pointSize:20}
                //     color:"white"
                // }
                // TextField{
                //     Layout.fillWidth:true
                //     font.pointSize:20
                //     horizontalAlignment:Text.AlignHCenter
                //     color: "white"

                //     background: Rectangle {
                //     color: Qt.rgba(0.1, 0.1, 0.1, 0.3)
                //     border.color: parent.enabled ? "white" : "gray"
                //     border.width: 1
                //     radius: 5
                //     }
                // }
                Label{
                    text:"目标IP:"
                    font{family:"微软雅黑";pointSize:20}
                    color:"white"
                }
                TextField{
                    id: targetIP
                    Layout.fillWidth:true
                    font.pointSize:20
                    horizontalAlignment:Text.AlignHCenter
                    color: "white"

                    background: Rectangle {
                    color: Qt.rgba(0.1, 0.1, 0.1, 0.3)
                    border.color: parent.enabled ? "white" : "gray"
                    border.width: 1
                    radius: 5
                    }
                }
                Label{
                    text:"目标端口:"
                    font{family:"微软雅黑";pointSize:20}
                    color:"white"
                }
                TextField{
                    id: targetPORT
                    Layout.fillWidth:true
                    font.pointSize:20
                    horizontalAlignment:Text.AlignHCenter
                    color: "white"

                    background: Rectangle {
                    color: Qt.rgba(0.1, 0.1, 0.1, 0.3)
                    border.color: parent.enabled ? "white" : "gray"
                    border.width: 1
                    radius: 5
                    }
                }
                Rectangle{
                    id: cntBtn
                    width:200
                    height:50
                    color: "yellow"
                    radius:10
                    Text{
                        anchors.fill:parent
                        text:"连接"
                        font{family:"微软雅黑";pixelSize:20}
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        }
                    MouseArea{
                        anchors.fill: parent
                        
                        //指针进入
                        onEntered: {
                            cntBtn.color = "gray"
                            // button.color = "black"
                        }

                        //按下
                        onPressed: {
                            cntMenu.clickCnt()
                            cntBtn.color = "gray"
                            
                        }

                        //释放
                        onReleased: {
                            cntBtn.color = "yellow"
                        }

                        //指针退出
                        onExited: {
                            cntBtn.color = "yellow"
                            // button.color = "white"
                        }
                    }
                }
                // Rectangle{
                //     width:200
                //     height:50
                //     color: "yellow"
                //     radius:10
                //     Text{
                //         anchors.fill:parent
                //         text:"断开"
                //         font{family:"微软雅黑";pixelSize:20}
                //         horizontalAlignment:Text.AlignHCenter
                //         verticalAlignment: Text.AlignVCenter
                //     }
                // }
            }
        }
        
    }
    
}