import QtQuick 2.15

QtObject {
    readonly property int duration: 200
    readonly property int easing: Easing.OutCubic
    
    readonly property Component fadeIn: Component {
        NumberAnimation { 
            property: "opacity"
            from: 0; to: 1
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    
    readonly property Component slideIn: Component {
        NumberAnimation {
            property: "x"
            from: -50; to: 0
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
}
