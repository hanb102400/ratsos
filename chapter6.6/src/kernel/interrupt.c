

#include "../include/stdint.h"
#include "../include/io.h"
#include "../include/global.h"
#include "../include/interrupt.h"
#include "../include/console.h"
#include "../include/keyboard.h"

#define IDT_DESC_COUNT 0x22

/**
 * idt中断符描述表
 */
struct gate_desc idt[IDT_DESC_COUNT];

/**
 * idt调用方法表
 */
void* handler_table[IDT_DESC_COUNT];


/**
 * 初始化PIC
 */
void init_pic()
{   
    io_out8(PIC0_IMR, 0xff);
    io_out8(PIC1_IMR, 0xff);

    //master
    io_out8(PIC0_ICW1, 0x11);
    io_out8(PIC0_ICW2, 0x20);
    io_out8(PIC0_ICW3, 0x04);
    io_out8(PIC0_ICW4, 0x01);

    //slaver
    io_out8(PIC1_ICW1, 0x11);
    io_out8(PIC1_ICW2, 0x28);
    io_out8(PIC1_ICW3, 0x02);
    io_out8(PIC1_ICW4, 0x01);
  
}

/**
 * 设置中断符描述表
 * p_gate_desc： 中断符描述
 * handler：中断调用方法地址
 */
void set_interrupt_desc(struct gate_desc *p_gate_desc, uint8 attr, void* handler)
{
    p_gate_desc->handler_offset_low = (uint32)handler & 0x0000ffff;
    p_gate_desc->selector = SELECTOR_CODE;
    p_gate_desc->dw_count = 0;
    p_gate_desc->attribute = attr;
    p_gate_desc->handler_offset_high = ((uint32)handler & 0xffff0000) >> 16;
}

/**
 * 注册中断调用方法
 */
void register_handler(int i, void* handler)
{
    set_interrupt_desc(&idt[i], IDT_DESC_ATTR_DPL0, handler);
}

/**
 * 初始化中断描述符表
 */
void init_interrupt_desc()
{
    for (int i = 0; i < IDT_DESC_COUNT; i++)
    {
        register_handler(&idt[i], handler_table[i]);
    }
}



/**
 * 初始化IDT
 */
void init_idt()
{
    //init pic
    init_pic();

    //init idt interrupt
    init_interrupt_desc();
    init_keyboard();

    //load idt
    uint64 idt_info = ((sizeof(idt) - 1) | ((uint64)idt << 16));
    io_lidt(&idt_info);


    /* 打开主片上IR0键盘中断,打开键盘中断处理，其他中断全关闭,keybord: 0xfb */
    io_out8(PIC0_IMR, 0xfb);
    io_out8(PIC1_IMR, 0xff);

    io_sti();
    io_out8(PIC0_IMR, 0xf9); /* PIC1偲僉乕儃乕僪傪嫋壜(11111001) */
    io_out8(PIC1_IMR, 0xef); /* 儅僂僗傪嫋壜(11101111) */
}






