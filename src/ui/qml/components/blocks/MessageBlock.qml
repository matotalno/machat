import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../" as Components  // Dodaj import za Components

Rectangle {
    id: root
    width: parent.width
    height: messageLayout.height + 32
    color: isUser ? "#f7f7f8" : "#ffffff"
    
    property bool isUser: false
    property string message: ""
    property string timestamp: ""
    
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }
    
    Behavior on scale {
        NumberAnimation { 
            duration: 150 
            easing.type: Easing.OutQuad 
        }
    }
    
    Component.onCompleted: {
        opacity = 0
        scale = 0.9
        entryAnimation.start()
    }
    
    ParallelAnimation {
        id: entryAnimation
        
        NumberAnimation {
            target: root
            property: "opacity"
            to: 1
            duration: 200
        }
        
        NumberAnimation {
            target: root
            property: "scale"
            to: 1
            duration: 300
            easing.type: Easing.OutBack
            easing.overshoot: 1.02
        }
    }
    
    ColumnLayout {
        id: messageLayout
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 16
        }
        spacing: 8
        
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            
            // Avatar
            Rectangle {
                width: 30
                height: 30
                radius: 15
                color: isUser ? "#1a7f64" : "#19c37d"
                
                Text {
                    anchors.centerIn: parent
                    text: isUser ? "U" : "AI"
                    color: "white"
                    font.pixelSize: 14
                }
            }
            
            // Message text
            Text {
                Layout.fillWidth: true
                text: message
                wrapMode: Text.WordWrap
                color: "#000000"
                font.pixelSize: 14
                textFormat: Text.StyledText
                
                // Dodaj typing animaciju
                opacity: text.length ? 1 : 0
                Behavior on opacity {
                    NumberAnimation { 
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }
                
                // Smooth text reveal
                visible: opacity > 0
                scale: opacity
                Behavior on scale {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutBack
                    }
                }
            }
            
            // Timestamp
            Text {
                text: timestamp
                color: "#666666"
                font.pixelSize: 12
            }
        }
        
        Row {
            visible: !isUser
            spacing: 8
            Layout.alignment: Qt.AlignRight
            
            Components.ActionButton {
                iconSource: "qrc:/icons/copy.svg"  // Promena sa /icons na qrc:/icons
                ToolTip.text: "Copy message"
                onClicked: clipboard.setText(message)
            }
            
            Components.ActionButton {
                iconSource: "qrc:/icons/thumbs-up.svg"  // Promena sa /icons na qrc:/icons
                ToolTip.text: "Good response"
                onClicked: chatBridge.rateMessage(true)
            }
            
            Components.ActionButton {
                iconSource: "qrc:/icons/thumbs-down.svg"  // Promena sa /icons na qrc:/icons
                ToolTip.text: "Bad response"
                onClicked: chatBridge.rateMessage(false)
            }
        }
    }
}
