int _start(){
    char *pvga = (char *)0xb8000;	//填充到显示内存的初始地址	
    for(int i = 0;i <= 0xffff;){
         //char: 0x3 ,color: 0x104
        *(pvga + i) = 0x03;i++;		 //显卡内存存填充颜色值，红色心形	
        *(pvga + i)= 0x104;i++;  
    }
    fin:
    	goto fin;
}