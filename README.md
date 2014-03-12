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

    rsync -Cav . root@jolla:/usr/share/sailtoVienna --exclude qml
    rsync -Cav qml/silica/ root@jolla:/usr/share/sailtoVienna/qml
    sailfish-qml sailtoVienna #on device

or

    cp data/sailtoVienna.desktop.sailfish /usr/share/applications/sailtoVienna.desktop #on device and then use the launcher
