import QtQuick.Dialogs
import QtQuick
import Qt.labs.platform as Platform
import Qt.labs.folderlistmodel
import QtQuick.Controls
import QtQml.Models
import QtQml

ApplicationWindow {
    id: mainWindow

    width: 470
    height: 500
    visible: true
    title: "Image Viewer"

    Rectangle{
        id: root
        anchors.fill: parent

        FileView{
            id: fileView
            anchors{
                fill: parent
                topMargin: 10
                bottomMargin: 10
                leftMargin: 10
                rightMargin: 10
            }

            onPhotoTriggered: (path_to_image) => {
                imageRect.visible = true
                imageRect.source = path_to_image
            }
        }
    }

    Rectangle{
        id: imageRect
        visible: false
        color: "#000000"
        anchors.fill: parent
        property string source

        Image{
            anchors.fill: parent
            fillMode: Image.Tile
            horizontalAlignment: Image.AlignLeft
            verticalAlignment: Image.AlignTop
            source: "qrc:/transparent.png"
        }

        Image{
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: imageRect.source

            MouseArea{
                id: imageRectMouseArea
                anchors.fill: parent

                onClicked: {
                    imageRect.visible = false
                }
            }
        }
    }

    header: Rectangle{
        width: mainWindow.width
        height: pathToFolder.height
        TextInput{
            id: pathToFolder
            width: mainWindow.width
            font.pixelSize: 18;

            onAccepted: {
                //console.log("Enter")
                //console.log(pathToFolder.text)
                folderChecker.folder = "file:///" + pathToFolder.text
            }
        }
    }

    menuBar: MenuBar{
        contentHeight: 10
        Menu {
            title: qsTr("&File")
            Action {
                text: qsTr("&Open folder")
                onTriggered: folderDialog.open()
            }
            MenuSeparator { }
            Action {
                text: qsTr("&Quit")
                onTriggered: mainWindow.close();
            }
        }
    }

    footer: Rectangle{
        id: viewChanger
        property int button_size : 20
        color: "#FFFFFF"
        width: mainWindow.width
        height: viewChanger.button_size
        Row{
            Button{
                width: viewChanger.button_size
                height: viewChanger.button_size
                text: "T"
                onClicked: {
                    fileView.viewMode = FileView.ViewMode.Table
                    folderChecker.reload()
                }
            }
            Button{
                width: viewChanger.button_size
                height: viewChanger.button_size
                text: "L"
                onClicked: {
                    fileView.viewMode = FileView.ViewMode.List
                    folderChecker.reload()
                }
            }
        }
    }

    Platform.FolderDialog  {
        id: folderDialog
        folder: Platform.StandardPaths.writableLocation(StandardPaths.DocumentsLocation)

        onAccepted:{
            var path = folderDialog.folder.toString();
            path = path.replace(/^(file:\/{3})/,"");
            var cleanPath = decodeURIComponent(path);
            pathToFolder.text = cleanPath;
            folderChecker.folder = folderDialog.folder
        }

    }

    FolderListModel{
        id: folderChecker
        nameFilters: [
            "*.png", "*.jpg"
        ]
        showDirs: false
        onStatusChanged: {
            if(folderChecker.status == FolderListModel.Ready)
            {
                //console.log(folderChecker.folder)
                fileView.clearListModel()
                for(var i = 0; i < folderChecker.count; ++i)
                {
                    fileView.appendToListModel(
                                {
                                    "path_to_image": folderChecker.get(i, "fileUrl").toString(),
                                    "name_of_image": folderChecker.get(i, "fileName")
                                })
                    //console.log(folderChecker.get(i, "fileName"))
                }
            }
        }

        function reload()
        {
            var temp = folderChecker.folder
            folderChecker.folder = ""
            folderChecker.folder = temp
        }
    }

}
