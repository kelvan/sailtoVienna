from operator import itemgetter

from pyWL.realtime import Departures
from pyWL.database import Station


class Deps:
    def get(self, name):
        stations = Station.search_by_name(name, exact=True)

        rbl = []
        for st in stations:
            rbl += list(st.get_stops())

        departures = Departures.get_by_stops(rbl)

        result_dicts = []
        for station in sorted(departures.values(), key=itemgetter('name')):
            for departure in sorted(station['departures'], key=itemgetter('countdown')):
                if not departure['line']['colour']:
                    departure['line']['colour'] = 'transparent'
                result_dicts.append(departure)

        return result_dicts

    def filter_line(self, name, line):
        deps = self.get(name)
        return [dep for dep in deps if dep['line']['name'] == line]

    def filter_towards(self, name, towards):
        deps = self.get(name)
        return [dep for dep in deps if dep['line']['towards'] == towards]

deps = Deps()
