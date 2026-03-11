#define GPIO (*(volatile unsigned int*)0x00001000)

void delay() {
    for (volatile int i = 0; i < 5000000; i++);
}

int main() {

    while (1) {

        GPIO = 0xFF;
        delay();

        GPIO = 0x00;
        delay();

    }

    return 0;
}