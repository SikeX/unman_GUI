import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Window{
    id:root
    visible:true
    width:900
    height:600
    
    property bool menu1:false
    property bool menu2:false
    property bool menu3:false

    Rectangle{
        id:menu1Con
        visible: menu1? true : false
        anchors.fill:parent
        color:"yellow"
        Text{text:"menu1"}
        
        Behavior on visible{
            NumberAnimation{
                duration: 300
            }
        }
    }
    Rectangle{
        id:menu2Con
        visible: menu2 ? true : false
        anchors.fill:parent
        color:"gray"
        Text{text:"menu2"}
        
        Behavior on visible{
            NumberAnimation{
                duration: 300
            }
        }
    }
    Rectangle{
        id:menu3Con
        visible: menu3 ? true : false
        anchors.fill:parent
        color:"pink"
        Text{text:"menu3"}
        
        Behavior on visible{
            NumberAnimation{
                duration: 300
            }
        }
    }

    Rectangle{
        anchors.fill:parent
        color:"transparent"
        
        ColumnLayout{
            Button {
                width: 48
                height: 48
                text: qsTr("菜单1")
                onClicked: {
                    menu1 = onMenu(menu1)
                    menu2 = false
                    menu3 = false
                }
            }
            Button {
                width: 48
                height: 48
                text: qsTr("菜单2")
                onClicked: {
                    menu2 = onMenu(menu2)
                    menu1 = false
                    menu3 = false
                }
            }  
            Button {
                width: 48
                height: 48
                text: qsTr("菜单3")
                onClicked: {
                    menu3 = onMenu(menu3)
                    menu1 = false
                    menu2 = false
                }
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
    }

    function onMenu(menu){
        menuTranslate.x = menu ? 0 : width * 0.8
        return !menu
    }


}