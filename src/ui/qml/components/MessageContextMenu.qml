import QtQuick 2.15
import QtQuick.Controls 2.15

Menu {
    id: contextMenu
    
    MenuItem {
        text: "Copy"
        onTriggered: clipboard.setText(modelData.message)
    }
    
    MenuItem {
        text: "Delete"
        onTriggered: chatBridge.deleteMessage(modelData.id)
    }
    
    MenuSeparator { }
    
    MenuItem {
        text: "Regenerate"
        visible: !modelData.isUser
        onTriggered: chatBridge.regenerateResponse()
    }
}
