

#ifndef __LIB_INTERRUPT_H
#define __LIB_INTERRUPT_H

#include "stdint.h"

struct gate_desc
{
    uint16 handler_offset_low;
    uint16 selector;
    uint8 dw_count;
    uint8 attribute;
    uint16 handler_offset_high;
};

void init_pic();

void init_idt();

void init_interrupt_desc();

void set_interrupt_desc(struct gate_desc *p_gate_desc, uint8 attr, void *handler);

#endif