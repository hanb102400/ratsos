int _start(){
	char *pvram = (char *)0xa0000;	//填充到显示内存的初始地址	
	char *p;
	int i;
	for( i = 0;i <= 0xffff;i++){
		p = pvram + i;	//指针指向显存地址
		*p = 0x3;		//显卡内存存填充颜色值
	}
	fin:
		goto fin;
}