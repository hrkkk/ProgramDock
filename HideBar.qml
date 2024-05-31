import QtQuick

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

            onExited: {

            }
        }
    }
}
