import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components" as Components

Components.MessageBlock {
    width: ListView.view.width
    message: model.message
    isUser: model.isUser
    timestamp: model.timestamp
}
