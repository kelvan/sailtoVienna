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

    qmlviewer qml/search.qml # search and departures

or

    qmlviewer qml/stations.qml # stations of line
