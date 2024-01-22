/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "ds18b20.h"
#include "lcd_i2cModule.h"
#include "stdio.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
ADC_HandleTypeDef hadc1;

I2C_HandleTypeDef hi2c1;

TIM_HandleTypeDef htim1;
TIM_HandleTypeDef htim3;
TIM_HandleTypeDef htim10;
TIM_HandleTypeDef htim11;

UART_HandleTypeDef huart2;

/* USER CODE BEGIN PV */

uint32_t LCD_Menu=0;

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_ADC1_Init(void);
static void MX_TIM1_Init(void);
static void MX_TIM3_Init(void);
static void MX_TIM10_Init(void);
static void MX_TIM11_Init(void);
static void MX_I2C1_Init(void);
static void MX_USART2_UART_Init(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

//variables de control de temperatura
float Temperature = 0;

//variables de control de la habitacion
volatile int boton_habitacion=0;
int estadohabitacion=0;

//variables de control de jardin
int16_t adcval_jardin;
uint32_t periodo=255;
int estadojardin=0;

//variables de control de pasillo
uint32_t echo, delay2;
float dis;
int estadopasillo=0;

//Conexion para el sensor de ultrasonidos
#ifdef GNUC
#define PUTCHAR_PROTOTYPE int to_putchar (int ch)
#else
#define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif
PUTCHAR_PROTOTYPE{
	HAL_UART_Transmit(&huart2, (uint8_t *)&ch, 1, 10);
	return ch;
}

//Interrupcion del ADC
void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef* hadc){
	 if (hadc->Instance == ADC1){
	 adcval_jardin = HAL_ADC_GetValue(&hadc1);
	 }
	}

//Interrupcion del boton del pulsador
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
	if(GPIO_Pin==GPIO_PIN_2)
		boton_habitacion=1;
}

//Debouncer del pulsador de la habitacion
int debouncer(volatile int* boton_habitacion, GPIO_TypeDef* GPIO_port, uint16_t GPIO_number){
	static uint8_t button_count=0;
	static int counter=0;

	if(*boton_habitacion==1){
		if (button_count==0){
			counter=HAL_GetTick();
			button_count++;
		}
		if(HAL_GetTick()-counter>=20){
			counter=HAL_GetTick();
			if(HAL_GPIO_ReadPin(GPIO_port,GPIO_number)!=1){
				button_count=1;
			}
			else{
				button_count++;
			}
			if(button_count==4){
				button_count=0;
				*boton_habitacion=0;
				return 1;
			}
		}
	}
	return 0;
}

//Temporizador del sensor de temperatura
void delay (uint16_t time)
{
	__HAL_TIM_SET_COUNTER(&htim11, 0);
	while ((__HAL_TIM_GET_COUNTER(&htim11))<time);
}

//Zumbador del control de temperatura
void AlarmSet(double alarm_level)
{
	if(Temperature <= 0  || Temperature >= 30)
	{
		HAL_GPIO_WritePin(GPIOD, GPIO_PIN_14, GPIO_PIN_SET);      //Alarma On con LED ROJO
	    HAL_GPIO_WritePin(GPIOD, GPIO_PIN_12, GPIO_PIN_RESET);
	}
	else
	{
		HAL_GPIO_WritePin(GPIOD, GPIO_PIN_14, GPIO_PIN_RESET);    //Alarm Off con LED VERDE
	    HAL_GPIO_WritePin(GPIOD, GPIO_PIN_12, GPIO_PIN_SET);
	}
}

