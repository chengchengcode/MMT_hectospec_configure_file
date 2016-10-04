# MMT_hectospec_configure_file

20160922:

Correct the awkward from the radec, ra, dec, ihr, imin, xsec, ideg, imn, xsc when ideg = 0 and imn, xsc < 0

Correct the index err in Hecto_obs_catalog.pro


-------
These idl codes aim to prepare the MMT/Hectospec config file.

In the order of:

Hecto_guidestar.pro

Hecto_match_gsc_catalog.pro

Hecto_gsc_offset_plot.pro

Hecto_match_SDSS_fstar_catalog.pro

Hecto_obs_catalog.pro

--
Hecto_spec_show.pro is a code for:

a, Draw the MMT spectrum

b, Download the SDSS stamp image in the same ra dec

c, Creat a latex source file and compile the pdf

d, Open the PDF
 
--

Hecto_sdss_img_check.pro is a code for:

wget the SDSS stamp image

--

# Improvements should be:

1, How to select f star from SDSS

2, Get rid of the personal files, upload some real examples

3, ...


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
# My Chinese note is:

MMT/hectospec 笔记一：准备config file

MMT的Hectospec是个多光纤光谱仪，观测流程是望远镜仰脸后用机械臂把光纤放置在合适位置，大约半小时overhead，再指向目标源曝光若干次，每次曝光后有个几分钟把数据读出来，overhead+多次曝光一起叫做一个run或者一个config

Hectospec是个PI的仪器，通过TAP申请的话需要给PI也就是D. E 写邮件申请批准，再把批准的邮件附在申请书最后

Hectospec的观测模式是Q，也就是排队，大家要在每个观测季开始前两周提交configure file，具体观测的时候会安排最合适此时观测的源来观测，因此尽管给了观测时间某天到某天，但是很可能届时是观测别人的源

那是不是不用过去了呢，还是去一下吧，可以做点检查之类的工作，数据几乎当时就能得到，理论上可以夜里观测白天处理数据

这里介绍一些最基本的准备过程，介绍一些高级用法，介绍一些八卦

整个config file的准备过程有:

1, 准备guide star
-----

MMT需要在望远镜周围，至少两个guide star，很多网站都能下载到guide star catalog，这里说个cadc：

网页在 http://www.cadc-ccda.hia-iha.nrc-cnrc.gc.ca/cadcbin/astrocat/gsc

写一下天区坐标和尺寸，选Html, text, raw 有结果出来，选fits之类的怎么都弄不出来东西，我最终选的是raw的结果，复制到文本里会看到：

_r  GSC2.3  RAJ2000 DEJ2000 Epoch Fmag  jmag  Vmag  Nmag  Class a e

arcmin    deg deg yr  mag mag mag mag   pix 

--------  ----------  ----------  ----------  --------  ----- ----- ----- ----- - ------  -----

  0.1729  S0ES003231  035.239661  -04.767139  1995.641  19.45 21.50       17.70 0   1.87   0.03

  0.3271  S0ES003182  035.237587  -04.774893  1995.641  18.57 20.08       18.03 3   3.50   0.35

  0.5064  S0ES003260  035.238562  -04.761682  1995.641  19.32 20.38             3   1.90   0.05

  0.5842  S0ES003185  035.248471  -04.774853  1995.641  18.46 19.87       17.70 3   2.58   0.01

  0.8091  S0ES003208  035.226505  -04.771003  1995.641  20.26 21.51             3   1.56   0.36

  0.9022  S0ES003217  035.255088  -04.769846  1995.641  19.95 21.98             3   1.88   0.12

  0.9469  S0ES003252  035.254531  -04.763727  1995.641  17.26 18.02       17.03 3   3.54   0.12

  0.9910  S0ES003106  035.245923  -04.785426  1995.641  19.66 21.43             3   2.60   0.40

  0.9935  S0ES003120  035.248762  -04.784070  1982.643        21.87             3   1.54   1.00

  1.1402  S0ES003281  035.226090  -04.757000  1995.641  19.78 20.94             3   1.86   0.05

  1.1539  S0ES003189  035.259034  -04.773173  1982.643        22.15             3   1.12   0.39

  1.2087  S0ES003309  035.239418  -04.749864  1995.641  19.74 20.97             3   2.27   0.38

  1.2706  S0ES003314  035.243338  -04.749086  1995.641  18.12 19.41       17.66 0   2.75   0.05

  1.3178  S0ES000050  035.254222  -04.753221  1995.641  13.52 14.57       13.24 0   5.54   0.08


