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
import qzeecontrol 1.0

BtConnector{
    id: zeeRemoteControl

    /*
     * Keybindings
     */
    property string keyBindingA
    property string keyBindingB
    property string keyBindingC
    property string keyBindingD

    property string keyBindingUp
    property string keyBindingDown
    property string keyBindingLeft
    property string keyBindingRight

//      Examples on how to use these old signals.
//        onStickMoved: {
//            console.log("Stick moved. x: " + x + " y: " + y)
//        }
//        onButtonsChanged: {
//            console.log("Buttons changed. A: " + a + " B: " + b + " C: " + c + " D: " + d)
//        }

    /*
     * Do the actual keyboard interaction.
     */
    onAChanged: xtstAdapter.sendKey(keyBindingA, val);
    onBChanged: xtstAdapter.sendKey(keyBindingB, val);
    onCChanged: xtstAdapter.sendKey(keyBindingC, val);
    onDChanged: xtstAdapter.sendKey(keyBindingD, val);

    onUpChanged: xtstAdapter.sendKey(keyBindingUp, val)
    onDownChanged: xtstAdapter.sendKey(keyBindingDown, val)
    onLeftChanged: xtstAdapter.sendKey(keyBindingLeft, val)
    onRightChanged: xtstAdapter.sendKey(keyBindingRight, val)
}


