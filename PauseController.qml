pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool manualPause: false
    property bool fullscreenActive: false
    property bool onBattery: false
    property bool hyprlandAvailable: false

    readonly property bool paused: manualPause
        || (Config.pauseOnFullscreen && fullscreenActive)
        || (Config.pauseOnBattery && onBattery)

    Process {
        command: ["sh", "-c", "command -v hyprctl"]
        running: true
        onExited: (code) => { root.hyprlandAvailable = (code === 0) }
    }

    Process {
        id: fullscreenPoll
        command: ["hyprctl", "-j", "clients"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const clients = JSON.parse(text)
                    root.fullscreenActive = clients.some(c => c.fullscreen > 0)
                } catch (e) {
                    root.fullscreenActive = false
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: Config.pauseOnFullscreen && root.hyprlandAvailable
        repeat: true
        onTriggered: if (!fullscreenPoll.running) fullscreenPoll.running = true
    }

    Process {
        id: batteryPoll
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n1"]
        stdout: StdioCollector {
            onStreamFinished: { root.onBattery = text.trim() === "Discharging" }
        }
    }

    Timer {
        interval: 5000
        running: Config.pauseOnBattery
        repeat: true
        onTriggered: if (!batteryPoll.running) batteryPoll.running = true
    }
}
