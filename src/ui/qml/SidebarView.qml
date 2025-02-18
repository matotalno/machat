import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components" as Components

Rectangle {
    id: root
    width: 260
    color: "#202123"
    
    property bool collapsed: false
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header sa logom
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: "transparent"
            
            Text {
                anchors.centerIn: parent
                text: "Modern AI Chat"
                color: "#ffffff"
                font.pixelSize: 18
            }
        }
        
        // New Chat dugme
        Components.RippleButton {
            Layout.fillWidth: true
            Layout.margins: 8
            height: 44
            text: "New Chat"
            backgroundColor: "transparent"
            rippleColor: "#40ffffff"
            
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: "#565869"
                border.width: 1
                radius: 6
                z: -1
            }
            
            onClicked: chatBridge.createNewChat()
        }
        
        // Lista sesija
        ListView {
            id: sessionList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: sessionModel
            clip: true
            
            Components.EmptyStateComponent {
                anchors.centerIn: parent
                visible: sessionList.count === 0
            }
            
            delegate: Rectangle {
                width: parent.width
                height: 44
                color: model.sessionId === chatBridge.current_session_id ? "#3E3F4B" : "transparent"
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    
                    Rectangle {
                        anchors.fill: parent
                        color: parent.containsMouse ? 
                               (model.sessionId === chatBridge.current_session_id ? "#4B4C5A" : "#2D2D2D") : 
                               "transparent"
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8
                            
                            Text {
                                Layout.fillWidth: true
                                text: model.title
                                color: "#ffffff"
                                elide: Text.ElideRight
                            }
                            
                            Components.ActionButton {
                                iconSource: "qrc:/icons/copy.svg"
                                visible: parent.parent.parent.containsMouse
                                onClicked: chatBridge.deleteSession(model.sessionId)
                            }
                        }
                    }
                    
                    onClicked: chatBridge.selectSession(model.sessionId)
                }
            }
        }
        
        // Settings dugme na dnu
        Components.RippleButton {
            Layout.fillWidth: true
            Layout.margins: 8
            height: 44
            text: "Settings"
            backgroundColor: "transparent"
            
            onClicked: settingsDialog.open()
        }
    }
}
