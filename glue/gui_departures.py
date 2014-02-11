from operator import itemgetter

from realtime import Departures
from database import Station


class Deps:
    def get(self, name):
        stations = Station.search_by_name(name)

        rbl = []
        for st in stations:
            rbl += list(st.get_stops())

        departures = Departures.get_by_stops(rbl)

        result_dicts = []
        for station in sorted(departures.values(), key=itemgetter('name')):
            for departure in sorted(station['departures'], key=itemgetter('countdown')):
                bar = ('timePlanned', 'timeReal')
                for foo in bar:
                    if foo in departure:
                        del(departure[foo])

                result_dicts.append(departure)

        return result_dicts

deps = Deps()
