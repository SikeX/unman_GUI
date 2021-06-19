import QtQuick 2.4
import QtLocation 5.6
import QtPositioning 5.8


MapQuickItem{
    id:ais

    property int bearing: 0
    
    anchorPoint.x: image.width/2
    anchorPoint.y: image.height/2
    //coordinate: QtPositioning.coordinate(35.77134650426574, 120.07295862700086)

    sourceItem: Grid{
        columns: 1
        horizontalItemAlignment: Grid.AlignHCenter
        Image {
            id: image
            width: 30
            height: 30
            rotation: bearing
            source: "../images/ais_boat.png"
        }
    }
}
