int _start(){
    char *pvga = (char *)0xb8000;	//填充到显示内存的初始地址	
    for(int i = 0;i <= 0xffff;i++){							
        *(pvga + i)= 0x3;		 //显卡内存存填充颜色值，红色心形
    }
    fin:
    	goto fin;
}