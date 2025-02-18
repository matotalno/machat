import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: control
    
    background: Rectangle {
        color: control.enabled ? "#f9fafb" : "#f3f4f6"
        radius: 8
        border.color: control.activeFocus ? "#19c37d" : "#e5e7eb"
        border.width: control.activeFocus ? 2 : 1
        
        // Highlight animation
        Rectangle {
            anchors.fill: parent
            radius: 8
            color: "#19c37d"
            opacity: control.activeFocus ? 0.1 : 0
            
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }
        
        // Shadow effect
        layer.enabled: control.enabled
        layer.effect: DropShadow {
            transparentBorder: true
            color: "#20000000"
            radius: 4
            samples: 8
            verticalOffset: 2
        }
    }
    
    // Text animations
    color: enabled ? "#000000" : "#666666"
    opacity: enabled ? 1.0 : 0.6
    
    Behavior on opacity {
        NumberAnimation { duration: 150 }
    }
}
