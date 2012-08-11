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
import "settingsstorage.js" as SettingsStorage

Sheet {
    id: keyBindingSettings
    anchors.fill: parent
    visualParent: mainPage
    z: 2

    acceptButtonText: "Save"
    rejectButtonText: "Cancel"

    property string currentRemote: "none"

    function loadBindings(){
        if(currentRemote === "none"){
            console.log("Current remote is none. Not going to load key bindings.")
            return
        }

        console.log("Loading stored key bindings for " + currentRemote + ".")
        fieldA.text = SettingsStorage.getSetting(currentRemote + "A")
        fieldB.text = SettingsStorage.getSetting(currentRemote + "B")
        fieldC.text = SettingsStorage.getSetting(currentRemote + "C")
        fieldD.text = SettingsStorage.getSetting(currentRemote + "D")

        fieldUp.text = SettingsStorage.getSetting(currentRemote + "Up")
        fieldDown.text = SettingsStorage.getSetting(currentRemote + "Down")
        fieldLeft.text = SettingsStorage.getSetting(currentRemote + "Left")
        fieldRight.text = SettingsStorage.getSetting(currentRemote + "Right")
    }

    function saveBindings(){
        if(currentRemote === "none"){
            console.log("Current remote is none. Not going to save key bindings.")
            return
        }

        console.log("Saving new key bindings for " + currentRemote + ".")
        SettingsStorage.setSetting(currentRemote + "A", fieldA.text)
        SettingsStorage.setSetting(currentRemote + "B", fieldB.text)
        SettingsStorage.setSetting(currentRemote + "C", fieldC.text)
        SettingsStorage.setSetting(currentRemote + "D", fieldD.text)

        SettingsStorage.setSetting(currentRemote + "Up", fieldUp.text)
        SettingsStorage.setSetting(currentRemote + "Down", fieldDown.text)
        SettingsStorage.setSetting(currentRemote + "Left", fieldLeft.text)
        SettingsStorage.setSetting(currentRemote + "Right", fieldRight.text)
    }

    onAccepted: saveBindings()

    onStatusChanged:{
        if(status === DialogStatus.Opening){
            loadBindings()
        }
    }

    content: Flickable{
        anchors.fill: parent
        anchors.margins: 10
        contentHeight: contentGrid.height + explanationLabel.height

        Grid{
            id: contentGrid

            anchors{top: parent.top}
            width: 300
            spacing: 10

            Label{
                text: "A"
            }
            TextField{
                id: fieldA
                text: "-"
                width: 150
            }

            Label{
                text: "B"
            }
            TextField{
                id: fieldB
                text: "-"
                width: 150
            }

            Label{
                text: "C"
            }
            TextField{
                id: fieldC
                text: "-"
                width: 150
            }

            Label{
                text: "D"
            }
            TextField{
                id: fieldD
                text: "-"
                width: 150
            }

            Label{
                text: "Up"
            }
            TextField{
                id: fieldUp
                text: "-"
                width: 150
            }

            Label{
                text: "Down"
            }
            TextField{
                id: fieldDown
                text: "-"
                width: 150
            }

            Label{
                text: "Left"
            }
            TextField{
                id: fieldLeft
                text: "-"
                width: 150
            }

            Label{
                text: "Right"
            }
            TextField{
                id: fieldRight
                text: "-"
                width: 150
            }
        }

        Label{
            id: explanationLabel
            anchors{top: contentGrid.bottom; left: parent.left; right: parent.right; margins: 20}
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap

            text: "Some possibly useful key names are:\nUp, Down, Left, Right, Return, space\n" +
                  "If you don't need any of these special keys just enter a single character for each key binding. " +
                  "Upper- and lowercase characters are allowed."
        }
    }
}

