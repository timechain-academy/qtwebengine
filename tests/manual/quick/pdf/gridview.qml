/****************************************************************************
**
** Copyright (C) 2022 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the manual tests of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick
import QtQuick.Pdf

Window {
    width: 320
    height: 440
    color: "lightgrey"
    title: doc.source
    visible: true

    property real cellSize: 150

    PdfDocument {
        id: doc
        source: "test.pdf"
    }

    GridView {
        id: view
        anchors.fill: parent
        anchors.margins: 10
        model: doc.pageCount
        cellWidth: cellSize
        cellHeight: cellSize
        delegate: Item {
            width: view.cellWidth
            height: view.cellHeight
            Rectangle {
                id: paper
                width: image.width
                height: image.height
                x: (parent.width - width) / 2
                y: (parent.height - height - pageNumber.height) / 2
                PdfPageImage {
                    id: image
                    document: doc
                    currentPage: index
                    asynchronous: true
                    fillMode: Image.PreserveAspectFit
                    property size naturalSize: doc.pagePointSize(index)
                    property bool landscape: naturalSize.width > naturalSize.height
                    width: landscape ? Math.min(view.cellWidth, naturalSize.width) : height * naturalSize.width / naturalSize.height
                    height: landscape ? width * naturalSize.height / naturalSize.width : Math.min(view.cellHeight - pageNumber.height, naturalSize.height)
                    sourceSize.width: width
                    sourceSize.height: height
                }
            }
            Text {
                id: pageNumber
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Page " + (image.currentFrame + 1)
            }
        }
    }
}