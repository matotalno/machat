import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    color: isDarkTheme ? "#1e1e1e" : "#f6f8fa"
    border.color: isDarkTheme ? "#383838" : "#e1e4e8"
    radius: 6
    
    property string text: ""
    property string language: "plaintext"
    property bool isDarkTheme: false
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header sa jezikom i copy dugmetom
        Rectangle {
            Layout.fillWidth: true
            height: 36
            color: isDarkTheme ? "#2d2d2d" : "#f1f3f4"
            radius: 6
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                
                Text {
                    text: language
                    color: isDarkTheme ? "#9da5b4" : "#666666"
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                }
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "Copy"
                    flat: true
                    onClicked: {
                        clipboard.setText(root.text)
                        copyFeedback.start()
                    }
                }
            }
        }
        
        // Code content
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            padding: 12
            
            TextArea {
                text: root.text
                readOnly: true
                color: isDarkTheme ? "#d4d4d4" : "#24292e"
                font.family: "Consolas"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                background: null
                
                // Syntax highlighting would be applied here
            }
        }
    }
    
    // Copy feedback
    ToolTip {
        id: copyFeedback
        text: "Copied!"
        timeout: 2000
        y: parent.height + 8
        
        function start() {
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
