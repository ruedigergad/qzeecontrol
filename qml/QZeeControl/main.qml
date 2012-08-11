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

PageStackWindow {
    id: appWindow

    initialPage: mainPage

    Page{
        id: mainPage

        tools: commonTools
        orientationLock: PageOrientation.LockPortrait

        TabGroup {
            id: tabGroup

            currentTab: zeeTab1

            ZeeConnectPage{
                id: zeeTab1
                name: "Zee_1"
            }

            ZeeConnectPage{
                id: zeeTab2
                name: "Zee_2"
                usedAddresses: zeeTab1.currentAddress
            }

            onCurrentTabChanged: keyBindingsSettings.currentRemote = currentTab.name
        }
    }

    ToolBarLayout {
        id: commonTools
        visible: true

        ButtonRow{
            id: tabButtonRow
            style: TabButtonStyle {}

            TabButton{
                text: zeeTab1.connected ? "*Zee 1*" : "Zee 1"
                tab: zeeTab1

            }

            TabButton{
                text: zeeTab2.connected ? "*Zee 2*" : "Zee 2"
                tab: zeeTab2
                enabled: zeeTab1.currentAddress !== "No Zeemote found yet."
            }
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack

        MenuLayout {
            MenuItem {
                text: "Edit Key Bindings"
                onClicked: keyBindingsSettings.open()
            }

            MenuItem {
                text: "About"
                onClicked: aboutDialog.open()
            }
        }
    }

    AboutDialog{
        id: aboutDialog
    }

    KeyBindingSettings{
        id: keyBindingsSettings
        onAccepted: tabGroup.currentTab.loadKeyBindings()
    }
}
