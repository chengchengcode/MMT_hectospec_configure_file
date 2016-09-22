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

Chris的网页：http://mips.as.arizona.edu/~cnaw/hectospec.html

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
