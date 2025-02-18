import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    color: "#1e1e1e"
    radius: 6
    clip: true
    
    property string code: ""
    property string language: "plaintext"
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Rectangle {
            Layout.fillWidth: true
            height: 36
            color: "#2d2d2d"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                
                Text {
                    text: language
                    color: "#9da5b4"
                    font.family: "Segoe UI"
                }
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "Copy"
                    flat: true
                    onClicked: {
                        clipboard.setText(code)
                        copyFeedback.show()
                    }
                }
            }
        }
        
        // Code area
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            TextArea {
                text: root.code
                readOnly: true
                color: "#d4d4d4"
                font.family: "Consolas"
                font.pixelSize: 14
                wrapMode: Text.NoWrap
                background: null
            }
        }
    }
    
    // Copy feedback
    ToolTip {
        id: copyFeedback
        text: "Code copied!"
        timeout: 2000
        
        function show() {
            visible = true
            hideTimer.restart()
        }
        
        Timer {
            id: hideTimer
            interval: 2000
            onTriggered: copyFeedback.visible = false
        }
    }
}