这种感觉的文档，其中的Fmag差不多是r mag

有句古话是说，如果有个程序能读所有的文件，那么一定是你自己写的

这种空格+漏行的格式很难读，我用的idl读成字符串，写起来不麻烦，主要的句子是：

gsc[i_gsc - line_start].r_c = float(strmid(string_temp_line[i_gsc], 2, 6))

这种感觉，用strmid来取字符串，最后生成fits

对应程序是Hecto_guidestar.pro，此时得到的是个fits文件

接下来要做catalog match来查看 ra dec 的 offset，这一步很有必要，一方面guide star不一定是哪一年拍的，说不定会有自行，另一方面如果offset比较大，会胡guide

程序是Hecto_match_gsc_catalog.pro，match的思路很简单就是算一下ra dec的距离，为了节省时间我先排出一些明显很远的源再做比较

有了match的结果，就可以算offset了，程序是Hecto_gsc_offset_plot.pro 生成个文件叫做 gsc_ra_dec_offset.txt，用HISTOGAUSS做出来的offset和sigma，有注释

还可以顺便画个图看看

2, 准备f star
-----

f star是用来做流量定标的，由于其亮的波段和我将会用的所谓270接近，比较合适做流量定标，找f star的方法我还在学习，基本上是从color color上选一下

假设已经找到了，存在一个fits里

之后同样的，要做catalog match，程序在Hecto_match_SDSS_fstar_catalog.pro

3, 准备目标源
-----

这个就是怎么搞的准备好了的需要拍光谱的源列表，没什么好说的，至少有ra dec 和星等吧

4, 准备总的文件
-----

程序在Hecto_obs_catalog.pro，主要内容是把刚才准备的那些catalog放在一起并且用tab做分隔符来配合即将登场的xfitfibs

这里有若干需要注意的地方：

a, guide star的选取

guide star不能有的亮有的暗，因为如果最终选中的guide star 一个特别亮一个特别暗，除了敏感与天气的影响外，还有一些容易被亮星带偏的麻烦，因此可以限制星等在14.5 15.5之间，实在稀缺guide star的时候可以略亮一点

b, f star 选取

历史不断的证明，并将继续证明，如果观测的总曝光时间有1小时，一个18等星是一定能看清楚的，因此f star大约选在16 18等之间即可，不要太亮，光谱搞饱和了就更不好玩了

c, rank赋值选取

guide star 统统是0，f star 统统是1，余下的分配2-5

余下的如何分配2-5，这是个大问题，我需要再想想

d, 不大不小的技巧：

如果要对一个天区拍两次，由于f star 也是被当做源来拍的，如果拍过了就不会再拍，导致这个区域第二次曝光的时候没有足够多的f star做定标，为此可以重复出现一下这些f star，保证能有足够多的f star 做定标

希望再多次一些曝光的暗源也可以这么搞，多出现几次暗源就能把曝光时间延长了


-----
#下集预告：使用xfitfibs的艺术


参考：
---

官网的手册：https://www.cfa.harvard.edu/mmti/hectospec.html

不是最后的最后，非常感谢Chris老师的耐心帮助，让我对MMT的了解从一个平面网页变得立体，生动起来

附录：
---

0，图森的生活：

我主要活动在亚利桑那大学周边，学校里有食堂，学校外有旅馆，学校旁边有一些餐馆和冰激凌店，他们都会先问候一下

1，亚利桑那大学的生活：

走在N Cherry Ave. 上，路过NOAO，进入Steward大楼，或者继续走看到镜子实验室，心情相当激动，这已经很high了，别的娱乐暂时不需要了

2，如何上山：

如果能开车，可以在这里租车开上去，或者可以提前半月左右写邮件给MMT问一下如何上下山，并且注明你愿意多住几天还是怎样，MMT的工作人员会非常热心的安排一些顺风车，建议新手不要冒然开车上山，山高路险需要老司机

