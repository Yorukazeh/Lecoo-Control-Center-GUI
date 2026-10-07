import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import io.lecooctrl.gui

// Material Design button with an ink ripple.
Button {
    id: root
    property bool toggled
    property string buttonText
    property bool pointingHandCursor: true
    property real buttonRadius: Appearance?.rounding?.small ?? 4
    property real buttonRadiusPressed: buttonRadius
    property real buttonEffectiveRadius: root.down ? root.buttonRadiusPressed : root.buttonRadius
    property real leftRadius: root.buttonEffectiveRadius
    property real rightRadius: root.buttonEffectiveRadius
    property int rippleDuration: 1200
    property bool rippleEnabled: true
    property var downAction
    property var releaseAction
    property var altAction
    property var middleClickAction
    property bool border: false
    property real borderWidth: 1
    property color colBorder: Appearance.colors.colOutlineVariant

    property color colBackground: ColorUtils.transparentize(Appearance.colors.colLayer1Hover, 1)
    property color colBackgroundHover: Appearance.colors.colLayer1Hover
    property color colBackgroundActive: Appearance.colors.colLayer1Active
    property color colBackgroundToggled: Appearance.colors.colPrimary
    property color colBackgroundToggledHover: Appearance.colors.colPrimaryHover
    property color colBackgroundToggledActive: Appearance.colors.colPrimaryActive
    property color colRipple: Appearance.colors.colLayer1Active
    property color colRippleToggled: Appearance.colors.colPrimaryActive

    opacity: root.enabled ? 1 : 0.4
    property color buttonColor: ColorUtils.transparentize(root.toggled ? (root.down ? colBackgroundToggledActive : root.hovered ? colBackgroundToggledHover : colBackgroundToggled) : (root.down ? colBackgroundActive : root.hovered ? colBackgroundHover : colBackground), root.enabled ? 0 : 1)
    property color rippleColor: root.toggled ? colRippleToggled : colRipple

    function startRipple(x, y) {
        const stateY = buttonBackground.y;
        rippleAnim.x = x;
        rippleAnim.y = y - stateY;

        const dist = (ox, oy) => ox * ox + oy * oy;
        const stateEndY = stateY + buttonBackground.height;
        rippleAnim.radius = Math.sqrt(Math.max(dist(0, stateY), dist(0, stateEndY), dist(width, stateY), dist(width, stateEndY)));

        rippleFadeAnim.complete();
        rippleAnim.restart();
    }

    component RippleAnim: NumberAnimation {
        duration: root.rippleDuration
        easing.type: Appearance?.animation.elementMoveFast.type
        easing.bezierCurve: Appearance?.animationCurves.standardDecel
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: root.pointingHandCursor ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onPressed: (event) => {
            if (event.button === Qt.RightButton) {
                if (root.altAction)
                    root.altAction(event);
                return;
            }
            if (event.button === Qt.MiddleButton) {
                if (root.middleClickAction)
                    root.middleClickAction();
                return;
            }
            root.down = true;
            if (root.downAction)
                root.downAction();
            if (!root.rippleEnabled)
                return;
            startRipple(event.x, event.y);
        }
        onReleased: (event) => {
            root.down = false;
            if (event.button !== Qt.LeftButton)
                return;
            if (root.releaseAction)
                root.releaseAction();
            root.click();
            if (!root.rippleEnabled)
                return;
            rippleFadeAnim.restart();
        }
        onCanceled: (event) => {
            root.down = false;
            if (!root.rippleEnabled)
                return;
            rippleFadeAnim.restart();
        }
    }

    RippleAnim {
        id: rippleFadeAnim
        duration: root.rippleDuration * 2
        target: ripple
        property: "opacity"
        to: 0
    }

    SequentialAnimation {
        id: rippleAnim
        property real x
        property real y
        property real radius

        PropertyAction {
            target: ripple
            property: "x"
            value: rippleAnim.x
        }
        PropertyAction {
            target: ripple
            property: "y"
            value: rippleAnim.y
        }
        PropertyAction {
            target: ripple
            property: "opacity"
            value: 1
        }
        ParallelAnimation {
            RippleAnim {
                target: ripple
                properties: "rippleWidth,rippleHeight"
                from: 0
                to: rippleAnim.radius * 2
            }
        }
    }

    background: Rectangle {
        id: buttonBackground
        radius: root.buttonEffectiveRadius
        topLeftRadius: root.leftRadius
        topRightRadius: root.rightRadius
        bottomLeftRadius: root.leftRadius
        bottomRightRadius: root.rightRadius
        implicitHeight: 30
        color: root.buttonColor
        border.width: root.border ? root.borderWidth : 0
        border.color: root.colBorder
        Behavior on color {
            animation: Appearance?.animation.elementMoveFast.colorAnimation.createObject(this)
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: buttonBackground.width
                height: buttonBackground.height
                topLeftRadius: root.leftRadius
                topRightRadius: root.rightRadius
                bottomLeftRadius: root.leftRadius
                bottomRightRadius: root.rightRadius
            }
        }

        Item {
            id: ripple
            width: ripple.rippleWidth
            height: ripple.rippleHeight
            opacity: 0
            visible: width > 0 && height > 0
            property real rippleWidth: 0
            property real rippleHeight: 0

            Behavior on opacity {
                animation: Appearance?.animation.elementMoveFast.colorAnimation.createObject(this)
            }

            RadialGradient {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: root.rippleColor }
                    GradientStop { position: 0.3; color: root.rippleColor }
                    GradientStop { position: 0.5; color: ColorUtils.applyAlpha(root.rippleColor, 0) }
                }
            }

            transform: Translate {
                x: -ripple.width / 2
                y: -ripple.height / 2
            }
        }
    }

    contentItem: StyledText {
        text: root.buttonText
    }
}
