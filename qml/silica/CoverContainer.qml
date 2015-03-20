import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Image {
        source: '../data/cover.png'
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: sourceSize.height * width / sourceSize.width
    }

    Label {
        anchors.centerIn: parent
        text: "sailtoVienna"

        visible: resultPage.status !== PageStatus.Active
    }

    ListView {
        anchors.fill: parent
        visible: resultPage.status === PageStatus.Active

        header: Label {
            anchors {
                left: parent.left
                margins: Theme.paddingSmall
            }
            //% "Refreshing..."
            text: resultPage.refreshing ? qsTrId("refreshing...") : resultPage.station
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeTiny
        }

        model: resultPage.resultList

        delegate: ListItem {
            width: parent.width
            height: lineText.height + Theme.paddingSmall
            opacity: index < 8 ? 1.0 - index * 0.13 : 0.0

            Row {
                anchors.fill: parent
                anchors.margins: Theme.paddingSmall

                Label {
                    id: lineText
                    width: parent.width * 0.2
                    anchors.verticalCenter: parent.verticalCenter
                    text: model.line.name
                    font.pixelSize: Theme.fontSizeTiny
                }

                Label {
                    width: parent.width * 0.55
                    anchors.verticalCenter: parent.verticalCenter
                    text: model.line.towards
                    font.pixelSize: Theme.fontSizeTiny
                }

                Label {
                    width: parent.width * 0.25
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight
                    text: model.countdown
                    font.pixelSize: Theme.fontSizeTiny
                }
            }
        }
    }

    CoverActionList {
        enabled: resultPage.status !== PageStatus.Active

        CoverAction {
            iconSource: "image://theme/icon-cover-location"
            onTriggered: showNearBy()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-search"
            onTriggered: showSearch()
        }
    }

    CoverActionList {
        enabled: resultPage.status === PageStatus.Active

        CoverAction {
            iconSource: settings.coverActionSearch ? "image://theme/icon-cover-search" : "image://theme/icon-cover-location"
            onTriggered: {
                if(settings.coverActionSearch)
                    showSearch()
                else
                    showNearBy()
            }
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: refresh()
        }
    }

    function showSearch() {
        pageStack.pop(appWindow.initialPage, PageStackAction.Immediate)
        pageStack.navigateForward(PageStackAction.Immediate)
        appWindow.activate()
    }

    function showNearBy() {
        pageStack.pop(appWindow.initialPage, PageStackAction.Immediate)
        pageStack.push(Qt.resolvedUrl("NearBy.qml"), null, PageStackAction.Immediate)
        appWindow.activate()
    }

    function refresh() {
        resultPage.refresh()
    }
}
