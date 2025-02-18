import QtQuick 2.15

Item {
    id: root
    width: 32
    height: 32
    visible: false
    
    property bool running: false
    property color color: "#19c37d"
    
    Rectangle {
        anchors.centerIn: parent
        width: parent.width
        height: width
        radius: width/2
        color: "transparent"
        border.width: 3
        border.color: root.color
        opacity: root.running ? 1 : 0
        
        RotationAnimation {
            target: parent
            running: root.running
            from: 0
            to: 360
            duration: 1000
            loops: Animation.Infinite
        }
    }
    
    onRunningChanged: {
        visible = running
    }
}
