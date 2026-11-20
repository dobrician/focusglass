import QtQuick
import Quickshell
import Quickshell.Io

// focusglass lives in your Hyprland config (~/.config/hypr/focusglass.lua), which
// runs it only while the plugin is enabled in Omarchy. This service checks, when
// the plugin starts, that it is set up there (the first time it isn't, it opens a
// terminal that offers to do it), and reloads Hyprland's config when the plugin
// is enabled or disabled, so the change shows right away.
Item {
  id: root

  property var shell: null

  readonly property string setupScript: decodeURIComponent(Qt.resolvedUrl("focusglass-setup").toString().replace(/^file:\/\//, ""))

  // Disabled (or the shell stops): reload once shell.json no longer lists the plugin.
  Component.onDestruction: Quickshell.execDetached(["bash", "-c", "sleep 1; hyprctl reload >/dev/null"])

  Process {
    id: ensure
    command: ["bash", root.setupScript, "ensure"]
    running: true
  }
}
