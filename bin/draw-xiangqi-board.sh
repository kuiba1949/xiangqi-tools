#!/bin/bash
# coding: utf-8
# draw xiangqi board.png
# 用 convert 命令画中国象棋棋盘，并保存为 board.png 图片
# 默认棋格大小为 40x40 像素 
# original filename: draw-xiangqi-board.sh
# by Careone
# 2018-3-12

APPNAME="draw-xiangqi-board"
APPVER="0.1"

### defines ###
## Piece size, Board Width/Height
## Piece /Board file
##

SUFFIX="png"
declare -a p_size b_width b_height
declare -a pic tmp

p_size=( 40 1 38 42 )
b_width=( 318 320 6 4 )
b_height=( 362 382 )


## pic: id 0-5
pic=( board tmp01 tmp02 tmp03 tmp04 tmp05 )

THEME="black-white-40"
prefix="$HOME/xiangqi/themes/$THEME"

DEBUG=1

## DEL_TMP: 是否清除临时图片文件。默认为1（清除）。
DEL_TMP=1

### ready ###
echo -e "  用 convert 命令制作中国象棋棋盘，并保存为 board.png 图片\n"
echo "  棋格大小为 40x40 像素, 棋盘尺寸 370x410 ..."
echo -e "  棋格大小:\tp_size[0]=${p_size[0]}\n  初始棋盘宽度: b_width[0]=${b_width[0]}"
echo -e "  初始棋盘高度: b_height[0]=${b_height[0]}"
echo -e "  生成的棋盘图片: pic[0].\$SUFFIX=${pic[0]}.$SUFFIX"
echo -e "  保存到目录: $prefix/"
echo

if [ ! -d "$prefix" ]; then
  mkdir -p "$prefix"
fi

cd "$prefix"
pwd
echo

### body ###
## 1. 绘制38x38的透明空白图片1
#convert -size 800x900 -strip -colors 8 -depth 8 xc:none blank-board.png

## 2. 绘制40x40的单个网格图片2（带框线）
#* 加边框: 在一张照片的四周加上边框，可以用 -mattecolor 参数，
#  比如某位同志牺牲了，我们需要为他做一张黑边框的遗像，可以这样：
#convert -mattecolor "#000000" -frame 60x60 name.jpg rememberyou.png
#其中，"#000000"是边框的颜色，边框的大小为60x60

declare -i MAX=5 ID 

for a in `seq 0 1 $MAX`; do
    let "ID = a + 1"; let "b = a - 1"; 
    # file a,b:
	    fa="${pic[a]}.$SUFFIX"
	    fb="${pic[b]}.$SUFFIX"

    case "$a" in  
	0) 
      echo "  * step $ID: 制作 ${p_size[2]}x${p_size[2]} 的透明空白图片 ($fa)"
      convert -size "${p_size[2]}x${p_size[2]}" -strip -colors 8 -depth 8 xc:none "$fa"
	;;

	1)

    echo "  * step $ID: 制作 ${p_size[0]}x${p_size[0]} 的单个网格图片 ($fa)"
convert -mattecolor "#000000" -frame "${p_size[1]}x${p_size[1]}" $fb $fa
;;
		
	2) ## 3. 制作8格x1行的单排图片
	   #convert +append ${row9[@]} "$pic9"
	   
	    echo "  * step $ID: 制作 8格x1行的单排图片 ($fa)"

    convert +append $fb $fb $fb $fb $fb $fb $fb $fb "$fa"
    ;;
	
	3) ## 4. 制作8格x9行的单排图片
	   #convert -append ${row9[@]} "$pic9"
	   
	    echo "  * step $ID: 制作 8格x9行的单排图片 (${pic[0]}.$SUFFIX)"
	    # 先制作8格x行的半边棋盘，
	    # 再制作 38x318 的透明空白图片1 (即河界中间行)，并添加细框线
	    # 最后合并3个图片

	    ## 从上往下，合并4行棋格（每行有8格）
	    convert -append $fb $fb $fb $fb "$fa"

	    declare -i x1 y1
	    x1="${b_width[0]}"; y1="${p_size[2]}"; 
	    #fc="_318x38_alpha.png"
	    #fd="_320x40_alpha.png"

	    ## tmp[@] id: 0-1
	    tmp=( _318x38_alpha.png _320x40_alpha_frame.png )
	    ## 准备制作河界的那一行。先制作空白的小格（不含框线）
	    convert -size "${x1}x${y1}" -strip -colors 8 -depth 8 xc:none "${tmp[0]}"

	    ## 为河界行添加细框线。框线宽度为线宽的一半
	    convert -mattecolor "#000000" -frame "${p_size[1]}x${p_size[1]}" "${tmp[0]}" "${tmp[1]}"

	    ## 合并上中下3部分（黑方地界，河界，红方地界）为一个完整的棋盘
	    convert -append $fa ${tmp[1]} $fa "${pic[0]}.$SUFFIX"


