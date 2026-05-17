#include "xgpio.h"
#include "xparameters.h"
#include "xil_printf.h"
#include "sleep.h"
#include <xstatus.h>

#define GPIO_BASEADDR XPAR_XGPIO_0_BASEADDR
#define GPIO_CHANNEL 1

#define LED0_R (1U << 0)
#define LED0_G (1U << 1)
#define LED0_B (1U << 2)

#define LED1_R (1U << 3)
#define LED1_G (1U << 4)
#define LED1_B (1U << 5)

int main(void)
{
    XGpio gpio;
    int status;

    xil_printf("PS/PL RGB LED demo starting...\r\n");

    status = XGpio_Initialize(&gpio, GPIO_BASEADDR);
    if (status != XST_SUCCESS)
    {
        xil_printf("GPIO Init Failed\r\n");
        return XST_FAILURE;
    }

    XGpio_SetDataDirection(&gpio, GPIO_CHANNEL, 0x00);

    while (1) {
        XGpio_DiscreteWrite(&gpio, GPIO_CHANNEL, LED0_R | LED1_R);
        sleep(1);
        XGpio_DiscreteWrite(&gpio, GPIO_CHANNEL, LED0_B | LED1_B);
        sleep(1);
        XGpio_DiscreteWrite(&gpio, GPIO_CHANNEL, LED0_G | LED1_G);
        sleep(1);
        XGpio_DiscreteWrite(&gpio, GPIO_CHANNEL, LED0_R | LED0_B | LED1_R | LED1_B);
        sleep(1);
        XGpio_DiscreteWrite(&gpio, GPIO_CHANNEL, LED0_R | LED0_G | LED1_R | LED1_G);
        sleep(1);
        XGpio_DiscreteWrite(&gpio, GPIO_CHANNEL, LED0_B | LED0_G | LED1_B | LED1_G);
        sleep(1);
        XGpio_DiscreteWrite(&gpio, GPIO_CHANNEL, LED0_R | LED0_B | LED0_G| LED1_R | LED1_B | LED1_G);
        sleep(1);
    }

    return 0;

}