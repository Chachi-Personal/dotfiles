pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Effects
import qs.CustomTheme

PanelWindow {
    id: root

    // --- WAYLAND CONFIGURATION ---
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: WlrLayershell.Ignore

    implicitWidth: 380
    color: "transparent"

    // --- POSITIONING ---
    anchors {
        left: true
        top: true
        bottom: true
    }

    margins {
        top: 87
        bottom: 20
    }

    // --- CLICK OUTSIDE TO CLOSE ---
    HyprlandFocusGrab {
        windows: [root]
        active: root.isOpen
        onCleared: {
            if (root.isOpen) {
                root.isOpen = false;
            }
        }
    }

    // --- ESCAPE KEY LISTENER ---
    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (root.isOpen) {
                root.isOpen = false;
            }
        }
    }

    // --- ANIMATION LOGIC ---
    property bool isOpen: false
    visible: isOpen || slideAnim.running

    margins {
        left: root.currentMargin
    }
    property real currentMargin: isOpen ? 20 : -450

    Behavior on currentMargin {
        NumberAnimation {
            id: slideAnim
            duration: 250
            easing.type: Easing.OutQuint
        }
    }

    // --- IPC HANDLER ---
    IpcHandler {
        target: "wallpaper"
        function toggle(): void {
            root.isOpen = !root.isOpen;
        }
        function open(): void {
            root.isOpen = true;
        }
        function close(): void {
            root.isOpen = false;
        }
        function isOpen(): bool {
            return root.isOpen;
        }
        function rescan(): void {
            root.rescanWallpapers();
        }
    }

    property string defaultWallpaperFolder: Quickshell.env("HOME") + "/.config/ml4w/wallpapers"
    property string wallpaperSettingFile: Quickshell.env("HOME") + "/.config/ml4w/settings/wallpaper-folder"

    // Start as default in case file does not exist
    property string wallpaperFolder: defaultWallpaperFolder

    FileView {
        id: wallpaperDirSettingFileHandler
        path: Qt.url(root.wallpaperSettingFile)
        blockLoading: true
        watchChanges: true
        onFileChanged: {
            this.reload();
            const settingValue = this.text().trim();
            console.log("Wallpaper directory setting changed on disk; attempting to load directory \"" + settingValue + "\"");
            updateWallpaperFolder(settingValue);
        }
        onLoaded: {
            const settingValue = this.text().trim();
            console.log("Loading wallpaper directory \"" + settingValue + "\"");
            updateWallpaperFolder(settingValue);
        }
        onSaved: {
            const settingValue = this.text().trim();
            console.log("Wallpaper directory setting saved successfully; reloading from directory \"" + settingValue + "\"");
            updateWallpaperFolder(this.text().trim());
        }
    }

    property string defaultTransitionEffect: "simple"
    property string transitionEffectSettingFile: Quickshell.env("HOME") + "/.config/ml4w/settings/wallpaper-transition-effect"
    property var transitionEffects: ["simple", "fade", "left", "right", "top", "bottom", "wipe", "wave", "grow", "center", "outer", "any", "random", "none"]
    property string transitionEffect: defaultTransitionEffect

    FileView {
        id: transitionEffectSettingFileHandler
        path: Qt.url(root.transitionEffectSettingFile)
        blockLoading: true
        watchChanges: true
        onFileChanged: {
            this.reload();
            const settingValue = this.text().trim();
            console.log("Transition effect setting changed on disk; attempting to update to \"" + settingValue + "\"");
            updateTransitionEffect(settingValue);
        }
        onLoaded: {
            const settingValue = this.text().trim();
            console.log("Loading transition effect \"" + settingValue + "\"");
            updateTransitionEffect(settingValue);
        }
        onSaved: {
            const settingValue = this.text().trim();
            console.log("Transition effect setting saved successfully; updating to \"" + settingValue + "\"");
            updateTransitionEffect(this.text().trim());
        }
    }

    // --- FAVORITES ---
    // One absolute image path per line. Plain text rather than JSON so
    // ml4w-wallpaper --favorites can shuf the file directly, without jq.
    // Only this app writes it, so it is not watched: watchChanges would
    // re-fire on our own setText().
    property string favoritesFile: Quickshell.env("HOME") + "/.config/ml4w/settings/wallpaper-favorites"

    // Path -> true. Reassigned wholesale on every change; QML does not deep
    // watch var objects and the grid delegates bind to the change signal.
    property var favoriteSet: ({})

    function isFavorite(path): bool {
        return root.favoriteSet[path] === true;
    }

    function toggleFavorite(path): void {
        let next = {};
        for (let key in root.favoriteSet)
            next[key] = true;
        if (next[path] === true)
            delete next[path];
        else
            next[path] = true;
        root.favoriteSet = next;
        favoritesFileHandler.setText(Object.keys(next).join("\n") + "\n");
        root.filterWallpapers();
    }

    FileView {
        id: favoritesFileHandler
        path: Qt.url(root.favoritesFile)
        blockLoading: true
        printErrors: false
        onLoaded: {
            let set = {};
            for (let line of this.text().split("\n")) {
                const path = line.trim();
                if (path !== "")
                    set[path] = true;
            }
            root.favoriteSet = set;
        }
    }

    // --- FILTER STATE (persisted across restarts) ---
    property string filtersFile: Quickshell.env("HOME") + "/.config/ml4w/settings/wallpaper-filters.json"

    property bool favoritesOnly: false
    // "" means "All Folders". Otherwise a directory path relative to
    // wallpaperFolder, or rootFolderLabel for images sitting at its top level.
    property string folderFilter: ""

    readonly property string allFoldersLabel: "All Folders"
    readonly property string rootFolderLabel: "(root)"

    FileView {
        id: filtersFileHandler
        path: Qt.url(root.filtersFile)
        blockLoading: true
        printErrors: false
        onLoaded: {
            try {
                const parsed = JSON.parse(this.text());
                if (parsed.favoritesOnly !== undefined)
                    root.favoritesOnly = parsed.favoritesOnly === true;
                if (parsed.folder !== undefined)
                    root.folderFilter = String(parsed.folder);
            } catch (e) {
                console.warn("wallpaper-filters.json: could not parse, using defaults", e);
            }
        }
    }

    function saveFilters(): void {
        filtersFileHandler.setText(JSON.stringify({
            favoritesOnly: root.favoritesOnly,
            folder: root.folderFilter
        }));
    }

    // The automation-favorites setting is a 0-byte marker file (the ml4w idiom
    // for booleans), so it is probed rather than read through a FileView.
    Process {
        id: automationFavoritesProbe
        command: ["bash", "-c", "test -f \"$HOME/.config/ml4w/settings/wallpaper-automation-favorites\" && echo 1 || echo 0"]
        stdout: StdioCollector {
            onStreamFinished: {
                automationFavoritesOnly.checked = this.text.trim() === "1";
            }
        }
    }

    Component.onCompleted: automationFavoritesProbe.running = true
    // Nothing watches the wallpaper folder, so opening the panel is when we
    // pick up files added or removed since the last scan. The scan short
    // circuits when the tree is unchanged, so this is free in the common case.
    onIsOpenChanged: {
        if (root.isOpen) {
            automationFavoritesProbe.running = true;
            rescanWallpapers();
        }
    }

    function advancedSettingsLabel(): string {
        const actionText = advancedOptions.visible ? "Hide" : "Show";
        return actionText + " Advanced Options";
    }

    function updateWallpaperFolder(dirString): void {
        root.wallpaperFolder = dirString.replace(/~|\$HOME/g, Quickshell.env("HOME"));
        rescanWallpapers();
    }

    function updateTransitionEffect(effectString): void {
        const cleaned = effectString.trim();
        if (root.transitionEffects.indexOf(cleaned) !== -1) {
            root.transitionEffect = cleaned;
        } else {
            root.transitionEffect = "simple";
        }
    }

    // --- WALLPAPER SCANNING (recursive: wallpaperFolder may contain nested category subfolders) ---
    ListModel {
        id: wallpaperModel
    }
    ListModel {
        id: displayModel
    }
    Connections {
        target: searchInput
        function onTextChanged() {
            filterWallpapers();
        }
    }

    // "All Folders" plus every subfolder that actually holds an image, so an
    // empty category directory never shows up as a dead entry.
    property var folderList: [allFoldersLabel]

    // Raw output of the last scan that actually rebuilt the model. A rescan
    // whose result matches it is dropped, so opening the panel does not reset
    // the grid scroll position when nothing changed on disk. Set hasScanned
    // back to false to force the next scan through.
    property string lastScanSignature: ""
    property bool hasScanned: false

    function filterWallpapers() {
        displayModel.clear();
        let query = searchInput.text.trim().toLowerCase();
        for (let i = 0; i < wallpaperModel.count; i++) {
            let item = wallpaperModel.get(i);
            if (query !== "" && !item.fileName.toLowerCase().includes(query))
                continue;
            if (root.favoritesOnly && !root.isFavorite(item.filePath))
                continue;
            if (root.folderFilter !== "" && item.folder !== root.folderFilter)
                continue;
            displayModel.append(item);
        }
    }

    // Directory of an image relative to wallpaperFolder. Uses the whole
    // relative path rather than just the first segment so deeper nesting keeps
    // working; top-level images get rootFolderLabel.
    function folderOf(path): string {
        const base = root.wallpaperFolder.replace(/\/+$/, "") + "/";
        if (!path.startsWith(base))
            return root.rootFolderLabel;
        const rest = path.substring(base.length);
        const cut = rest.lastIndexOf("/");
        return cut === -1 ? root.rootFolderLabel : rest.substring(0, cut);
    }

    function rescanWallpapers() {
        wallpaperScanner.running = false;
        wallpaperScanner.command = ["find", root.wallpaperFolder, "-type", "f", "(", "-iname", "*.jpg", "-o", "-iname", "*.jpeg", "-o", "-iname", "*.webp", "-o", "-iname", "*.png", ")"];
        wallpaperScanner.running = true;
    }

    Process {
        id: wallpaperScanner
        stdout: StdioCollector {
            onStreamFinished: {
                const raw = this.text.trim();
                if (root.hasScanned && raw === root.lastScanSignature)
                    return;
                root.hasScanned = true;
                root.lastScanSignature = raw;

                wallpaperModel.clear();
                let folders = {};
                let lines = raw.split("\n");
                for (let line of lines) {
                    let path = line.trim();
                    if (path !== "") {
                        let fileName = path.split("/").pop();
                        let folder = root.folderOf(path);
                        folders[folder] = true;
                        wallpaperModel.append({
                            filePath: path,
                            fileName: fileName,
                            folder: folder
                        });
                    }
                }

                // Rebuild the dropdown model, then re-apply the persisted
                // selection: replacing the model resets currentIndex, and the
                // saved folder may no longer exist after a rescan.
                let names = Object.keys(folders).filter(f => f !== root.rootFolderLabel).sort();
                if (folders[root.rootFolderLabel] === true)
                    names.unshift(root.rootFolderLabel);
                root.folderList = [root.allFoldersLabel].concat(names);
                if (root.folderFilter !== "" && names.indexOf(root.folderFilter) === -1) {
                    root.folderFilter = "";
                    root.saveFilters();
                }
                folderSelector.currentIndex = root.folderFilter === "" ? 0 : root.folderList.indexOf(root.folderFilter);

                root.filterWallpapers();
            }
        }
    }

    // --- REUSABLE COMPONENTS ---
    component ML4WMenuItem: MenuItem {
        id: control
        contentItem: Text {
            text: control.text
            font.family: Theme.fontFamily
            font.pixelSize: 14
            color: control.highlighted ? Theme.background : Theme.primary
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 36
            color: control.highlighted ? Theme.primary : "transparent"
            radius: 4
        }
    }

    component SettingsWheel: Button {
        implicitWidth: 28
        implicitHeight: 28
        text: "󰒓"
        font.family: "monospace"
        background: Rectangle {
            color: "transparent"
        }
        contentItem: Text {
            text: parent.text
            color: Theme.primary
            font.pixelSize: 18
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // Filled star when the favorites-only filter is on, dimmed outline when off.
    component StarToggle: Button {
        id: starToggle
        required property bool active
        implicitWidth: 28
        implicitHeight: 28
        background: Rectangle {
            color: "transparent"
        }
        contentItem: Text {
            text: starToggle.active ? "★" : "☆"
            color: Theme.primary
            opacity: starToggle.active ? 1.0 : 0.45
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }
        }
    }

    component ML4WComboBox: ComboBox {
        id: ml4wComboBox
        delegate: ItemDelegate {
            id: itemDelegate
            required property var modelData
            required property int index
            width: ml4wComboBox.width
            contentItem: Text {
                text: ml4wComboBox.textRole ? (modelData[ml4wComboBox.textRole] ?? "") : modelData
                color: itemDelegate.highlighted ? Theme.background : Theme.primary
                font.family: Theme.fontFamily
                font.pixelSize: 14
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            background: Rectangle {
                color: itemDelegate.highlighted ? Theme.primary : "transparent"
                radius: 4
            }
            highlighted: ml4wComboBox.highlightedIndex === index
        }
        contentItem: Text {
            leftPadding: 12
            rightPadding: ml4wComboBox.indicator.width + 12
            text: ml4wComboBox.displayText
            font.family: Theme.fontFamily
            font.pixelSize: 14
            color: Theme.primary
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }
        indicator: Canvas {
            id: canvas
            x: ml4wComboBox.width - width - 12
            y: (ml4wComboBox.height - height) / 2
            width: 12
            height: 8
            contextType: "2d"

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.moveTo(0, 0);
                ctx.lineTo(width, 0);
                ctx.lineTo(width / 2, height);
                ctx.closePath();
                ctx.fillStyle = Theme.primary;
                ctx.fill();
            }

            Connections {
                target: Theme
                function onPrimaryChanged() {
                    canvas.requestPaint();
                }
            }
        }
        background: Rectangle {
            implicitHeight: 36
            color: Theme.background
            border.color: Theme.primary
            border.width: 1
            radius: 10
        }
        popup: Popup {
            y: ml4wComboBox.height + 2
            width: ml4wComboBox.width
            implicitHeight: contentItem.contentHeight > 250 ? 250 : contentItem.contentHeight
            padding: 4

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: ml4wComboBox.popup.visible ? ml4wComboBox.delegateModel : null
                currentIndex: ml4wComboBox.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator {}
            }
            background: Rectangle {
                color: Theme.background
                border.color: Theme.primary
                border.width: 1
                radius: 8
            }
        }
    }

    component ML4WCheckBox: CheckBox {
        id: ml4wCheckBox
        spacing: 10
        indicator: Rectangle {
            implicitWidth: 18
            implicitHeight: 18
            x: ml4wCheckBox.leftPadding
            y: (ml4wCheckBox.height - height) / 2
            radius: 4
            border.color: Theme.primary
            border.width: 1
            color: "transparent"
            Rectangle {
                width: 8
                height: 8
                anchors.centerIn: parent
                color: Theme.primary
                visible: ml4wCheckBox.checked
            }
        }
        contentItem: Text {
            text: ml4wCheckBox.text
            font.family: Theme.fontFamily
            color: Theme.primary
            font.pixelSize: 14
            verticalAlignment: Text.AlignVCenter
            leftPadding: ml4wCheckBox.indicator.width + ml4wCheckBox.spacing
        }
    }

    // ==========================================
    // MAIN PANEL BACKGROUND & UI
    // ==========================================
    Item {
        anchors.fill: parent
        anchors.margins: 20

        RectangularShadow {
            id: shadow
            anchors.fill: mainBgRect
            radius: mainBgRect.radius
            blur: 15
            color: Qt.rgba(Theme.shadow.r, Theme.shadow.g, Theme.shadow.b, 0.4)
        }

        Rectangle {
            id: mainBgRect
            anchors.fill: parent
            radius: 10
            opacity: 0.95
            clip: true

            // Gradient border (outer)
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop {
                    position: 0.0
                    color: Theme.primary
                }
                GradientStop {
                    position: 1.0
                    color: Theme.on_primary
                }
            }

            // Background fill (inner), inset by the border thickness
            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                radius: parent.radius - anchors.margins
                color: Theme.background
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15

                // --- HEADER CONTROLS (Search & Settings) ---
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 5
                    spacing: 10

                    // Search Input
                    TextField {
                        id: searchInput
                        placeholderText: "Search image"
                        color: Theme.primary
                        font.pixelSize: 14
                        padding: 8
                        Layout.fillWidth: true
                        horizontalAlignment: TextInput.AlignHCenter

                        background: Rectangle {
                            anchors.fill: parent
                            color: Theme.background
                            radius: 10
                            border.color: Theme.primary
                            border.width: 1
                        }
                    }

                    // Favorites-only filter
                    StarToggle {
                        active: root.favoritesOnly
                        onClicked: {
                            root.favoritesOnly = !root.favoritesOnly;
                            root.saveFilters();
                            root.filterWallpapers();
                        }

                        Accessible.name: "Favorites only"
                        Accessible.description: qsTr("Show only wallpapers marked as favorite")
                        Accessible.role: Accessible.CheckBox
                    }

                    // Settings Wheel & Menu
                    SettingsWheel {
                        onClicked: wallpaperMenu.open()

                        Menu {
                            id: wallpaperMenu
                            y: parent.height

                            implicitWidth: 220
                            padding: 8

                            background: Rectangle {
                                color: Theme.background
                                border.color: Theme.primary
                                border.width: 1
                                radius: 8
                            }

                            ML4WMenuItem {
                                text: "Random Wallpaper"
                                onClicked: {
                                    root.isOpen = false;
                                    const script = Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-wallpaper";
                                    // Draw from what is actually on screen, so the
                                    // active filters apply. Fall back to the script's
                                    // own folder-wide pick when nothing is shown.
                                    if (displayModel.count > 0) {
                                        const pick = displayModel.get(Math.floor(Math.random() * displayModel.count));
                                        Quickshell.execDetached(["bash", "-c", script + " '" + pick.filePath + "'"]);
                                    } else {
                                        Quickshell.execDetached(["bash", "-c", script + " --random"]);
                                    }
                                }
                            }

                            ML4WMenuItem {
                                text: "Wallpaper Effects"
                                onClicked: {
                                    root.isOpen = false;
                                    Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-wallpaper-effects"]);
                                }
                            }

                            ML4WMenuItem {
                                text: "Clear Wallpaper Cache"
                                onClicked: {
                                    root.isOpen = false;
                                    Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-clear-wallpaper-cache"]);
                                }
                            }

                            ML4WMenuItem {
                                text: "Reload Images"
                                onClicked: {
                                    // Manual escape hatch: rebuild even if the
                                    // scan comes back byte-identical.
                                    root.hasScanned = false;
                                    rescanWallpapers();
                                }
                            }

                            ML4WMenuItem {
                                text: advancedSettingsLabel()
                                onClicked: {
                                    advancedOptions.visible = !advancedOptions.visible;
                                    if (!advancedOptions.visible) {
                                        outputMonitorSelector.currentIndex = 0;
                                        wallpaperPositioningSelector.currentIndex = 0;
                                        shouldUpdateTheming.checked = true;
                                    }
                                }
                            }
                        }
                    }
                }

                // --- SUBFOLDER FILTER ---
                // Hidden when the wallpaper folder is flat, so there is no
                // dead control with nothing to pick.
                ML4WComboBox {
                    id: folderSelector
                    model: root.folderList
                    Layout.fillWidth: true
                    visible: root.folderList.length > 1

                    Accessible.name: "Wallpaper Folder Filter"
                    Accessible.description: qsTr("Show only wallpapers from one subfolder")
                    Accessible.role: Accessible.ComboBox

                    onActivated: {
                        root.folderFilter = index === 0 ? "" : root.folderList[index];
                        root.saveFilters();
                        root.filterWallpapers();
                    }
                }

                // --- ADVANCED OPTIONS ---
                ColumnLayout {
                    id: advancedOptions
                    Layout.fillWidth: true
                    Layout.topMargin: 5
                    spacing: 10
                    visible: false

                    // --- WALLPAPER DIRECTORY SETTING ---
                    ColumnLayout {
                        Layout.fillWidth: true
                        Label {
                            id: wallpaperDirInputLabel
                            color: Theme.primary
                            font.family: Theme.fontFamily

                            text: "Wallpaper Folder"

                            Accessible.name: text
                            Accessible.role: Accessible.StaticText
                        }

                        TextField {
                            id: wallpaperDirInput
                            color: Theme.primary
                            font.pixelSize: 14
                            padding: 8
                            Layout.fillWidth: true
                            horizontalAlignment: TextInput.AlignHCenter

                            Accessible.name: wallpaperDirInputLabel.text
                            Accessible.description: qsTr("Enter the full path to your wallpaper folder")
                            Accessible.role: Accessible.EditableText

                            placeholderText: "Specify wallpaper directory"
                            text: wallpaperDirSettingFileHandler.text().trim()

                            onAccepted: {
                                console.log("Updating wallpaper directory to \"" + this.text + "\"");
                                wallpaperDirSettingFileHandler.setText(this.text);
                            }

                            background: Rectangle {
                                anchors.fill: parent
                                color: Theme.background
                                radius: 10
                                border.color: Theme.primary
                                border.width: 1
                            }
                        }
                    }

                    // --- WALLPAPER TRANSITION EFFECT SETTING ---
                    ColumnLayout {
                        Layout.fillWidth: true
                        Label {
                            id: transitionEffectInputLabel
                            color: Theme.primary
                            font.family: Theme.fontFamily
                            text: "Transition Effect"
                            Accessible.name: text
                            Accessible.role: Accessible.StaticText
                        }

                        ML4WComboBox {
                            id: transitionEffectComboBox
                            model: root.transitionEffects
                            currentIndex: root.transitionEffects.indexOf(root.transitionEffect)
                            Layout.fillWidth: true
                            onActivated: {
                                const selectedEffect = root.transitionEffects[index];
                                console.log("Updating wallpaper transition effect to \"" + selectedEffect + "\"");
                                transitionEffectSettingFileHandler.setText(selectedEffect);
                            }
                        }
                    }

                    // --- OUTPUT SETTINGS ---
                    RowLayout {
                        ColumnLayout {
                            Label {
                                id: outputSettingsLabel
                                color: Theme.primary
                                font.family: Theme.fontFamily

                                text: "Output Monitor"

                                Accessible.name: text
                                Accessible.role: Accessible.StaticText
                            }

                            ML4WComboBox {
                                id: outputMonitorSelector
                                model: monitorModel
                                textRole: "name"
                                Layout.fillWidth: true

                                property var monitorModel: {
                                    let list = [
                                        {
                                            "name": "All",
                                            "isSingleOutput": false
                                        }
                                    ];
                                    for (let i = 0; i < Hyprland.monitors.values.length; i++) {
                                        list.push({
                                            "name": Hyprland.monitors.values[i].name,
                                            "isSingleOutput": true
                                        });
                                    }
                                    return list;
                                }

                                Accessible.name: wallpaperDirInputLabel.text
                                Accessible.description: qsTr("Select which output to change the wallpaper (or change for all outputs)")
                                Accessible.role: Accessible.ComboBox
                            }
                        }

                        ColumnLayout {
                            Label {
                                id: wallpaperPositioningLabel
                                color: Theme.primary
                                font.family: Theme.fontFamily

                                text: "Wallpaper Positioning"

                                Accessible.name: text
                                Accessible.role: Accessible.StaticText
                            }

                            ML4WComboBox {
                                id: wallpaperPositioningSelector
                                model: ["center", "top-left", "top", "top-right", "left", "right", "bottom-left", "bottom", "bottom-right"]
                                Layout.fillWidth: true
                                Accessible.name: wallpaperPositioningLabel.text
                                Accessible.description: qsTr("How to align wallpaper when setting (default is centered)")
                                Accessible.role: Accessible.ComboBox
                            }
                        }
                    }

                    ML4WCheckBox {
                        id: shouldUpdateTheming
                        checked: true
                        text: "Update theming from wallpaper"

                        Accessible.name: text
                        Accessible.description: qsTr("Choose whether to update theming based on the new wallpaper selector")
                        Accessible.role: Accessible.CheckBox
                    }

                    // Marker-file setting (existence = on) read by
                    // ml4w-wallpaper-automation. Unlike the controls above this
                    // mirrors on-disk state, so it is not reset when the
                    // advanced section is hidden.
                    ML4WCheckBox {
                        id: automationFavoritesOnly
                        checked: false
                        text: "Rotate only through favorites"

                        Accessible.name: text
                        Accessible.description: qsTr("Restrict the background wallpaper rotation to favorites")
                        Accessible.role: Accessible.CheckBox

                        onToggled: {
                            const marker = Quickshell.env("HOME") + "/.config/ml4w/settings/wallpaper-automation-favorites";
                            const cmd = checked ? "touch '" + marker + "'" : "rm -f '" + marker + "'";
                            Quickshell.execDetached(["bash", "-c", cmd]);
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: Theme.primary
                    opacity: 0.3
                }

                // --- EMPTY STATE: invalid/empty directory, or filters matching nothing ---
                Text {
                    id: emptyWallpaperDirectoryMsg
                    visible: displayModel.count === 0

                    Layout.fillWidth: true
                    color: Theme.primary
                    font.family: Theme.fontFamily
                    wrapMode: Text.WordWrap
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter

                    text: wallpaperModel.count === 0 ? "Wallpaper folder is either empty or invalid." : "No wallpapers match the current filters."
                }

                // --- IMAGE GRID ---
                GridView {
                    id: grid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    // --- SCROLLING PERFORMANCE FIX ---
                    cacheBuffer: 3000
                    reuseItems: true

                    cellWidth: width / 2
                    cellHeight: cellWidth * 0.80

                    ScrollBar.vertical: ScrollBar {
                        interactive: true
                    }

                    model: displayModel

                    delegate: Item {
                        id: tile
                        width: grid.cellWidth
                        height: grid.cellHeight
                        required property string filePath
                        required property string fileName

                        // Read favoriteSet directly so the binding captures it:
                        // the set is reassigned wholesale on every toggle.
                        readonly property bool isFav: root.favoriteSet[filePath] === true

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 8
                            color: Theme.secondary

                            border.color: mouseArea.containsMouse ? Theme.primary : "transparent"
                            border.width: 2
                            radius: 10
                            clip: true

                            Rectangle {
                                id: contentMask
                                anchors.fill: parent
                                anchors.margins: 2
                                radius: 8
                                visible: false
                            }

                            Item {
                                anchors.fill: parent
                                anchors.margins: 2

                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: contentMask
                                }

                                BusyIndicator {
                                    anchors.centerIn: parent
                                    width: 30
                                    height: 30
                                    running: thumbnail.status === Image.Loading
                                    opacity: running ? 0.5 : 0.0
                                }

                                Image {
                                    id: thumbnail
                                    anchors.fill: parent
                                    source: "file://" + filePath
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    sourceSize.width: 250
                                    sourceSize.height: 250

                                    opacity: status === Image.Ready ? 1.0 : 0.0
                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: 350
                                            easing.type: Easing.OutCubic
                                        }
                                    }

                                    onStatusChanged: {
                                        if (status === Image.Error) {
                                            console.log("Failed to load image at: " + source);
                                        }
                                    }
                                }

                                // The text label gets beautifully clipped by the rounded mask at the bottom corners too!
                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 22
                                    color: "#aa000000"

                                    Text {
                                        anchors.centerIn: parent
                                        text: fileName
                                        color: "white"
                                        font.pixelSize: 11
                                        elide: Text.ElideRight
                                        width: parent.width - 8
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    let scriptPath = Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-wallpaper";
                                    let options = "";
                                    if (advancedOptions.visible) {
                                        const outputSelection = outputMonitorSelector.monitorModel[outputMonitorSelector.currentIndex];
                                        const outputParams = outputSelection.isSingleOutput ? " --monitor " + outputSelection.name : "";
                                        const positioningParams = " --crop-gravity " + wallpaperPositioningSelector.currentText;
                                        const themingParams = shouldUpdateTheming.checked ? "" : " --skip-theming";
                                        options = `${outputParams}${positioningParams}${themingParams}`;
                                    }
                                    Quickshell.execDetached(["bash", "-c", scriptPath + " '" + filePath + "'" + options]);
                                }
                            }

                            // Favorite star. Declared after mouseArea so it sits
                            // on top and swallows the click; hoverEnabled stays
                            // off so hover still reaches the tile underneath and
                            // the border/star don't flicker when pointing at it.
                            Rectangle {
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.margins: 6
                                width: 24
                                height: 24
                                radius: 12
                                color: "#66000000"

                                visible: tile.isFav || mouseArea.containsMouse
                                opacity: visible ? 1.0 : 0.0
                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 150
                                    }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: tile.isFav ? "★" : "☆"
                                    color: "white"
                                    font.pixelSize: 15
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.toggleFavorite(tile.filePath)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
