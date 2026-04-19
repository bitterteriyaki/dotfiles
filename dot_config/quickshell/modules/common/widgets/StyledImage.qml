import QtQuick

Image {
  asynchronous: true
  retainWhileLoading: true

  visible: opacity > 0
  opacity: (status === Image.Ready) ? 1 : 0
}
