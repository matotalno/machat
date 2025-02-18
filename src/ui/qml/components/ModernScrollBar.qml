import QtQuick 2.15
import QtQuick.Controls 2.15

ScrollBar {
    id: control
    size: 0.3
    position: 0.2
    active: true
    orientation: Qt.Vertical
    
    contentItem: Rectangle {
        implicitWidth: 6
        implicitHeight: 100
        radius: width / 2
        color: control.pressed ? "#666666" : 
               control.hovered ? "#888888" : "#CCCCCC"
        opacity: control.active ? 0.8 : 0
        
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }
}
