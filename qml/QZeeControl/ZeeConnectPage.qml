/*
 *  Copyright 2012 Ruediger Gad
 *
 *  This file is part of QZeeControl.
 *
 *  QZeeControl is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  QZeeControl is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with QZeeControl.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.connectivity 1.2
import QtMobility.systeminfo 1.2
import "settingsstorage.js" as SettingsStorage
import qzeecontrol 1.0

Page {
    id: zeeConnectPage
    tools: commonTools

    anchors.fill: parent

    orientationLock: PageOrientation.LockPortrait

    property bool connected: false
    property alias currentAddress: addressField.text
    property bool initializing: true
    property string name: "none"
    property string usedAddresses: "none"

    Component.onCompleted: {
        SettingsStorage.initialize();

        var address = SettingsStorage.getSetting(name + "address");
        var port = SettingsStorage.getSetting(name + "port");
        if(address !== "Unknown" && port !== "Unknown") {
            console.log("Loaded address " + address + " and port " + port + " from DB for " + name + ".")
            addressField.text = address
            portField.text = port
        }

        if(SettingsStorage.getSetting(name + "A") === "Unknown") {
            console.log("Initializing key bindings for " + name + ".")
            setKeyBindingsToDefault()
        }

        loadKeyBindings()
        updateConnectAndScanButton()
        initializing = false
    }

    function setKeyBindingsToDefault() {
        console.log("Setting key bindings to default for " + name + ".")
        SettingsStorage.setSetting(name + "A", "a")
        SettingsStorage.setSetting(name + "B", "b")
        SettingsStorage.setSetting(name + "C", "c")
        SettingsStorage.setSetting(name + "D", "d")

        SettingsStorage.setSetting(name + "Up", "Up")
        SettingsStorage.setSetting(name + "Down", "Down")
        SettingsStorage.setSetting(name + "Left", "Left")
        SettingsStorage.setSetting(name + "Right", "Right")

        SettingsStorage.setSetting(name + "Threshold", "50")

        /*
         * The following settings are not used right now but
         * we initialize these anyhow for possibly later use.
         */
        SettingsStorage.setSetting(name + "MousePointerMode", "false")
        SettingsStorage.setSetting(name + "AlternateActionTrigger", "none")
    }

    function loadKeyBindings() {
        console.log("Loading key bindings for " + name + ".")
        zeeRemoteControl.keyBindingA = SettingsStorage.getSetting(name + "A")
        zeeRemoteControl.keyBindingB = SettingsStorage.getSetting(name + "B")
        zeeRemoteControl.keyBindingC = SettingsStorage.getSetting(name + "C")
        zeeRemoteControl.keyBindingD = SettingsStorage.getSetting(name + "D")

        zeeRemoteControl.keyBindingUp = SettingsStorage.getSetting(name + "Up")
        zeeRemoteControl.keyBindingDown = SettingsStorage.getSetting(name + "Down")
        zeeRemoteControl.keyBindingLeft = SettingsStorage.getSetting(name + "Left")
        zeeRemoteControl.keyBindingRight = SettingsStorage.getSetting(name + "Right")

        zeeRemoteControl.threshold = SettingsStorage.getSetting(name + "Threshold")
    }

    function updateConnectAndScanButton() {
        if(!deviceInfo.currentBluetoothPowerState) {
            scanButton.enabled = false
            connectButton.enabled = false

            addressField.enabled = false
            portField.enabled = false

            infoText.text = "To get started please turn Bluetooth on."
            return
        }

        scanButton.enabled = true

        addressField.enabled = true
        portField.enabled = true

        connectButton.enabled = (addressField.text !== "No Zeemote found yet.")
        infoText.text = (addressField.text !== "No Zeemote found yet.") ?
                    "To enable remote control please press \"Connect\" when ready." :
                    "Please scan for a Zeemote first."
    }

    states: [
        State {
            name: "active"
            PropertyChanges {
                target: cursorRectangle
                x: moveArea.x + (moveArea.width * 0.5) + zeeRemoteControl.x - (cursorRectangle.width * 0.5)
                y: moveArea.y + (moveArea.height * 0.5) + zeeRemoteControl.y - (cursorRectangle.height * 0.5)
            }
            PropertyChanges {
                target: labelA
                color: zeeRemoteControl.a ? "red" : "blue"
            }
            PropertyChanges {
                target: labelB
                color: zeeRemoteControl.b ? "red" : "blue"
            }
            PropertyChanges {
                target: labelC
                color: zeeRemoteControl.c ? "red" : "blue"
            }
            PropertyChanges {
                target: labelD
                color: zeeRemoteControl.d ? "red" : "blue"
            }
        },
        State {
            name: "inactive"
            PropertyChanges {
                target: cursorRectangle
                x: moveArea.x + (moveArea.width * 0.5) - (cursorRectangle.width * 0.5)
                y: moveArea.y + (moveArea.height * 0.5) - (cursorRectangle.height * 0.5)
            }
            PropertyChanges {
                target: labelA
                color: "blue"
            }
            PropertyChanges {
                target: labelB
                color: "blue"
            }
            PropertyChanges {
                target: labelC
                color: "blue"
            }
            PropertyChanges {
                target: labelD
                color: "blue"
            }
        }
    ]

    Connections {
        target: platformWindow

        onActiveChanged: {
            if(platformWindow.active) {
                state = "active"
            } else {
                state = "inactive"
            }
        }
    }

    Rectangle {
        id: header
        height: 72
        color: "#0c61a8"
        anchors{left: parent.left; right: parent.right; top: parent.top}

        Text {
            text: "QZeeControl"
            color: "white"
            font.family: "Nokia Pure Text Light"
            font.pixelSize: 32
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Flickable {
        clip: true

        anchors {
            top: header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            spacing: 10
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 10
            }

            Button {
                id: scanButton
                enabled: false

                anchors.horizontalCenter: parent.horizontalCenter
                text: "Scan"

                onClicked: {
                    btDiscovery.discovery = true
                }
            }

            Row {
                id: addressRow
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 5

                TextField {
                    id: addressField
                    text: "No Zeemote found yet."
                    width: 280

                    onTextChanged: {
                        if(zeeConnectPage.initializing)
                            return

                        if(text === "No Zeemote found yet.")
                            return

                        if(text === usedAddresses){
                            console.log("Not using address " + text + " as it is already used somewhere else.")
                            return
                        }

                        updateConnectAndScanButton();

                        console.log("Storing address in DB for " + name + ": " + text)
                        SettingsStorage.setSetting(name + "address", text)
                    }
                }
                TextField {
                    id: portField
                    text: "na"
                    width: 60
                    validator: IntValidator{}

                    onTextChanged: {
                        if(zeeConnectPage.initializing)
                            return

                        if(text === "na")
                            return

                        console.log("Storing port in DB for " + name + ": " + text)
                        SettingsStorage.setSetting(name + "port", text)
                    }
                }
            }

            Label {
                id: infoText
                width: parent.width

                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Button {
                id: connectButton
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: false

                text: "Connect"

                onClicked: {
                    scanButton.enabled = false
                    addressField.enabled = false
                    portField.enabled = false
                    connectButton.enabled = false
                    disconnectButton.enabled = false
                    infoText.text = "Connecting..."

                    zeeRemoteControl.connect(addressField.text, parseInt(portField.text))
                }
            }

            Button {
                id: disconnectButton
                anchors.horizontalCenter: parent.horizontalCenter

                text: "Disconnect"
                enabled: false

                onClicked: {
                    zeeRemoteControl.disconnect()
                }
            }

            Row {
                id: buttonRow
                anchors.horizontalCenter: parent.horizontalCenter

                spacing: 20

                Label {
                    id: labelA
                    text: "A"
                    color: zeeRemoteControl.a ? "red" : "blue"
                }
                Label {
                    id: labelB
                    text: "B"
                    color: zeeRemoteControl.b ? "red" : "blue"
                }
                Label {
                    id: labelC
                    text: "C"
                    color: zeeRemoteControl.c ? "red" : "blue"
                }
                Label {
                    id: labelD
                    text: "D"
                    color: zeeRemoteControl.d ? "red" : "blue"
                }
            }

            Item {
                id: testArea
                anchors.horizontalCenter: parent.horizontalCenter
                height: moveArea.height
                width: moveArea.width

                Rectangle {
                    id: moveArea
                    color: "gray"

                    width: 256
                    height: 256
                }

                Rectangle {
                    id: cursorRectangle
                    width: 10
                    height: 10
                    color: "red"

                    x: moveArea.x + (moveArea.width * 0.5) + zeeRemoteControl.x - (cursorRectangle.width * 0.5)
                    y: moveArea.y + (moveArea.height * 0.5) + zeeRemoteControl.y - (cursorRectangle.height * 0.5)
                }
            }
        }
    }

    DeviceInfo {
        id: deviceInfo

        monitorBluetoothStateChanges: true

        onBluetoothStateChanged: {
            updateConnectAndScanButton()
        }
    }

    BluetoothDiscoveryModel {
        id: btDiscovery

        discovery: false
        minimalDiscovery: true

        onDiscoveryChanged: {
            if(initializing)
                return

            if(discovery) {
                infoText.text = "Scanning for a Zeemote..."
                scanButton.enabled = false
                connectButton.enabled = false
                disconnectButton.enabled = false
                addressField.enabled = false
                portField.enabled = false
            } else {
                scanButton.enabled = true
                disconnectButton.enabled = false
                addressField.enabled = true
                portField.enabled = true

                if(addressField.text !== "No Zeemote found yet." && portField.text !== "na") {
                    infoText.text = "Zeemote found. To enable remote control please press \"Connect\" when ready."
                    connectButton.enabled = true
                }
            }
        }

        onNewServiceDiscovered: {
            console.log("Service " + service.serviceName + " found on "
                        + service.deviceName + " at address " + service.deviceAddress
                        + " on port " + service.servicePort + ".")

            if(service.serviceName !== "Zeemote")
                return

            if(service.deviceAddress === usedAddresses) {
                console.log("Zeemote at address " + service.deviceAddress + " already in use somewhere else. " +
                            "Not going to use this one.")
                return
            }

            addressField.text = service.deviceAddress
            portField.text = service.servicePort
            discovery = false
            console.log("Found Zeemote. Stopped further discovery.")
        }
    }

    ZeeRemoteControl {
        id: zeeRemoteControl

        onConnected: {
            zeeConnectPage.connected = true
            disconnectButton.enabled = true
            infoText.text = "Connected. Have fun."
        }
        onDisconnected: {
            zeeConnectPage.connected = false
            scanButton.enabled = true
            addressField.enabled = true
            portField.enabled = true
            connectButton.enabled = true
            disconnectButton.enabled = false
            infoText.text = "To enable remote control please press \"Connect\" when ready."
        }
    }

    XtstAdapter {
        id: xtstAdapter
    }
}
