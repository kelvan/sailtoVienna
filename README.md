sailtoVienna
============

Wienerlinien departure app for SailfishOS

Requirements
------------
 - QT5
 - pyotherside
 - QtGraphicalEffects
 - python >= 3.3 (not tested with 3.2)

pyWL
----

    git submodule init
    git submodule update pyWL

see pyWL github project for howto import stations and add apikey

Generic QML2 test gui
---------------------

    qmlscene qml/desktop/search.qml # search and departures

or

    qmlscene qml/desktop/stations.qml # stations of line

Silica QML2 gui
--------------

    # for pyWL setup see pyWL readme
    mkdir /usr/share/harbour-sailtovienna/
    ln -s /home/nemo/<path-to-sailtovienna>/pyWL /usr/share/harbour-sailtovienna/pyWL
    ln -s /home/nemo/<path-to-sailtovienna>/data /usr/share/harbour-sailtovienna/data
    ln -s /home/nemo/<path-to-sailtovienna>/translations /usr/share/harbour-sailtovienna/translations
    ln -s /home/nemo/<path-to-sailtovienna>/glue /usr/share/harbour-sailtovienna/glue
    ln -s /home/nemo/<path-to-sailtovienna>/qml/silica/ /usr/share/harbour-sailtovienna/qml
    ln -s /home/nemo/<path-to-sailtovienna>/data/harbour-sailtovienna.png /usr/share/icons/hicolor/86x86/apps/
    ln -s /home/nemo/<path-to-sailtovienna>/data/harbour-sailtovienna.desktop /usr/share/applications/sailtoVienna.desktop
