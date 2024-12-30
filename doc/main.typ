#import "@preview/quick-maths:0.2.0": shorthands
#show: shorthands.with(
  ($**$, $times$),
  ($===$, $equiv$),
  ($~=$, $approx$),
)

#import "@preview/fletcher:0.5.3": diagram, edge

#import "template.typ": project, table-header, thin-hline, subpar-grid, corollary, proof, parencite
#show: project.with(
  headline: "非平稳信号处理·考核论文",
  title: "Wigner–Ville分布中交叉项的意义",
  authors: (
    (name: "薛龙斌", email: "3120245441@bit.edu.cn", id: "3120245441"),
    (name: "徐元昌", email: "y_d_x@bit.edu.cn", id: "3120245440"),
  ),
  date: datetime.today().display("[year]年[month]月[day]日"),
)

#import "alias.typ": *

#heading(numbering: none)[摘要]

Wigner--Ville分布（Wigner--Ville distribution, WVD）是一种双线性形式的时频分布，这意味着WVD一般存在交叉项。首先，构造一特例让WVD中的交叉项消失。对于双分量随机信号，如果两分量的相位差随机，那么其WVD的期望可以没有交叉项。并用Monte Carlo仿真验证。其次，探究WVD的物理意义。与自项相比，WVD中的交叉项反映了分量间的稳定相位差。从时域可用自相关定性理解，从频域可用互WVD的平移性质定量理解。再次，分析WVD中交叉项的几何特征。交叉项振荡的位置、方向、疏密与信号各分量密切相关，并且可用于检测弱信号。然后，研究WVD中的交叉项显现到时域的条件。以桌子振动产生的双频信号为例验证。此外，WVD首先在量子物理领域提出，量子物理与信号分析也许存在联系，我们给出了其间的翻译词典。

= 介绍 <sec:intro>

== WVD的双线性与交叉项 <sec:bilinear>

对于从实数集 $RR$ 映射到复数集 $CC$ 的两个函数 $x, y$，定义其*瞬时互相关*为
$
  R_(x,y) (t, tau) := x(t + tau/2) y^*(t - tau/2),
  quad t,tau in RR,
$
其中 $t$ 为 $x,y$ 自变量的平均值，$tau$ 为 $x,y$ 自变量之差，加“$#h(0em)^*$”表示共轭。如果将 $x,y$ 看作时域信号，其自变量代表时刻，则 $t$ 代表平均时刻，而 $tau$ 代表时间差。由映射 $(x,y) |-> R_(x,y)$ 定义的形式可知它满足以下性质。
- 共轭反转对称：$forall t,tau in RR, thick R_(y, x) (t,tau) = R_(x,y)^* (t,-tau)$；
- 齐次：$forall lambda in CC, thick R_(lambda x,y) === lambda R_(x,y)$；
- 可加：$R_(x+y, z) === R_(x, z) + R_(y,z)$。
因此，$(x,y) |-> R_(x,y)$ 是共轭反转对称的双线性映射。

瞬时互相关是二元函数，应用Fourier变换于第二个变量，结果称是
$
  WVD_(x,y) (t, f) := integral_RR R_(x,y) (t,tau) ** e^(-j 2pi f tau) dif tau,
  quad t,f in RR.
$
这称作 $x,y$ 的互Wigner--Ville分布（Wigner--Ville distribution, WVD），简称*互WVD*。
如果将 $x,y$ 看作时域信号，则 $WVD_(x,y) (t,f)$ 大致反映能量在 $t$ 时刻 $f$ 频率附近的分布密度。WVD同时描述时刻、频率，是一种时频分析工具。由Fourier变换的线性性质和反转性质，映射 $(x,y) |-> WVD_(x,y)$ 满足以下以下性质。
- 共轭对称：$WVD_(x,y) === WVD_(y,x)^*$；
- 齐次：$forall lambda in CC, thick WVD_(lambda x,y) === lambda WVD_(x,y)$；
- 可加：$WVD_(x+y,z) === WVD_(x,z) + WVD_(y,z)$。
因此，$(x,y) |-> WVD_(x,y)$ 是共轭对称的双线性映射。


$x === y$ 时，瞬时互相关退化为*瞬时自相关*，互WVD退化为*自WVD*（无歧义时可简称作WVD）：
$
  R_x (t, tau) &:= x(t + tau/2) x^*(t - tau/2),
  quad t,tau in RR, \
  WVD_x (t, f) &:= integral_RR R_x (t,tau) ** e^(-j 2pi f tau) dif tau,
  quad t,tau in RR.
$
将 $x === y$ 代入瞬时互相关、互WVD的性质，可知瞬时自相关、自WVD满足以下性质。
- 自相关共轭对称，自WVD实：$forall t,tau in RR,thick R_x (t,tau) = R_x^* (t,-tau)$ 与 $WVD_x === WVD_x^* in RR$；
- 二次：$forall lambda in CC, quad thick R_(lambda x) = abs(lambda)^2 R_x,space WVD_(lambda x) = abs(lambda)^2 WVD_x$；
- 叠加：$R_(x + y) = R_x + R_y + R_(x,y) + R_(y,x), space WVD_(x+y) = WVD_x + WVD_y + WVD_(x,y) + WVD_(y,x)$。
将以上第一个性质代入第三个性质，可得
$
  R_(x + y) &= R_x &&+ R_y &&+ 2 caron(Re) R_(x,y) , \
  WVD_(x+y) &= underbrace(WVD_x, "自项") &&+ underbrace(WVD_y, "自项") &&+ underbrace(2 Re WVD_(x,y), "交叉项"),
$ <eq:expand-sum>
其中 $Re$ 表示提取函数的实部，即 $Re WVD_(x,y) := 1/2 (WVD_(x,y) + WVD_(x,y)^*)$，而 $hat(Re)$ 表示提取函数的共轭对称成分，即 $hat(Re) R_(x,y) (t,tau) := 1/2 (R_(x,y) (t,tau) + R_(x,y)^* (t,-tau))$。

@eq:expand-sum 中，两函数之和的瞬时自相关、自WVD，除了包含两函数各自的瞬时自相关、自WVD，还与两函数的瞬时互相关、互WVD有关。前者各自称作自项，后者统一称作*交叉项*。如果不将 $x,y$ 看作信号，而只将它们看作双分量信号 $z = x+y$ 的两个*分量*，则@eq:expand-sum 说明多分量信号的瞬时自相关、自WVD并非各分量瞬时自相关、自WVD的简单叠加，而还包含分量之间的交叉项。@fig:intro 展示了一个双分量信号的WVD，该信号包含两个时频位置不同的波包。可见WVD的能量分布于三块，除了与两波包时频位置对应的两块自项，还有一块位于其间的交叉项。

#figure(
  image("fig/10次MC仿真.png"),
  caption: [双分量信号的WVD的能量分布于两块自项和一块交叉项]
) <fig:intro>

== 关于交叉项的讨论

一般认为，WVD存在交叉项这一特点，是它在多分量信号应用中需要克服的不足，需要进行抑制。

