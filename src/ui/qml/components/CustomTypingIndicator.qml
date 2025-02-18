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
                opacity: 0.6
                
                SequentialAnimation {
                    running: root.visible
                    loops: Animation.Infinite
                    
                    NumberAnimation {
                        target: parent
                        property: "y"
                        from: 0
                        to: -5
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                    
                    NumberAnimation {
                        target: parent
                        property: "y"
                        from: -5
                        to: 0
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
                    
                    PauseAnimation {
                        duration: index * 200
                    }
                }
            }
        }
    }
    
    // Fade in/out animacija
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }
    
    Text {
        anchors.left: parent.left
        anchors.leftMargin: 60
        color: "#666666"
        text: "AI kuca..."
        font.pixelSize: 12
    }
}
