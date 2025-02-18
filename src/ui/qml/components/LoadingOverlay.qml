import QtQuick 2.15
import QtQuick.Controls 2.15
import "." as Components

Rectangle {
    id: root
    width: 60
    height: 60
    radius: 30
    color: "#ffffff"
    opacity: 0
    visible: opacity > 0
    scale: opacity
    
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
        size: 30
    }

    // Fade in/out
    Behavior on opacity {
        NumberAnimation { duration: 200 }
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
