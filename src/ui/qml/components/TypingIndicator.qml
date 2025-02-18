import QtQuick 2.15

Row {
    id: root
    spacing: 4
    
    property int dotSize: 6
    property color dotColor: "#19c37d"
    
    Repeater {
        model: 3
        
        Rectangle {
            width: root.dotSize
            height: root.dotSize
            radius: width/2
            color: root.dotColor
            
            SequentialAnimation {
                running: true
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
