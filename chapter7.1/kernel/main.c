

#include "../include/stdint.h"

int _start(){
    uint8 *pvga = (uint8 *)0xa0000;	//填充到显示内存的初始地址	
    for(int i = 0;i <= 0xffff;i++){	
		  *(pvga + i) = i & 0x0F;     //显卡内存存填充颜色值	
    }
    fin:
    goto fin;
}