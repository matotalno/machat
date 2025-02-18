import QtQuick 2.15

ListView {
    id: root
    
    // Smooth scrolling
    flickDeceleration: 3000
    maximumFlickVelocity: 3000
    boundsBehavior: Flickable.StopAtBounds
    
    // Section transitions
    add: Transition {
        NumberAnimation { 
            property: "opacity"
            from: 0; to: 1
            duration: 200 
            easing.type: Easing.OutCubic
        }
    }
    
    // Removal transitions  
    remove: Transition {
        NumberAnimation { 
            property: "opacity"
            from: 1; to: 0
            duration: 200
            easing.type: Easing.InCubic
        }
    }
    
    // Enhanced scroll animations
    displaced: Transition {
        NumberAnimation {
            properties: "x,y"
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
}
