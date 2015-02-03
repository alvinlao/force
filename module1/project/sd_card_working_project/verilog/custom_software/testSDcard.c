#include <stdio.h>
#include <altera_up_sd_card_avalon_interface.h>

int main(void) {
	alt_up_sd_card_dev *device_reference = NULL;
	int connected = 0;
	char a;

	device_reference = alt_up_sd_card_open_dev("/dev/SD_CARD_INTERFACE");
	if (device_reference != NULL) {
		while(1) {
			if ((connected == 0) && (alt_up_sd_card_is_Present())) {
				printf("Card connected.\n");
				if (alt_up_sd_card_is_FAT16()) {
					printf("FAT16 file system detected.\n");
					alt_up_sd_card_find_first(device_reference, a);
					printf("FILE FOUND: %s\n", a);

					while(alt_up_sd_card_find_next(a) != -1) {
						printf("FILE FOUND: %s\n", a);
					}

				} else {
					printf("Unknown file system.\n");
				}
				connected = 1;
			} else if ((connected == 1) && (alt_up_sd_card_is_Present() == false)) {
				printf("Card disconnected.\n");
				connected = 0;
			}
		}
	}
	else{
		printf("twas null\n");
	}
return 0;
}
