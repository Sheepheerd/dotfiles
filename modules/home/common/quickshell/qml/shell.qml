import Quickshell
import Quickshell.Io
import qs

ShellRoot {
    id: shell

    // waybar hid itself on SIGUSR1; this is the equivalent, driven by
    // `qs ipc call bar toggle`.
    property bool barVisible: true

    IpcHandler {
        target: "bar"

        function toggle(): void {
            shell.barVisible = !shell.barVisible;
        }

        function show(): void {
            shell.barVisible = true;
        }

        function hide(): void {
            shell.barVisible = false;
        }
    }

    Variants {
        // One bar per monitor, matching waybar's `all-outputs`.
        model: Quickshell.screens

        Bar {
            visible: shell.barVisible
        }
    }
}
