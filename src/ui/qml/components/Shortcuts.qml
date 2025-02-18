import QtQuick 2.15

Item {
    Shortcut {
        sequence: StandardKey.Find
        onActivated: searchField.forceActiveFocus()
    }
    
    Shortcut {
        sequence: "Ctrl+N"
        onActivated: chatBridge.createNewChat()
    }
    
    Shortcut {
        sequence: "Ctrl+S"
        onActivated: settingsDialog.open()
    }
}
