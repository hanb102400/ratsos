
#include "../include/console.h"
#include "../include/io.h"
#include "../include/stdint.h"

#define VGA_BASE 0xB8000;
#define DATA_BASE 0x60000

uint32 getCursor()
{
    io_out8(0x3d4, 0x0e);
    uint8 cursorHigh = io_in8(0x3d5);
    io_out8(0x3d4, 0x0f);
    uint8 cursorLow = io_in8(0x3d5);
    return (cursorHigh << 8) + (cursorLow & 0xff);
}

void setCursor(uint32 pos)
{
    uint8 cursorHigh = pos >> 8;
    uint8 cursorLow = pos & 0xff;
    io_out8(0x3d4, 0x0e);
    io_out8(0x3d5, cursorHigh);
    io_out8(0x3d4, 0x0f);
    io_out8(0x3d5, cursorLow);
}

void putchar(char ch)
{

    uint32 pos = getCursor();
    char *pvga = (char *)VGA_BASE;

    //zifu
    switch (ch)
    {
    case 0x0d: //\r
        pos = (pos / 80) * 80;
        break;
    case 0x0a: //\n
        pos = pos + 80;
        pos = (pos / 80) * 80;
        break;
    default:
        *(pvga + pos * 2) = ch;
        pos++;
    }
    //roll_screen
    if (pos > 1999)
    {
        pos = pos - 80;
        for (int i = 0; i < 1920; i++)
        {
            *(pvga + 0x00 + i * 2) = *(pvga + 0xa0 + i * 2);
        }
        //cls with space
        for (int i = 0; i < 80; i++)
        {
            *(pvga + 1920 * 2 + i * 2) = 0x0;
        }
    }
    setCursor(pos);
}

void putstring(char *chs)
{
    int i = 0;
    while (*(chs + i) != 0)
    {
        putchar(*(chs + i));
        i++;
    }
}

void putpointer(uint32 addr)
{   
    putchar('0');
    putchar('x');
    int i = 0;
    char *chs = (char *)DATA_BASE; //need point mem alloc
    do
    {
        *(chs + i) = (char)(addr % 10 + '0'); //取下一个数字
        i++;

    } while ((addr /= 10) > 0); //删除该数字
    for (int j = i; j >= 0; j--)
    { //生成的数字是逆序的，所以要逆序输出
        putchar(*(chs + j));
        *(chs + j) = 0;
    }
}