然而WVD的“刚性”比较强，它不像短时Fourier变换（short-time Fourier transform, STFT）、小波变换、Cohen类那样有窗的形式、尺寸、作用域等人为因素可调。WVD给出的结果基本可认为是信号所固有的。如果这种工具分析出的结果不符合人的直观，有可能意味着人的直观需要修正，而未必是分析结果错了。

并非只有WVD“刚性”强，Fourier变换也是如此，并且Fourier变换也曾给出“反直觉”的结论。例如用Fourier变换分析正弦信号，以往直观认为信号中只有单一频率，而Fourier变换却给出正负两个频率，工具分析结果不符合直观。这时有两条处理思路。一条是修改工具，替换Fourier变换，去掉负频率，让变换只给出符合以往直观的正频率。沿着这条思路发展出了解析信号和Hilbert变换等。另一条是修正直观，接受负频率的存在，就用正负两个频率分析。沿着这条思路发展出了正交调制、频谱循环混叠分析方法等。可见，修正直观与修改工具一样都是可行思路。

用WVD分析双分量信号，以往直观认为只有两块与两分量对应的能量，而WVD却给出两自项、一交叉项共三块能量。考虑修改工具，已经提出了Choi-Williams分布（Choi–Williams distribution, CWD）等加窗WVD。考虑修正直观，则现有研究不充分。

本文将沿修正直观这一思路分析。@sec:disappear\构造一特例让WVD中的交叉项消失；@sec:meaning\探究WVD中交叉项的物理意义，@sec:geometry\分析其几何特征，@sec:reify\研究它显现到时域的条件；@sec:quantum\补充讨论信号分析与量子物理的联系。

= WVD可以没有交叉项<sec:disappear>

// TODO（徐）：“2.1.2.2”是哪里？薛：“感觉应该对应于第三节互WVD平移性质的推导。”
不同于STFT对信号的线性表示，WVD是一种非线性变换，是双线性形式的时频分布@张贤达2015a。假如某一个信号含有多个不同的分量，利用WVD对信号做时频分析的时候，这就不可避免地要讨论交叉项这个问题。对于含有多个不同分量的的确知信号，利用WVD分析该信号的时频特性。这时，时频平面上一定会出现交叉项，这在2.1.2.2将会有详细的讨论。而对于含有多个不同分量的随机信号，我们更关心集体的平均效果，信号的演变谱就等于该信号WVD的数学期望。由于随机信号的演变谱在WVD的基础上又求了数学期望，因此随机信号的演变谱中交叉项有可能为零，交叉线不会出现再时频平面中，也就是没有交叉项。

我们构造了一个随机信号，该随机信号含有两个分量，两个分量之间相差一个均匀分布的随机相位。该信号的演变谱将没有交叉项，这点可以从数学上去证明。此外，我们进行了Monte Carlo仿真实验，进一步验证我们的猜想。

构造含有两个分量的随机信号形式如下：
$
  X(t) = x_1 (t) + C x_2(t),
  quad t in RR,
$
其中，$x_1 (t)$ 和 $x_2 (t)$ 是确定信号，$C = e^(j phi)$，$phi ~ U(0, 2 pi)$。

== 数学证明

所构造的随机信号 $X(t)$ 的演变谱为：
// TODO: 用@sec:intro\简化
$
  & expect WVD_X (t,f) \
  & = expect integral_RR X(t+tau/2) X^*(t-tau/2)e^(-j 2pi f tau) dif tau \
  & = expect integral_RR
    [x_1(t+tau/2) + C x_2 (t+tau/2)]
    [x_1(t-tau/2) + C x_2(t-tau/2)]^*
    e^(-j 2pi f tau) dif tau \
  & = expect integral_RR
    x_1(t+tau/2) x_1^*(t-tau/2) e^(-j 2pi f tau) dif tau \
  &quad + 2 Re expect integral_RR 
    C x_1 (t+tau/2) x_2^*(t-tau/2) e^(-j 2pi f tau) dif tau \
  &quad + expect integral_RR
    abs(C)^2 x_2(t+tau/2) x_2^*(t-tau/2) e^(-j 2pi f tau) dif tau.
$ <eq:expect-wvd>
@eq:expect-wvd 中，第一项和第三项为自项，第二项为交叉项。

第二项交叉项可以利用两个信号之间的相位差 $phi$ 服从 $[0, 2pi]$ 之间的均匀分布进一步写作：
$
  & 2 Re expect integral_RR C x_1(t+tau/2)x_2^*(t-tau/2) e^(-j 2pi f tau) dif tau \
  & = 2 Re integral_RR dif tau integral_0^(2pi) (dif phi)/(2pi) C x_1(t+tau/2) x_2^*(t-tau/2) e^(-j 2pi f tau) \
  & = 2 Re integral_0^(2pi) C (d phi)/(2pi) **
    integral_RR x_1(t+tau/2)x_2^*(t-tau/2) e^(-j 2pi f tau) dif tau.
$ <eq:expect-cross>
@eq:expect-cross 中，$integral_0^(2pi) C (dif phi)/(2pi) = 0$，所以随机信号 $X(t)$ 演变谱的交叉项为0，也就是刚好没有交叉项。



#figure(
  image("fig/cross_intensity.png"),
  caption: [TODO：理论差个系数],
)

== Monte Carlo实验

我们对构造的随机信号 $X(t)$ 的演变谱进行了Monte Carlo仿真实验，实验中随机选择相位 $phi$，10次、100次、500次、1000次、2000次Monte Carlo实验的结果如@fig:WignerNoCrossterms 所示。当实验次数分别为10次、100次和500次时，交叉项隐约可以看到，但是交叉项随着仿真次数的增加啊会变得更小。进一步增加实验次数至1000次、2000次，交叉项基本消失。

我们选择交叉项绝对值的最大值作为交叉项的幅度，基于此分析交叉项的Monte Carlo实验的仿真结果与理论值的偏差，结果如@fig:cross_intensity 所示。随着样本数量的增加，交叉项的幅度会变得更小，这进一步印证了所构造的信号的演变谱没有交叉项。

#subpar-grid(
  columns: 3,
  figure(image("fig/10次MC仿真.png"), caption: [10次实验]),
  figure(image("fig/100次MC仿真.png"), caption: [100次实验]),
  figure(image("fig/500次MC仿真.png"), caption: [500次实验]),
  figure(image("fig/1000次MC仿真.png"), caption: [1000次实验]),
  figure(image("fig/2000次MC仿真.png"), caption: [2000次实验]),
  figure(image("fig/cross_intensity.png"), caption: [仿真与理论误差]), <fig:cross_intensity>,
  caption: [Monte Carlo实验结果及误差分析],
  label: <fig:WignerNoCrossterms>,
)

= 交叉项的物理意义 <sec:meaning>

@sec:disappear\说明WVD中的交叉项并不总存在，交叉项存在与否本身就蕴含了信息。本节研究交叉项信息的物理意义，特别关注自项没有而交叉项独有的信息。

== 时域定性理解交叉项的物理意义

