pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string configDir: Quickshell.env("HOME") + "/.config/rosewallpapers"
    readonly property string configPath: configDir + "/config.toml"

    property var data: ({})
    property int currentIndex: 0
    property bool loaded: false

    readonly property var wallpapers: data.wallpapers ?? []
    readonly property var active: (wallpapers.length > 0 && currentIndex >= 0 && currentIndex < wallpapers.length)
        ? wallpapers[currentIndex] : null

    readonly property int fps: data.fps ?? 30
    readonly property real renderScale: data.render_scale ?? 0.5
    readonly property bool pauseOnFullscreen: data.pause_on_fullscreen ?? true
    readonly property bool pauseOnIdle: data.pause_on_idle ?? true
    readonly property bool pauseOnBattery: data.pause_on_battery ?? false
    readonly property bool crossfade: data.crossfade ?? true
    readonly property int crossfadeMs: data.crossfade_ms ?? 600

    function setWallpaper(name) {
        const i = wallpapers.findIndex(w => w.name === name)
        if (i >= 0) currentIndex = i
    }
    function next() {
        if (wallpapers.length > 0) currentIndex = (currentIndex + 1) % wallpapers.length
    }
    function prev() {
        if (wallpapers.length > 0) currentIndex = (currentIndex - 1 + wallpapers.length) % wallpapers.length
    }

    function shaderUrl(wp) {
        if (!wp) return ""
        return Qt.resolvedUrl(root.configDir + "/" + wp.source + ".qsb")
    }
    function assetUrl(wp) {
        if (!wp) return ""
        const s = wp.source ?? ""
        if (s.startsWith("file://") || s.startsWith("http")) return s
        if (s.startsWith("/")) return "file://" + s
        return "file://" + root.configDir + "/" + s
    }

    Process {
        id: loader
        command: ["python3", "-c", "import tomllib,json,sys;print(json.dumps(tomllib.load(open(sys.argv[1],'rb'))))", root.configPath]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.data = JSON.parse(text)
                    root.loaded = true
                    if (root.wallpapers.length > 0 && root.currentIndex >= root.wallpapers.length)
                        root.currentIndex = 0
                } catch (e) {
                    console.error("[rosewallpapers] config parse failed:", e)
                }
            }
        }
        onExited: (code) => {
            if (code !== 0) console.error("[rosewallpapers] toml parser exited with", code)
        }
    }

    function reload() {
        if (loader.running) return
        loader.running = true
    }

    Component.onCompleted: reload()
}
