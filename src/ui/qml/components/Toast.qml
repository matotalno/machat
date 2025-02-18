import QtQuick 2.15

Rectangle {
    id: root
    height: 40
    width: message.width + 40
    color: "#323232"
    radius: 20
    opacity: 0
    
    property string text: ""
    
    Text {
        id: message
        anchors.centerIn: parent
        color: "white"
        text: root.text
    }
    
    function show(msg) {
        root.text = msg
        animation.start()
    }
    
    SequentialAnimation {
        id: animation
        
        NumberAnimation {
            target: root
            property: "opacity"
            to: 1
            duration: 200
        }
        
        PauseAnimation { duration: 2000 }
        
        NumberAnimation {
            target: root
            property: "opacity" 
            to: 0
            duration: 200
        }
    }
}
