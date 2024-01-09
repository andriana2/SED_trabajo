/*
 * ds18b20.h
 *
 *  Created on: Jan 4, 2024
 */

#ifndef INC_DS18B20_H_
#define INC_DS18B20_H_

#include "stm32f4xx_hal.h"

uint8_t DS18B20_Start(void);
void DS18B20_Write(uint8_t data);
uint8_t DS18B20_Read(void);
float DS18B20_Get_Temp(void);


#endif /* INC_DS18B20_H_ */

