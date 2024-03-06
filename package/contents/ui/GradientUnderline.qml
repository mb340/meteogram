import QtQuick
import QtQuick.Shapes

Shape {
    required property color lineColor

    ShapePath {
        strokeWidth: -1
        strokeColor: 'transparent'

        startX: 0
        startY: 0
        PathLine { x: parent.width; y: 0 }
        PathLine { x: parent.width; y: 1 }
        PathLine { x: 0; y: 1 }

        fillGradient: LinearGradient {
            x1: 0; y1: 1
            x2: parent.width; y2: 1
            GradientStop { position: 0; color: "transparent" }
            GradientStop { position: 0.1; color: lineColor }
            GradientStop { position: 1; color: "transparent" }
        }
    }
}