3，山上如何生存：

首先参考贝爷的系列视频，学习野外生存技巧，之后去超市买点东西，山上有宿舍和厨房，可以自己做饭


4，关于给PI写邮件

我的经历是第一次我就写了一句话：

我是那谁，我在申请TAP时间，想用Hectospec看一些暗源，希望得到批准

D很快回信说：

好说，多暗？

我一看有戏，立刻回复说

22等

D再次很快回信：

来来来，详细说说？

我这次才写邮件说我想做光谱巡天

D回信说：

这种光谱巡天cfa的人正在做，我不能给你批准

proposal还是提交了，后来发现这个申请写的非常粗糙

暂且轮不到用“没有PI批准邮件”这种理由来拒绝

转眼半年，可以再申请第二季观测了，我再次给PI写信

此时我提前了很久就准备写这个邮件，我这么写的：

您好，我是那谁，在申请TAP的时间，我们打算做个这样的观测，将会有助于

a,
b,
c,
...

其中的源有__等，是否可以批准

为了防止被发现这个想法已经和cfa组撞车，我换了个角度解释其意义

出我意料的顺利，D很快回邮件说

我看行

没有一步不艰辛啊有没有，处处有难步步该栽啊有没有

好了至少你知道不能一句话来PI批准了


----

MMT/hectospec笔记二：config提交
----

经过上一节的努力，我已经能弄出来个可以被xfitfibs运行的catalog了，请一定要看新的程序，也许原来的程序有个指标写错了，转换gsc的txt的时候要等网页冷静下来后再复制文档，得到后要检查一下字符的位置，但这都不是事儿你说是吧

这里简单说一点行情和技巧：

0，参数设置

xfitsfib可以在网上下载，并且每年都会更新，用法如下：

加载cat文件，鼠标点一下那个蓝圈拖动，或者直接填写ra dec，观测时间，曝光时间，次数，棱镜编号

由于Hectospec是q mode，也就是由操作员安排好具体的观测时间后顺次观测，观测时间写源上中天的时间就行

先fit导星，之后要classify一下，这一步是链接到cfa的网站用sextractor找一下这个位置是不是有星，也许会找不到，这时候可以动一下视场的圆圈，或者动一下导星的轨道，把蓝圈点成红的，点fit导星下面那个键，用鼠标拖那个导星的弧

mmt导星在三个镜片的120°三个方向，至少两颗星才行

fit fibber的时候，设置sky的number，mmt的sky做法是随机的放置一些光纤，默认至少三十个，基本够用了，rank设置可以给出每个rank至少多少，至多多少，其中的minfield，maxfield是每次config一个row的时候最少最多的值，min max是总的最少最多的值，比如rank 1 的源有一百个，分了十次观测，那么平均每次个数大约是10个，如果设成100个程序会报错，用来做定标的F star大约10个就够用

1，曝光时间

增加一倍曝光时间并不是很有助于改善信噪比，由于观测哪些源是由某个不停更新的软件定的，我们要认真点做这个事情：

如果有一些源曝光一次不够，可以把这些源重复出现一次，并且优先级给到最高，并且用至少两个同一个位置的config table，软件在分配光纤位置的时候会同时在两个table里放置优先级高的源，我的感觉是rank设置为1的会尽量被分配到光纤，2的几乎可以保证，3的时候能有70%，4和5的就是随机的来几个

由于F star很重要，可以设置F star rank = 1，剩下的源分配2-5，rank 不建议拖拖拉拉的从1到100都有，这样软件运行时间会很长，我的感觉是从1到5，十个config table，大约1小时左右

所以对于强烈要求观测的源，有一个办法是设置这种源rank = 1，F star rank = 2，config出来后按右边rank 设置，能看到每个config tab得到多少个源，总共多少个源，rank = 2，并且个数10个的话，都能分配到光纤，rank = 1 的源会按照平均下来能摆得下的情况几乎都能配置到光纤，算是一个不大不小的技巧

同时出现的还有一些文本，有一个cfg是记载那些源会被观测，可以用ds9看一下是不是满意

2，fit导星的时候要注意有没有选中那个config table，我是会全选一下，这里要注意选中，否则容易奇怪

