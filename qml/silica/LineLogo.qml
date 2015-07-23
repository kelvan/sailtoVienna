import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: linelogo
    property string linename
    property string linecolour
    height: parent.height

    Rectangle {
        id: rectangle
        height: label.height
        width: label.width + 8
        anchors.verticalCenter: parent.verticalCenter
        color: linecolour
    }

    Label {
        id: label
        x: 4
        anchors.verticalCenter: parent.verticalCenter
        text: linename
    }
}
