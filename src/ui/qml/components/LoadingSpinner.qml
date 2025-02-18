import QtQuick 2.15

Item {
    id: root
    
    property bool running: false
    property int size: parent.height * 0.5  // Proporcionalna veličina

    width: size
    height: size
    visible: running
    opacity: running ? 1 : 0
    
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }
    
    Rectangle {
        id: spinner
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: width
        radius: width/2
        color: "transparent"
        border.width: width/10
        border.color: "#19c37d"
        
        RotationAnimation {
            target: spinner
            from: 0
            to: 360
            duration: 1000
            loops: Animation.Infinite
            running: root.running
        }
    }
}
