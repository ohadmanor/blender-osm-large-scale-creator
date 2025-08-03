"""
This file is a part of Blosm addon for Blender.
Copyright (C) 2014-2018 Vladimir Elistratov
prokitektura+support@gmail.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""
import math

# see conversion formulas at
# http://en.wikipedia.org/wiki/Transverse_Mercator_projection
# and
# http://mathworld.wolfram.com/MercatorProjection.html
class TransverseMercator:
    radius = 6378137.

    def __init__(self, **kwargs):
        # setting default values
        self.lat = 0. # in degrees phi Y
        self.lon = 0. # in degrees lamda X
        #self.k = 1. # scale factor - inaccurate for large 3Dtiles deployment
        
        for attr in kwargs:
            setattr(self, attr, kwargs[attr])
        self.latInRadians = math.radians(self.lat)

    def fromGeographic(self, lat, lon):
        lat = math.radians(lat)
        lon = math.radians(lon-self.lon)
        B = math.sin(lon) * math.cos(lat)
        # scale factor calculator based on: https://en.wikipedia.org/wiki/Mercator_projection#Derivation_of_the_Mercator_projection Scale factor
        k0 = 0.00862463*lat*lat - 0.00143612*lat + 0.99417459
        kx = -40*k0*k0 + 79.336*k0-38.8353831
        kc = k0/(math.sqrt(1 - math.sin(lon)**2 * math.cos(lat)**2))
        
        x = kx * kc * self.radius * math.log((1.+B)/(1.-B))
        y = kc * self.radius * (math.atan(math.tan(lat)/math.cos(lon)) - self.latInRadians)
        return (x, y, 0.)

    def toGeographic(self, x, y):
        x = x/(self.k * self.radius)
        y = y/(self.k * self.radius)
        D = y + self.latInRadians
        lon = math.atan(math.sinh(x)/math.cos(D))
        lat = math.asin(math.sin(D)/math.cosh(x))

        lon = self.lon + math.degrees(lon)
        lat = math.degrees(lat)
        return (lat, lon)