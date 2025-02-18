import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: control
    
    property color rippleColor: "#40ffffff"
    property color backgroundColor: "#19c37d"
    property color hoverColor: Qt.darker(backgroundColor, 1.1)
    
    background: Rectangle {
        color: control.pressed ? control.hoverColor : 
               control.hovered ? Qt.darker(control.backgroundColor, 1.05) : 
               control.backgroundColor
        radius: 6
        
        Ripple {
            id: ripple
            anchors.fill: parent
            clip: true
            color: control.rippleColor
            pressed: control.pressed
            active: control.down || control.visualFocus || control.hovered
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: ripple.width
                    height: ripple.height
                    radius: 6
                }
            }
        }
        
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
}
