Image {
    id: closeButton
    x:0
    anchors.right: parent.right
    width: parent.height
    height: width            
    source: "new/prefix1/closei.png"
 
    MouseArea{
        anchors.fill: parent
        onClicked: {
            Qt.quit()//退出程序
        }
    }        
}