3，MMT/Hectospec 的主办方会发邮件说几号把config文件send过去，一般是波士顿的周五，以往经历来看不是那种严格当地时间几点前接收，因为周五傍晚他们下班并被堵车在路上，周末休息，并没有个特别精确的deadline，提交的时候是选那个send选项，选你的名字的那个项目，点send，这时候会有个弹窗出来，表示已经收到了，可以截图留念

4，MMT是欢迎观测者在所谓的观测时间去圆顶观测的，尽管并不一定是观测你的源，一个好处是可以跟操作员讨论一下观测是怎么回事，多一个智力输出，一个经典案例是config file似乎是要看一个星系的外围，目标源什么看上去很怪，Chris也听不懂，但是看到PI名字的时候立刻明白他要做什么，并且解释明白了要怎么观测

另外尽管是q mode，如果你去了，他们会多多少少观测你的源给你看

5，mmt官网写了很多很详细的信息，懒得看的话，那就是他们会有厨房，但是没有米，可以自带粮食上去做饭，如果没有车或者没有驾照，提前告知MMT的话，会得到相关安排

想起什么再补充吧，每个望远镜都有自己的一套理论，要不断学习，下一节讲数据处理

MMT/Hectospec 数据处理
------

Hectspec 的数据处理已经有何止是完善的pipeline，最近有了2.0版，整个流程浑浑噩噩，已经没有什么参与感了，相关网页在：

http://mmto.org/node/536
http://www.mmto.org/~rcool/hsred/hsred_reductions.html
http://mmto.org/~rcool/hsred/hsred_reductions.html

整个过程基于SDSS的pipeline idl code，最初还要用一些iraf的程序，后来c把程序重写成纯idl的程序，后来又来了一版，也就是现在的样子，安装过程可能碰到的问题是：

1，idlspec2d的lib只有libspec2d.dylib却没有libspec2d.so库，我的做法是在src的Makefile里生成库的那句话后加上 -o $(LIB)/libspec2d.so 这样就生成了so库，安装过程是evilmake all

2，hsred有推荐的sdss 的idl库的版本，建议考虑一下

好下面开始跑程序，下面是270grating的流程，从F star开始：

If the F star is used for calibration, then change the stardstar.dat in path_to/HSRed/etc into the F star catalog of the observation. This is why you need the mag and unreden mag in F star SDSS sql

In the raw data path

hs_pipeline_wrap, /uberextract

Then find the reduction/0100/spHect-xmm_lss_2010_rev_5.0684-0100.fits

error might occur because the raw data include 600 and 270. For bias file its the same, otherwise you need to pick it out:

|spawn, ‘ls *.fits’, name_list
|spawn, ‘mkdir 600_gpm’
|for i_list = 0, n_elements(name_list) – 1 do begin
|	if sxpar(headfits(name_list[i_list]), ‘NAXIS1’) eq 640 then continue
|	if sxpar(headfits(name_list[i_list],EXT = 1), ‘DISPERSE’) eq ‘600_gpm ‘ and strmid(name_list[i_list], 0, 4) ne ‘bias’ then spawn, ‘mv ‘+name_list[i_list]+’ ./600_gpm’
|endfor

hs_reduce1d, “The spHect file path”

Then there might be an error from mpfit, which is caused by the fitting code use the old version mpfit in idlutils.

.r /Users/chengcheng/lib_idl/idlutils/pro/mpfit/mpfit.pro
.r /Users/chengcheng/lib_idl/idlutils/pro/mpfit/mpfitfun.pro
hs_reduce1d, “The spHect file path”

****************************************

Now you have some spZall, spZbest files etc. This is kind of spec-z catalog now.

One more thing, you need to verify the spec-z. Verfication code is qplot:

1, Config the perl code to generate the cat file, which is used by qplot:

input:

rerun
obsdir
source
configuration

in the first several lines

then:

@cats for the catlog which have been inputed into xfibfits

regions_path	for output path
root_dir for output path

perl this .pl file then we get the cat file in the obsdir

example of the output:

****************************************