if [ $DEL_TMP = 1 ]; then
  #rm -f line.png line45.png line135.png xx.png
  echo "     清除临时文件..."
  rm -f ${tmp[*]}
fi	    
    ;;

	4) ## 5. 画炮，兵/卒位置的十字坐标线
	   #convert +append ${row9[@]} "$pic9"
	   
	    echo "  * step $ID: 画炮，兵/卒位置的十字坐标线 ($fa)"
	    #	    q1="_q1.png"; q2="_q2.png"; q3="_q3.png"; q4="_q4.png";

## 临时图片文件. id: 0-5	    
unset tmp
tmp=( bg.png _q1.png _q2.png _q3.png _q4.png tmp99.png )	    

## 创建透明的底图
convert -size "40x40" -strip -colors 8 -depth 8 xc:none "${tmp[0]}"

## 对透明底图，增加2x2的黑色框线，为后面截取
#  第1个直角标记（剪切图片的左上角）做准备	    
convert -mattecolor "#000000" -frame "2x2" ${tmp[0]} ${tmp[5]}

# 上下翻转
#convert -flip foo.png bar.png
#
# 左右翻转
	    #convert -flop foo.png bar.png
	    #
	    # -crop 剪切图片
#    convert -crop 13x13-5-5 old new
# convert abc.jpg -rotate 90 abc-rotated.jpg
## -crop 剪切为直角标记，并对称镜像，生成第2个方向的直角标记（总共有4种直角标记）
	    convert -crop 13x13-5-5 ${tmp[5]} "${tmp[1]}"
	    convert -flip ${tmp[1]} ${tmp[2]}
	    
# convert 背景 {图片1 -geometry +x+y -composite} {图片2 ...} 新图片
#convert "${blackp[8]}" "$PIC_TMP" -geometry +${x0}+${y0} -composite "$PIC_TMP"

## 镜像图片，生成上下左右共4个直角标记 	    
   #convert -flop $q1 $q3
   #convert -flop $q2 $q4
    convert -flop ${tmp[1]} ${tmp[3]}
    convert -flop ${tmp[2]} ${tmp[4]}
    
## 重新创建新的透明底图，然后把4个直角标记，分别添加到底图上    
   convert -size "60x60" -strip -colors 8 -depth 8 xc:none "${tmp[0]}"
	    
   convert ${tmp[0]} ${tmp[1]} -geometry +30+30 -composite "${tmp[0]}"
   convert ${tmp[0]} ${tmp[2]} -geometry +30+14 -composite "${tmp[0]}"
   convert ${tmp[0]} ${tmp[3]} -geometry +14+30 -composite "${tmp[0]}"
   convert ${tmp[0]} ${tmp[4]} -geometry +14+14 -composite "${tmp[0]}"
       ;;

	5)  echo "  * step $ID: 复制炮，兵/卒位置的十字坐标线 ($fa)"
	    cp -v ${pic[0]}.$SUFFIX $fa
	    
	    declare -a x0 y0

	    ## 设定红黑双方共4个炮的坐标位置，然后再复制坐标十字线
	    x0=( 14 14 254 254 )
	    y0=( 54 254 54 254 )

	for a in `seq 0 3`; do
	    convert $fa $fb -geometry +"${x0[a]}"+"${y0[a]}" -composite $fa
	done
	
	#wait;
	#sleep 3
	    ## 设定红黑双方共10个兵/卒的坐标位置，然后再复制坐标十字线
	    x0=( -26 54 134 214 294 -26 54 134 214 294 )
	    y0=( 94 94 94 94 94 214 214 214 214 214 214 )

		for a in `seq 0 9`; do
		    convert $fa $fb -geometry +"${x0[a]}"+"${y0[a]}" -composite $fa
		    #wait;
		    #sleep 1
		done
		
##
if [ $DEL_TMP = 1 ]; then
  #rm -f line.png line45.png line135.png xx.png
  echo "     清除临时文件..."
  rm -f ${tmp[*]}
fi

### Arrry tmp[@] id: 0-4
unset tmp
tmp=( bg.png line.png line45.png line135.png xx.png )		

echo "  ** 画九宫斜线..."
## 画九宫斜线。先画直线（即单色或透明背景的窄图片），再旋转45度或135度。
# 注意要准确计算直线的长度，即 = (棋格边长大小 * 2 - 线宽 ) * 1.414
convert -size 80x80 -strip -colors 8 -depth 8 xc:none "${tmp[0]}"
#convert -size 110x2 -strip -colors 8 -depth 8 xc:"#000000" "${tmp[1]}"
convert -size 110x1 -strip -colors 8 -depth 8 xc:"#000000" "${tmp[1]}"

