pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    readonly property string fontFamily: "Fira Sans Semibold"
	
		readonly property color background: "#111318"
	
		readonly property color error: "#ffb4ab"
	
		readonly property color error_container: "#93000a"
	
		readonly property color inverse_on_surface: "#2e3035"
	
		readonly property color inverse_primary: "#3e5f90"
	
		readonly property color inverse_surface: "#e1e2e9"
	
		readonly property color on_background: "#e1e2e9"
	
		readonly property color on_error: "#690005"
	
		readonly property color on_error_container: "#ffdad6"
	
		readonly property color on_primary: "#04305f"
	
		readonly property color on_primary_container: "#d5e3ff"
	
		readonly property color on_primary_fixed: "#001b3b"
	
		readonly property color on_primary_fixed_variant: "#244777"
	
		readonly property color on_secondary: "#273141"
	
		readonly property color on_secondary_container: "#d9e3f8"
	
		readonly property color on_secondary_fixed: "#121c2b"
	
		readonly property color on_secondary_fixed_variant: "#3d4758"
	
		readonly property color on_surface: "#e1e2e9"
	
		readonly property color on_surface_variant: "#c4c6cf"
	
		readonly property color on_tertiary: "#3e2845"
	
		readonly property color on_tertiary_container: "#f8d8fe"
	
		readonly property color on_tertiary_fixed: "#27132f"
	
		readonly property color on_tertiary_fixed_variant: "#553e5d"
	
		readonly property color outline: "#8e9199"
	
		readonly property color outline_variant: "#43474e"
	
		readonly property color primary: "#a7c8ff"
	
		readonly property color primary_container: "#244777"
	
		readonly property color primary_fixed: "#d5e3ff"
	
		readonly property color primary_fixed_dim: "#a7c8ff"
	
		readonly property color scrim: "#000000"
	
		readonly property color secondary: "#bdc7dc"
	
		readonly property color secondary_container: "#3d4758"
	
		readonly property color secondary_fixed: "#d9e3f8"
	
		readonly property color secondary_fixed_dim: "#bdc7dc"
	
		readonly property color shadow: "#000000"
	
		readonly property color source_color: "#4d5769"
	
		readonly property color surface: "#111318"
	
		readonly property color surface_bright: "#37393e"
	
		readonly property color surface_container: "#1d2024"
	
		readonly property color surface_container_high: "#282a2f"
	
		readonly property color surface_container_highest: "#33353a"
	
		readonly property color surface_container_low: "#191c20"
	
		readonly property color surface_container_lowest: "#0c0e13"
	
		readonly property color surface_dim: "#111318"
	
		readonly property color surface_tint: "#a7c8ff"
	
		readonly property color surface_variant: "#43474e"
	
		readonly property color tertiary: "#dbbde2"
	
		readonly property color tertiary_container: "#553e5d"
	
		readonly property color tertiary_fixed: "#f8d8fe"
	
		readonly property color tertiary_fixed_dim: "#dbbde2"
	
	property var themeReader: Process {
		id: reader
		command: ["cat", Quickshell.env("HOME") + "/.config/ml4w/colors/colors.json"]

		// REQUIRED: Quickshell needs this to parse the binary stream into text
		stdout: StdioCollector {
			onStreamFinished: {
				// "this.text" contains the full output of the cat command
				var output = this.text.trim();

				if (output !== "") {
					try {
						var newColors = JSON.parse(output);
						for (var key in newColors) {
							if (root.hasOwnProperty(key) && key !== "objectName") {
								root[key] = newColors[key];
							}
						}
						console.log("Theme colors loaded successfully!");
					} catch (e) {
						console.log("Failed to parse theme JSON: " + e);
					}
				}
			}
		}
	}

    function reloadTheme() {
        // Toggle false then true to guarantee Quickshell restarts the cat process
        reader.running = false;
        reader.running = true;
    }

    // Load the JSON colors automatically when Quickshell starts
    // Component.onCompleted: reloadTheme()

}
