import QtQuick 2.4
import QtLocation 5.6
import QtPositioning 5.8


MapQuickItem{
    id:plane

    property int bearing: 0
    property string path
    property int type:2
    
    anchorPoint.x: image.width/2
    anchorPoint.y: image.height/2
    //coordinate: QtPositioning.coordinate(35.77134650426574, 120.07295862700086)

    Component.onCompleted:{
        if(type == 3){
            path = "../images/plane.png"
        }
        if(type == 2){
            path = "../images/boat.png"
        }
        if(type == 0){
            path = "../images/雷达.png"
        }
        
    }

    sourceItem: Grid{
        columns: 1
        horizontalItemAlignment: Grid.AlignHCenter
        Image {
            id: image
            width: 30
            height: 30
            rotation: bearing
            source: path
        }
    }
}