# 两条透明的九宫斜线，合并成一个透明的叉。
convert -background "rgba(0,0,0,0)" -rotate 45 "${tmp[1]}" "${tmp[2]}"
convert -background "rgba(0,0,0,0)" -rotate 135 "${tmp[1]}" "${tmp[3]}"

convert ${tmp[0]} ${tmp[2]} -geometry +0+0 -composite "${tmp[0]}"
#wait; sleep 1;
convert ${tmp[0]} ${tmp[3]} -geometry +0+0 -composite "${tmp[0]}"
#wait; sleep 1;

# 添加透明的九宫叉线2处
## XX_WIDTH: 九宫叉线的线宽。应小于标准线宽，因为旋转45/135度后，
#  斜线看起来要比横线和竖线要粗一些
declare -i XX_WIDTH=1

case "$XX_WIDTH" in
    1)
convert $fa ${tmp[0]} -geometry +120+0 -composite $fa
convert $fa ${tmp[0]} -geometry +120+280 -composite $fa
;;
    2 | *)
convert $fa ${tmp[0]} -geometry +119-1 -composite $fa
convert $fa ${tmp[0]} -geometry +119+279 -composite $fa
;;
    
    esac

if [ $DEL_TMP = 1 ]; then
  #rm -f line.png line45.png line135.png xx.png
  echo "     清除临时文件..."
  rm -f ${tmp[*]}
fi

#eog $fa &
#exit 0
		
		## 此时棋盘图片的最外面的边框只有半个线宽。
		## 等棋盘内部线条和数据全部画好后（如九宫斜线，楚河汉界文字，
		# 1-9,九到一路数文字），最后再添加边框

		echo "  ** 添加棋盘外框线..."

		## 把外框线宽度由半宽，补到1倍标准宽度
	   	convert -mattecolor "#000000" -frame "1x1" $fa $fa

		## 加一层空白外框
		convert -mattecolor "rgba(0,0,0,0)" -frame "2x2" $fa $fa
		#convert -mattecolor "#ffffff" -frame "2x2" $fa $fa

		## 再加一层黑线框
		convert -mattecolor "#000000" -frame "2x2" $fa $fa

		## 再加半个棋子的空位
		convert -mattecolor "rgba(0,0,0,0)" -frame "20x20" $fa $fa
		#convert -mattecolor "#ffffff" -frame "20x20" $fa $fa

		## 添加背景底色为白色，而不是透明
		
#convert -size 370x410 -strip -colors 8 -depth 8 xc:"rgba(255,255,255,127)" bg.png
convert -size 370x410 -strip -colors 8 -depth 8 xc:"#eeeeee" bg.png

## xc: 指定背景色。xc:none 代表透明。white 代表白色, red 代表红色.
# 其它色彩："#abcdef"

convert bg.png $fa -geometry +0+0 -composite ${pic[0]}.$SUFFIX
		;;
	*) : ;;
    esac
    

if [ -s "${pic[a]}.$SUFFIX" ]; then    
  echo -e "\n  图片详细信息..."
  #echo "  -------------------"
  ls -l ${pic[a]}.$SUFFIX
  file ${pic[a]}.$SUFFIX
  echo "  -------------------"
  echo
fi
  #sleep 2

done

    ### ------------
    DRAW_PIECE=0 # 是否制作象棋棋子。暂未完成。
    
    if [ "$DRAW_PIECE" = 1 ]; then
	 echo "  * step $ID: 制作 [红/黑]（或者 [白/黑]）双方棋子 ($fa)"
	   STR="帅"
	   #  字体文件名称如: /usr/share/fonts/truetype/wqy/wqy-zenhei.ttc
	     FONT=/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc
	     #convert 背景图片 -font 字体文件名称 -pointsize 字体大小 -annotate +x+y "文字内容"
convert ${pic[0]}.$SUFFIX -font "$FONT" -pointsize 12 -fill red -annotate +0+0 "STR" $fa
#	     convert ${pic[0]}.$SUFFIX -draw "text 0,0 '帅'" "$fa"
#	     convert _${p_size[2]}x${p_size[2]}.$SUFFIX -fill red -draw "text 0,0 '帅'" "$fa"	     

    fi
    
  echo -e "\n  图片详细信息..."
  #echo "  -------------------"
  ls -l ${pic[0]}.$SUFFIX
  file ${pic[0]}.$SUFFIX
  echo "  -------------------"
  
  eog "${pic[0]}.${SUFFIX}" &
  #  eog $fa &

  cd -
  echo
#  pwd
#  echo
exit 0

