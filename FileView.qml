import QtQuick
import QtQml.Models

GridView{
    id: fileView
    anchors.fill: parent
    cellWidth: (viewMode == FileView.ViewMode.Table) ? 150 : fileView.width
    cellHeight:(viewMode == FileView.ViewMode.Table) ? fileView.cellWidth + 20 : 50
    property var fileViewListModel: ListModel{}
    property var viewMode: FileView.ViewMode.Table

    model: fileViewListModel

    delegate: Rectangle{
        id: rootItem
        width: fileView.cellWidth
        height: fileView.cellHeight
        Rectangle{
            anchors{
                fill: rootItem
                topMargin: 10
                bottomMargin: 10
                leftMargin: 10
                rightMargin: 10
            }

            Image {
                id: rootItemImage
                fillMode: Image.PreserveAspectFit
                width: (viewMode == FileView.ViewMode.Table) ? parent.width : cellHeight
                height: (viewMode == FileView.ViewMode.Table) ? parent.height - 20 : cellHeight
                source: path_to_image
            }

            TextMetrics{
                id: rootItemTextMetrics
                text: name_of_image
                elide: Qt.ElideMiddle
                elideWidth: {
                    if(viewMode == FileView.ViewMode.Table)
                        return rootItemImage.width
                    else
                        return rootItem.width
                }
            }

            Text {
                id: rootItemText
                text: rootItemTextMetrics.elidedText
                anchors
                {
                    top:{
                        if(viewMode == FileView.ViewMode.Table)
                            return rootItemImage.bottom
                        else
                            return undefined
                    }
                    horizontalCenter: {
                        if(viewMode == FileView.ViewMode.Table)
                            return parent.horizontalCenter
                        else
                            return undefined
                    }
                    left:{
                        if(viewMode == FileView.ViewMode.Table)
                            return undefined
                        else
                            return rootItemImage.right
                    }
                }
            }

            MouseArea{
                anchors.fill: parent

                onClicked:{
                    //console.log(rootItemText.text)
                    photoTriggered(path_to_image)
                }
            }
        }
    }

    signal photoTriggered(var path_to_image)

    function appendToListModel(new_element)
    {
        fileView.fileViewListModel.append(new_element)
    }

    function clearListModel()
    {
        fileView.fileViewListModel.clear()
    }

    enum ViewMode{Table, List}
}
