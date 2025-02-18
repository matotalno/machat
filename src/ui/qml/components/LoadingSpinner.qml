import QtQuick 2.15

Item {
    id: root
    
    property bool running: false
    property int size: parent.height * 0.5
    property color color: "#19c37d"

    width: size
    height: size
    visible: running
    opacity: running ? 1 : 0
    
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }
    
    // Glavni spinner krug
    Rectangle {
        id: spinner
        anchors.fill: parent
        radius: width/2
        color: "transparent"
        border.width: width/10
        border.color: root.color
        
        RotationAnimation {
            target: spinner
            from: 0
            to: 360
            duration: 1000
            loops: Animation.Infinite
            running: root.running
        }
        
        // Dodatni gradijent efekat
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: root.color }
                GradientStop { position: 0.5; color: "transparent" }
            }
            opacity: 0.2
            
            RotationAnimation {
                target: parent
                from: 180
                to: 540
                duration: 1500
                loops: Animation.Infinite
                running: root.running
            }
        }
    }
    
    // Manji unutrašnji krug koji se vrti u suprotnom smeru
    Rectangle {
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: width
        radius: width/2
        color: "transparent"
        border.width: width/8
        border.color: root.color
        opacity: 0.7
        
        RotationAnimation {
            target: parent
            from: 360
            to: 0
            duration: 1500
            loops: Animation.Infinite
            running: root.running
        }
    }
}
