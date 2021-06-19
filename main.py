from PyQt5.QtGui import QGuiApplication, QIcon
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QFile, QJsonDocument, QJsonParseError, QJsonValue, QObject, pyqtSlot
import sys
from radar import Radar_det
from ais import Ais_det
import time
import ctypes

ctypes.windll.shell32.SetCurrentProcessExplicitAppUserModelID("myappid")

# sys.path.append("D:\\wslhome\\project\\unman_py\\dlls")

class DJson(QObject):
    def __init__(self):
        super().__init__()

    @pyqtSlot(str,result=QJsonValue)
    def readJsonFile(self, path):
        file = QFile(path)
        if(file.open(QFile.ReadOnly | QFile.Text) != 1):
            print("Open json file failed!")
            return QJsonValue()
        data = file.readAll()
        if(data.isEmpty()):
            return QJsonValue()
        error = QJsonParseError()
        json = QJsonDocument.fromJson(data, error)
        if(error.error != QJsonParseError.NoError):
            print("erro")
            return QJsonValue()
        rootObj = json.object()
        if(file.isOpen()):
            file.close()

        return rootObj


if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    icon = QIcon('./images/jm.png')
    app.setWindowIcon(icon)

    engine = QQmlApplicationEngine()
    
    djson = DJson()
    engine.rootContext().setContextProperty('Djson', djson)

    radar_det = Radar_det()
    engine.rootContext().setContextProperty('Radar_det', radar_det)

    ais_det = Ais_det()
    engine.rootContext().setContextProperty('Ais_det', ais_det)

    # engine.load('./qmls/test.qml')
    #url = QUrl('test.qml')
    engine.load('main.qml')

    if not engine.rootObjects():
        sys.exit(-1)

    #view.setSource(url)
    #view.show()
    sys.exit(app.exec_())
