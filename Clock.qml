pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    property real time: 0
    readonly property real fps: Math.max(1, Config.fps)
    readonly property bool running: Config.loaded && Config.active !== null && !PauseController.paused

    Timer {
        interval: Math.round(1000 / root.fps)
        running: root.running
        repeat: true
        onTriggered: root.time += interval / 1000.0
    }
}
