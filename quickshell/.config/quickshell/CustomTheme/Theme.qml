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
	
		readonly property color inverse_primary: "#3c6090"
	
		readonly property color inverse_surface: "#e1e2e9"
	
		readonly property color on_background: "#e1e2e9"
	
		readonly property color on_error: "#690005"
	
		readonly property color on_error_container: "#ffdad6"
	
		readonly property color on_primary: "#00315e"
	
		readonly property color on_primary_container: "#d4e3ff"
	
		readonly property color on_primary_fixed: "#001c3a"
	
		readonly property color on_primary_fixed_variant: "#224876"
	
		readonly property color on_secondary: "#273141"
	
		readonly property color on_secondary_container: "#d8e3f8"
	
		readonly property color on_secondary_fixed: "#111c2b"
	
		readonly property color on_secondary_fixed_variant: "#3d4758"
	
		readonly property color on_surface: "#e1e2e9"
	
		readonly property color on_surface_variant: "#c3c6cf"
	
		readonly property color on_tertiary: "#3d2946"
	
		readonly property color on_tertiary_container: "#f7d8ff"
	
		readonly property color on_tertiary_fixed: "#271430"
	
		readonly property color on_tertiary_fixed_variant: "#553f5d"
	
		readonly property color outline: "#8d9199"
	
		readonly property color outline_variant: "#43474e"
	
		readonly property color primary: "#a5c8ff"
	
		readonly property color primary_container: "#224876"
	
		readonly property color primary_fixed: "#d4e3ff"
	
		readonly property color primary_fixed_dim: "#a5c8ff"
	
		readonly property color scrim: "#000000"
	
		readonly property color secondary: "#bcc7dc"
	
		readonly property color secondary_container: "#3d4758"
	
		readonly property color secondary_fixed: "#d8e3f8"
	
		readonly property color secondary_fixed_dim: "#bcc7dc"
	
		readonly property color shadow: "#000000"
	
		readonly property color source_color: "#3365a3"
	
		readonly property color surface: "#111318"
	
		readonly property color surface_bright: "#37393e"
	
		readonly property color surface_container: "#1d2024"
	
		readonly property color surface_container_high: "#282a2f"
	
		readonly property color surface_container_highest: "#32353a"
	
		readonly property color surface_container_low: "#191c20"
	
		readonly property color surface_container_lowest: "#0c0e13"
	
		readonly property color surface_dim: "#111318"
	
		readonly property color surface_tint: "#a5c8ff"
	
		readonly property color surface_variant: "#43474e"
	
		readonly property color tertiary: "#dabde2"
	
		readonly property color tertiary_container: "#553f5d"
	
		readonly property color tertiary_fixed: "#f7d8ff"
	
		readonly property color tertiary_fixed_dim: "#dabde2"
	
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
