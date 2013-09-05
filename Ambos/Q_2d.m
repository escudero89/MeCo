## Copyright (C) 2013 Marcos
## 
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## conduccionCalor_estacionario_2d

## Author: Marcos <marcos@marcosNetbook>
## Created: 2013-09-04

function [ Q ] = Q_2d(XX, YY)

    Q = 2 * (XX.^2 + YY.^2);

endfunction;
