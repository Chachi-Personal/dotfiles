pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    readonly property string fontFamily: "Fira Sans Semibold"
	<* for name, value in colors *>
		readonly property color {{name}}: "{{value.default.hex}}"
	<* endfor *>
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
