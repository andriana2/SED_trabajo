/*
 * lcd_userConf.h
 *
 *  Created on: Jan 6, 2024
 */

#ifndef INC_LCD_USERCONF_H_
#define INC_LCD_USERCONF_H_

uint8_t i2cDeviceAddr = 0x4E; //* LCD i2c module default address, change i2c device address here, default is 0x4E.

/**
*@brief: I2C_HandleTypeDef define.
*@val: Default: hi2c1
*/
I2C_HandleTypeDef hi2cx;
extern I2C_HandleTypeDef hi2c1; //* Change "hi2c1" like hi2c2, hi2c3... according to which i2c type(i2c1,i2c2...) you use, default is hi2c1.
                                //That I2C_HandleTypeDef hi2c1 comes from main.c*.
static void hi2cx_define(void)
{
	hi2cx = hi2c1;	//* Change "hi2c1" like hi2c2, hi2c3... according to which i2c type you use, default is hi2c1.
}

/**
*@brief: LCD (Character x Line) number definition.
*@val: Default: lcd 16x2
*/
//Uncomment which one you want to use and comment the default.
#define LCD_16x2
//#define LCD_16x4
//#define LCD_20x2
//#define LCD_20x4

/**
*@brief: Buffer data character number.
*@val: Default: BFR_MAX=100 (Maksimum BFR_MAX=255).
*/
#define BFR_MAX 100 //*Change it if you want to use a different value.


#endif /* INC_LCD_USERCONF_H_ */

/*************************END OF FILE*****************************/
