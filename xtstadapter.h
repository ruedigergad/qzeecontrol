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

#ifndef XTSTADAPTER_H
#define XTSTADAPTER_H

#include <QObject>

#include <X11/extensions/XTest.h>
#include <X11/Xlib.h>

class XtstAdapter : public QObject
{
    Q_OBJECT
public:
    explicit XtstAdapter(QObject *parent = 0)
        : QObject(parent){
        display = XOpenDisplay(0);
    }
    
signals:
    
public slots:
    void sendKeyPress(QString key);
    void sendKey(QString key, bool down);

private:
    Display *display;

    
};

#endif // XTSTADAPTER_H
