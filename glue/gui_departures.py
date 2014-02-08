from operator import itemgetter

from realtime import Departures
from database import Station


class Deps:
    def get(self, name):
        result = []
        stations = Station.search_by_name(name)

        rbl = []
        for st in stations:
            rbl += list(st.get_stops())

        deps = Departures.get_by_stops(rbl)

        for station in sorted(deps.values(), key=itemgetter('name')):
            result.append('='*len(station['name']))
            result.append(station['name'])
            result.append('='*len(station['name']))

            for departure in sorted(station['departures'], key=itemgetter('countdown')):
                dep_text = departure['line']['name'].ljust(6)
                dep_text += departure['line']['towards'].ljust(20)
                if departure['line']['barrierFree']:
                    dep_text += str(departure['countdown']).rjust(4)
                else:
                    dep_text += str(departure['countdown']).rjust(4)

                result.append(dep_text)

        return result

deps = Deps()
