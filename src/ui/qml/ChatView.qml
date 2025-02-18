import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic  // Dodajemo Basic stil
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "components" as Components
import "components/blocks" as Blocks  // Dodaj ovo

ApplicationWindow {
    id: root
    width: 800
    height: 600
    visible: true
    title: "Modern AI Chat"
    
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        // Sidebar
        Rectangle {
            Layout.preferredWidth: 260
            Layout.fillHeight: true
            color: "#202123"
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                
                // New Chat dugme
                Button {
                    Layout.fillWidth: true
                    Layout.margins: 8
                    height: 44
                    text: "New Chat"
                    onClicked: chatBridge.createNewChat()
                    
                    background: Rectangle {
                        color: "transparent"
                        border.color: "#565869"
                        border.width: 1
                        radius: 6
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                
                // Lista razgovora
                ListView {
                    id: sessionList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: sessionModel
                    spacing: 1
                    verticalLayoutDirection: ListView.TopToBottom
                    clip: true
                    
                    Blocks.EmptyStateComponent {
                        anchors.centerIn: parent
                        visible: sessionList.count === 0
                        width: parent.width
                        height: parent.height
                    }
                    
                    delegate: Rectangle {
                        width: sessionList.width || 0  // Fix null width error
                        height: 44
                        color: model.sessionId === chatBridge.current_session_id ? "#3E3F4B" : "transparent"
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            
                            onClicked: {
                                if (model.sessionId) {
                                    chatBridge.selectSession(model.sessionId)
                                }
                            }
                            
                            Rectangle {
                                anchors.fill: parent
                                color: {
                                    if (!parent.containsMouse) return "transparent"
                                    return model.sessionId === chatBridge.current_session_id ? "#4B4C5A" : "#2D2D2D"
                                }
                                
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 12
                                    text: model.title
                                    color: "#ffffff"
                                    font.pixelSize: 14
                                }
                                
                                Row {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter

                                    Button {
                                        width: 24
                                        height: 24
                                        text: "×"
                                        
                                        background: Rectangle {
                                            color: parent.hovered ? "#ff4444" : "transparent"
                                            radius: 4
                                        }
                                        
                                        contentItem: Text {
                                            text: parent.text
                                            color: parent.hovered ? "white" : "#666666"
                                            font.pixelSize: 16
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        
                                        onClicked: {
                                            if (model.sessionId) {
                                                chatBridge.deleteSession(model.sessionId)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Model selector na dnu
                ComboBox {
                    Layout.fillWidth: true
                    Layout.margins: 8
                    model: ["GPT-4", "GPT-3.5"]
                    currentIndex: 0
                }
            }
        }
        
        // Chat area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#ffffff"
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                
                // Chat area
                ScrollView {
                    id: chatScrollView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    // Dodaj property za praćenje scroll pozicije
                    property bool atBottom: messageList.atYEnd
                    
                    ListView {
                        id: messageList
                        width: chatScrollView.width
                        height: chatScrollView.height
                        model: chatModel
                        delegate: Components.MessageBlock {
                            width: messageList.width
                            message: model.message
                            isUser: model.isUser
                            timestamp: model.timestamp
                        }
                        spacing: 0
                        
                        // Osnovna podešavanja
                        layoutDirection: Qt.LeftToRight
                        verticalLayoutDirection: ListView.TopToBottom
                        
                        // Poboljšane scrolling performanse
                        cacheBuffer: 1000
                        reuseItems: true
                        
                        // Scrolling properties
                        property bool autoScrollEnabled: true
                        property real lastContentY: 0
                        
                        // Dodaj property za praćenje pozicije
                        property bool atYEnd: contentY >= contentHeight - height - 10
                        
                        // Poboljšan auto-scroll
                        
                        // Pratimo promene u modelu
                        onCountChanged: {
                            if (count > 0) {
                                messageList.positionViewAtEnd()
                            }
                        }
                        
                        // Pratimo promene sadržaja
                        onContentHeightChanged: {
                            if (autoScrollEnabled) {
                                messageList.positionViewAtEnd()  // Fix: Dodaj messageList.
                            }
                            lastContentY = contentY 
                        }
                        
                        // Smooth scrolling postavke
                        flickDeceleration: 1500
                        maximumFlickVelocity: 2500
                        boundsBehavior: Flickable.StopAtBounds
                        
                        // Praćenje novih poruka
                        Connections {
                            target: chatModel
                            function onLastMessageChanged() {
                                messageList.positionViewAtEnd()
                            }
                        }
                        
                        // Uvek scroll na dno kad stigne nova poruka
                        Connections {
                            target: chatBridge
                            function onMessageReceived() {
                                messageList.positionViewAtEnd()  // Fix: Dodaj messageList.
                            }
                        }
                        
                        // Prati da li je korisnik manuelno skrolovao
                        onContentYChanged: {
                            if (!dragging && !flicking) {
                                var atBottom = (contentY + height + 10 >= contentHeight)
                                autoScrollEnabled = atBottom
                            }
                            lastContentY = contentY
                            
                            // Proveri da li smo na dnu
                            atYEnd = contentY >= contentHeight - height - 10
                        }
                        
                        // Dodaj smooth scroll behavior
                        Behavior on contentY {
                            SmoothedAnimation {
                                duration: 800  // Duža animacija
                                velocity: 800  // Brža početna brzina
                                easing.type: Easing.OutCubic  // Prirodniji efekat
                            }
                        }
                    }
                    
                    // "Scroll to bottom" dugme (moderniji pristup bez DropShadow)
                    Rectangle {
                        id: scrollToBottomButton
                        width: 44
                        height: 44
                        radius: 22
                        color: "#ffffff"
                        visible: !messageList.atYEnd
                        opacity: visible ? 0.95 : 0
                        z: 100

                        // Svojstva za animacije
                        property bool isHovered: false
                        
                        anchors {
                            right: parent.right
                            bottom: parent.bottom
                            margins: 24
                        }
                        
                        // Moderna senka bez DropShadow
                        Rectangle {
                            id: buttonShadow
                            anchors.fill: parent
                            anchors.margins: -2
                            radius: parent.radius + 2
                            color: "#20000000"
                            z: -1
                        }

                        // Zelena pozadina sa ikonom
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: scrollToBottomButton.isHovered ? Qt.darker("#19c37d", 1.1) : "#19c37d"
                            
                            Text {
                                anchors.centerIn: parent
                                text: "↓"
                                color: "white"
                                font.pixelSize: 20
                                font.bold: true
                            }
                            
                            // Smooth color transition
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }

                        // Interakcija
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onEntered: {
                                scrollToBottomButton.isHovered = true
                                parent.scale = 1.05
                            }
                            onExited: {
                                scrollToBottomButton.isHovered = false
                                parent.scale = 1.0
                            }
                            onClicked: {
                                scrollToBottomAnimation.start()
                            }
                        }
                        
                        // Scale animation
                        Behavior on scale {
                            NumberAnimation { 
                                duration: 150 
                                easing.type: Easing.OutQuad
                            }
                        }
                        
                        // Opacity animation
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                    }

                    // Smooth scroll animation
                    NumberAnimation {
                        id: scrollToBottomAnimation
                        target: messageList
                        property: "contentY"
                        to: messageList.contentHeight - messageList.height
                        duration: 500
                        easing.type: Easing.OutCubic
                        
                        onFinished: {
                            messageList.autoScrollEnabled = true
                        }
                    }
                }
                
                // Typing indicator
                Components.CustomTypingIndicator {
                    id: typingIndicator
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.bottomMargin: 8
                }

                // Input area
                Rectangle {
                    id: inputArea
                    Layout.fillWidth: true
                    height: 80
                    color: "#ffffff"
                    border.color: "#e5e7eb"
                    border.width: 1
                    
                    RowLayout {
                        anchors {
                            fill: parent
                            margins: 16
                        }
                        spacing: 12
                        
                        TextField {
                            id: messageInput
                            Layout.fillWidth: true
                            placeholderText: "Unesite poruku..."
                            enabled: !typingIndicator.visible
                            font.pixelSize: 16
                            
                            background: Rectangle {
                                color: "#f9fafb"
                                radius: 8
                                border.color: "#e5e7eb"
                                border.width: 1
                            }
                            
                            onAccepted: {
                                if (text.trim()) {
                                    chatBridge.sendMessage(text.trim())
                                    text = ""
                                }
                            }
                        }
                        
                        Button {
                            text: "Pošalji"
                            enabled: messageInput.text.trim() && !typingIndicator.visible
                            implicitHeight: 40
                            implicitWidth: 80
                            
                            background: Rectangle {
                                color: parent.enabled ? "#19c37d" : "#e5e7eb"
                                radius: 8
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: parent.enabled ? "white" : "#6B7280"
                                font.pixelSize: 14
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: messageInput.accepted()
                        }
                    }
                }
            }
        }
    }
    
    Component.onCompleted: {
        console.log("ChatView loaded")
    }
    
    // Pojednostavi Connections
    Connections {
        target: chatBridge
        
        function onIsTypingChanged(isTyping) {
            typingIndicator.visible = isTyping
        }
    }
}
