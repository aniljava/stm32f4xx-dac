#include "main.h"

#include "usbd_usr.h"
#include "usbd_desc.h"

#include "stm32f4xx_conf.h"

#include "usbd_audio_core.h"
#include "usbd_audio_out_if.h"

USB_OTG_CORE_HANDLE USB_OTG_dev;

RCC_ClocksTypeDef RCC_Clocks;
__IO uint8_t RepeatState = 0;
__IO uint16_t CCR_Val = 16826;

void init_leds();




int main(void) {

	init_leds();

	/* SysTick end of count event each 10ms */
	RCC_GetClocksFreq(&RCC_Clocks);
	SysTick_Config(RCC_Clocks.HCLK_Frequency / 100);

	RCC_HSEConfig(RCC_HSE_ON);
	while (!RCC_WaitForHSEStartUp()) {}



	unsigned int mode = 0;
	#ifdef USE_USB_OTG_HS
		USBD_Init(mode, &USB_OTG_dev,USB_OTG_HS_CORE_ID,&USR_desc, &AUDIO_cb, &USR_cb);
	#else
		USBD_Init(mode, &USB_OTG_dev, USB_OTG_FS_CORE_ID,&USR_desc, &AUDIO_cb, &USR_cb);
	#endif


	while (1) { }
}

void init_leds() {
	/* Initialize LEDS */
	STM_EVAL_LEDInit(LED4);
	/* Green Led On: start of application */
	STM_EVAL_LEDOn(LED4);
}


