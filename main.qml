import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.3
import com.defiantgoat 1.0

Window {
    visible: true
    width: 800
    height: 600
    title: qsTr("QML / JS Line Counter")
    property int finalLineCount: 0
    property string fileSummary: ""

    ColumnLayout {
        spacing: 0
        anchors.fill: parent
        anchors.margins: 20
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            RowLayout {
                anchors.fill: parent
                spacing: 5
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100
                    Button {
                        anchors.fill: parent
                        text: "Choose app folder"
                        onClicked: {
                            folderChooser.open();
                        }
                    }
                }
                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Text {
                        id: chosenPath
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }
                }
            }
        }
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            ScrollView {
                id: view
                anchors.fill: parent
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                TextArea {
                   id: fileReadSummary
                   font {
                       pointSize: 12
                   }


                   wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }

        }
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            Text {
                id: finalLineCountText
                text: "Line Count: %1".arg(finalLineCount)
                font.weight: Font.Bold
                font.pointSize: 18
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    LineCount {
        id: lineCounter
        onFileRead: {
            fileSummary += "File: %1 | Lines: %2\n".arg(fileData.fileName).arg(fileData.lineCount);
        }

        onLineCountComplete: {
            finalLineCount = count;
            fileReadSummary.text = fileSummary;
        }
    }

    FileDialog {
        id: folderChooser
        selectFolder: true
        onAccepted: {
            finalLineCount = 0;
            fileSummary = "";
            chosenPath.text = folderChooser.fileUrl.toString();
            var url = folderChooser.fileUrl.toString();
            var path = url.substring(7, url.length);
            lineCounter.parseDir(path);
        }
    }
}
