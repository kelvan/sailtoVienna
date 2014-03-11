from pyWL.database import Station

class Stops:
    def get(self, term):
        stations = Station.search_by_name(term, weight='line_count')
        return [x['name'] for x in stations]

stops = Stops()
