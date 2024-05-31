import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

ApplicationWindow {
    id: rootWindow
    width: 600
    height: 400
    visible: true
    title: "设置"

    property int currentIndex: 0

    TabBar {
        id: tabBar
        width: parent.width

        TabButton {
            text: "常规"
            onClicked: swipeView.currentIndex = 0
        }

        TabButton {
            text: "程序"
            onClicked: swipeView.currentIndex = 1
        }

        TabButton {
            text: "关于"
            onClicked: swipeView.currentIndex = 2
        }
    }

    SwipeView {
        id: swipeView
        width: parent.width
        anchors.top: tabBar.bottom
        anchors.bottom: parent.bottom
        orientation: Qt.Horizontal
        interactive: false
        currentIndex: 1

        Page {
            Rectangle {
                id: firstPage
                anchors.fill: parent
                color: "red"
            }
        }

        Page {
            Rectangle {
                id: secondPage
                anchors.fill: parent

                ScrollView {
                    anchors.left: parent.left
                    width: 0.8 * parent.width
                    height: parent.height


                    ListView {
                        id: listView
                        anchors.top: listView.top
                        height: parent.height
                        width: parent.width
                        spacing: 20

                        model: UserDataModel
                        delegate: Item {
                            Rectangle {
                                id: item
                                width: listView.width
                                height: 30
                                color: {
                                    if (index === currentIndex) {
                                        return "#4079FC"
                                    } else {
                                        if (index % 2 == 0) {
                                            return "#E5F3FF"
                                        } else {
                                            return "#ffffff"
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                                    onClicked: {
                                        currentIndex = index
                                    }
                                }

                                Row {
                                    width: parent.width
                                    height: 30
                                    spacing: 0.03 * parent.width

                                    Text {
                                        height: 30
                                        width: 0.2 * parent.width
                                        text: NameRole
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        height: 30
                                        width: 0.15 * parent.width
                                        text: IconRole
                                        x: 0.4 * parent
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        height: 30
                                        width: 0.45 * parent.width
                                        text: ExecRole
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        height: 30
                                        width: 0.1 * parent.width
                                        text: ParaRole
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.right: parent.right
                    width: 0.2 * parent.width
                    height: parent.height

                    Column {
                        height: parent.height - 30
                        width: 0.6 * parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 30
                        spacing: 20

                        Button {
                            id: addBtn
                            width: parent.width
                            height: 20
                            text: "添  加"
                            onClicked: {
                                for (var i = 0; i < 4; i++) {
                                    listModel.get(i)["value"] = ""
                                }

                                editDialog.open()
                            }
                        }

                        Button {
                            id: deleteBtn
                            width: parent.width
                            height: 20
                            text: "删  除"
                            onClicked: {

                            }
                        }

                        Button {
                            id: editBtn
                            width: parent.width
                            height: 20
                            text: "编  辑"

                            onClicked: {
                                var list = UserDataModel.getItem(currentIndex)
                                for (var i = 0; i < 4; i++) {
                                    listModel.get(i)["value"] = list[i]
                                }
                                editDialog.open()
                            }
                        }

                        Button {
                            id: upperBtn
                            width: parent.width
                            height: 20
                            text: "上  移"
                            enabled: currentIndex <= 0 ? false : true
                            onClicked: {
                                if (currentIndex >= 1) {
                                    UserDataModel.exchangeItem(currentIndex, currentIndex - 1)
                                    currentIndex -= 1
                                }
                            }
                        }

                        Button {
                            id: downBtn
                            width: parent.width
                            height: 20
                            text: "下  移"
                            enabled: currentIndex >= (listView.count - 1) ? false : true
                            onClicked: {
                                if (currentIndex <= listView.count - 2) {
                                    UserDataModel.exchangeItem(currentIndex, currentIndex + 1)
                                    currentIndex += 1
                                }
                            }
                        }

                        Button {
                            id: restoreBtn
                            width: parent.width
                            height: 20
                            text: "恢  复"
                            onClicked: {

                            }
                        }

                        Button {
                            id: saveBtn
                            width: parent.width
                            height: 20
                            text: "保  存"
                            onClicked: {
                                UserDataModel.writeToFile()
                            }
                        }
                    }
                }
            }

            ListModel {
                id: listModel

                ListElement {
                    key: "程序名:"
                    value: ""
                }

                ListElement {
                    key: "程序图标:"
                    value: ""
                }

                ListElement {
                    key: "执行命令:"
                    value: ""
                }

                ListElement {
                    key: "命令参数:"
                    value: ""
                }
            }

            Dialog {
                id: editDialog
                width: 400
                height: 200
                anchors.centerIn: parent
                modal: true
                standardButtons: Dialog.Save | Dialog.Cancel

                FileDialog {
                    id: execFileDialog
                    title: "Choose Exec File"
                    currentFolder: "file:///C:/"
                    nameFilters: ["Executable files (*.exe)"]
                    onAccepted: {
                        var execUrl = execFileDialog.selectedFile.toString().slice(8)
                        listModel.get(2).value = execUrl
                    }
                }

                FileDialog {
                    id: iconFileDialog
                    title: "Choose Icon File"
                    currentFolder: "file:///C:/Users/hrkkk/Desktop/Dock/ProgramDock/resource/"
                    nameFilters: ["Image files (*.png *.jpg *.bmp *.gif)"]

                    onAccepted: {
                        var iconUrl = iconFileDialog.selectedFile.toString().slice(8)
                        var newUrl = iconUrl.slice(iconUrl.lastIndexOf("/") + 1)
                        listModel.get(1).value = newUrl
                    }
                }

                Column {
                    anchors.fill: parent
                    spacing: 5

                    Repeater {
                        id: repeater
                        model: listModel
                        delegate: Rectangle {
                            width: parent.width
                            height: 20
                            color: "transparent"

                            property alias dynamicText: textInput.text

                            Text {
                                id: firstText
                                anchors.left: parent.left
                                width: 70
                                height: parent.height
                                text: key
                            }

                            Rectangle {
                                id: secondInput
                                anchors.left: firstText.right
                                anchors.leftMargin: 20
                                width: parent.width - 130
                                height: parent.height
                                color: "grey"
                                border.width: 1

                                TextInput {
                                    id: textInput
                                    anchors.fill: parent
                                    text: value
                                }
                            }

                            Button {
                                anchors.left: secondInput.right
                                anchors.leftMargin: 20
                                width: 20
                                height: 20
                                visible: (index === 1 || index === 2) ? true :false

                                onClicked: {
                                    if (index === 1) {  // 程序图标选择
                                        iconFileDialog.open()
                                    } else if (index === 2) {   // 执行程序选择
                                        execFileDialog.open()
                                    }
                                }

                                Image {
                                    anchors.fill: parent
                                    source: "qrc:/resource/microsoft.png"
                                    fillMode: Image.PreserveAspectFit
                                }
                            }
                        }
                    }
                }

                onAccepted: {
                    var strList = []
                    for (var i = 0; i < repeater.count; ++i) {
                        strList.push(repeater.itemAt(i).dynamicText)
                    }
                    UserDataModel.setItem(currentIndex, strList)
                }

                onRejected: {
                    editDialog.close()
                    for (var i = 0; i < 4; i++) {
                        listModel.get(i)["value"] = ""
                    }
                }
            }
        }

        Page {
            Rectangle {
                id: thirdPage
                anchors.fill: parent
                color: "green"
            }
        }
    }
}
