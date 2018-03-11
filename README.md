# xiangqi-tools
中国象棋相关的工具，包含3个命令行程序: xiangqi-fen2text, xiangqi-fen2pic, xiangqi-ubb2fen

changelog for xiangqi-tools
coding: utf-8

2018-3-12 version 1.2, by Careone

	* 更新 /usr/games/xiangqi-fen2pic 1.1 -> 1.2;
	
	** 调整了生成的图片文件的命名规则：以前是用“年月日-时分秒”来命名图片文件，
	改为8位字符加上图片扩展名的形式，如 18cv0001.jpg 
	说明：前2位数字代表2018年；第3位1-9, a-c 代表1-12月；
	      第4位1-9, a-v 代表1-31号；最后的4位数字代表0001-9999的数字序号。
	      超过4位数字，则以实际数字为准；
	并启用一个隐藏的编号参数文件，保存和累计更新数字序号。
	文件名: ~/xiangqi/pic/.pic_index

	** 新增选项 --tips-gifs, 提示如何使用convert命令把生成的多个棋局图片，
	   转换成GIF动画, 以及 convert 命令的其它常用技巧；
		
	* 微调了部分FEN示例文件的文件名。
	  文件目录位置: usr/share/xiangqi/fen/	
	
	* 更新了FEN示例文件 fen/shiqingyaqu551.fen
	  文件目录位置: usr/share/xiangqi/fen/	
	参照《适情雅趣》551局-李浭-新版本，对变更过的棋局名称、FEN数据进行了同步
	更新，并调整了棋局序号：原1-226局编号不变；插入补图复原的第227局-舍生取义，
	原第227-550局顺延为第228-551局。同时，新增备注文件：

	    适情雅趣_551局_李浭_新版本与_550局旧版本的区别.txt


2018-3-08 version 1.1, by Careone

	* 更新 /usr/games/xiangqi-fen2pic 1.0 -> 1.1;
	
	** 新增主题: wood3-50 (木纹红黑棋子/木质棋盘，棋子大小50x50像素)；

	** 新增选项: --list-fen, 列出象棋FEN示例文件。共14个FEN复合数据文件。
	   目录位置: /usr/share/xiangqi/fen/
	   其中13个文件的FEN数据来自“象棋巫师(xqwizard)”的EPD残局库文件，
	   还有一个来自《适情雅趣》残局谱; 

	** 新增选项: --random, 可随机生成一张象棋残局图片。残局选自《适情雅趣》
	   残局谱550+1例, 对应文件为 usr/share/xiangqi/fen/shiqingyaqu551.fen 

	** 其它细节微调和代码优化；
	
	* 添加开发相关附加脚本命令(仅供开发用，不适用普通用户)：
	  + usr/share/xiangqi/dev/bin/shiqingyaqu550-xqf2pgn.sh
	    转换象棋《适情雅趣》残局谱550例的XQF棋谱为PGN棋谱；

	  + usr/share/xiangqi/dev/bin/xiangqi-epd2fen.sh
	    转换象棋“象棋巫师(xqwizard)”的13个EPD残局库文件为FEN复合数据格式；


2018-2-28 version 1.0, by Careone

	* added/updated: 更新并调整了主题和默认使用主题；

	* updated: usr/games/xiangqi-fen2pic (version 0.4 -> 1.0);
	
	** 调整 xiangqi-fen2pic 相关的主题目录位置：
	   原目录：usr/share/xiangqi-tools/themes/
	   新目录：usr/share/xiangqi/themes/
	
	** 优化程序代码，同时对FEN数据进行必要的检查、过滤和错误信息输出；
	
	** 支持LOG功能。部分出错信息自动保存到
	   ~/xiangqi/log/xiangqi-fen2pic.log
	  BUG: 编写了一个用户级的日志行为，但似乎无法正常轮换和备份。待跟进。
	  ( etc/logrotate.d/xiangqi-fen2pic )
   
	** 支持3种模式读取FEN（象棋布子数据）：
	  + input: 即不带参数，直接运行命令，然后在提示下手动输入FEN数据。
		可连续多次输入FEN；
	  + string: 即在命令行给出FEN附加参数。可用于命令管道操作
		（通过 --fen 选项实现）；
	  + file:   从文件中读取FEN数据。支持在同一个PGN/FEN格式中，读取一组或
		多组FEN数据（通过 --file 选项实现）；
	  
	** 新增更多选项：
	  + --event: 在图片中添加棋局备注文字。如“XXX先胜XXX”，等等；
	  + --resize: 按比例或指定图片的宽度，缩放图片；
	  + 默认在图片最下方添加FEN数据(如果棋子小于40x40的主题，则默认不添加FEN)；
	  + 其它更多选项； 

	** 新增调试相关：在 usr/share/xiangqi/debug/ 目录下，存放有调试程序用的
	  测试脚本和示例文件;

  TODO & BUGS: 

	* 选项 --file, --string 的处理方式仍不理想，无法正常处理多个文件或多组
	字符串输入（目前只能处理单个文件/单组字符串）；
	
	* 对截取的FEN数据的初步检验和过滤功能暂不完整，待完善和优化；
	
	附：当前检验和处理流程：先把FEN数据中的9个斜杠分隔符（/）用sed强制添加
	换行符，通过行数来判定是否是10行（对应10行棋子）。如果缺少一行或多行，则在
	最后一行（即数组值row0[@]，红方底线）加入一个错误的棋子图片unknown.png
	(通常是一个黑白格马赛克图片)来进行标示。

	* 部分操作中，无法有效识别“错误的FEN数据”（如某一行多子/少子，或者缺行/多行）
	如：
	  [FEN "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABN"]
	** 错误1 (E800): row0 单行棋子数量少于9个 (row9 -> row0)

	方式1（功能正常）：
	直接运行命令 xiangqi-fen2pic, 再输入FEN：
	能准确分析FEN数据并报错；

	方式2（功能正常）：
	运行命令（带FEN数据） 
	xiangqi-fen2pic "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABN"
	能准确分析FEN数据并报错；

	方式3（功能异常）*：
	运行命令（带--fen 参数和 FEN数据） 
	xiangqi-fen2pic --fen "rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABN"
	异常内容：未提示FEN数据错误;


2018-2-11 version 0.4, by Careone

	* added/updated: 更新并调整了4种主题; 默认使用主题： mono-40：
		40x40棋子，黑白棋子/棋盘，棋盘上带有数字1-9,一到九路数；

	* updated: usr/games/xiangqi-fen2pic (version 0.3 -> 0.4);


2018-2-07, version 0.1, by Careone

	* new: usr/games/xiangqi-fen2pic  (version 0.3 -> 0.4);
	* new: usr/games/xiangqi-fen2text (version 0.2);
	* new: usr/games/xiangqi-ubb2fen  (version 0.1.1);
 
