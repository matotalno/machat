import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../" as Components  // Dodaj import za Components

Rectangle {
    id: root
    width: parent.width
    height: contentColumn.height + 32
    color: isUser ? "#f7f7f8" : "white"
    
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
    
    Column {
        id: contentColumn
        anchors {
            left: parent.left
            right: parent.right
            margins: 16
            verticalCenter: parent.verticalCenter
        }
        spacing: 8
        
        TextEdit {
            id: messageText
            width: parent.width
            text: root.message
            wrapMode: Text.WordWrap
            readOnly: true
            selectByMouse: true  // Omogućava selekciju
            selectedTextColor: "white"
            selectionColor: "#19c37d"
            color: "#343541"
            font.pixelSize: 14
            
            // Stil za link-ove
            onLinkActivated: (link) => Qt.openUrlExternally(link)
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton
                cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.IBeamCursor
            }
        }

        Row {
            spacing: 8
            visible: !isUser
            
            Components.ActionButton {
                iconSource: "qrc:/icons/copy.svg"
                ToolTip.text: "Copy"
                onClicked: {
                    messageText.selectAll()
                    messageText.copy()
                    messageText.deselect()
                }
            }
            
            Components.ActionButton {
                iconSource: "qrc:/icons/thumbs-up.svg"
                ToolTip.text: "Like"
            }
            
            Components.ActionButton {
                iconSource: "qrc:/icons/thumbs-down.svg"
                ToolTip.text: "Dislike"
            }
        }
    }
}
