import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 200
    height: 120
    color: "transparent"
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12
        
        Text {
            text: "Nema aktivnih razgovora"
            color: "#666666"
            font.pixelSize: 14
            Layout.alignment: Qt.AlignHCenter
        }
        
        Button {
            text: "Započni novi razgovor"
            Layout.alignment: Qt.AlignHCenter
            
            onClicked: chatBridge.createNewChat()
            
            background: Rectangle {
                color: "#19c37d"
                radius: 6
                
                Rectangle {
                    anchors.fill: parent
                    color: parent.parent.hovered ? "#000000" : "transparent"
                    opacity: parent.parent.hovered ? 0.1 : 0
                    radius: 6
                }
            }
            
            contentItem: Text {
                text: parent.text
                color: "white"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
