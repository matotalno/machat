import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: control
    
    property string iconSource
    property color iconColor: "#666666"
    property color hoverColor: "#19c37d"
    
    width: 32
    height: 32
    flat: true
    
    background: Rectangle {
        color: control.hovered ? Qt.lighter(control.hoverColor, 1.8) : "transparent"
        radius: 4
        
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
    
    contentItem: Image {
        source: control.iconSource
        sourceSize: Qt.size(16, 16)
        
        // Fallback bez ColorOverlay
        opacity: control.enabled ? 1.0 : 0.3
        
        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }
    
    ToolTip {
        visible: control.hovered
        text: control.ToolTip.text
        delay: 500
        timeout: 2000
        padding: 8
        
        contentItem: Text {
            text: control.ToolTip.text
            color: "white"
            font.pixelSize: 12
        }
        
        background: Rectangle {
            color: "#1e1e1e"
            radius: 4
            opacity: 0.95
        }
    }
}
