import QtQuick 2.3
import QtQuick.Controls 1.0

Rectangle{
    id: root
    property bool disabled: false
    property bool hoverEnabled: true
    property url normal_image
    property var normal_opacity: 0.8
    property var hovered_opacity: 1
    property var pressed_opacity: 1
    property var disabled_opacity: 1

    property string tooltip

    signal hovered
    signal clicked
    signal pressed
    signal released
    signal exited

    color: "transparent"
    state: 'normal'

    opacity: 1

    MouseArea {

        id: mouseArea

        anchors.fill: parent
        enabled: !disabled
        hoverEnabled: parent.hoverEnabled
        onEntered: {
            parent.hovered();
            parent.state = "hovered"

      //    var obj = mapToItem(null, mouseX, mouseY);
            // print(obj.x, obj.y, obj.width, obj.height)
        }
        onExited: {
            parent.exited()
            parent.state = "normal"

            // showTimer.start()

        }

        onPressed:{
            parent.pressed()
            parent.state = "pressed"
        }

        onReleased:{
            parent.released()
            parent.state = "normal"
        }

        onClicked: {
            parent.clicked()
        }
    }

    Image {
        id: image
        anchors.centerIn: parent
        asynchronous: true
        source: normal_image
    }

    Component {
        id: tooltip
        DToolTip {
            tooltip: root.tooltip
        }
    }

    Loader {
        id: tooltipLoader
        // active: false
    }


    Timer {
        id: showTimer
        interval: 1000
        running: false
        onTriggered:{
            if (mouseArea.containsMouse){
                tooltipLoader.sourceComponent = tooltip;
                if (tooltipLoader.item ){
                    tooltipLoader.item.visible = true;
                    tooltipLoader.item.x = Qt.globalPos.x + 10;
                    tooltipLoader.item.y = Qt.globalPos.y + 10;
                    hideTimer.restart();
                }
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 2000
        running: false

        onTriggered:{
            tooltipLoader.sourceComponent = null;
            hideTimer.stop();
        }
    }

    states:[
        State{
            name: "normal"
            PropertyChanges {target: image; opacity: normal_opacity}
        },
        State{
            name: "hovered"
            PropertyChanges {target: image; opacity: hovered_opacity}
        },
        State{
            name: "pressed"
            PropertyChanges {target: image; opacity: pressed_opacity}
        },
        State{
            name: "disabled"
            PropertyChanges {target: image; opacity: disabled_opacity}
        }
    ]
}