以双分量信号 $z = x+y$ 为例讨论。由@eq:expand-sum，$WVD_z$ 中的自项、交叉项与 $R_z$ 的两自项、一交叉项一一对应，构成三个Fourier变换对。既然WVD中交叉项与瞬时自相关中交叉项在数学上可相互推出，那么其物理意义自然也一致。按@eq:expand-sum，$R_z$ 中的交叉项等于 $2 caron(Re) R_(x,y)$，而
$
  R_(x,y) (t,tau) := x(t+tau/2) y^*(t-tau/2),
$ <eq:cross-corr>
其辐角是 $arg x(t+tau/2) - arg y(t-tau/2)$，即分量间的相位差。——交叉项反映分量间的相位差。

特别注意，分量间相位差是交叉项独有的，在自项完全没有反映。首先，分量的自项并不反映其绝对相位，无法推出分量间相位差。@sec:bilinear\中介绍了自WVD的二次性质：$forall lambda in CC, thick WVD_(lambda x) = abs(lambda)^2 WVD_x$。若保持 $abs(lambda)$ 不变，改变 $arg lambda$，则 $lambda x$ 这一分量的绝对相位改变了，但其自WVD始终保持 $abs(lambda)^2 WVD_x$ 不变。这说明WVD中的自项不反映相应分量的绝对相位。其次，每个自项只与单个分量有关，不直接包含分量间的任何信息。

另外，如果采集信号时的初始时刻不确定，那么信号每个分量的绝对相位都不可知。而交叉项反映了分量间的相对相位，已经是这种条件下所能确定的全部信息。

以上根据@eq:cross-corr 定性分析，其实只是“交叉项反映分量间相位差”的必要不充分条件。因为交叉项并不是@eq:cross-corr，而是其共轭对称成分的Fourier变换。提取共轭对称成分时，还可能丢失这一信息。要想明确“交叉项反映分量间相位差”，还应定量理解。


== 互WVD的平移性质 <sec:shift>

交叉项的物理意义可从频域定量理解。为此先需证明一引理：互WVD的平移性质。

// §4 如何发表……证明 https://user.guancha.cn/main/content?id=1353068

按@sec:intro\分析，交叉项与互WVD紧密相关，双分量信号WVD中的交叉项等于分量间互WVD的实部的两倍，所以分析清楚互WVD有助于理解交叉项。然而双分量信号中的两个分量有很大任意性，而任意一对函数的互WVD的比较复杂。有了互WVD的平移性质，可以先把这一对函数归一化为标准的简单形式，分析这些简单形式间的互WVD，然后应用互WVD的平移性质把结论推广回任意一对函数。

#corollary[互WVD平移性质][
  对于一对 $RR -> CC$ 函数 $x, y$，任取 $t_x, t_y, f_x, f_y in RR$，定义另外一对 $RR -> CC$ 函数 $x',y'$：
  $
    x' (t) &:= x(t - t_x) ** e^(j 2pi f_x t), quad
    y' (t) &:= y(t - t_y) ** e^(j 2pi f_y t), quad
    t in RR.
  $
  那么 $forall t,f in RR$，
  $
    WVD_(x',y') (t,f) = WVD_(x,y) (t - t_mu, f - f_mu)  ** e^(j 2pi (f_d t - f t_d + f_mu t_d)),
  $
  其中
  $
    t_mu = (t_x + t_y)/2, &quad t_d = t_x - t_y, \
    f_mu = (f_x + f_y)/2, &quad f_d = f_x - f_y. \
  $
] <thm:shift>

#figure(
  block(
    diagram(spacing: (8em, 6em), $
      x,y edge(label: "各自延时、调频", marks: ->, dash: "dashed")
      edge("d", label: "互WVD", ->)
      & x',y'
      edge("d", label: "互WVD", ->)
      \
      WVD_(x,y)
      edge(label: "平移性质", marks: ->, dash: "dashed")
      & WVD_(x',y')
    $),
    inset: (bottom: 1em),
  ),
  caption: [互WVD平移性质所描述的关系]
) <fig:shift>

@thm:shift 可直观理解如@fig:shift。$x,y$ 各自延时、调频得 $x',y'$。于是在时频平面内，$x,y$ 各自的自WVD分别平移 $(t_x,f_x), (t_y,f_y)$，其间的互WVD也存在关联。具体来说，在时频平面内，将 $WVD_(x,y)$ 按平均平移量 $(t_mu, f_mu)$ 二维平移，并按平移量之差 $(f_d, -t_d)$ 二维调制，再适当调整初相，即为 $WVD_(x',y')$。

#proof[(@thm:shift)][
  互WVD与瞬时互相关是Fourier变换对，先分析瞬时互相关的变化，再导出WVD的变化。

  用 $R_(x,y)$ 表示 $R_(x',y')$：
  $
    R_(x',y') (t, tau)
    &:= x'(t+tau/2) y'^*(t-tau/2) \
    &= x(t-t_x+tau/2) e^(j 2pi f_x (t+tau\/2)) ** y^*(t-t_y-tau/2) e^(-j 2pi f_y (t-tau\/2)) \
    &= x(t-t_x+tau/2) y^*(t-t_y-tau/2) ** e^(j 2pi (f_x (t+tau\/2) - f_y (t-tau\/2))) \
    &= R_(x,y) (t-t_mu, tau-t_d)  ** e^(j 2pi (f_d t + f_mu tau)).
  $ <eq:shift-corr>
  可见瞬时自相关的变化是将 $t$ 先延时 $t_mu$、再调频 $f_d$，将 $tau$ 先延时 $t_d$、再调频 $f_mu$。

  对@eq:shift-corr 两端的 $tau$ 应用Fourier变换，左端套用互WVD的定义，右端利用Fourier变换的延时和调频性质，得
  $
    WVD_(x',y') (t,f)
    = WVD_(x,y) (t-t_mu, f - f_mu) ** e^(j 2pi (f_d t - (f-f_mu) t_d)).
  $
]

@thm:shift 中时频并不对称，这是平移顺序导致的。@thm:shift 是先延时再调频；如果先调频再延时，也能得到如下类似结论。

#corollary[互WVD平移性质的变体][
  前提条件同@thm:shift，补充定义第三对 $RR -> CC$ 函数 $x'', y''$：
  $
    x'' (t) &= x(t - t_x) ** e^(j 2pi f_x (t - t_x)), quad
    y'' (t) &= y(t - t_y) ** e^(j 2pi f_y (t - t_y)), quad
    t in RR.
  $
  那么 $forall t,f in RR$，
  $
    WVD_(x'',y'') (t,f) = WVD_(x,y) (t - t_mu, f - f_mu)  ** e^(j 2pi (f_d t - f t_d - f_d t_mu)).
  $
] <thm:shift-variant>

