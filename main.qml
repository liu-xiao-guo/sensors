import QtQuick 2.0
import Ubuntu.Components 0.1
import "components"
import QtSensors 5.0

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.liu-xiao-guo.sensors"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(100)
    height: units.gu(75)

    Page {
        title: i18n.tr("Sensors")
        clip: true

        Accelerometer {
            id: accel
            active: true
            dataRate: 20

            onReadingChanged: {
                accelLabel.text = "Accel " + "x: " + reading.x.toFixed(1) +" y: " + reading.y.toFixed(1) + " z: " + reading.z.toFixed(1)
            }
        }

        TiltSensor {
            id: tilt
            active: false

            onReadingChanged: {
                tiltLabel.text = "Tilt " + "x " + tilt.reading.xRotation.toFixed(1) + " y " + tilt.reading.yRotation.toFixed(1);
            }
        }

        AmbientLightSensor {
            active: true
            onReadingChanged: {
                if (reading.lightLevel === AmbientLightReading.Dark) {
                    lightLabel.text = "It is dark"
                }  else if ( reading.lightLevel === AmbientLightReading.Twilight) {
                    lightLabel.text = "It is moderately dark";
                } else if ( reading.lightLevel === AmbientLightReading.Light) {
                    lightLabel.text = "It is light (eg. internal lights)";
                } else if ( reading.lightLevel === AmbientLightReading.Bright) {
                    lightLabel.text = "It is bright (eg. shade)";
                } else if ( reading.lightLevel === AmbientLightReading.Sunny) {
                    lightLabel.text = "It is very bright (eg. direct sunlight)";
                }else if ( reading.lightLevel === AmbientLightReading.Undefined) {
                    lightLabel.text = "It is unknown";
                }
            }
        }

        OrientationSensor {
            active: true
            onReadingChanged: {
                orientationLabel.text = "something happened"
                if ( reading.orientation === OrientationReading.TopUp) {
                    orientationLabel.text = "TopUp";
                } else if ( reading.orientation === OrientationReading.TopDown) {
                    orientationLabel.text = "TopDown";
                } else if ( reading.orientation === OrientationReading.LeftUp) {
                    orientationLabel.text = "LeftUp";
                } else if ( reading.orientation === OrientationReading.RightUp) {
                    orientationLabel.text= "RightUp";
                } else if ( reading.orientation === OrientationReading.FaceDown) {
                    orientationLabel.text = "FaceDown";
                }  else if ( reading.orientation === OrientationReading.FaceUp) {
                    orientationLabel.text = "FaceUp";
                }
            }
        }

        RotationSensor {
            id: rotation
            onReadingChanged: {
                rotationLabel.text = "Rotation x: " + rotation.reading.x.toFixed(1) + " y: "
                        + rotation.reading.y.toFixed(1) + " z: " + rotation.reading.z.toFixed(1);
            }
        }

        SensorGesture {
            id: sensorGesture

            Component.onCompleted: {
                console.log("The invalid gestures: ");
                for ( var gesture in invalidGestures ) {
                    console.log(" invalid[" + gesture + "]: " + invalidGestures[gesture])
                }

                console.log("The available gestures: ");
                for ( var gesture in availableGestures ) {
                    console.log(" available[" + gesture + "]: " + availableGestures[gesture])
                }
            }

            gestures: ["QtSensors.SecondCounter",
                       "QtSensors.cover",
                       "QtSensors.doubletap",
                       "QtSensors.hover",
                       "QtSensors.freefall",
                       "QtSensors.pickup",
                       "QtSensors.shake2",
                       "QtSensors.slam",
                       "QtSensors.turnover",
                       "QtSensors.twist",
                       "QtSensors.whip",
                       "QtSensors.shake"
                      ]

            enabled: true

            onDetected: {
                console.log("detected gesture: " + gesture);
            }
        }

        Column {
            anchors.fill: parent
            spacing: units.gu(2)

            ListView {
                width: parent.width
                height: parent.height*.25

                delegate: Text {
                    text: modelData
                }

                model:QmlSensors.sensorTypes()
            }

            ListView {
                width: parent.width
                height: parent.height*.33

                delegate: Text {
                    text: modelData
                }

                model:sensorGesture.availableGestures
            }

            Label {
                id: accelLabel
                fontSize: "large"
            }

            Label {
                id: tiltLabel
                fontSize: "large"
            }

            Label {
                id: lightLabel
                fontSize: "large"
            }

            Label {
                id: orientationLabel
                fontSize: "large"
            }

            Label {
                id: rotationLabel
                fontSize: "large"
            }
        }

        Component.onCompleted: {
            var types = QmlSensors.sensorTypes();
            console.log(types.join(", "));
        }
    }
}

