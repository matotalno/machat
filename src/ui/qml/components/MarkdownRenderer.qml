import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    color: "transparent"
    
    property string markdownText: ""
    property bool isDarkTheme: false
    
    // Signali za interakciju
    signal linkClicked(string url)
    signal codeBlockCopied(string code)
    
    // Markdown parsing i rendering
    Flickable {
        id: markdownFlickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: markdownColumn.height
        clip: true
        
        ColumnLayout {
            id: markdownColumn
            width: parent.width
            spacing: 8
            
            Repeater {
                id: blockRepeater
                model: MarkdownParser.parse(markdownText)
                
                delegate: Loader {
                    Layout.fillWidth: true
                    Layout.margins: modelData.type === "code" ? 8 : 0
                    
                    source: {
                        switch(modelData.type) {
                            case "paragraph": return "blocks/ParagraphBlock.qml"
                            case "code": return "blocks/CodeBlock.qml"
                            case "heading": return "blocks/HeadingBlock.qml"
                            case "list": return "blocks/ListBlock.qml"
                            case "quote": return "blocks/QuoteBlock.qml"
                            default: return "blocks/ParagraphBlock.qml"
                        }
                    }
                    
                    onLoaded: {
                        item.text = modelData.content
                        if (modelData.type === "code") {
                            item.language = modelData.language || "plaintext"
                            item.isDarkTheme = root.isDarkTheme
                        }
                    }
                }
            }
        }
    }
}