~/Jobs/Extent_SDSS/data_process/idl_code$perl absorbers_reduce.pl
Name “main::date” used only once: possible typo at absorbers_reduce.pl line 315.
Name “main::images_cl” used only once: possible typo at absorbers_reduce.pl line 568.
Name “main::target” used only once: possible typo at absorbers_reduce.pl line 426.
Name “main::sdss_id” used only once: possible typo at absorbers_reduce.pl line 266.
Name “main::mask” used only once: possible typo at absorbers_reduce.pl line 358.
Name “main::fiber” used only once: possible typo at absorbers_reduce.pl line 426.
Name “main::beam” used only once: possible typo at absorbers_reduce.pl line 426.
Name “main::raw_data_path” used only once: possible typo at absorbers_reduce.pl line 295.
Name “main::platex” used only once: possible typo at absorbers_reduce.pl line 427.
Name “main::regions_path” used only once: possible typo at absorbers_reduce.pl line 289.
Name “main::id” used only once: possible typo at absorbers_reduce.pl line 426.
Name “main::platey” used only once: possible typo at absorbers_reduce.pl line 427.
Name “main::chart” used only once: possible typo at absorbers_reduce.pl line 258.
root_dir is /Users/chengcheng/Jobs/Extent_SDSS/data_process/ ; dir is /Users/chengcheng/Jobs/Extent_SDSS/data_process//2010.1011
config 0
First map file for this configuration is
/Users/chengcheng/Jobs/Extent_SDSS/data_process//2010.1011/xmm_lss_2010_rev_2.0616_map

First map file for this configuration is
/Users/chengcheng/Jobs/Extent_SDSS/data_process//2010.1011/xmm_lss_2010_rev_2.0616.cat

reduced file is
/Users/chengcheng/Jobs/Extent_SDSS/data_process//2010.1011/reduction/0100/spHect-xmm_lss_2010_rev_2.0616-0100.fits
cannot open /data1/mmt/2010.1011/crank2.idl at absorbers_reduce.pl line 360.
~/Jobs/Extent_SDSS/data_process/idl_code$perl absorbers_reduce.pl
Name “main::date” used only once: possible typo at absorbers_reduce.pl line 315.
Name “main::images_cl” used only once: possible typo at absorbers_reduce.pl line 568.
Name “main::target” used only once: possible typo at absorbers_reduce.pl line 426.
Name “main::sdss_id” used only once: possible typo at absorbers_reduce.pl line 266.
Name “main::fiber” used only once: possible typo at absorbers_reduce.pl line 426.
Name “main::beam” used only once: possible typo at absorbers_reduce.pl line 426.
Name “main::raw_data_path” used only once: possible typo at absorbers_reduce.pl line 295.
Name “main::platex” used only once: possible typo at absorbers_reduce.pl line 427.
Name “main::regions_path” used only once: possible typo at absorbers_reduce.pl line 289.
Name “main::id” used only once: possible typo at absorbers_reduce.pl line 426.
Name “main::platey” used only once: possible typo at absorbers_reduce.pl line 427.
Name “main::chart” used only once: possible typo at absorbers_reduce.pl line 258.
root_dir is /Users/chengcheng/Jobs/Extent_SDSS/data_process/ ; dir is /Users/chengcheng/Jobs/Extent_SDSS/data_process//2010.1011
config 0
First map file for this configuration is
/Users/chengcheng/Jobs/Extent_SDSS/data_process//2010.1011/xmm_lss_2010_rev_2.0616_map

First map file for this configuration is
/Users/chengcheng/Jobs/Extent_SDSS/data_process//2010.1011/xmm_lss_2010_rev_2.0616.cat

reduced file is
/Users/chengcheng/Jobs/Extent_SDSS/data_process//2010.1011/reduction/0100/spHect-xmm_lss_2010_rev_2.0616-0100.fits
qplot_cat is /Users/chengcheng/Jobs/Extent_SDSS/data_process//2010.1011/xmm_lss_2010_rev_2.cat
cat is /Users/chengcheng/Jobs/Extent_SDSS/data_process//2010.1011/xmm_lss_2010_rev_2.0616.cat
map is /Users/chengcheng/Jobs/Extent_SDSS/data_process//2010.1011/xmm_lss_2010_rev_2.0616_map
~/Jobs/Extent_SDSS/data_process/idl_code$

****************************************

2, config qplot:

Edit the run_qplot:

data_path	should be the path to the date name file.

file = data_path+date+’/reduction/0100/spHect-‘+program+’_’+config+’.0616-0100.fits’
spzbest = data_path+date+’/spZall-‘+program+’_’+config+’.0616-0100.fits’
catalog = data_path+date+’/’+program+’_’+config+’.cat’

remember to change the *0616-0100.fits’* part. But it is OK to leave it there since there will be error message to instruct you change the right path and name.

3, qplot usage:

? is the help comand

a, All the redshfit are judged by you. Usually:

Q = 4 the redshift is clearly identified using more than two significant spectral features.
Probability P > 95% of being correct.
Q = 3 the redshift is very likely identified. Multiple spectral features are used, but some of
the features have low signal-to-noise ratio. 90% < P < 95%.
Q = 2 the redshift is identified based on single, weak spectral features (including continuum
break). Probable, but unreliable. P @hecto.batch

Try to understand ALL the error information and fix it. Several tips:

1, run zcat.batch in qplot to make the catalog file more readable by hecto.batch

2, Change the path in hecto.batch as the right ones by hand.

3, mkdir some files for the fitline results.

后续的改进可以有：

1，把整个流程写的连续一些

2，谱线拟合的程序写的更美好一些

3，等等，但都是小改动，需要点时间和耐心，精力和勇气

好了我现在知道怎么处理MMT/Hectospec的数据了


MMT/hectospec笔记四：数据下载
----
---

尽管山上没有宿舍，并不影响我还是有话要说，关于观测

首先是这些网页：

MMT天气：http://www.mmto.org/node/217
MMT监控：https://www.mmto.org/webcams
MMT全天：http://skycam.mmto.arizona.edu

其中第三个可以查询下载往日往夜的视频，能看到飞机飞来飞去，云飘来飘去，银河系徐徐推进，日月像两把圆梭

和

夜空中有个红圈，有观测的晚上这个红圈的位置是MMT的指向，结合

https://www.cfa.harvard.edu/~caldwell/outgoing/logs/

可以看到当自己的源被观测的时候，云量月亮如何行走

比如我的源被观测的时候，视频显示中途有一片温柔云，穿堂而过

在郑老师的指导下，我了解到还有更专业的网页：

http://observatories.hodar.com/index.html

可以用来看云识天气，上面有个cam的链接，可以看到各个天文台的此时此刻

由于我一直有看这种全天相机之类的镜头的习惯，每当自己不是很有状态，抓狂或者怎样的时候，我就会打开兴隆或者丽江的相关网页发呆

现在我又得到了更多的发呆网页，会不会影响发呆的质量啊，我问自己

有一天傍晚，这个网页上显示着各个天文台的黄昏，忽然想起一个电影，叫All the Mornings of the World

好，玩够了以后是数据下载，也是为什么我会写第四个笔记：

当目标源被观测后，系统会发来一个sh的脚本，用来指导如何下载，通常是这样的：

>#!/bin/sh
>
># Copy SPEC files from distribution area
># using TAR via NFS or CURL via HTTP
>
>localtar=gtar
>dowget=0
>
>[ -f $localtar -a -x $localtar ] || localtar=tar # Linux tar is GNUtar
>
>…….
>
>urlbase=https://www.cfa.harvard.edu/oir/data/mmtdist/rawdata/spec/2016C-UAO-G21
>while read filename; do
>curl –create-dirs –tlsv1.1 -o $filename $urlbase/$filename
>done
>fi
>exit 0

这时候，按照来信说明

sh SPEC.2016C-UAO-G21.RAW.161002T1335.sh <dirname>

可能完全无法下载，可能的改动是：

dowget=0 >>> dowget=1

或者由于curl的错误需要把

curl –create-dirs –tlsv1.1 -o $filename $urlbase/$filename

改成

curl –create-dirs –tlsv1 -o $filename $urlbase/$filename

Chris老师的系统是linux，只碰到了wget的问题，我的系统是苹果10.9，需要改动curl那句话

其实如果不介意的话，可以看一下这个sh文件，重新做一个需要下载的文件的链接，直接下载就行

好了，这个系列告一段落

祝大家夜空澄澈，开心快乐


