TARGET = harbour-sailtovienna

CONFIG += sailfishapp_qml
CONFIG += sailfishapp_i18n

pywl.files = $$files(pyWL/*)
pywl.path = /usr/share/$${TARGET}/pyWL

glue.files = $$files(glue/*)
glue.path = /usr/share/$${TARGET}/glue

INSTALLS += pywl glue

TRANSLATIONS += translations/$${TARGET}-de.ts
