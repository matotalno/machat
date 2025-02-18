import QtQuick 2.15
import QtQuick.Controls 2.15

ScrollView {
    id: root
    clip: true
    
    property real smoothContentY: 0
    
    Behavior on smoothContentY {
        SmoothedAnimation {
            duration: 500
            velocity: 800
        }
    }
    
    contentItem: ListView {
        // ...existing ListView code...
        
        onContentYChanged: {
            if (!moving && !dragging) {
                smoothContentY = contentY
            }
        }
    }
}
