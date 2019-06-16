#ifndef __LIB_GLOBAL_H
#define __LIB_GLOBAL_H

#define RPL0 0
#define RPL1 1
#define RPL2 2
#define RPL3 3

#define TI_GDT 0
#define TI_LDT 1

#define SELECTOR_CODE ((1 << 3) + (TI_GDT << 2) + RPL0)         
#define SELECTOR_DATA ((2 << 3) + (TI_GDT << 2) + RPL0)         
#define SELECTOR_STACK SELECTOR_DATA
#define SELECTOR_GS ((3 << 3) + (TI_GDT << 2) + RPL0)

#define IDT_DESC_P 1
#define IDT_DESC_DPL0 0
#define IDT_DESC_DPL3 3
#define IDT_DESC_TYPE16 0x6
#define IDT_DESC_TYPE32 0xe

#define IDT_DESC_ATTR_DPL0 ((IDT_DESC_P << 7) + (IDT_DESC_DPL0 << 5) + IDT_DESC_TYPE32)
#define IDT_DESC_ATTR_DPL3 ((IDT_DESC_P << 7) + (IDT_DESC_DPL3 << 5) + IDT_DESC_TYPE32)



#define PIC0_ICW1  0x20
#define PIC0_ICW2  0x21
#define PIC0_ICW3  0x21
#define PIC0_ICW4  0x21
#define PIC0_IMR   0x21

#define PIC1_ICW1  0xa0
#define PIC1_ICW2  0xa1
#define PIC1_ICW3  0xa1
#define PIC1_ICW4  0xa1
#define PIC1_IMR   0xa1


#endif