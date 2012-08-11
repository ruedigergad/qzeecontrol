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
 *  along with QZeeControl. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 1.1
import com.nokia.meego 1.0

Dialog {
    id: aboutDialog

    content:Item {
        anchors.fill: parent

        Text {
            id: homepage
            text: "<a href=\"http://qzeecontrol.garage.maemo.org/\" style=\"text-decoration:none; color:#78bfff\">QZeeControl<br /><img src=\"/opt/QZeeControl/qzeecontrol.png\" /><br />Version 0.4.0</a>"
            textFormat: Text.RichText
            onLinkActivated: Qt.openUrlExternally(link)
            font.pixelSize: 22
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: description.top; anchors.bottomMargin: 8
        }

        Text {
            id: description
            text: "Control your N9 remotely."
            font.pixelSize: 22; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: author.top; anchors.bottomMargin: 12; color: "white"
        }

        Text {
            id: author
            text: "Author: <br />"
                  + "Ruediger Gad - <a href=\"http://ruedigergad.com/\" style=\"text-decoration:none; color:#78bfff\" >http://ruedigergad.com/</a><br />"
                  + "Logo: <br />"
                  + "Michaela Rother - <a href=\"http://www.michaelarother.de/\" style=\"text-decoration:none; color:#78bfff\" >http://www.michaelarother.de/</a><br />"
            textFormat: Text.RichText
            onLinkActivated: Qt.openUrlExternally(link)
            font.pixelSize: 20; anchors.centerIn: parent; color: "lightgray"; horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: license
            text: "QZeeControl is free software: you can redistribute it and/or modify "
                  + "it under the terms of the <a href=\"http://www.gnu.org/licenses\" style=\"text-decoration:none; color:#78bfff\" >GNU General Public License</a> as published by "
                  + "the Free Software Foundation, either version 3 of the License, or "
                  + "(at your option) any later version.<br /><br />"
                  + "Zeemote (TM) is a trademark of Zeemote Technology Inc. Other trademarks are property of their respective owners."
            textFormat: Text.RichText
            onLinkActivated: Qt.openUrlExternally(link)
            font.pixelSize: 18
            anchors{horizontalCenter: parent.horizontalCenter; top: author.bottom; topMargin: 12}
            width: parent.width
            color: "lightgray"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }
    }
}
