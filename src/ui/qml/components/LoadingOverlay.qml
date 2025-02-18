import QtQuick 2.15
import QtQuick.Controls 2.15
import "." as Components

Rectangle {
    id: root
    width: 44
    height: 44
    radius: width/2
    color: "#ffffff"
    opacity: 0
    visible: opacity > 0
    
    // Centriranje u parent
    anchors.centerIn: parent
    
    // Dodaj senku
    Rectangle {
        id: shadow
        anchors.fill: parent
        anchors.margins: -2
        radius: parent.radius + 2
        color: "#20000000"
        z: -1
    }
    
    Components.LoadingSpinner {
        anchors.centerIn: parent
        running: root.visible
        size: 24
    }

    // Fade in/out
    Behavior on opacity {
        NumberAnimation { duration: 150 }
    }
    
    // Scale animation
    Behavior on scale {
        NumberAnimation { 
            duration: 200 
            easing.type: Easing.OutBack
            easing.overshoot: 1.2
        }
    }

    // States
    states: [
        State {
            name: "visible"
            when: root.visible
            PropertyChanges {
                target: root
                opacity: 0.95
            }
        }
    ]
}
