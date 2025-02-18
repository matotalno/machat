import QtQuick 2.15

Rectangle {
    id: root
    height: 60
    color: "#f7f7f8"
    radius: 8
    
    Rectangle {
        width: parent.width * 0.7
        height: 16
        radius: 4
        color: "#e5e7eb"
        anchors {
            left: parent.left 
            leftMargin: 16
            verticalCenter: parent.verticalCenter
        }
        
        SequentialAnimation on opacity {
            running: true
            loops: Animation.Infinite
            
            NumberAnimation {
                from: 1.0
                to: 0.5
                duration: 800
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                from: 0.5
                to: 1.0
                duration: 800
                easing.type: Easing.InOutQuad
            }
        }
    }
}
