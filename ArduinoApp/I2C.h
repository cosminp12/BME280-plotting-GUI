#ifndef I2C_H
#define I2C_H

#include "DataTypes.h"

uint8 I2C_WriteData(uint8 device_addr, uint8 register_addr, uint8* data, uint8 length);
uint8 I2C_ReadData(uint8 device_addr, uint8 register_addr, uint8* data, uint8 length);

#endif	/* I2C_H */

