import QtQuick
import Quickshell.Io

// focusglass lives in your Hyprland config (~/.config/hypr/focusglass.lua). This
// service only checks, at every shell start, that it is set up there, and the
// first time it isn't, opens a terminal that offers to do it.
Item {
  id: root

  property var shell: null

  readonly property string setupScript: decodeURIComponent(Qt.resolvedUrl("focusglass-setup").toString().replace(/^file:\/\//, ""))

  Process {
    id: ensure
    command: ["bash", root.setupScript, "ensure"]
    running: true
  }
}
