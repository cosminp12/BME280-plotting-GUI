/**************************************************************************

 Aimed to provide a more standard and portable I2C API.

 Copyright (C) 2016, Cosmin Plasoianu

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

***************************************************************************/

#include "I2C.h"
#include <Wire.h>

uint8 I2C_WriteData(uint8 device_addr, uint8 register_addr, uint8* data, uint8 length)
{
  Wire.beginTransmission(device_addr);
  Wire.write(register_addr);
  Wire.write(data, length);
  return(Wire.endTransmission());
}

uint8 I2C_ReadData(uint8 device_addr, uint8 register_addr, uint8* data, uint8 length)
{
  uint8 cnt = 0;
  
  Wire.beginTransmission(device_addr);
  Wire.write(register_addr);
  if(Wire.endTransmission())
    return 1;
  
  if(Wire.requestFrom(device_addr, length) != length)
    return 2;
  while(length--)
    data[cnt++] = Wire.read();
    
  return 0;
}