//Control del menu por medio del boton
void Button_Set()
{
	static uint32_t button=0, button_flag=0, counter=0;

	button = HAL_GPIO_ReadPin(GPIOA, GPIO_PIN_0);
    if(button)
			button_flag=1;

		  if(!button&&button_flag==1){
				button_flag=0;
				counter++;
				if(counter == 1) LCD_Menu = 1;
				if(counter == 2) LCD_Menu = 2;
				if(counter == 3) LCD_Menu = 3;
				if(counter == 4) LCD_Menu = 4;
                if(counter == 5) {counter = 0; LCD_Menu = 0;}
			}
}

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_ADC1_Init();
  MX_TIM1_Init();
  MX_TIM3_Init();
  MX_TIM10_Init();
  MX_TIM11_Init();
  MX_I2C1_Init();
  MX_USART2_UART_Init();
  /* USER CODE BEGIN 2 */

  //Temporizador de jardin
  HAL_TIM_PWM_Start(&htim3, TIM_CHANNEL_2);

  //Temporizador de temperatura
  HAL_TIM_Base_Start(&htim11);
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_12, GPIO_PIN_SET);

  //Temporizador de pasillo
  HAL_TIM_Base_Start(&htim10);
  HAL_TIM_PWM_Start(&htim10, TIM_CHANNEL_1);
  HAL_TIM_IC_Start(&htim1, TIM_CHANNEL_1);
  TIM10->CCR1 =3;

  //Muestra del menu LCD
  LCD_i2cDeviceCheck();
  LCD_Init();
  LCD_BackLight(LCD_BL_ON);
  LCD_SetCursor(1,1);
  LCD_Send_String("INICIANDO>>>>",STR_NOSLIDE);
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_12, GPIO_PIN_SET);
  HAL_Delay(2000);
  LCD_Clear ();


  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */

	  	  	  	  //Funcion del boton del menu
	          	Button_Set();

	             //Funcion que calcula la temperatura
	          	Temperature =  DS18B20_Get_Temp();
	          	AlarmSet(0);

	             //Uso del debouncer para el boton de la habitacion
	          	if(debouncer(&boton_habitacion,GPIOA,GPIO_PIN_2)){
	          		estadohabitacion++;
	          		HAL_GPIO_TogglePin(GPIOD,GPIO_PIN_9);
	          	}

	             //Codigo para encender el Led del jardin
	             HAL_ADC_Start_IT(&hadc1);
	             if (adcval_jardin>=50){
	             	__HAL_TIM_SET_COMPARE(&htim3, TIM_CHANNEL_2, 0);
	             	estadojardin=0;
	             }
	            else{
	         	   __HAL_TIM_SET_COMPARE(&htim3, TIM_CHANNEL_2, periodo-adcval_jardin*5);
	                estadojardin=1;
	            }
	            HAL_ADC_Stop(&hadc1);

	            //Codigo para encender el Led del pasillo segun la distancia
	            if(HAL_GetTick()- delay2 >=100){
	         	   delay2 = HAL_GetTick();
	             	echo = HAL_TIM_ReadCapturedValue(&htim1, TIM_CHANNEL_1);
	             	dis = echo / 11.60f;
	            }
	            if(dis<30)
	            {
	              	estadopasillo = 1;
	              	HAL_GPIO_WritePin(GPIOD,GPIO_PIN_10,GPIO_PIN_SET);
	            }
	            else
	            {
	         	   estadopasillo = 0;
	                HAL_GPIO_WritePin(GPIOD,GPIO_PIN_10,GPIO_PIN_RESET);
	            }

	            	   //Codigo para la gestion del menu en la pantalla LCD
	             	switch(LCD_Menu)
	                {
	             	//Menu principal
	             	case 0:
	             		LCD_Clear ();
	             		HAL_GPIO_WritePin(GPIOD, GPIO_PIN_12, GPIO_PIN_SET);
	             		HAL_GPIO_WritePin(GPIOD, GPIO_PIN_14, GPIO_PIN_RESET);
	             		LCD_SetCursor(1,1);
	             		LCD_Send_String("Select Menu!",STR_NOSLIDE);
	             		LCD_SetCursor(2,1);
	             		LCD_Send_String("Push Blue Button",STR_NOSLIDE);
	                 break;
	                 //Menu de temperatura
	                 case 1:
	                 	LCD_Clear ();
	                    	Display_Temp(Temperature);
	                 break;
	                 //Menu de la habitacion
	                 case 2:
	                 	LCD_Clear ();
	                		LCD_SetCursor(1,1);
	                		LCD_Send_String("LUZ HABITACION: ",STR_NOSLIDE);
	                    	LCD_SetCursor(2,1);
	                    	if(estadohabitacion%2==0)
	                    		LCD_Send_String("       OFF",STR_NOSLIDE);
	                    	else
	                    		LCD_Send_String("       ON",STR_NOSLIDE);
	                    	HAL_Delay(500);
	                 break;
	                 //Menu del jardin
	                 case 3:
	                 	LCD_Clear ();
	                 	LCD_SetCursor(1,1);
	                 	LCD_Send_String("LUZ JARDIN: ",STR_NOSLIDE);
	                 	LCD_SetCursor(2,1);
	                 	if(estadojardin==0)
	                 		LCD_Send_String("       OFF",STR_NOSLIDE);
	                 	if(estadojardin==1)
	                 		LCD_Send_String("       ON",STR_NOSLIDE);
	                 	HAL_Delay(500);
	                 break;
	                   //Menu del pasillo
	                 case 4:
	                 	LCD_Clear ();
	                 	LCD_SetCursor(1,1);
	                 	LCD_Send_String("LUZ PASILLO: ",STR_NOSLIDE);
	                 	if(estadopasillo==0)
	                 		LCD_Send_String("OFF",STR_NOSLIDE);
	                 	if(estadopasillo==1)
	                 		LCD_Send_String("ON",STR_NOSLIDE);
	                 	Display_Dis(dis);
	                 	HAL_Delay(500);
	                break;
	                //Otro caso
	                 default:
	                 	LCD_Clear ();
	                 break;
	                }

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 4;
  RCC_OscInitStruct.PLL.PLLN = 50;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 4;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_3) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief ADC1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_ADC1_Init(void)
{

  /* USER CODE BEGIN ADC1_Init 0 */

  /* USER CODE END ADC1_Init 0 */

  ADC_ChannelConfTypeDef sConfig = {0};

  /* USER CODE BEGIN ADC1_Init 1 */

  /* USER CODE END ADC1_Init 1 */

  /** Configure the global features of the ADC (Clock, Resolution, Data Alignment and number of conversion)
  */
  hadc1.Instance = ADC1;
  hadc1.Init.ClockPrescaler = ADC_CLOCK_SYNC_PCLK_DIV4;
  hadc1.Init.Resolution = ADC_RESOLUTION_12B;
  hadc1.Init.ScanConvMode = DISABLE;
  hadc1.Init.ContinuousConvMode = DISABLE;
  hadc1.Init.DiscontinuousConvMode = DISABLE;
  hadc1.Init.ExternalTrigConvEdge = ADC_EXTERNALTRIGCONVEDGE_NONE;
  hadc1.Init.ExternalTrigConv = ADC_SOFTWARE_START;
  hadc1.Init.DataAlign = ADC_DATAALIGN_RIGHT;
  hadc1.Init.NbrOfConversion = 1;
  hadc1.Init.DMAContinuousRequests = DISABLE;
  hadc1.Init.EOCSelection = ADC_EOC_SINGLE_CONV;
  if (HAL_ADC_Init(&hadc1) != HAL_OK)
  {
    Error_Handler();
  }

  /** Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time.
  */
  sConfig.Channel = ADC_CHANNEL_3;
  sConfig.Rank = 1;
  sConfig.SamplingTime = ADC_SAMPLETIME_3CYCLES;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN ADC1_Init 2 */

  /* USER CODE END ADC1_Init 2 */

}

