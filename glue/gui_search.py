from math import radians, cos, sin, asin, sqrt

from pyWL.database import Station

class Stops:
    def get(self, term):
        stations = Station.search_by_name(term, weight='line_count')
        return [x['name'] for x in stations]

    def get_nearby(self, lat, lon, distance=0.007):
        return sorted([_distance(s, lat, lon) for s in Station.get_nearby(lat, lon, distance)],
            key=lambda s: s['distance'])

def _distance(station, lat, lon):
    station['distance'] = round(_haversine(lat, lon, station['lat'], station['lon']), 2 )
    return station

# stolen from http://stackoverflow.com/questions/4913349/haversine-formula-in-python-bearing-and-distance-between-two-gps-points
def _haversine(lat1, lon1, lat2, lon2):
    """
    Calculate the great circle distance between two points
    on the earth (specified in decimal degrees)
    """
    # convert decimal degrees to radians
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])

    # haversine formula
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a))

    # 6367 km is the radius of the Earth
    km = 6367 * c
    return km

stops = Stops()
