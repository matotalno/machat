import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: "transparent"

    Column {
        anchors.centerIn: parent
        spacing: 16

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Nema aktivnih razgovora"
            color: "#666666"
            font.pixelSize: 16
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Započni novi razgovor"
            
            contentItem: Text {
                text: parent.text
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
            }
            
            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 40
                color: parent.down ? Qt.darker("#19c37d", 1.2) :
                       parent.hovered ? Qt.darker("#19c37d", 1.1) : "#19c37d"
                radius: 6
            }
            
            onClicked: chatBridge.createNewChat()
        }
    }
}
