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

#include "xtstadapter.h"

void XtstAdapter::sendKeyPress(QString key){
    sendKey(key, true);
    sendKey(key, false);
//    int keyCode = XKeysymToKeycode(display, XStringToKeysym(key.toUtf8().constData()));

////        "Shift_L" on N9 equals keycode 50.
////        qDebug("Shift_L is: %d", XKeysymToKeycode(display, XStringToKeysym("Shift_L")));

//    /*
//     * In case we want to send a single upper case character we press and release shift
//     * prior respectively after sending our actual key press.
//     */
//    bool isUpperCaseChar = (key.length() == 1 && key.at(0).isUpper());
//    if(isUpperCaseChar){
//        XTestFakeKeyEvent(display, 50, true, 0);
//    }

//    XTestFakeKeyEvent(display, keyCode, true, 0);
//    XTestFakeKeyEvent(display, keyCode, false, 0);

//    /*
//     * In case we want to send a single upper case character we press and release shift
//     * prior respectively after sending our actual key press.
//     */
//    if(isUpperCaseChar){
//        XTestFakeKeyEvent(display, 50, false, 0);
//    }

//    XFlush(display);
}

void XtstAdapter::sendKey(QString key, bool down){
    int keyCode = XKeysymToKeycode(display, XStringToKeysym(key.toUtf8().constData()));

//        "Shift_L" on N9 equals keycode 50.
//        qDebug("Shift_L is: %d", XKeysymToKeycode(display, XStringToKeysym("Shift_L")));

    /*
     * In case we want to send a single upper case character we press and release shift
     * prior respectively after sending our actual key press.
     */
    bool isUpperCaseChar = (key.length() == 1 && key.at(0).isUpper());
    if(isUpperCaseChar){
        XTestFakeKeyEvent(display, 50, true, 0);
    }

    XTestFakeKeyEvent(display, keyCode, down, 0);

    /*
     * In case we want to send a single upper case character we press and release shift
     * prior respectively after sending our actual key press.
     */
    if(isUpperCaseChar){
        XTestFakeKeyEvent(display, 50, false, 0);
    }

    XFlush(display);
}
