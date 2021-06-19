import QtQuick 2.0

Rectangle
{
    id:root
    width: 200
    height: 200
    anchors.margins: 10
    property int m_Angle: 0
    Timer
    {
            interval: 25; running: true; repeat: true
            onTriggered:
            {

                root.m_Angle = root.m_Angle + 1 ;
                if(root.m_Angle == 360)
                {
                    root.m_Angle = 0;
                }
            }

    }
    color: Qt.rgba(92/255, 112/255, 87/255,0.7)
    radius: 5
    //anchors.centerIn: parent
    Rectangle
    {
        anchors.fill: parent
        color: "transparent"
        opacity: 1
        Canvas
        {
            anchors.fill: parent
            onPaint:
            {
                var ctx = getContext("2d");
                ctx.lineWidth = 2;
                ctx.strokeStyle = "#00FF00";
                ctx.fillStyle = "#00FF00";
                ctx.globalAlpha = 1.0;
                ctx.beginPath();
                ctx.arc(width/2,width/2,2,0,2*Math.PI);
                ctx.stroke();
                ctx.fill()
                ctx.restore();
                ctx.beginPath();
                ctx.arc(width/2,width/2,width/2-80,0,2*Math.PI);
                ctx.stroke();
                ctx.restore();
                ctx.beginPath();
                ctx.arc(width/2,width/2,width/2-60,0,2*Math.PI);
                ctx.stroke();
                ctx.restore();
                ctx.beginPath();
                ctx.arc(width/2,width/2,width/2-40,0,2*Math.PI);
                ctx.stroke();
                ctx.restore();
                ctx.beginPath();
                ctx.arc(width/2,width/2,width/2-20,0,2*Math.PI);
                ctx.stroke();
                ctx.restore();
                ctx.beginPath();
                ctx.arc(width/2,width/2,width/2-1,0,2*Math.PI);
                ctx.stroke();
                ctx.restore();
                ctx.beginPath();
                ctx.lineTo(0,width/2)
                ctx.lineTo(width,width/2)
                ctx.stroke();
                ctx.restore();
                ctx.beginPath();
                ctx.lineTo(width/2,0)
                ctx.lineTo(width/2,width)
                ctx.stroke();
                ctx.restore();

            }
        }
        Canvas{
            anchors.fill: parent
            rotation: -root.m_Angle
            onPaint:
            {
                var ctx = getContext("2d");
                ctx.lineWidth = 2;
                var sectorCnt = 30;
                var startDeg = 90, endDeg;
                var sectorRadius = width/2
                ctx.translate(sectorRadius, sectorRadius);
                ctx.fillStyle = 'rgba(0, 255, 0, 0.05)';

                for(var i = 0; i < sectorCnt; i++)
                {
                    endDeg = startDeg + 60 - 60/ sectorCnt * i;
                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.lineTo(0, -sectorRadius);
                    ctx.arc(0, 0, sectorRadius, Math.PI / 180 * (startDeg), Math.PI / 180 * endDeg);
                    ctx.closePath();
                    ctx.fill();
                }
//                ctx.restore();


            }
        }
    }
}
