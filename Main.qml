import QtQuick
import QtQuick.Controls
import Qt.labs.platform

Window {
    id: mainWindow
    width: 1400
    height: 60
    visible: true
    title: qsTr("Hello World")
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"
    x: (Screen.width - width) / 2
    y: Screen.height - 100

    property int timerCounter: 0
    property bool windowIsHidden: false

    Window {
        id: hideBar
        width: 200
        height: 5
        visible: true
        flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
        x: (Screen.width - width) / 2
        y: (Screen.height - 12)
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: "white"
            opacity: 0.5
            radius: 7

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton

                onEntered: {
                    hideBar.width = 250
                    hideBar.height = 10

                    if (windowIsHidden) {
                        enterAnimation.start()

                        windowIsHidden = false
                    }
                }

                onExited: {
                    hideBar.width = 200
                    hideBar.height = 5

                    // 此时再启动定时器，使得鼠标位于横条上时程序坞不会消失
                    mainTimer.start()
                }
            }
        }
    }

    Timer {
        id: mainTimer
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            timerCounter += 1

            if (timerCounter === 5) {
                exitAnimation.start()
                mainTimer.stop()
                windowIsHidden = true
                timerCounter = 0
            }
        }
    }

    NumberAnimation {
        id: enterAnimation
        target: mainWindow
        properties: "y"
        from: Screen.height
        to: Screen.height - 100
        duration: 300
    }

    NumberAnimation {
        id: exitAnimation
        target: mainWindow
        properties: "y"
        from: Screen.height - 100
        to: Screen.height
        duration: 300
    }

    SystemTrayIcon {
        id: trayIcon
        icon.source: "qrc:/resource/microsoft.png"
        menu: trayMenu
        visible: true
    }

    Menu {
        id: trayMenu

        MenuItem {
            text: "设置"
            onTriggered: {
                var settingWindow = Qt.createComponent("SettingWindow.qml")

                if (settingWindow.status === Component.Ready) {
                    var windowInstance = settingWindow.createObject();

                    // 获取屏幕宽度和高度
                    var screenWidth = Screen.width;
                    var screenHeight = Screen.height;

                    // 设置新窗口居中显示
                    windowInstance.x = (screenWidth - windowInstance.width) / 2;
                    windowInstance.y = (screenHeight - windowInstance.height) / 2;
                }
            }
        }

        MenuSeparator{}

        MenuItem {
            text: "显示 / 隐藏"
            onTriggered: {
                if (mainWindow.visible) {
                    mainWindow.hide()
                } else {
                    mainWindow.show()
                }
            }
        }
        MenuItem {
            text: "重启"
        }
        MenuItem {
            text: "退出"
            onTriggered: {
                Qt.quit()
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 15
        color: "white"
        opacity: 0.5

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton

            property bool mouseIsPressed: false
            property int myMouseX: 0
            property int myMouseY: 0
            property int offsetX: 0
            property int offsetY: 0

            onEntered: function(mouse) {
                timerCounter = 0
            }

            onPressed: function(mouse) {
                cursorShape = Qt.SizeAllCursor
                mouseIsPressed = true

                myMouseX = mouse.x
                myMouseY = mouse.y
            }

            onReleased: function(mouse) {
                cursorShape = Qt.ArrowCursor
                mouseIsPressed = false
            }

            onPositionChanged: {
                if (mouseIsPressed) {
                    offsetX = mouse.x - myMouseX
                    offsetY = mouse.y - myMouseY

                    mainWindow.x += offsetX
                    mainWindow.y += offsetY

                    myMouseX = mouse.x
                    myMouseY = mouse.y
                }
            }
        }
    }

    Row {
        id: userProgramArea
        width: 0.8 * parent.width
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 11

        Repeater {
            id: userPrograms
            model: UserDataModel
            delegate: ProgramComponent {
                programName: NameRole
                programIcon: "file:./icon/" + IconRole
                opacity: 1

                onItemLeftClicked: {
                    UserDataModel.execProgram(index, [])
                }

                onFileDraggedin: function(fileUrlList) {
                    UserDataModel.execProgram(index, fileUrlList)
                }
            }
        }
    }

    Rectangle {
        id: divider
        width: 1
        height: 0.7 * parent.height
        anchors.left: userProgramArea.right
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
    }

    Row {
        id: systemProgramArea
        height: parent.height
        anchors.right: parent.right
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 10

        Repeater {
            id: systemPrograms
            model: SystemDataModel
            delegate: ProgramComponent {
                programName: NameRole
                programIcon: "file:./icon/" + IconRole
                opacity: 1

                onItemLeftClicked: {
                    SystemDataModel.execProgram(index, [])
                }

                onFileDraggedin: function(fileUrlList) {
                    // SystemDataModel.execProgram(index, fileUrlList)
                }
            }
        }
    }
}
