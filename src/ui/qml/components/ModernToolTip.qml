import QtQuick 2.15
import QtQuick.Controls 2.15

ToolTip {
    id: control
    
    contentItem: Text {
        text: control.text
        font: control.font
        color: "#ffffff"
    }
    
    background: Rectangle {
        color: "#1e1e1e"
        radius: 6
        opacity: 0.95
        
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 4
            radius: 12
            samples: 25
            color: "#40000000"
        }
    }
    
    enter: Transition {
        NumberAnimation { 
            property: "opacity"
            from: 0.0
            to: 1.0 
            duration: 150
        }
    }
    
    exit: Transition {
        NumberAnimation { 
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 75
        }
    }
}