#proof[(@thm:shift-variant)][
  比较 $x', y'$ 与 $x'', y''$，可知它们只差与 $t,tau$ 无关的常数
  $
    x'' === x' ** e^(-j 2pi f_x t_x), quad
    y'' === y' ** e^(-j 2pi f_y t_y).
  $
  由@sec:bilinear\中介绍的WVD双线性性质，
  $ WVD_(x'',y'') === WVD_(x',y') ** e^(j 2pi (f_y t_y - f_x t_x)), $
  其中常数的指数中
  $
    f_y t_y - f_x t_x
    = -f_d t_mu - f_mu t_d.
  $
  再代入@thm:shift 给出的 $WVD_(x',y')$ 即得证。
]
另外也可直接从定义证明。
#proof[(@thm:shift-variant 另法)][ 
  用与@eq:shift-corr 类似的方法，可推出
  $
    R_(x'', y'') (t,tau)
    = R_(x,y) (t-t_mu, tau-t_d)  ** e^(j 2pi (f_d (t-t_mu) + f_mu (tau-t_d))).
  $ <eq:shift-corr-variant>
  可见瞬时自相关的变化是将 $t$ 先调频 $f_d$、再延时 $t_mu$，将 $tau$ 先调频 $f_mu$、再延时 $t_d$。

  对@eq:shift-corr-variant 两端的 $tau$ 应用Fourier变换，左端套用互WVD的定义，右端利用Fourier变换的调频和延时性质，得
  $
    WVD_(x'',y'') (t,f)
    = WVD_(x,y) (t-t_mu, f - f_mu) ** e^(j 2pi (f_d (t-t_mu) - f t_d)).
  $
]

其实对于 $x,y$ 可由同一函数延时、调频得到这类特例，#parencite(<hlawatsch1997>) 已给出@thm:shift 的证明。@thm:shift 的意义在于排除了无关因素，抽离出了研究交叉项需要的互WVD的更弱而又更本质的性质。

== 频域定量理解交叉项的物理意义

现在利用互WVD的平移性质，从频域定量理解交叉项的物理意义。

#[
  #let wvd = $WVD_(tilde(x), tilde(y))$
  
  考虑双分量信号 $z = x + y$。记两分量的时频中心分别为 $(t_x, f_x) in RR^2$ 与 $(t_y, f_y) in RR^2$，记两分量在各自时频中心的辐角分别为 $phi_x := arg x(t_x) in CC, thick phi_y := arg y(t_y) in CC$。

  首先，简化 $x,y$ 为 $tilde(x), tilde(y)$。构造
  $
    tilde(x) (t) &:= x(t + t_x) **e^(-j 2pi f_x t - j phi_x),
    &quad t in RR, \
    tilde(y) (t) &:= y(t + t_y) **e^(-j 2pi f_y t - j phi_y),
    &quad t in RR. \
  $ <eq:normalize>
  这样 $tilde(x), tilde(y)$ 是零时刻、零频率附近的零初相（$arg tilde(x) (0) = arg tilde(y) (0) = 0$）函数。

  接着，分析 $wvd$。 $tilde(x), tilde(y)$ 零频率故缓变，$tilde(x), tilde(y)$ 时间中心重合故 $wvd$ 类似自WVD。因此，$wvd$ 通常是零时刻、零频率附近的缓变分布，并且在其附近 $arg wvd ~= 0$。如果 $x,y$ 是Gauss波包，这严格成立；如果 $x,y$ 可由同一函数延时、调频得到，则 $tilde(x) === tilde(y)$，这也严格成立。如果 $wvd$ 明显偏离上述分布，则可将原信号分解为更多分量，让每对分量间的 $wvd$ 符合上述分布。

  然后，从 $wvd$ 恢复 $WVD_(x,y)$。反解@eq:normalize 可得
  $
    x(t) ** e^(-j phi_x) &= tilde(x)(t - t_x) **e^(j 2pi f_x (t-t_x)),
    &quad t in RR, \
    y(t) ** e^(-j phi_y) &= tilde(y)(t - t_y) **e^(j 2pi f_y (t-t_y)),
    &quad t in RR. \
  $
  应用@thm:shift-variant，得上式左端两函数的互WVD为
  $
    (t,f) |-> wvd(t-t_mu, f-f_mu) ** e^(j 2pi (f_d t - f t_d - f_d t_mu)).
  $
  再由WVD双线性，得
  $
    WVD_(x,y) (t,f)
    = wvd(t-t_mu, f-f_mu) ** e^(j 2pi (f_d t - f t_d - f_d t_mu)) ** e^(j (phi_x - phi_y)).
  $
  至此已分析清楚互WVD：在时频平面中，将缓变且几乎实的 $wvd$ 二维平移至 $(t_mu, f_mu)$，按 $(f_d, -t_d)$ 二维调制，再适当调整初相，即为 $WVD_(x,y)$。

  最后，从互WVD导出交叉项。由@eq:expand-sum，交叉项等于
  $
    2 Re WVD_(x,y) (t,f)
    &~= 2 abs(wvd(t-t_mu, f-f_mu)) \
    &quad ** cos(2pi (f_d t - f t_d - f_d t_mu) + phi_x - phi_y).
  $ <eq:cross>
  @eq:cross 中“$~=$”的唯一不严格处在于 $arg wvd ~= 0$。若满足前述任一严格成立条件，则 @eq:cross 也严格成立。

  观察@eq:cross，可见交叉项的表达式确实包含分量间相位差 $phi_x - phi_y$，交叉项振荡的基准点就是分量间相位差。
]

== 仿真验证

生成一双分量信号，其两个分量均为Gauss波包，其时频中心关于原点对称，而且宽度相同。改变两分量间的相位差，考查其WVD，得@fig:relative-phase。图中横纵坐标分别代表时频，颜色代表WVD。时频坐标经过归一化，故未在同中标出。由图可知，增加分量间相位差，自项（左下、右上两块恒正能量）完全不变，交叉项（中央一块正负交替能量）各处的振幅不变，但整体振荡基准向左上移动。相位差为 $0$ 时，交叉项正中心是极大值点（最绿）；相位差从 $0$ 增加到 $pi/2$，该极大值点从正中心向左上移动，正中心处的WVD逐渐减小，正中心成为为零点（无色）；相位差继续增加到 $pi$ 时，正中心变为极小值点（最红）；相位差变化 $2pi$，WVD恢复原貌。可见交叉项正中心处WVD的变换规律与相位差的余弦一致。

#figure(
  image("fig/relative-phase-frames.png", width: 100%),
  caption: [改变分量间相位差，考查WVD]
) <fig:relative-phase>

该信号的分量都是Gauss波包，@eq:cross 严格成立。又因两分量的时频中心关于原点对称，$t_d,f_d$ 均为零。因此，正中心处WVD的值
$
  WVD_(x,y) (t_mu, f_mu)
  &= 2 abs(dots.c) ** cos(2pi (f_d t_mu - f_mu t_d - f_d t_mu) + phi_x - phi_y) \
  &= 2 abs(dots.c) ** cos(0 + phi_x - phi_y). \
$
这与仿真结果一致。

== 交叉项可用于检测弱信号

如@fig:strength，信号两分量一强一弱时，弱分量的自项的幅度与弱分量幅度的平方成正比，而强弱交叉项的幅度与弱分量幅度的一次方成正比。交叉项强于自项，可用于检测弱信号。

#figure(
  image("fig/检测弱信号.png"),
  caption: [包含强弱分量的信号的WVD]
) <fig:strength>

