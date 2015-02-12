#ifndef EXCEPTION_H
#define EXCEPTION_H

#include "sys/alt_irq.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"
#include "screenshot.h"

void handle_button_interrupts(void* context, alt_u32 id);
void init_button_pio();

#endif
