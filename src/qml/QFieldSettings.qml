import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.4
import QtBluetooth 5.14
import Qt.labs.settings 1.0

import org.qfield 1.0

import Theme 1.0

Page {
  signal finished

  property alias currentPanel: bar.currentIndex

  property alias showScaleBar: registry.showScaleBar
  property alias fullScreenIdentifyView: registry.fullScreenIdentifyView
  property alias locatorKeepScale: registry.locatorKeepScale
  property alias numericalDigitizingInformation: registry.numericalDigitizingInformation
  property alias nativeCamera: registry.nativeCamera
  property alias autoSave: registry.autoSave
  property alias mouseAsTouchScreen: registry.mouseAsTouchScreen

  Settings {
    id: registry
    property bool showScaleBar: true
    property bool fullScreenIdentifyView: false
    property bool locatorKeepScale: false
    property bool numericalDigitizingInformation: false
    property bool nativeCamera: true
    property bool autoSave: false
    property bool mouseAsTouchScreen: false
  }

  ListModel {
      id: settingsModel
      ListElement {
          title: qsTr( "Show scale bar" )
          settingAlias: "showScaleBar"
      }
      ListElement {
          title: qsTr( "Maximized attribute form" )
          settingAlias: "fullScreenIdentifyView"
      }
      ListElement {
          title: qsTr( "Fixed scale navigation" )
          description: qsTr( "When fixed scale navigation is active, focusing on a search result will pan to the feature. With fixed scale navigation disabled it will pan and zoom to the feature." )
          settingAlias: "locatorKeepScale"
      }
      ListElement {
          title: qsTr( "Show digitizing information" )
          description: qsTr( "When switched on, coordinate information, such as latitude and longitude, is overlayed onto the map while digitizing new features or using the measure tool." )
          settingAlias: "numericalDigitizingInformation"
      }
      ListElement {
          title: qsTr( "Use native camera" )
          description: qsTr( "If disabled, QField will use a minimalist internal camera instead of the camera app on the device.<br>Tip: Enable this option and install the open camera app to create geo tagged photos." )
          settingAlias: "nativeCamera"
      }
      ListElement {
          title: qsTr( "Fast editing mode" )
          description: qsTr( "If enabled, the feature is stored after having a valid geometry and the constraints are fulfilled and atributes are commited immediately." )
          settingAlias: "autoSave"
      }
      ListElement {
          title: qsTr( "Consider mouse as a touchscreen device" )
          description: qsTr( "If disabled, the mouse will act as a stylus pen." )
          settingAlias: "mouseAsTouchScreen"
      }
  }

  Rectangle {
    color: "white"
    anchors.fill: parent
  }

  ColumnLayout {
    anchors {
      top: parent.top
      left: parent.left
      right: parent.right
      bottom: parent.bottom
    }

    TabBar {
      id: bar
      currentIndex: 0
      Layout.fillWidth: true
      Layout.preferredHeight: 48

      onCurrentIndexChanged: swipeView.currentIndex = bar.currentIndex

      TabButton {
        text: qsTr("General")
        height: 48
        font: Theme.defaultFont
        anchors.verticalCenter : parent.verticalCenter
      }
      TabButton {
        text: qsTr("Positioning")
        height: 48
        font: Theme.defaultFont
        anchors.verticalCenter : parent.verticalCenter
      }
      TabButton {
        text: qsTr("Variables")
        height: 48
        font: Theme.defaultFont
        anchors.verticalCenter : parent.verticalCenter
      }
    }

    SwipeView {
      id: swipeView
      width: mainWindow.width
      currentIndex: 0
      Layout.fillHeight: true
      Layout.fillWidth: true

      onCurrentIndexChanged: bar.currentIndex = swipeView.currentIndex

      Item {
          ScrollView {
              topPadding: 5
              leftPadding: 0
              rightPadding: 0
              ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
              ScrollBar.vertical.policy: ScrollBar.AsNeeded
              contentWidth: positioningGrid.width
              contentHeight: positioningGrid.height
              anchors.fill: parent
              clip: true

              ColumnLayout {
                  id: generalSettingsGrid
                  width: parent.parent.width
                  spacing: 10

                  ListView {
                      Layout.preferredWidth: mainWindow.width
                      Layout.preferredHeight: childrenRect.height

                      model: settingsModel

                      delegate: Row {
                          width: parent ? parent.width - 16 : undefined

                          Column {
                              width: parent.width - toggle.width
                              Label {
                                  width: parent.width
                                  padding: 8
                                  leftPadding: 22
                                  text: title
                                  font: Theme.defaultFont
                                  wrapMode: Text.WordWrap
                                  MouseArea {
                                      anchors.fill: parent
                                      onClicked: toggle.toggle()
                                  }
                              }

                              Label {
                                  width: parent.width
                                  visible: !!description
                                  padding: !!description ? 8 : 0
                                  topPadding: 0
                                  leftPadding: 22
                                  text: description || ''
                                  font: Theme.tipFont
                                  color: Theme.gray
                                  wrapMode: Text.WordWrap
                              }
                          }

                          QfSwitch {
                              id: toggle
                              width: implicitContentWidth
                              checked: registry[settingAlias]
                              Layout.alignment: Qt.AlignTop | Qt.AlignRight
                              onCheckedChanged: registry[settingAlias] = checked
                          }
                      }
                  }

                  GridLayout {
                      Layout.fillWidth: true
                      Layout.leftMargin: 20
                      Layout.rightMargin: 20

                      columns: 2
                      columnSpacing: 0
                      rowSpacing: 5

                      Label {
                          text: qsTr("Customize search bar")
                          font: Theme.defaultFont
                          wrapMode: Text.WordWrap
                          Layout.fillWidth: true

                          MouseArea {
                              anchors.fill: parent
                              onClicked: showSearchBarSettings.clicked()
                          }
                      }

                      QfToolButton {
                          id: showSearchBarSettings
                          Layout.preferredWidth: 48
                          Layout.preferredHeight: 48
                          Layout.alignment: Qt.AlignVCenter
                          clip: true

                          iconSource: Theme.getThemeIcon( "ic_gear_black_24dp" )
                          bgcolor: "transparent"

                          onClicked: {
                              // to something
                              console.log('dd');
                          }
                      }
                  }
              }
          }
      }

      Item {
          ScrollView {
            topPadding: 5
            leftPadding: 20
            rightPadding: 20
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            contentWidth: positioningGrid.width
            contentHeight: positioningGrid.height
            anchors.fill: parent
            clip: true

          ColumnLayout {
              id: positioningGrid
              width: parent.parent.width
              spacing: 10

              GridLayout {
                  Layout.fillWidth: true

                  columns: 2
                  columnSpacing: 0
                  rowSpacing: 5

                  Label {
                      Layout.fillWidth: true
                      Layout.columnSpan: 2
                      text: qsTr( "Positioning device in use:" )
                      font: Theme.defaultFont

                      wrapMode: Text.WordWrap
                  }

                  RowLayout {
                      Layout.fillWidth: true
                      Layout.columnSpan: 2

                      ComboBox {
                          id: bluetoothDeviceComboBox
                          enabled: bluetoothDeviceModel.scanningStatus !== BluetoothDeviceModel.Scanning
                          Layout.fillWidth: true
                          Layout.alignment: Qt.AlignVCenter
                          textRole: 'display'
                          model: BluetoothDeviceModel {
                              id: bluetoothDeviceModel
                          }

                          property string selectedPositioningDevice

                          onCurrentIndexChanged: {
                              if( bluetoothDeviceModel.scanningStatus !== BluetoothDeviceModel.Scanning )
                              {
                                  selectedPositioningDevice = bluetoothDeviceModel.data(bluetoothDeviceModel.index(currentIndex, 0), BluetoothDeviceModel.DeviceAddressRole );
                              }
                              if( positioningSettings.positioningDevice !== selectedPositioningDevice )
                              {
                                  positioningSettings.positioningDevice = selectedPositioningDevice
                                  positioningSettings.positioningDeviceName = bluetoothDeviceModel.data(bluetoothDeviceModel.index(currentIndex, 0), BluetoothDeviceModel.DeviceNameRole );
                              }
                          }

                          Component.onCompleted: {
                              currentIndex = positioningSettings.positioningDevice == '' ? 0 : find(positioningSettings.positioningDeviceName + ' (' + positioningSettings.positioningDevice + ')');
                          }

                          Connections {
                              target: bluetoothDeviceModel

                              function onModelReset() {
                                  bluetoothDeviceComboBox.currentIndex = bluetoothDeviceModel.findAddressIndex(positioningSettings.positioningDevice)
                              }

                              function onScanningStatusChanged(scanningStatus) {
                                  if( scanningStatus === BluetoothDeviceModel.Scanning )
                                  {
                                      displayToast( qsTr('Scanning for paired devices') )
                                  }
                                  if( scanningStatus === BluetoothDeviceModel.Failed )
                                  {
                                      displayToast( qsTr('Scanning failed: %1').arg( bluetoothDeviceModel.lastError ) )
                                  }
                                  if( scanningStatus === BluetoothDeviceModel.Succeeded )
                                  {
                                      var message = qsTr('Scanning done')
                                      if ( bluetoothDeviceModel.rowCount() > 1 )
                                      {
                                          message += ': ' + qsTr( '%n device(s) found', '', bluetoothDeviceModel.rowCount() - 1 )
                                      }
                                      displayToast( message )
                                  }
                                  if( scanningStatus === BluetoothDeviceModel.Canceled )
                                  {
                                      displayToast( qsTr('Scanning canceled') )
                                  }
                              }
                          }
                      }

                      Rectangle {
                          color: "transparent"
                          Layout.preferredWidth: childrenRect.width
                          Layout.preferredHeight: childrenRect.height
                          Layout.alignment: Qt.AlignVCenter

                          QfButton {
                              id: scanButton
                              leftPadding: 10
                              rightPadding: 10
                              font: Theme.defaultFont
                              text: qsTr('Scan')

                              onClicked: {
                                  bluetoothDeviceModel.startServiceDiscovery( false )
                              }
                              onPressAndHold: {
                                  fullDiscoveryDialog.open()
                              }

                              enabled: bluetoothDeviceModel.scanningStatus !== BluetoothDeviceModel.Scanning
                              opacity: enabled ? 1 : 0
                          }


                          BusyIndicator {
                              id: busyIndicator
                              anchors.centerIn: scanButton
                              width: 36
                              height: 36
                              running: bluetoothDeviceModel.scanningStatus === BluetoothDeviceModel.Scanning
                          }
                      }

                      Dialog {
                          id: fullDiscoveryDialog
                          parent: mainWindow.contentItem

                          visible: false
                          modal: true

                          x: ( mainWindow.width - width ) / 2
                          y: ( mainWindow.height - height ) / 2

                          title: qsTr( "Make a full service discovery" )
                          Label {
                              width: parent.width
                              wrapMode: Text.WordWrap
                              text: qsTr( 'A full device scan can take longer. You really want to do it?\nCancel to make a minimal device scan instead.')
                          }

                          standardButtons: Dialog.Ok | Dialog.Cancel
                          onAccepted: {
                              bluetoothDeviceModel.startServiceDiscovery( true )
                              visible = false
                          }
                          onRejected: {
                              bluetoothDeviceModel.startServiceDiscovery( false )
                              visible = false
                          }
                      }
                  }

                  QfButton {
                      id: connectButton
                      Layout.fillWidth: true
                      Layout.columnSpan: 2
                      Layout.topMargin: 5
                      font: Theme.defaultFont
                      text: {
                          switch (positionSource.bluetoothSocketState)
                          {
                          case BluetoothSocket.Connected:
                              return qsTr('Connected to %1').arg(positioningSettings.positioningDeviceName)
                          case BluetoothSocket.Unconnected:
                              return qsTr('Connect  to %1').arg(positioningSettings.positioningDeviceName)
                          default:
                              return qsTr('Connecting to %1').arg(positioningSettings.positioningDeviceName)
                          }
                      }
                      enabled: positionSource.bluetoothSocketState === BluetoothSocket.Unconnected
                      visible: positioningSettings.positioningDevice !== ''

                      onClicked: {
                          // make sure positioning is active when connecting to the bluetooth device
                          if (!positioningSettings.positioningActivated) {
                              positioningSettings.positioningActivated = true
                          } else {
                              positionSource.connectBluetoothSource()
                          }
                      }
                  }

                  Label {
                      text: qsTr("Use orthometric altitude from device")
                      font: Theme.defaultFont
                      wrapMode: Text.WordWrap
                      Layout.fillWidth: true
                      visible: positioningSettings.positioningDevice !== ''

                      MouseArea {
                          anchors.fill: parent
                          onClicked: reportOrthometricAltitude.toggle()
                      }
                  }

                  QfSwitch {
                      id: reportOrthometricAltitude
                      Layout.preferredWidth: implicitContentWidth
                      Layout.alignment: Qt.AlignTop
                      visible: positioningSettings.positioningDevice !== ''
                      checked: !positioningSettings.ellipsoidalElevation
                      onCheckedChanged: {
                          positioningSettings.ellipsoidalElevation = !checked
                      }
                  }
              }

              GridLayout {
                  Layout.fillWidth: true

                  columns: 2
                  columnSpacing: 0
                  rowSpacing: 5

                  Label {
                      text: qsTr("Show position information")
                      font: Theme.defaultFont
                      wrapMode: Text.WordWrap
                      Layout.fillWidth: true

                      MouseArea {
                          anchors.fill: parent
                          onClicked: showPositionInformation.toggle()
                      }
                  }

                  QfSwitch {
                      id: showPositionInformation
                      Layout.preferredWidth: implicitContentWidth
                      Layout.alignment: Qt.AlignTop
                      checked: positioningSettings.showPositionInformation
                      onCheckedChanged: {
                          positioningSettings.showPositionInformation = checked
                      }
                  }

                  Label {
                      text: qsTr("Activate accuracy indicator")
                      font: Theme.defaultFont
                      wrapMode: Text.WordWrap
                      Layout.fillWidth: true

                      MouseArea {
                          anchors.fill: parent
                          onClicked: accuracyIndicator.toggle()
                      }
                  }

                  QfSwitch {
                      id: accuracyIndicator
                      Layout.preferredWidth: implicitContentWidth
                      Layout.alignment: Qt.AlignTop
                      checked: positioningSettings.accuracyIndicator
                      onCheckedChanged: {
                          positioningSettings.accuracyIndicator = checked
                      }
                  }

                  Label {
                      text: qsTr("Bad accuracy below [m]")
                      font: Theme.defaultFont
                      enabled: accuracyIndicator.checked
                      visible: accuracyIndicator.checked
                      Layout.leftMargin: 8
                  }

                  TextField {
                      id: accuracyBadInput
                      width: antennaHeightActivated.width
                      font: Theme.defaultFont
                      enabled: accuracyIndicator.checked
                      visible: accuracyIndicator.checked
                      horizontalAlignment: TextInput.AlignHCenter
                      Layout.preferredWidth: 60
                      Layout.preferredHeight: font.height + 20

                      inputMethodHints: Qt.ImhFormattedNumbersOnly
                      validator: DoubleValidator { locale: 'C' }

                      background: Rectangle {
                        y: parent.height - height - parent.bottomPadding / 2
                        implicitWidth: 120
                        height: parent.activeFocus ? 2: 1
                        color: parent.activeFocus ? '#4CAF50' : '#C8E6C9'
                      }

                      Component.onCompleted: {
                          text = isNaN( positioningSettings.accuracyBad ) ? '' : positioningSettings.accuracyBad
                      }

                      onTextChanged: {
                          if( text.length === 0 || isNaN(text) ) {
                              positioningSettings.accuracyBad = NaN
                          } else {
                              positioningSettings.accuracyBad = parseFloat( text )
                          }
                      }
                  }

                  Label {
                      text: qsTr("Excellent accuracy above [m]")
                      font: Theme.defaultFont
                      enabled: accuracyIndicator.checked
                      visible: accuracyIndicator.checked
                      Layout.leftMargin: 8
                  }

                  TextField {
                      id: accuracyExcellentInput
                      width: antennaHeightActivated.width
                      font: Theme.defaultFont
                      enabled: accuracyIndicator.checked
                      visible: accuracyIndicator.checked
                      horizontalAlignment: TextInput.AlignHCenter
                      Layout.preferredWidth: 60
                      Layout.preferredHeight: font.height + 20

                      inputMethodHints: Qt.ImhFormattedNumbersOnly
                      validator: DoubleValidator { locale: 'C' }

                      background: Rectangle {
                        y: parent.height - height - parent.bottomPadding / 2
                        implicitWidth: 120
                        height: parent.activeFocus ? 2: 1
                        color: parent.activeFocus ? '#4CAF50' : '#C8E6C9'
                      }

                      Component.onCompleted: {
                          text = isNaN( positioningSettings.accuracyExcellent ) ? '' : positioningSettings.accuracyExcellent
                      }

                      onTextChanged: {
                          if( text.length === 0 || isNaN(text) ) {
                              positioningSettings.accuracyExcellent = NaN
                          } else {
                              positioningSettings.accuracyExcellent = parseFloat( text )
                          }
                      }
                  }

                  Label {
                      text: qsTr("Enable accuracy requirement")
                      font: Theme.defaultFont
                      enabled: accuracyIndicator.checked
                      visible: accuracyIndicator.checked
                      wrapMode: Text.WordWrap
                      Layout.fillWidth: true
                      Layout.leftMargin: 8

                      MouseArea {
                          anchors.fill: parent
                          onClicked: accuracyIndicator.toggle()
                      }
                  }

                  QfSwitch {
                      id: accuracyRequirement
                      Layout.preferredWidth: implicitContentWidth
                      Layout.alignment: Qt.AlignTop
                      enabled: accuracyIndicator.checked
                      visible: accuracyIndicator.checked
                      checked: positioningSettings.accuracyRequirement
                      onCheckedChanged: {
                          positioningSettings.accuracyRequirement = checked
                      }
                  }

                  Label {
                      text: qsTr( "When the accuracy indicator is enabled, a badge is attached to the location button and colored <span %1>red</span> if the accuracy value is below bad, <span %2>yellow</span> if it falls short of excellent, or <span %3>green</span>.<br><br>In addition, an accuracy restriction mode can be toggled on, which restricts vertex addition when locked to coordinate cursor to positions with an accuracy value above the bad threshold." )
                                .arg("style='%1'".arg(Theme.toInlineStyles({color:Theme.errorColor})))
                                .arg("style='%1'".arg(Theme.toInlineStyles({color:Theme.warningColor})))
                                .arg("style='%1'".arg(Theme.toInlineStyles({color:Theme.mainColor})))
                      font: Theme.tipFont
                      color: Theme.gray
                      textFormat: Qt.RichText
                      wrapMode: Text.WordWrap
                      Layout.fillWidth: true
                  }

                  Item {
                      // empty cell in grid layout
                      width: 1
                  }

                  Label {
                      text: qsTr("Antenna height compensation")
                      font: Theme.defaultFont
                      wrapMode: Text.WordWrap
                      Layout.fillWidth: true

                      MouseArea {
                          anchors.fill: parent
                          onClicked: antennaHeightActivated.toggle()
                      }
                  }

                  QfSwitch {
                      id: antennaHeightActivated
                      Layout.preferredWidth: implicitContentWidth
                      Layout.alignment: Qt.AlignTop
                      checked: positioningSettings.antennaHeightActivated
                      onCheckedChanged: {
                          positioningSettings.antennaHeightActivated = checked
                      }
                  }

                  Label {
                      text: qsTr("Antenna height [m]")
                      enabled: antennaHeightActivated.checked
                      visible: antennaHeightActivated.checked
                      font: Theme.defaultFont
                      textFormat: Text.RichText
                      Layout.leftMargin: 8
                  }

                  TextField {
                      id: antennaHeightInput
                      enabled: antennaHeightActivated.checked
                      visible: antennaHeightActivated.checked
                      width: antennaHeightActivated.width
                      font: Theme.defaultFont
                      horizontalAlignment: TextInput.AlignHCenter
                      Layout.preferredWidth: 60
                      Layout.preferredHeight: font.height + 20

                      inputMethodHints: Qt.ImhFormattedNumbersOnly
                      validator: DoubleValidator { locale: 'C' }

                      background: Rectangle {
                        y: parent.height - height - parent.bottomPadding / 2
                        implicitWidth: 120
                        height: parent.activeFocus ? 2: 1
                        color: parent.activeFocus ? '#4CAF50' : '#C8E6C9'
                      }

                      Component.onCompleted: {
                          text = isNaN( positioningSettings.antennaHeight ) ? '' : positioningSettings.antennaHeight
                      }

                      onTextChanged: {
                          if( text.length === 0 || isNaN(text) ) {
                              positioningSettings.antennaHeight = NaN
                          } else {
                              positioningSettings.antennaHeight = parseFloat( text )
                          }
                      }
                  }

                  Label {
                      text: qsTr( "Z values which are recorded from the positioning device will be corrected by this value. If a value of 1.6 is entered, this will result in a correction of -1.6 for each recorded value." )
                      font: Theme.tipFont
                      color: Theme.gray

                      wrapMode: Text.WordWrap
                      Layout.fillWidth: true
                  }

                  Item {
                      // empty cell in grid layout
                      width: 1
                  }

                  Label {
                      text: qsTr( "Skip altitude correction" )
                      font: Theme.defaultFont
                      wrapMode: Text.WordWrap
                      Layout.fillWidth: true

                      MouseArea {
                          anchors.fill: parent
                          onClicked: skipAltitudeCorrectionSwitch.toggle()
                      }
                  }

                  QfSwitch {
                      id: skipAltitudeCorrectionSwitch
                      Layout.preferredWidth: implicitContentWidth
                      Layout.alignment: Qt.AlignTop
                      checked: positioningSettings.skipAltitudeCorrection
                      onCheckedChanged: {
                          positioningSettings.skipAltitudeCorrection = checked
                      }
                  }

                  Label {
                      topPadding: 0
                      text: qsTr( "Use the altitude as reported by the positioning device. Skip any altitude correction that may be implied by the coordinate system transformation." )
                      font: Theme.tipFont
                      color: Theme.gray

                      wrapMode: Text.WordWrap
                      Layout.fillWidth: true
                  }
              }

              ColumnLayout {
                  Layout.fillWidth: true

                  Label {
                      text: qsTr( "Vertical grid shift in use:" )
                      font: Theme.defaultFont

                      wrapMode: Text.WordWrap
                      Layout.fillWidth: true
                  }

                  ComboBox {
                      Layout.fillWidth: true
                      model: [ qsTr( "None" ) ].concat( platformUtilities.availableGrids() );

                      onCurrentIndexChanged: {
                          positioningSettings.verticalGrid = currentIndex > 0 ? platformUtilities.availableGrids()[currentIndex - 1] : '';
                      }

                      Component.onCompleted: {
                          currentIndex = positioningSettings.verticalGrid != '' ? find(positioningSettings.verticalGrid) : 0;
                      }
                  }

                  Label {
                      topPadding: 0
                      rightPadding: antennaHeightActivated.width
                      text: qsTr( "Vertical grid shift is used to increase the altitude accuracy." )
                      font: Theme.tipFont
                      color: Theme.gray

                      wrapMode: Text.WordWrap
                      Layout.fillWidth: true
                  }
              }

              Item {
                  // spacer item
                  Layout.fillWidth: true
                  Layout.fillHeight: true
              }
            }
          }
        }

      Item {
          VariableEditor {
              id: variableEditor
              anchors.fill: parent
              anchors.margins: 4
          }
      }
    }
  }

  header: PageHeader {
      title: qsTr("QField Settings")

      showApplyButton: true
      showCancelButton: false

      onFinished: {
          parent.finished()
          variableEditor.apply()
      }
    }

  Keys.onReleased: {
    if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape) {
      event.accepted = true
      variableEditor.apply()
    }
  }
}
