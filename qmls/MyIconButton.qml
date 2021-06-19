import QtQuick 2.0

Rectangle {
    id: rec

    property alias img_src: icon.source
    property alias btn_txt: button.text

    property color clr_enter: Qt.rgba(249/255, 188/255, 96/255)
    property color clr_exit: Qt.rgba(85/255, 66/255, 61/255, 0.8)
    property color clr_click: "#aba9b2"
    property color clr_release: Qt.rgba(85/255, 66/255, 61/255, 0.8)

    //自定义点击信号
    signal clickedLeft()
    signal clickedRight()
    signal release()

    width: 120
    height: 100
    radius: 10
    color: Qt.rgba(85/255, 66/255, 61/255, 0.8)

    Image {
        id: icon
        width: 60
        height: 60
        source: "qrc:/camera.png"
        fillMode: Image.PreserveAspectFit
        clip: true
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.margins: 10
    }

    Text {
        id: button
        text: qsTr("button")
        color: "white"

        anchors.top: icon.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: icon.horizontalCenter
        //anchors.bottom: icon.bottom
        anchors.bottomMargin: 5

        font.family: "微软雅黑"
        font.bold: true
        font.pointSize: 10
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        //接受左键和右键输入
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            //左键点击
            if (mouse.button === Qt.LeftButton)
            {
                parent.clickedLeft()
                //console.log(button.text)
            }
            else if(mouse.button === Qt.RightButton)
            {
                parent.clickedRight()
            }
        }

        //按下
        onPressed: {
            color = clr_click
        }

        //释放
        onReleased: {
            color = clr_enter
            parent.release()
        }

        //指针进入
        onEntered: {
            color = clr_enter
            button.color = "black"
        }

        //指针退出
        onExited: {
            color = clr_exit
            button.color = "white"
        }
    }
}