以Gauss波包为例具体分析自项和交叉项的强度。取
$
  x(t) &= exp(2pi (- (t-t_x)^2/(2 sigma_x^2) + j f_x (t-t_x))),
  &quad t in RR, \
  y(t) &= exp(2pi (- (t-t_y)^2/(2 sigma_y^2) + j f_y (t-t_y))),
  &quad t in RR. \
$
（$sigma_x = sigma_y$ 时，可用@thm:shift-variant 快速计算。）
经过计算，自WVD
$
  WVD_x (t,f)
  &= sqrt(2) ** sigma_u ** exp(-2pi ( 1/sigma^2 (t-t_u)^2/2 + sigma^2 (f-f_u)^2/2)), \
  &quad t,f in RR, u in {x,y},
$
而互WVD
$
  WVD_(x,y) (t,f)
  &= sqrt(2) ** sqrt(2 / (1 \/ sigma_x^2 + 1\/sigma_y^2)) \
  &quad ** exp(-2pi S)
  &quad t,f in RR,
$
其中
$
  -2 (sigma_x^2 + sigma_y^2) Re S &= (2t - t_x - t_y)^2 + (2f-f_x-f_y)^2 sigma_x^2 sigma_y^2 >= 0, \
  (sigma_x^2 + sigma_y^2) Im S
  &= 2 f t (sigma_y^2 - sigma_x^2) + 2f (sigma_x^2 t_y - sigma_y^2 t_x) + (2t - t_x - t_y) (f_x sigma_x^2 - f_y sigma_y^2).
$
简而言之，$forall a, b in RR^+$,
$
  max WVD_(a x) = sqrt(2) a sigma_x, 
  quad max WVD_(b y) = sqrt(2) b sigma_y, \
  max WVD_(a x, b y) = sqrt(2) a b sqrt(2 / (1 \/ sigma_x^2 + 1\/sigma_y^2)).
$
$a=b$ 时，互WVD幅度是自WVD幅度的调和平方平均值。

= 交叉项的几何特征 <sec:geometry>

