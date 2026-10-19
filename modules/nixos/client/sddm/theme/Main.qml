import QtQuick
import QtQuick.Window

// Deliberately flat: a clock, one password field and the few controls a login
// screen cannot do without. Colours and font come from theme.conf so the look
// can be retuned without touching this file.
Rectangle {
    id: root

    // SDDM sizes the greeter window per screen; the theme just fills it.
    width: Screen.width
    height: Screen.height
    color: config.background

    property int userIndex: userModel.lastIndex
    property int sessionIndex: sessionModel.lastIndex
    property bool busy: false
    property string notice: ""

    // The greeter's models hand QML no role names, so the roles are addressed
    // by their enum order: name and real name on userModel, and the fourth
    // role on sessionModel, which is the session's display name.
    function currentUser(): string {
        return userModel.data(userModel.index(root.userIndex, 0), Qt.UserRole + 1) || "";
    }

    function currentRealName(): string {
        return userModel.data(userModel.index(root.userIndex, 0), Qt.UserRole + 2) || root.currentUser();
    }

    function currentSession(): string {
        return sessionModel.data(sessionModel.index(root.sessionIndex, 0), Qt.UserRole + 4) || "";
    }

    function submit() {
        if (root.busy || password.text.length === 0)
            return;

        root.busy = true;
        root.notice = "";
        sddm.login(root.currentUser(), password.text, root.sessionIndex);
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            root.busy = false;
            root.notice = "Incorrect password";
            password.selectAll();
            password.forceActiveFocus();
            shake.restart();
        }

        function onLoginSucceeded() {
            // Fade rather than blink straight into the compositor.
            root.opacity = 0;
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    // A second is finer than the clock needs, but it keeps the minute from
    // flipping visibly late.
    Timer {
        id: ticker

        property date now: new Date()

        interval: 1000
        running: true
        repeat: true
        onTriggered: now = new Date()
    }

    Column {
        anchors.centerIn: parent
        spacing: 0

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(ticker.now, "HH:mm")
            color: config.foreground
            font.family: config.font
            font.pixelSize: 96
            font.weight: Font.Light
            font.letterSpacing: -2
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: 4
            text: Qt.formatDateTime(ticker.now, "dddd, d MMMM").toLowerCase()
            color: config.subdued
            font.family: config.font
            font.pixelSize: 14
            font.letterSpacing: 3
        }

        Item {
            width: 1
            height: 72
        }

        // Only worth showing when there is a choice to make; a click walks
        // through the accounts.
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            bottomPadding: 12
            visible: userModel.count > 1
            text: root.currentRealName()
            color: users.containsMouse ? config.foreground : config.subdued
            font.family: config.font
            font.pixelSize: 14

            MouseArea {
                id: users

                anchors.fill: parent
                anchors.margins: -8
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.userIndex = (root.userIndex + 1) % userModel.count
            }
        }

        Rectangle {
            id: field

            anchors.horizontalCenter: parent.horizontalCenter
            width: 300
            height: 44
            radius: height / 2
            color: config.surface
            border.width: 1
            border.color: root.notice.length > 0 ? config.error : (password.activeFocus ? config.hover : config.border)

            Behavior on border.color {
                ColorAnimation {
                    duration: 150
                }
            }

            SequentialAnimation {
                id: shake

                loops: 2

                NumberAnimation {
                    target: field
                    property: "anchors.horizontalCenterOffset"
                    to: 8
                    duration: 50
                }

                NumberAnimation {
                    target: field
                    property: "anchors.horizontalCenterOffset"
                    to: -8
                    duration: 50
                }

                NumberAnimation {
                    target: field
                    property: "anchors.horizontalCenterOffset"
                    to: 0
                    duration: 50
                }
            }

            Text {
                anchors.centerIn: parent
                visible: password.text.length === 0 && !password.activeFocus
                text: "password"
                color: config.subdued
                font.family: config.font
                font.pixelSize: 15
            }

            TextInput {
                id: password

                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                clip: true
                enabled: !root.busy
                echoMode: TextInput.Password
                passwordCharacter: "•"
                passwordMaskDelay: 0
                color: config.foreground
                selectionColor: config.hover
                selectedTextColor: config.foreground
                font.family: config.font
                font.pixelSize: 15
                // The dots are wide enough to read without the default spacing.
                font.letterSpacing: 2

                onTextChanged: root.notice = ""
                onAccepted: root.submit()

                Keys.onEscapePressed: text = ""

                Component.onCompleted: forceActiveFocus()
            }
        }

        // Reserved height, so the layout does not jump when a message appears.
        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: field.width
            height: 40

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                y: 14
                text: root.notice.length > 0 ? root.notice : (keyboard.capsLock ? "caps lock is on" : "")
                color: root.notice.length > 0 ? config.error : config.subdued
                font.family: config.font
                font.pixelSize: 13
            }
        }
    }

    // Cycles the session; hidden when there is nothing to cycle to.
    Text {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 24
        visible: sessionModel.rowCount() > 1
        text: root.currentSession().toLowerCase()
        color: sessions.containsMouse ? config.foreground : config.subdued
        font.family: config.font
        font.pixelSize: 13

        MouseArea {
            id: sessions

            anchors.fill: parent
            anchors.margins: -8
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.sessionIndex = (root.sessionIndex + 1) % sessionModel.rowCount()
        }
    }

    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 24
        spacing: 18

        // Nerd Font glyphs given as codepoints so this file stays plain ASCII.
        Repeater {
            model: [
                {
                    glyph: 0xf186,
                    action: () => sddm.suspend(),
                    enabled: sddm.canSuspend
                },
                {
                    glyph: 0xf021,
                    action: () => sddm.reboot(),
                    enabled: sddm.canReboot
                },
                {
                    glyph: 0xf011,
                    action: () => sddm.powerOff(),
                    enabled: sddm.canPowerOff
                }
            ]

            Text {
                required property var modelData

                visible: modelData.enabled
                text: String.fromCodePoint(modelData.glyph)
                color: power.containsMouse ? config.foreground : config.subdued
                font.family: config.font
                font.pixelSize: 16

                MouseArea {
                    id: power

                    anchors.fill: parent
                    anchors.margins: -8
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.action()
                }
            }
        }
    }

    // Typing anywhere should land in the password field.
    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: password.forceActiveFocus()
    }
}
