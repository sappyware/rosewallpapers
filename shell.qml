import Quickshell
import Quickshell.Io

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens
        delegate: WallpaperWindow {}
    }

    IpcHandler {
        target: "rosewallpapers"

        function next(): void { Config.next() }
        function prev(): void { Config.prev() }
        function set(name: string): void { Config.setWallpaper(name) }
        function pause(): void { PauseController.manualPause = true }
        function resume(): void { PauseController.manualPause = false }
        function toggle(): void { PauseController.manualPause = !PauseController.manualPause }
        function reload(): void { Config.reload() }
        function info(): string {
            const a = Config.active
            return a ? `${a.name} (${a.type}) paused=${PauseController.paused}` : "no wallpaper"
        }
    }
}
