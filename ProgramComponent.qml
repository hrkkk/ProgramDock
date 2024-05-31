import QtQuick
import QtQuick.Controls

Item {
    property string programName: ""
    property string programExecPath: ""
    property string programIcon: ""
    signal itemLeftClicked()
    signal itemRightClicked()
    signal fileDraggedin(var fileUrlList)

    width: 40
    height: 40
    anchors.verticalCenter: parent.verticalCenter

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        ToolTip {
            id: toolTip
            text: programName
            visible: false
            x: parent.x
            y: parent.y + 100
        }

        Image {
            id: icon
            width: 40
            height: 40
            source: programIcon
            fillMode: Image.PreserveAspectFit
            smooth: true
            antialiasing: true
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            hoverEnabled: true

            Timer {
                id: timer
                interval: 1000
                onTriggered: {
                    toolTip.visible = true
                }
            }

            onEntered: {
                icon.scale = 1.3
                timer.start()
            }

            onExited: {
                timer.stop()
                icon.scale = 1
                toolTip.visible = false
            }

            onClicked: function(mouse) {
                if (mouse.button === Qt.LeftButton) {
                    itemLeftClicked()
                }
            }
        }

        DropArea {
            anchors.fill: parent

            // 当文件被拖入时触发
            onEntered: {
                icon.scale = 1.3
            }

            onExited: {
                icon.scale = 1
            }

            // 当文件被释放时触发
            onDropped: function(drop) {
                var fileUrls = [""]
                for (var i = 0; i < drop.urls.length; ++i) {
                    fileUrls.push(drop.urls[i].toString().slice(8))
                }
                fileDraggedin(fileUrls)
            }
        }
    }
}
