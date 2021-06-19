/*!
 *@file main.qml
 *@brief 主文件
 *@version 1.0
 *@section LICENSE Copyright (C) 2003-2103 CamelSoft Corporation
 *@author zhengtianzuo
*/
import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0

ApplicationWindow {
    visible: true
    width: 400
    height: 300
    title: qsTr("Qml侧边滑动菜单")
    property bool menu1: false
    property bool menu2: false
    property bool menu3: false
    property bool menu4: false
    property bool menu5: false

    Rectangle {
        anchors.fill: parent
        color: "#AAAAAA";
        opacity: menu1 ? 1 : 0
        Text{
            text:"这个是菜单内容区\nhello\nhello\nhello\nhello"
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        color: "black";
        opacity: menu2 ? 1 : 0
        Text{
            text:"这个是菜单内容区2\nhello\nhello\nhello\nhello"
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
        Text{text:"这给是菜单按钮区\nnihao\nnihao\nnihao\nnihao"}
        opacity: (menu1 || menu2) ? 0.5 : 1
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }
        

        Column{
            Button {
                width: 48
                height: 48
                text: qsTr("菜单1")
                onClicked: {
                    menu1 = onMenu(menu1)
                }
            }
            Button {
                width: 48
                height: 48
                text: qsTr("菜单2")
                onClicked: menu2 = onMenu(menu2);
            }
        }
        
        transform: Translate {
            id: menuTranslate
            x: 0
            Behavior on x {
                NumberAnimation {
                    duration: 400;
                    easing.type: Easing.OutQuad
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            enabled: menu1
            onClicked: onMenu(menu1);
        }
    }

    function onMenu(menu)
    {
        menuTranslate.x = menu ? 0 : width * 0.8
        return !menu;
    }
}