两分量的确定信号可以看作时频中心重叠的两个分量分别经过不同的时移和频移得到的。依旧按照@sec:shift 的思路，将 $x(t)$ 看作两个分量时频中心重叠的确定信号，根据互WVD的平移性质，此时信号的交叉项是缓变的。$x(t)$ 的两个分量分别经过时延平移和频率调制后得到 $x'(t)$，则信号 $x'(t)$ 的交叉项 $I_(x')(t,f)$ 为：

$
  I_(x')(t,f) & = 2Re WVD_(x_1,x_2)(t,f) \
              & = 2abs(WVD_(x_1, x_2)(t-t_(12),f-f_(12)))cos(2pi(v_(12)t-f tau_(12))+phi)
$

其中，$t_(12)=(t_1+t_2)/2$，$f_(12)=(f_1+f_2)/2$，$tau_(12)=t_1-t_2$，$v_(12)=f_1-f_2$，$phi$ 是由 $WVD_(x_1,x_2)(t-t_(12),f-f_(12))$ 的相位。

后面从交叉项的振荡位置、振荡疏密和振荡方向三个方面分析交叉项的几何特征。

@fig:cross-position 分别展示了两个分量相同和两个分量不同时的交叉项，从图中可以看到交叉项的振荡位置始终位于两个信号中间。交叉项 $I_(x')(t,f)$ 的振荡位置主要由 $abs(WVD_(x_1, x_2)(t-t_(12),f-f_(12)))$决定，交叉项的中心位置应该在两个分量时频中心连线的中点上，交叉项始终位于两个信号的自项中间。

#subpar-grid(
  columns: (auto, auto),
  figure(image("fig/两个信号分量相同时的交叉项.png", height: 15em), caption: [分量形式相同]),
  figure(image("fig/几何特征-分量形式不同.png", height: 15em), caption: [分量形式相同]),
  caption: [交叉项的振荡位置],
  label: <fig:cross-position>,
)

@fig:cross-distance 展示两个分量时频中心距离不同时的交叉项。从图中可以看到，随着两个信号时频中心距离的变大，信号的振荡变得更快，振荡变得更密集。交叉项 $I_(x')(t,f)$ 的振荡疏密主要由 $cos(2pi(v_(12)t-f tau_(12))+phi)$ 决定，随着分量时频中心间距的变大，$v_(12)$ 和 $tau_(12)$ 会变得更大，因此交叉项的振荡会更快，在时频图中更加密集。

#subpar-grid(
  columns: 3,
  figure(image("fig/几何特征-距离-0.8倍.png"), caption: [时频中心间距：$0.8$ 倍]),
  figure(image("fig/几何特征-基本-1倍距离-π_4角度.png"), caption: [时频中心间距：$1$ 倍]),
  figure(image("fig/几何特征-距离-1.7倍.png"), caption: [时频中心间距：$1.7$ 倍]),
  caption: [两个分量时频中心距离不同时的交叉项],
  label: <fig:cross-distance>,
)

@fig:cross-direction 展示了两个分量时频中心连线旋转不同角度下的交叉项。从图中可以看到，信号的振荡方向始终沿着两个分量的时频中心连线，也就是说交叉项振荡的等相位面平行于两个分量的时频中心连线。从理论上分析，交叉项 $I_(x')(t,f)$ 的振荡主要由 $cos(2pi(v_(12)t-f tau_(12))+phi)$ 决定，而 $cos(2pi(v_(12)t-f tau_(12))+phi)$ 的等相位面平行于两个分量的时频中心连线。

#subpar-grid(
  columns: 3,
  figure(image("fig/几何特征-旋转-0.png"), caption: [角度：$0$]),
  figure(image("fig/几何特征-基本-1倍距离-π_4角度.png"), caption: [(b) 角度：$pi/4$]),
  figure(image("fig/几何特征-旋转-π_2.png"), caption: [角度：$pi/2$]),
  caption: [两个分量时频中心连线不同角度时的交叉项],
  label: <fig:cross-direction>,
)

= 交叉项显现到时域 <sec:reify>

== 拍频现象

== 实验设计

= 信号分析与量子物理的翻译词典 <sec:quantum>

// 此外，Wigner函数在1932年被提出，用于描述量子态在相空间中的分布，而后被Ville引入到信号分析。量子物理与信号分析之间也许存在着某种联系，我们给出了其间的翻译词典。

= 任务分工

/ 薛龙斌: 主要负责演变谱没有交叉项时的数学证明、Monte Carlo仿真实验、互WVD平移性质的证明。

/ 徐元昌: 主要负责Monte Carlo仿真实验中误差分析、交叉项几何特征分析以及图像绘制，交叉项显现到时域实验、信号与量子物理的翻译词典……（其他几乎所有，你能想到的都往上写！）。

= 参考文献







=== 交叉项反映什么东西？

==== 互WVD反映相对相位

// TODO: `relative-phase.mp4`

两分量形式相同时，等相位面平行于两个时频中心的连线，源于公式 (3.3)@hlawatsch1997[page. 7] 中的 $cos$ 项，*看具体推导*，并考虑推广到形式不同的情况。

==== 关于两个不同的分量的交叉项的推导

假设确定信号 $x(t)$ 由两个分量 $x_1(t)$ 和 $x_2(t)$ 组成，即 $x(t)=c_1x_1(t)+c_2x_2(t)$。
为简单起见，先忽略两个分量的系数 $c_1$ 和 $c_2$，考虑 $x_1, x_2$ 的互WVD
$
  WVD_(x_1, x_2) (t,f)
  &:= integral_RR x_1(t+tau/2)x_2^*(t-tau/2) e^(-j 2pi f tau) dif tau \
  &= integral_RR X_1(f+nu/2) X_2^*(f-nu/2) e^(j 2pi nu t) dif nu.
$
互WVD的时移性质：
$
  & integral_RR x_1(t+tau/2-t_1) x_2^*(t-tau/2-t_2) e^(-j 2pi f tau) dif tau \
  &= integral_RR x_1(t+tau/2-t_1) x_2^*(t-tau/2-t_2) e^(-j 2pi f (tau-t_1 + t_2)) dif tau ** e^(-j 2pi f (t_1 - t_2)) \
  &= e^(-j 2pi f (t_1-t_2)) WVD_(x_1, x_2)(t-(t_1+t_2)/2,f).
$

【证明】
已知
$ cases(x_1(tau)<->X_1(f), x_2(tau)<->X_2(f)), $
则
$
  cases(
  x_1(t-t_1+tau/2)<->2X_1(2f)e^(j 2pi (2f)(t-t_1)),
  x_2^*(t-t_2-tau/2)<->2X_2^*(2f)e^(-j 2pi (2f)(t-t_2))
).
$
于是
$
  & integral_RR x_1(t+tau/2-t_1) ** x_2^*(t-tau/2-t_2) e^(-j 2pi f tau) dif tau \
  & = 4integral_RR X_1(2beta)e^(j 2pi (2beta)(t-t_1)) ** X_2^*(2f-2beta)e^(-j pi (2f-2beta)(t-t_2)) dif beta.
$
令 $2beta=f+nu/2$,则
$
  & integral_RR x_1(t+tau/2-t_1) ** x_2^*(t-tau/2-t_2) e^(-j 2pi f tau) dif tau \
  & = 4integral_RR X_1(2beta)e^(j 2pi (2beta)(t-t_1)) ** X_2^*(2f-2beta)e^(-j pi (2f-2beta)(t-t_2)) dif beta \
  & = integral_RR X_1(f+nu/2)e^(j 2pi (f+nu/2)(t-t_1)) ** X_2^*(f+nu/2)e^(-j pi (f-v/2)(t-t_2)) dif nu  \
  & = e^(-j 2pi f (t_1-t_2))integral_RR X_1(f+nu/2)X_2^*(f+nu/2)e^(-j 2pi nu (t_1+t_2)/2)e^(j 2pi nu t) dif nu \
  & = e^(-j 2pi f (t_1-t_2)) WVD_(x_1, x_2)(t-(t_1+t_2)/2,f).
$
同理，有交叉项的频移性质：
$
  e^(j 2pi t (f_1-f_2)) WVD_(x_1, x_2)(t,f-(f_1+f_2)/2)
  = integral_RR X_1(f+nu/2-f_1)X_2^*(f-v/2-f_2) e^(j 2pi nu t) dif tau.
$

设信号 $x_1(t)$ 的时间偏移了 $t_1$ 且频率偏移了 $f_1$ 后为 $x'_1(t)$，信号 $x_2(t)$ 的时间偏移了 $t_2$ 且频率偏移了 $f_2$ 后为 $x'_2(t)$，即
$
  x'_1(t) &= x(t-t_1)e^(j 2pi f_1t) <-> X_1(f-f_1)e^(-j 2pi f t_1). \
  x'_2(t) &= x(t-t_2)e^(j 2pi f_2t) <-> X_2(f-f_2)e^(-j 2pi f t_2).
$

根据交叉项的时移和频移性质有：
$ WVD_(x'_1, x'_2)(t,f) = e^(-j 2pi f (t_1-t_2))e^(j 2pi t (f_1-f_2))WVD_(x_1, x_2)(t-(t_1+t_2)/2,f-(f_1+f_2)/2). $

现在定义交叉项（I代表干涉interference）
$
  I(t,f)
  &:= WVD_(x'_1, x'_2)(t,f) + WVD_(x'_2, x'_1)(t,f) \
  &= WVD_(x'_1, x'_2)(t,f) + WVD^*_(x'_1, x'_2)(t,f) \
  &= 2 Re WVD_(x'_1, x'_2)(t,f).
$
令 $t_(12)=(t_1+t_2)/2$，$f_(12)=(f_1+f_2)/2$，$tau_(12)=t_1-t_2$，$v_(12)=v_1-v_2$
则
// TODO: 互WVD未必实。
$
  I(t,f)=2WVD_(x_1, x_2)(t-t_(12),f-f_(12))cos(2pi(v_(12)t-f tau_(12))).
$
假如考虑系数 $c_1$ 和 $c_2$，则
$
  I(t,f)
  = 2 abs(c_1) abs(c_2) WVD_(x_1, x_2)(t-t_(12),f-f_(12)) cos[2pi(v_(12)t-f tau_(12)) + arg c_1 - arg c_2].
$

==== 弱分量和强分量的交叉项可用于检测弱分量

弱分量的自项的能量与其幅度的平方成正比，而它与其它分量的互项的能量与其幅度的一次方成正比。

=== 在什么条件下会显现到时域（或频域）？

同一时刻有多个频率分量，交叉项就会显现为拍频。拍频的频率正是公式 (3.3)@hlawatsch1997[page. 7] 中 $(t,f)$ 平面内交叉项
的角波矢的模。

== 任给一个函数，它都可能是某个信号的WVD吗？

并非如此。
$forall sigma_t, sigma_f in RR^+$，
$
  & integral.double_(RR^2) (((t-t_0) / sigma_t)^2 + ((f-f_0) / sigma_f)^2) (WVD dif t dif f) / E \
  &= integral_RR ((t-t_0) / sigma_t)^2 (dif t ** integral_RR WVD dif t) / E
  + integral_RR ((f-f_0) / sigma_f)^2 (dif f ** integral_RR WVD dif t) / E \
  &= (Delta_t / sigma_t)^2 + (Delta_f / sigma_f)^2 \
  &>= 2 (Delta_t Delta_f) / (sigma_t sigma_f)
  >= 1 / (2pi sigma_t sigma_f).
$
可取适当的 $sigma_t, sigma_f$ 让 $sigma_t sigma_f = 1/(2pi)$。这时假设函数只在
$ { (t,f) : ((t-t_0) / sigma_t)^2 + ((f-f_0) / sigma_f)^2 <= 1 - epsilon}, $
这个椭圆区域上非零，那么
$ 1-epsilon >= integral.double_(RR^2) (((t-t_0) / sigma_t)^2 + ((f-f_0) / sigma_f)^2) (abs(WVD) dif t dif f) / E $
注意这个积分大于等于上述不等式起始的积分（$abs(WVD) >= WVD$），而上述不等式又指出它“$>= 1$”——矛盾。所以这种函数不可能是某个信号的WVD。@claasen1984

另：inner interference formula $abs(WVD(t,f))^2 = WVD(t,f) conv_(2t)^(2t) conv_(2f)^(2f) WVD(t,f)$。

== 旋转时频平面的物理意义

= 词典

#{
  let comment(it) = table.cell(colspan: 2, text(0.8em, gray.darken(20%), it))
  let section(it) = table.cell(colspan: 2, strong(it))
  figure(
    table(
      columns: 2,
      table.hline(),
      table-header[信号分析][量子物理],
      table.hline(),
      section[基本概念],
      [时间—频率、空间—空频……], [位置—动量……],
      [确定信号 $x$], [纯态/概率幅/波函数 $ket(psi)$],
      [能量/功率 $abs(x)^2$], [概率/概率密度 $abs(psi)^2$],
      [Parseval：能量在各域不变], [概率和在各表象都是一],
      comment[区分不变和守恒：不变（invariant）谈不同角度，守恒（conservative）谈不同时刻。#footnote[孤立系统动量守恒，但换参考系会变；加速度在Galileo惯性系间不变，但未必守恒；电荷既不变又守恒。]],
      [相干幅度叠加], [量子概率幅叠加],
      [非相干功率叠加], [经典概率叠加],
      thin-hline(),
      section[确定函数],
      [瞬时自相关 $(t, tau) |-> R(t,tau) = x^*(t-tau/2) x(t+tau/2)$], [密度矩阵 $rho = ket(psi) bra(psi)$],
      comment[中心 $t$ 对应主对角线方向，偏差 $tau$ 对应垂直于主对角线方向。],
      [信号相位未知时（具体何时？），也可观测自相关], [密度矩阵代表波函数信息中可观测的部分],
      [Wigner–Ville分布], [Wigner伪概率分布],
      thin-hline(),
      section[随机函数],
      [随机信号#footnote[只有可预测的？]], [混态/系综],
      [随机信号的瞬时自相关 $(t, tau) |-> expect R(t,tau)$], [混态的密度矩阵 $rho = sum_n P_n ket(psi_n) bra(psi_n)$],
      [随机信号的演变谱], [混态的Wigner伪概率分布],
      [？], [量子关联],
      [？], [经典关联],
      thin-hline(),
      section[分数Fourier域],
      [时频平面], [相空间],
      [旋转时频平面], [谐振子随时间演化],
      [旋转角度], [演化时长],
      [时频量纲归一化系数], [谐振子势中的弹性系数],
      comment[$1/2 k x^2 = 1/2 p^2 /m$ 给出了 $x,p$ 之间的换算关系，即 $p = sqrt(m k) x$。],
      comment[弹性大就转得快，同等位置旋转出来的动量更大；弹性小就反过来。],
      thin-hline(),
      section[不确定性],
      [$sigma_t sigma_omega >= 1/2$ 或 $sigma_t sigma_f >= 1/(4pi)$], [Heisenberg：$sigma_x sigma_p >= hbar / 2 = h / (4pi)$],
      comment[$p = hbar k = h \/lambda, k = 2pi \/lambda$，所以 $hbar = 1$ 时 $p$ 对应圆频率，$h = 1$ 时 $p$ 对应普通频率。],
      thin-hline(),
      section[变换与映射],
      [系统平移不变], [算符与空间平移算符对易],
      [？], [幺正（酉）变换 $hat(H)$],
      [？], [期望 $expval(hat(H), psi)$],
      [匹配滤波], [？],
      table.hline(),
    ),
  )
}

// 那函数是一种WVD的充要条件是什么？

= 例子

== 有无交叉项——正负波包

我们课上讲的WVD针对确定信号。如果信号改成随机信号，WVD可以改成原来WVD的期望。这样的WVD仍然具有 $∫dif t$、$∫dif f$ 那些物理意义，但可以没有交叉项。
比较如下两种情况。

- 纯态：信号是确定信号，在 $±1$ 各有个波包。
- 混态：信号是随机信号，只有两种等概率的可能，一种是在 $+1$ 有个波包，另一种是在 $-1$ 有个波包。

两种信号的期望一样，但纯态的WVD有交叉项，混态的WVD没有交叉项。此外，也许两种信号的自相关的模也一样，只是辐角不一样；我还没仔细算过。

*自相关是可以计算的。*

- 为什么换成随机信号之后，两种信号之间没有交叉项？两种信号之间应该是有关系的吧，例如联合概率分布不等于0，那么他们两个之间应该有交叉项吧

  量子力学里面的混合态，混合态之中两个不同的态会不会没有关联，所以才没有交叉项？

- 你说是谁和谁的联合分布？这里似乎只有一个随机性。

- #strike[WVD的交叉项不是同时分析两个分量时才会出现的嘛，你举的例子好像只有一个信号吧]

  纯态那个是一个信号具有两个波包，就是两个分量？

- $+1$ 处波包这个信号叫 $a$，$-1$ 处这个叫 $b$。那么纯态是 $(a+b)/√2$，混态是 $1/2$ 概率 $a$ 和 $1/2$ 概率 $b$。

- 混态情况是假如a确定了，b就不会出现，那么这两个信号之间是不相关的吧，但是纯态情况，a和b可以同时出现，这两个信号应该是有关系的吧

  所以混态没有交叉项，但是纯态有交叉项

- 什么不相关啊……混态算出来是 $WVD[a]/2 + WVD[b]/2$，求期望时不管 $a,b$ 相不相关都一样啊。纯态是 $WVD[(a+b)/√2]$。

- 就是我们目前这个例子，如果观测到负半轴的情况，就能预测出后面的情况；而有的随机信号即使观测到负半轴，正半轴仍然具有随机性。

  随机信号是无穷维随机向量，不只是把有限个确定函数当成“变量的可能取值”的随机变量。

- 随机信号根本不是 x = 什么什么线性组合，没它这一套。

  是先WVD（或求自相关）再期望，不是反过来。

== 均匀随机相位

令 $phi$ 均匀分布于 $[0,2pi)$，则 $e^(j phi)$ 是个复随机变量。

可知
$
  expect e^(j phi)
  // = expect Re e^(j phi) + j Im expect e^(j phi)
  &= integral_0^(2pi) e^(j phi) ** (dif phi)/(2pi)
  &= 0.
  \
  expect abs(e^(j phi))^2
  &= expect 1 &= 1.
  \
  expect (Re e^(j phi))^2
  &= integral_0^(2pi) cos^2 phi ** (dif phi)/(2pi)
  &= 1/2.
  \
  expect (Im e^(j phi))^2
  &= expect abs(e^(j phi))^2 - expect (Re e^(j phi))^2
  &= 1/2.
  \
  expect Re e^(j phi) Im e^(j phi)
  &= integral_0^(2pi) cos phi sin phi ** (dif phi)/(2pi)
  = integral_0^(2pi) (sin(2phi))/2 ** (dif phi)/(2pi)
  &= 0.
$
这说明 $Re e^(j phi), Im e^(j phi)$ 是两个不线性相关、零均值、方差为 $1/2$ 的随机变量。

更进一步，令 ${phi_i}_(i=1)^N$ 是一组均匀分布于 $[0,2pi)$ 的独立随机变量，则 ${e^(j phi_i)}_i$ 也是一组独立随机变量。
$
  expect overline(e^(j phi))
  &= overline(expect e^(j phi)) = overline(0) &= 0.
  \
  // expect overline((Re e^(j phi))^2)
  // &= overline(expect (Re e^(j phi))^2) = overline(1/2) &= 1/2.
  // \
  expect overline(Re e^(j phi))^2
  &= 1/N ** overline(expect (Re e^(j phi))^2 + 0)
  &= 1/(2N).
  \
  expect overline(Im e^(j phi))^2
  &= expect overline(Re e^(j (phi + pi\/2)))^2
  &= 1/(2N).
$

// TODO: 与数据不符。

== 旋转时频平面——谐振子

#link("https://en.wikipedia.org/wiki/Phase-space_formulation")[Phase-space formulation - Wikipedia]

- 动图

  源代码和评论：#link("https://physics.stackexchange.com/questions/191260/how-to-visualize-a-schr%c3%b6dinger-cat-state/191272#191272")[quantum mechanics - How to visualize a Schrödinger cat state? - Physics Stack Exchange]

- 两种推导

  - 相空间：旋转轨迹切向的导数为零。
  - 时域：该场景的Schrödinger方程对应FrFT。

// 未能成功的思路：旋转WVD再累加，反推出FrFT的自相关

= WVD 的性质

== 记号与定义

=== 卷积

$ x(t) conv_t^tau y(t) = integral_RR x(t) ** y(tau - t) dif t. $
$x(dot) conv^tau y(dot) := x(t) conv_t^tau y(t)$。

例如
$
  x(t) conv_(2t)^tau y(t)
  &= integral_RR x(t) ** y(tau - t) dif (2t) \
  &= 2 integral_RR x(t) ** y(tau - t) dif t \
  &= 2 x(t) conv_t^t y(t), \
$
并且
$
  x(t) conv_(2t)^tau y(t)
  &= integral_RR x(t) ** y(tau - t) dif (2t) \
  &= integral_RR x(t' / 2) ** y(tau - t' / 2) dif t'
  quad (t' := 2t) \
  &= eval(x)_(t'\/2) conv_(t')^tau eval(y)_(t'\/2).
$

=== Fourier变换

$ fourier_t^f [x(t)] := integral_RR x(t) **e^(-j 2pi f t) dif t. $
$fourier^f [x(dot)] := fourier_t^f [x(t)]$。

例如 $c >0$ 倍的缩放性质表示为
$ fourier_t^f [x(c t)] = 1 / c fourier_t^(f\/c) [x(t)]. $
卷积定理则表示为
$ fourier_t^f [x(tau) conv_tau^t y(tau)] = fourier_tau^f [x(tau)] ** fourier_tau^f [y(tau)]. $

=== WVD

$ R_(x,y) (t,tau) := eval(x)_(t + tau / 2) ** eval(y^*)_(t - tau / 2). $

$ WVD_(x y) (t,f) := fourier_tau^f [R_(x y) (t,tau)]. $

$WVD_x := WVD_(x x)$。

== Outer interference formula

$
  WVD_x conv^t conv^f WVD_y
  &= fourier_tau^f [R_x (dot, tau) conv^t R_y (dot, tau)].
$
注意，$forall t_x, t_y in RR$，设 $t_mu := (t_x + t_y) / 2$ 与 $t_d = t_x - t_y$，则
$
  R_x (t_x, tau) **R_y (t_y, tau)
  &= eval(x)_(t_x + tau / 2) eval(x^*)_(t_x - tau / 2) **
  eval(y)_(t_y + tau / 2) eval(y^*)_(t_y - tau / 2) \
  &= eval(x)_(t_x + tau / 2) eval(y^*)_(t_y - tau / 2) **
  eval(y)_(t_y + tau / 2) eval(x^*)_(t_x - tau / 2) \
  &= R_(x y) (t_mu, t_d + tau) ** R_(y x) (t_mu, tau - t_d) \
  &= R_(x y) (t_mu, t_d + tau) ** R^*_(x y) (t_mu, t_d - tau).
$
因此其实卷积 $conv^t$
$
  R_x (dot, tau) conv^t R_y (dot, tau)
  &= integral_RR R_x (t', tau) ** R_y (t - t', tau) dif t' \
  &= integral_RR R_x (t / 2 + t_d / 2, tau) ** R_y (t / 2 - t_d / 2, tau) dif t_d / 2 \
  &= integral_RR R_(x y) (t / 2, t_d + tau) ** R_(x y)^* (t / 2, t_d - tau) dif t_d / 2 \
  &= integral_RR R_(x y) (t / 2, tau') ** R_(x y)^* (t / 2, tau' - 2tau) dif tau' / 2 \
  &= 1 / 2 R_(x y) (t / 2, dot) conv^(2tau) R_(x y)^* (t / 2, - dot).
$
既然如此，将两种卷积表示同时应用 $fourier_tau^f$，得
$
  WVD_x conv^t conv^f WVD_y
  &= 1 / 2 fourier_tau^f [R_(x y) (t / 2, dot) conv^(2tau) R_(x y)^* (t / 2, - dot)] \
  &= 1 / 4 fourier_tau^(f\/2) [R_(x y) (t / 2, dot) conv^tau R_(x y)^* (t / 2, - dot)] \
  &= 1 / 4 WVD_(x y) (t / 2, f / 2) ** WVD_(x y)^* (t / 2, f / 2) \
  &= 1 / 4 abs(WVD_(x y) (t/2, f/2))^2.
$

更换 $t,f$ 的定义，上式可更整洁地记为
$
  abs(WVD_(x y) (t,f))^2
  &= 4 WVD_x conv^(2t) conv^(2f) WVD_y \
  &= 4 WVD_x (t',f') conv_(t')^(2t) conv_(f')^(2f) WVD_y (t',f') \
  &= WVD_x (t',f') conv_(2t')^(2t) conv_(2f')^(2f) WVD_y (t',f') \
  &= integral.double_(RR^2) W_x (t + t' / 2, f + f' / 2) ** W_y (t - t' / 2, f - f' / 2) dif t' dif f'.
$

= 教材中WVD相关内容勘误

- §2第19页式 (2-56) 之前未编号的公式

  $R_(x_1 x_2)^* (t,tau)$ 中的 $tau$ 应该是 $-tau$，$Re$ 应该是 $caron(Re)$。论证详见本文@eq:expand-sum。

- §3第8页 $W_(x_1 x_2) (t,f) = dots.c$ 等公式中的相位

  $(f-f_mu) t + f_d (t-t_mu) + f_d t_mu$ 与同页下方的定义 $t_d = t_1 - t_2, f_d = t_1 - t_2$ 矛盾。如果保持 $t_d, f_d$ 定义不变，则该公式是本文@thm:shift 的特例，应该是 $(f-f_mu) t - f_d t$，这样才能给出正确的振荡方向。

  同页和第9页的图3-2还讨论了AF的位置，可能也有问题。

- §3第20页图3-6

  颜色
  // TODO
