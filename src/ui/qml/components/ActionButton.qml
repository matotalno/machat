import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: root
    
    property string iconSource
    property color iconColor: "#666666"
    property color hoverColor: "#19c37d"
    
    width: 32
    height: 32
    flat: true
    
    background: Rectangle {
        color: "transparent"
        radius: 4
        
        Rectangle {
            anchors.fill: parent
            color: root.hovered ? Qt.alpha(root.hoverColor, 0.1) : "transparent"
            radius: 4
        }
    }
    
    contentItem: Image {
        source: root.iconSource
        sourceSize: Qt.size(16, 16)
        fillMode: Image.PreserveAspectFit
    }
    
    ToolTip.visible: hovered
    ToolTip.delay: 500
}