/**
  * @brief I2C1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_I2C1_Init(void)
{

  /* USER CODE BEGIN I2C1_Init 0 */

  /* USER CODE END I2C1_Init 0 */

  /* USER CODE BEGIN I2C1_Init 1 */

  /* USER CODE END I2C1_Init 1 */
  hi2c1.Instance = I2C1;
  hi2c1.Init.ClockSpeed = 100000;
  hi2c1.Init.DutyCycle = I2C_DUTYCYCLE_2;
  hi2c1.Init.OwnAddress1 = 0;
  hi2c1.Init.AddressingMode = I2C_ADDRESSINGMODE_7BIT;
  hi2c1.Init.DualAddressMode = I2C_DUALADDRESS_DISABLE;
  hi2c1.Init.OwnAddress2 = 0;
  hi2c1.Init.GeneralCallMode = I2C_GENERALCALL_DISABLE;
  hi2c1.Init.NoStretchMode = I2C_NOSTRETCH_DISABLE;
  if (HAL_I2C_Init(&hi2c1) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN I2C1_Init 2 */

  /* USER CODE END I2C1_Init 2 */

}

/**
  * @brief TIM1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM1_Init(void)
{

  /* USER CODE BEGIN TIM1_Init 0 */

  /* USER CODE END TIM1_Init 0 */

  TIM_SlaveConfigTypeDef sSlaveConfig = {0};
  TIM_MasterConfigTypeDef sMasterConfig = {0};
  TIM_IC_InitTypeDef sConfigIC = {0};

  /* USER CODE BEGIN TIM1_Init 1 */

  /* USER CODE END TIM1_Init 1 */
  htim1.Instance = TIM1;
  htim1.Init.Prescaler = 79;
  htim1.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim1.Init.Period = 65535;
  htim1.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim1.Init.RepetitionCounter = 0;
  htim1.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_Base_Init(&htim1) != HAL_OK)
  {
    Error_Handler();
  }
  if (HAL_TIM_IC_Init(&htim1) != HAL_OK)
  {
    Error_Handler();
  }
  sSlaveConfig.SlaveMode = TIM_SLAVEMODE_RESET;
  sSlaveConfig.InputTrigger = TIM_TS_TI1FP1;
  sSlaveConfig.TriggerPolarity = TIM_INPUTCHANNELPOLARITY_RISING;
  sSlaveConfig.TriggerFilter = 0;
  if (HAL_TIM_SlaveConfigSynchro(&htim1, &sSlaveConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim1, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sConfigIC.ICPolarity = TIM_INPUTCHANNELPOLARITY_RISING;
  sConfigIC.ICSelection = TIM_ICSELECTION_DIRECTTI;
  sConfigIC.ICPrescaler = TIM_ICPSC_DIV1;
  sConfigIC.ICFilter = 0;
  if (HAL_TIM_IC_ConfigChannel(&htim1, &sConfigIC, TIM_CHANNEL_1) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM1_Init 2 */

  /* USER CODE END TIM1_Init 2 */

}

/**
  * @brief TIM3 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM3_Init(void)
{

  /* USER CODE BEGIN TIM3_Init 0 */

  /* USER CODE END TIM3_Init 0 */

  TIM_MasterConfigTypeDef sMasterConfig = {0};
  TIM_OC_InitTypeDef sConfigOC = {0};

  /* USER CODE BEGIN TIM3_Init 1 */

  /* USER CODE END TIM3_Init 1 */
  htim3.Instance = TIM3;
  htim3.Init.Prescaler = 0;
  htim3.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim3.Init.Period = 65535;
  htim3.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim3.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_PWM_Init(&htim3) != HAL_OK)
  {
    Error_Handler();
  }
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  if (HAL_TIMEx_MasterConfigSynchronization(&htim3, &sMasterConfig) != HAL_OK)
  {
    Error_Handler();
  }
  sConfigOC.OCMode = TIM_OCMODE_PWM1;
  sConfigOC.Pulse = 0;
  sConfigOC.OCPolarity = TIM_OCPOLARITY_HIGH;
  sConfigOC.OCFastMode = TIM_OCFAST_DISABLE;
  if (HAL_TIM_PWM_ConfigChannel(&htim3, &sConfigOC, TIM_CHANNEL_2) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM3_Init 2 */

  /* USER CODE END TIM3_Init 2 */
  HAL_TIM_MspPostInit(&htim3);

}

/**
  * @brief TIM10 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM10_Init(void)
{

  /* USER CODE BEGIN TIM10_Init 0 */

  /* USER CODE END TIM10_Init 0 */

  TIM_OC_InitTypeDef sConfigOC = {0};

  /* USER CODE BEGIN TIM10_Init 1 */

  /* USER CODE END TIM10_Init 1 */
  htim10.Instance = TIM10;
  htim10.Init.Prescaler = 199;
  htim10.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim10.Init.Period = 39999;
  htim10.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim10.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_Base_Init(&htim10) != HAL_OK)
  {
    Error_Handler();
  }
  if (HAL_TIM_PWM_Init(&htim10) != HAL_OK)
  {
    Error_Handler();
  }
  sConfigOC.OCMode = TIM_OCMODE_PWM1;
  sConfigOC.Pulse = 0;
  sConfigOC.OCPolarity = TIM_OCPOLARITY_HIGH;
  sConfigOC.OCFastMode = TIM_OCFAST_DISABLE;
  if (HAL_TIM_PWM_ConfigChannel(&htim10, &sConfigOC, TIM_CHANNEL_1) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM10_Init 2 */

  /* USER CODE END TIM10_Init 2 */
  HAL_TIM_MspPostInit(&htim10);

}

