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

#include "btconnector.h"

BtConnector::BtConnector(QObject *parent)
    : QObject(parent){
    _threshold = 50;

    _up = false;
    _down = false;
    _left = false;
    _right = false;

    _a = false;
    _b = false;
    _c = false;
    _d = false;

    _x = 0;
    _y = 0;
    oldButtonMap = 0;
}

void BtConnector::connect(QString address, int port){
    qDebug("Trying to connect to: %s--%d", address.toUtf8().constData(), port);

    if(socket)
        delete socket;

    socket = new QBluetoothSocket(QBluetoothSocket::RfcommSocket);
    QObject::connect(socket, SIGNAL(connected()), this, SIGNAL(connected()));
    QObject::connect(socket, SIGNAL(disconnected()), this, SIGNAL(disconnected()));
    QObject::connect(socket, SIGNAL(error(QBluetoothSocket::SocketError)), this, SIGNAL(error(QBluetoothSocket::SocketError)));

    qDebug("Connecting...");
    socket->connectToService(QBluetoothAddress(address), port);
    qDebug("Connected.");

    QObject::connect(socket, SIGNAL(readyRead()), this, SLOT(readData()));
}

void BtConnector::disconnect(){
    if(!socket)
        return;

    if(socket->isOpen())
        socket->close();

    delete socket;
    socket = 0;

    /*
     * Explicitly set D to false in case the remote was shut off
     * using the power key, which equals the 'D' key.
     * Well, good intention but doesn't seem to work.
     */
    setD(false);
}

void BtConnector::readData(){
//        qDebug("readData...");
    QByteArray data = socket->readAll();
//        qDebug("read %d bytes.", data.size());

/*
    for(int i=0; i < data.size(); i++){
        qDebug("%d: %d", i, ((signed char)data.at(i)));
    }
*/

    /*
     * Actually it seems like that the first three bytes are used for
     * identifying the "type" of data sent. However, for now using the
     * first seems to suffice.
     */
    if(data.at(0) == 5){
        /*
         * Joystick movement
         *
         * X-Axis: positive values -> right, negative values -> left
         * Y-Axis: positive values -> down, negative values -> up
         */

        setX((int)(signed char) data.at(4));
        setY((int)(signed char) data.at(5));

        emit(stickMoved(_x, _y));

        /*
         * Emulate a digital joystick.
         */
        if(_up && (_y > -threshold())){
            setUp(false);
        }else if(!_up && (_y < -threshold())){
            setUp(true);
        }

        if(_down && (_y < threshold())){
            setDown(false);
        }else if(!_down && (_y > threshold())){
            setDown(true);
        }

        if(_left && (_x > -threshold())){
            setLeft(false);
        }else if(!_left && (_x < -threshold())){
            setLeft(true);
        }

        if(_right && (_x < threshold())){
            setRight(false);
        }else if(!_right && (_x > threshold())){
            setRight(true);
        }
    }else if(data.at(0) == 8){ 
        /*
         * Button presses
         *
         * A -> 0, B -> 1, C -> 2, D ->3
         * At index 3 to 6 (inclusive)
         */

        char buttonMap = 0;

        for(int i = 3; i <= 6; i++){
            for(int b = 0; b <= 3; b++){
                if(data.at(i) == b){
                    buttonMap ^= (1 << b);
                }
            }
        }

//            qDebug("Button map: %d", buttonMap);
        emit(buttonsChanged(buttonMap & 0x01, buttonMap & 0x02, buttonMap & 0x04, buttonMap & 0x08));

        for(int i = 0; i <= 3; i++){
            if(((buttonMap | oldButtonMap) & (1 << i)) > 0){
                bool val = (buttonMap & (1 << i)) > 0;
                switch (i){
                case 0:
                    setA(val);
                    break;
                case 1:
                    setB(val);
                    break;
                case 2:
                    setC(val);
                    break;
                case 3:
                    setD(val);
                    break;
                }
            }
        }

        oldButtonMap = buttonMap;
    }
}
