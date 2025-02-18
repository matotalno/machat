import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    height: 30
    Layout.fillWidth: true
    color: "transparent"
    visible: false
    
    property alias isVisible: root.visible
    
    Row {
        spacing: 4
        anchors.left: parent.left
        anchors.leftMargin: 16
        
        Repeater {
            model: 3
            
            Rectangle {
                width: 6
                height: 6
                radius: width/2
                color: "#19c37d"
                
                SequentialAnimation {
                    running: root.visible
                    loops: Animation.Infinite
                    
                    PropertyAnimation {
                        target: parent
                        property: "y"
                        to: -5
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                    
                    PropertyAnimation {
                        target: parent
                        property: "y"
                        to: 0
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                    
                    PauseAnimation {
                        duration: index * 100
                    }
                }
            }
        }
    }
    
    Text {
        anchors.left: parent.left
        anchors.leftMargin: 60
        color: "#666666"
        text: "AI kuca..."
        font.pixelSize: 12
    }
}
