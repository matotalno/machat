import QtQuick 2.15

Item {
    width: 24
    height: 24

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        
        Canvas {
            anchors.centerIn: parent
            width: 16
            height: 16
            
            onPaint: {
                var ctx = getContext("2d")
                ctx.strokeStyle = "white"
                ctx.lineWidth = 2
                
                // Crtaj modernu chevron down ikonicu
                ctx.beginPath()
                ctx.moveTo(2, 6)
                ctx.lineTo(8, 12)
                ctx.lineTo(14, 6)
                ctx.stroke()
            }
        }
    }
}
