/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "altera_up_avalon_character_lcd.h"

#define key1 (char *) 0x0002060
#define key2 (char *) 0x0002050
#define key3 (char *) 0x0002040

#define leds (char *) 0x0002010

char AKeyIsPressed() {
	return !(*key1 & *key2 & *key3);
}

void displayKey(alt_up_character_lcd_dev * char_lcd_dev, char* keyString) {
	alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 1);
	alt_up_character_lcd_string(char_lcd_dev, keyString);

	printf(keyString);
	printf("\n");
}

int main()
{
	char keypressed;
	int i;

	alt_up_character_lcd_dev * char_lcd_dev;
	// open the Character LCD port
	char_lcd_dev = alt_up_character_lcd_open_dev ("/dev/character_lcd_0");
	if ( char_lcd_dev == NULL)
	alt_printf ("Error: could not open character LCD device\n");
	else
	alt_printf ("Opened character LCD device\n");
	/* Initialize the character display */
	alt_up_character_lcd_init (char_lcd_dev);
	alt_up_character_lcd_string(char_lcd_dev, "Press key: 0-3");
	alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 1);
	alt_up_character_lcd_string(char_lcd_dev, "Key: ?");

	while(1) {
		// Get around key press debounce
		// Estimate: 50MHz clock. 10 cycles per instruction. 20 instructions for one loop.
		// Estimated delay: ~20ms
		for (i = 0; i < 50000; i++);

		if (!keypressed) {
			if (!*key1) {
				displayKey(char_lcd_dev, "Key: 1");
			} else if (!*key2) {
				displayKey(char_lcd_dev, "Key: 2");
			} else if (!*key3) {
				displayKey(char_lcd_dev, "Key: 3");
			}
		}

		// Display keys on LCD
		*leds = *key3 << 3 | *key2 << 2 | *key1 << 1;

		// Update key press state
		keypressed = AKeyIsPressed();
	}
	return 0;
}
