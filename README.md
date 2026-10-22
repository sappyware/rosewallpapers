# rosewallpapers
A (cool) wallpaper engine..

![rosewallpapers screenshot](rosewallpapers.png)
## requirements

- **linux + wayland** — rosewallpapers is intended for wayland desktops.
- **[quickshell](https://github.com/quickshell-mirror/quickshell)** — required to run rosewallpapers.
- **a compatible wayland compositor** — required for wayland layer surfaces.
- **coreutils** — used by the installer for file operations.
- **qt6-shadertools (qsb)**

some components may require additional system utilities or services, depending on how they are implemented. make sure any tools used by your configuration are installed and available in your `PATH`.

## installation

clone the repository and run the installer:

```bash
git clone https://github.com/sappyware/rosewallpapers.git
cd rosewallpapers
chmod +x install.sh
./install.sh
```

the installer copies the QML files into `~/.config/quickshell/rosewallpapers/`.

## running

start rosewallpapers with:

```bash
qs -c rosewallpapers
```

## changing wallpapers
```bash
qs ipc -p ~/.config/rosewallpapers call rosewallpapers next
```
or 
```bash
qs ipc -p ~/.config/rosewallpapers call rosewallpapers set <name>
```

to stop it, use:

```bash
qs -c rosewallpapers kill
```

## configuration
```bash
fps = 30
render_scale = 0.5
pause_on_fullscreen = true
pause_on_idle = true
pause_on_battery = false
crossfade = true
crossfade_ms = 600

[[wallpapers]]
name = "topo"
type = "shader"
source = "shaders/topo.frag"

[[wallpapers]]
name = "plasma"
type = "shader"
source = "shaders/plasma.frag"

[[wallpapers]]
name = "aurora"
type = "shader"
source = "shaders/aurora.frag"

[[wallpapers]]
name = "gradient"
type = "shader"
source = "shaders/gradient.frag"

[[wallpapers]]
name = "ai1"
type = "shader"
source = "shaders/ai1.frag"

```

## help me fix any bugs with PRs!
