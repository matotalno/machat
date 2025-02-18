import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: root
    anchors.fill: parent
    
    property bool active: false
    
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: root.active ? 0.3 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }
    
    FastBlur {
        anchors.fill: parent
        source: ShaderEffectSource {
            sourceItem: applicationWindow
            recursive: false
        }
        radius: root.active ? 32 : 0
        
        Behavior on radius {
            NumberAnimation { duration: 200 }
        }
    }
    
    MouseArea {
        anchors.fill: parent
        enabled: root.active
    }
}
