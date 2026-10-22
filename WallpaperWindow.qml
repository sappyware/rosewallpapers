import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: root

    required property var modelData
    screen: modelData

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "#000000"
    exclusiveZone: 0

    WlrLayershell.layer: WlrLayershell.Background
    WlrLayershell.namespace: "rosewallpapers"
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrLayershell.None

    function componentFor(wp) {
        if (!wp) return null
        if (wp.type === "shader") return shaderComp
        if (wp.type === "image") return imageComp
        return null
    }

    Item {
        anchors.fill: parent

        Loader {
            id: current
            anchors.fill: parent
            sourceComponent: root.componentFor(Config.active)
            onLoaded: {
                if (Config.crossfade) {
                    opacity = 0
                    fadeIn.restart()
                }
            }
        }

        NumberAnimation {
            id: fadeIn
            target: current
            property: "opacity"
            to: 1
            duration: Config.crossfadeMs
            easing.type: Easing.InOutQuad
        }
    }

    Component {
        id: shaderComp
        Item {
            id: shaderRoot
            anchors.fill: parent
            property var wp: Config.active

            Item {
                id: lowRes
                width: Math.max(1, Math.round(shaderRoot.width * Config.renderScale))
                height: Math.max(1, Math.round(shaderRoot.height * Config.renderScale))
                transform: Scale {
                    origin.x: 0
                    origin.y: 0
                    xScale: lowRes.width > 0 ? shaderRoot.width / lowRes.width : 1
                    yScale: lowRes.height > 0 ? shaderRoot.height / lowRes.height : 1
                }
                ShaderEffect {
                    anchors.fill: parent
                    blending: false
                    fragmentShader: shaderRoot.wp ? Config.shaderUrl(shaderRoot.wp) : ""
                    property real time: Clock.time
                }
            }
        }
    }

    Component {
        id: imageComp
        Item {
            id: imageRoot
            anchors.fill: parent
            property var wp: Config.active

            Image {
                anchors.fill: parent
                source: imageRoot.wp ? Config.assetUrl(imageRoot.wp) : ""
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: false
                smooth: true
                mipmap: true
            }
        }
    }
}
