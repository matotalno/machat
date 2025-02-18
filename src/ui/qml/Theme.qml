import QtQuick 2.15

QtObject {
    property bool isDarkMode: false
    
    readonly property color primary: "#19c37d"
    readonly property color background: isDarkMode ? "#1f1f1f" : "#ffffff"
    readonly property color surface: isDarkMode ? "#2f2f2f" : "#f7f7f8"
    readonly property color text: isDarkMode ? "#ffffff" : "#000000"
    readonly property color textSecondary: isDarkMode ? "#cccccc" : "#666666"

    property QtObject animations: QtObject {
        readonly property int duration: 200
        readonly property int easing: Easing.OutCubic
        
        readonly property Component fadeIn: Component {
            NumberAnimation {
                property: "opacity"
                from: 0; to: 1
                duration: animations.duration
                easing.type: animations.easing
            }
        }
        
        readonly property Component slideUp: Component {
            NumberAnimation {
                property: "y"
                from: 50; to: 0
                duration: animations.duration
                easing.type: animations.easing
            }
        }
    }
}
