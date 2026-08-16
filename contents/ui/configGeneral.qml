import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

Kirigami.ScrollablePage {

    property bool cfg_showNotifications:        true
    property bool cfg_showNotificationsDefault: true
    property bool cfg_showErrorDetails:         true
    property bool cfg_showErrorDetailsDefault:  true
    property int  cfg_conflictStrategy:         1
    property int  cfg_conflictStrategyDefault:  1

    ColumnLayout {
        spacing: Kirigami.Units.largeSpacing

        Kirigami.FormLayout {

            QQC2.CheckBox {
                Kirigami.FormData.label: i18n("Notifications:")
                text: i18n("Show notification after each operation")
                checked: cfg_showNotifications
                onToggled: cfg_showNotifications = checked
            }

            // Conflict strategy — default index 1 = "Mantener ambos"
            QQC2.ComboBox {
                Kirigami.FormData.label: i18n("If the file already exists:")
                // 0 = Omitir, 1 = Mantener ambos (renombrar), 2 = Sobreescribir
                model: [
                    i18n("Skip (do not move)"),
                    i18n("Keep both (rename: [filename]_1.ext)"),
                    i18n("Overwrite")
                ]
                currentIndex: cfg_conflictStrategy
                onActivated: cfg_conflictStrategy = currentIndex
            }
        }

        Kirigami.Separator { Layout.fillWidth: true }

        Kirigami.InlineMessage {
            Layout.fillWidth: true
            type: Kirigami.MessageType.Warning
            text: i18n("⚠  Files are moved permanently.\nCarefully check the rules and destination folders before using them with important files.")
            visible: true
        }

        // Reset to defaults button
        QQC2.Button {
            text: i18n("Restore default rules")
            icon.name: "edit-reset"
            onClicked: resetDialog.open()
        }

        Kirigami.Dialog {
            id: resetDialog
            title: i18n("Restore default rules?")
            standardButtons: Kirigami.Dialog.Ok | Kirigami.Dialog.Cancel
            onAccepted: {
                // Clear rules so initRules() seeds defaults on next load
                plasmoid.configuration.rules = ""
            }
            QQC2.Label {
                text: i18n("This will remove all custom rules and restore the 9 predefined categories (disabled). Continue?")
                wrapMode: Text.WordWrap
                width: Kirigami.Units.gridUnit * 22
            }
        }
    }
}
