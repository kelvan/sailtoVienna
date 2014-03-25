from pyWL.database import Station

class Stops:
    def get(self, term):
        stations = Station.search_by_name(term, weight='line_count')
        return [x['name'] for x in stations]

    def get_nearby(self, lat, lon, distance=0.005):
        return list(Station.get_nearby(lat, lon, distance))


stops = Stops()