/**
  * @brief TIM11 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM11_Init(void)
{

  /* USER CODE BEGIN TIM11_Init 0 */

  /* USER CODE END TIM11_Init 0 */

  /* USER CODE BEGIN TIM11_Init 1 */

  /* USER CODE END TIM11_Init 1 */
  htim11.Instance = TIM11;
  htim11.Init.Prescaler = 50-1;
  htim11.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim11.Init.Period = 0xFFFF-1;
  htim11.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim11.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_Base_Init(&htim11) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM11_Init 2 */

  /* USER CODE END TIM11_Init 2 */

}

/**
  * @brief USART2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_USART2_UART_Init(void)
{

  /* USER CODE BEGIN USART2_Init 0 */

  /* USER CODE END USART2_Init 0 */

  /* USER CODE BEGIN USART2_Init 1 */

  /* USER CODE END USART2_Init 1 */
  huart2.Instance = USART2;
  huart2.Init.BaudRate = 115200;
  huart2.Init.WordLength = UART_WORDLENGTH_8B;
  huart2.Init.StopBits = UART_STOPBITS_1;
  huart2.Init.Parity = UART_PARITY_NONE;
  huart2.Init.Mode = UART_MODE_TX_RX;
  huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart2.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart2) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN USART2_Init 2 */

  /* USER CODE END USART2_Init 2 */

}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};
/* USER CODE BEGIN MX_GPIO_Init_1 */
/* USER CODE END MX_GPIO_Init_1 */

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOH_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOE_CLK_ENABLE();
  __HAL_RCC_GPIOD_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_1, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_9|GPIO_PIN_10|GPIO_PIN_12|GPIO_PIN_14, GPIO_PIN_RESET);

  /*Configure GPIO pins : PA0 PA2 */
  GPIO_InitStruct.Pin = GPIO_PIN_0|GPIO_PIN_2;
  GPIO_InitStruct.Mode = GPIO_MODE_IT_RISING;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pin : PA1 */
  GPIO_InitStruct.Pin = GPIO_PIN_1;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pins : PD9 PD10 PD12 PD14 */
  GPIO_InitStruct.Pin = GPIO_PIN_9|GPIO_PIN_10|GPIO_PIN_12|GPIO_PIN_14;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOD, &GPIO_InitStruct);

  /* EXTI interrupt init*/
  HAL_NVIC_SetPriority(EXTI0_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI0_IRQn);

  HAL_NVIC_SetPriority(EXTI2_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI2_IRQn);

/* USER CODE BEGIN MX_GPIO_Init_2 */
/* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
