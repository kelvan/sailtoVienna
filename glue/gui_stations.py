from pyWL.database import Line

class Stations:
    def get(self, line):
        result = []
        line = line.upper()
        l = Line.get_by_name(line)

        if l is None:
            s = Line.search_by_name(line)
            result.append('Line not found')
            if s:
                result.append('Did you mean:')
                for line in s:
                    result.append(line['name'])
        else:
            i = 1
            for direction in l.get_stations():
                result.append('* Direction %d' % i)
                result += [station['name'] for station in direction]
                if i == 1:
                    result.append('')
                i += 1

        return result

stations = Stations()
