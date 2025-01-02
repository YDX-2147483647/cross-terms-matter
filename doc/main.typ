#import "@preview/quick-maths:0.2.0": shorthands
#show: shorthands.with(
  ($**$, $times$),
  ($===$, $equiv$),
  ($~=$, $approx$),
  ($+-$, $plus.minus$),
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
  date: "2024年12月31日",
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

不同于STFT对信号的线性表示，WVD是一种非线性变换，是双线性形式的时频分布@张贤达2015a。假如某一个信号含有多个不同的分量，利用WVD对信号做时频分析的时候，这就不可避免地要讨论交叉项这个问题。对于含有多个不同分量的的确知信号，利用WVD分析该信号的时频特性。这时，时频平面上一定会出现交叉项，这将会详细讨论。而对于含有多个不同分量的随机信号，我们更关心集体的平均效果，信号的演变谱就等于该信号WVD的数学期望。由于随机信号的演变谱在WVD的基础上又求了数学期望，因此随机信号的演变谱中交叉项有可能为零，交叉线不会出现再时频平面中，也就是没有交叉项。

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

== Monte Carlo实验 <sec:disappear-simulate>

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

== 频域定量理解交叉项的物理意义 <sec:shift-quantitative>

现在利用互WVD的平移性质，从频域定量理解交叉项的物理意义。

#figure(
  {
    image("fig/几何特征-基本-1倍距离-π_4角度.png", width: 22em)
    import "@preview/cetz:0.3.1"
    set math.equation(numbering: none)
    place(
      top + left,
      dx: 0.5em,
      dy: 0.5em,
      cetz.canvas(
        length: 4.5em,
        {
          import cetz.draw: *
          set-style(
            // 用`circle`表示点
            circle: (
              fill: orange,
              radius: 2pt,
            ),
            line: (
              fill: blue.darken(20%),
              stroke: (paint: blue.darken(20%)),
            ),
            content: (padding: 0.25em),
          )
          let aa = calc.sqrt(calc.pi) / 2
          
          // 规定坐标范围
          grid((-2, -2), (2, 2), step: 1, stroke: none)

          line(name: "hypot", (-aa, -aa), (aa, aa), stroke: (dash: "dashed"))
          circle("hypot.50%")
          content((rel: (-0.6, 0.3)), $ (t_mu, f_mu) $, anchor: "south-east")
          line((), (to: "hypot.50%", rel: (-0.1, 0.08)), stroke: black)
          
          line(name: "t_d", "hypot.start", (aa,-aa), mark: (end: "stealth"))
          content("t_d.50%", $ t_d $, anchor: "north")
          
          line(name: "f_d", "t_d.end", "hypot.end", mark: (end: "stealth"))
          content("f_d.50%", $ f_d $, anchor: "west")

          circle(name: "x", "f_d.end")
          content("x", $ (t_x, f_x) $, anchor: "south-west")

          circle(name: "y", "t_d.start")
          content("y", $ (t_y, f_y) $, anchor: "north-east")
        },
      ),
    )
  },
  caption: [所涉及变量在时频平面中的意义],
) <fig:variables>

#[
  #let wvd = $WVD_(tilde(x), tilde(y))$
  
  考虑双分量信号 $z = x + y$。记两分量的时频中心分别为 $(t_x, f_x) in RR^2$ 与 $(t_y, f_y) in RR^2$，记两分量在各自时频中心的辐角分别为 $phi_x := arg x(t_x) in CC, thick phi_y := arg y(t_y) in CC$，并沿用@thm:shift 中对 $t_mu, f_mu, t_d, f_d$ 的定义，总结如@fig:variables#footnote[该图采用解析方法绘出，时频变量经过归一化，故未标出单位。后同。]。

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
  @eq:cross 中“$~=$”的唯一不严格处在于 $arg wvd ~= 0$。若满足前述任一严格成立条件，则 @eq:cross 也严格成立。#parencite(<hlawatsch1997>) 第7页式 (3.3) 给出了类似公式，但@eq:cross 的适用范围更广。

  观察@eq:cross，可见交叉项的表达式确实包含分量间相位差 $phi_x - phi_y$，交叉项振荡的基准点就是分量间相位差。
]

== 仿真验证

生成一双分量信号，其两个分量均为Gauss波包，其时频中心关于原点对称，而且宽度相同。改变两分量间的相位差，考查其WVD，得@fig:relative-phase。图中横纵坐标分别代表时频，颜色代表WVD。时频坐标经过归一化，故未在同中标出。由图可知，增加分量间相位差，自项（左下、右上两块恒正能量）完全不变，交叉项（中央一块正负交替能量）各处的振幅不变，但整体振荡基准向左上移动。相位差为 $0$ 时，交叉项正中心是极大值点（最绿）；相位差从 $0$ 增加到 $pi/2$，该极大值点从正中心向左上移动，正中心处的WVD逐渐减小，正中心成为为零点（无色）；相位差继续增加到 $pi$ 时，正中心变为极小值点（最红）；相位差变化 $2pi$，WVD恢复原貌。可见交叉项正中心处WVD的变换规律与相位差的余弦一致。

该信号的分量都是Gauss波包，@eq:cross 严格成立。又因两分量的时频中心关于原点对称，$t_d,f_d$ 均为零。因此，正中心处WVD的值
$
  WVD_(x,y) (t_mu, f_mu)
  &= 2 abs(dots.c) ** cos(2pi (f_d t_mu - f_mu t_d - f_d t_mu) + phi_x - phi_y) \
  &= 2 abs(dots.c) ** cos(0 + phi_x - phi_y). \
$
这与仿真结果一致。

#figure(
  placement: auto,
  image("fig/relative-phase-frames.png", width: 100%),
  caption: [改变分量间相位差，考查WVD]
) <fig:relative-phase>

== 交叉项的其它应用价值 <sec:dectect-the-weak>

弱分量和强分量的交叉项可用于检测弱分量。因为弱分量的自项的能量与其幅度的平方成正比，而它与其它分量的互项的能量与其幅度的一次方成正比。如@fig:strength，信号两分量一强一弱，交叉项强于弱分量的自项，可用于检测弱分量。

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

本节分析WVD中交叉项的几何特征。
// WVD中交叉项的几何特征。交叉项振荡的位置、方向、疏密与信号各分量密切相关

继续@sec:meaning\的思路，考虑双分量信号 $z = x + y$，沿用@fig:variables 中的记号 $(t_x,f_x), (t_y, f_y), (t_mu, f_mu)$ 以及 $t_d,f_d$，记交叉项为 $I$（代表干涉interference）。由@eq:cross，
$
  I(t,f)
  &~= 2 abs(WVD_(tilde(x), tilde(y)) (t-t_mu, f-f_mu))
   ** cos(2pi (f_d t - f t_d) + phi),
$ <eq:interference>
其中
$phi := phi_x - phi_y - 2pi f_d t_mu$
是在时频平面内固定的常数。下面根据@eq:interference 分析交叉项的几何特征。

== 交叉项振荡位置

交叉项 $I$ 的振幅等于 $2 abs(WVD_(tilde(x), tilde(y)) (t-t_mu, f-f_mu))$，所以 $I$ 主要位于 $abs(WVD_(tilde(x), tilde(y)) (t-t_mu, f-f_mu))$ 较大之处。由@sec:shift-quantitative，$abs(WVD_(tilde(x), tilde(y)) (t, f))$ 分布于零时刻零频率附近，故 $I$ 分布于 $(t_mu, f_mu)$ 附近，即两分量时频中心连线中点附近。

@fig:cross-position 展示了两个分量相同或不同时的WVD，图中可以看到交叉项始终位于两个信号的对称中心。

#subpar-grid(
  columns: (auto, auto),
  figure(image("fig/几何特征-基本-1倍距离-π_4角度.png", height: 15em), caption: [分量形式相同]),
  figure(image("fig/几何特征-分量形式不同.png", height: 15em), caption: [分量形式不同]), <fig:cross-position-distorted>,
  caption: [改变分量项形式，观察交叉项振荡位置],
  label: <fig:cross-position>,
)

== 交叉项振荡方向 <sec:cross-direction>

交叉项 $I$ 中振荡的部分是 $cos(2pi (f_d t - f t_d) + phi)$，其中 $f_d t - f t_d$ 在时频平面内变化，$phi$ 在时频平面内固定。因此，振荡的角波矢为 $(f_d, -t_d)$，垂直于两分量时频中心连线 $(t_d, f_d)$，等于连线顺时针旋转一个直角；而振荡的等相位面是“$f_d t - f t_d = "常数"$”，平行于两分量时频中心连线。

@fig:cross-direction 展示了两个分量时频中心连线旋转不同角度下的WVD。从图中可以看到，交叉项振荡的等相位面始终平行于两分量时频中心连线。

#subpar-grid(
  columns: 3,
  figure(image("fig/几何特征-旋转-0.png"), caption: [连线为时间方向]),
  figure(image("fig/几何特征-基本-1倍距离-π_4角度.png"), caption: [连线为倾斜方向]),
  figure(image("fig/几何特征-旋转-π_2.png"), caption: [连线为频率方向]), <fig:cross-direction-t>,
  caption: [改变两时频中心连线方向，观察交叉项振荡方向],
  label: <fig:cross-direction>,
)

== 交叉项振荡疏密

交叉项 $I$ 振荡的疏密由角波矢的大小决定。由@sec:cross-direction\的分析，角波矢等于 $(f_d, -t_d)$，大小等于两分量时频中心的间距。因此分量时频中心距离越远，则角波矢越大，等相位面越密集；而距离越近，则角波矢越小，等相位面越疏松。形象地说，交叉项的疏密正如橡皮筋的松紧。

@fig:cross-distance 展示了两个分量时频中心距离不同时的WVD。从图中可以看到，随着两个信号时频中心距离变大，交叉项振荡得更剧烈，等相位面更密集。

#subpar-grid(
  columns: 3,
  figure(image("fig/几何特征-距离-0.8倍.png"), caption: [$0.8$ 倍距离]),
  figure(image("fig/几何特征-基本-1倍距离-π_4角度.png"), caption: [$1$ 倍距离]),
  figure(image("fig/几何特征-距离-1.7倍.png"), caption: [$1.7$ 倍距离]),
  caption: [改变分量时频中心距离，观察交叉项振荡疏密],
  label: <fig:cross-distance>,
)

此外，若将@fig:cross-position-distorted 中时间分布更宽的分量拆分成若干时间分布更短的分量，则所形成交叉项振荡的疏密也符合上述分析。

= 交叉项显现到时域 <sec:reify>

WVD在时间边缘积分 $integral WVD_x dif f === abs(x)^2$ 反映信号在时域的瞬时功率。交叉项存在振荡，一般认为积分时正负抵消，最终结果为零，并不显现到时域。这一命题成立是否总成立？交叉项在何种条件下能显现到时域？

此外，WVD在频率边缘积分也反映信号在频域的功率谱。不过其原理与时域相同，将不重复讨论。

== 交叉项在时域显现为拍频现象

=== 理论分析

根据@sec:cross-direction\的分析，交叉项振荡的角波矢等于两分量时频中心连线旋转一个直角。若信号在同一时刻存在多个频率分量，则时频中心连线垂直于时间方向，角波矢平行于时间方向。此时交叉项只在时间方向振荡，而在频率方向不振荡。@fig:cross-direction-t 即为一例。若将这种WVD沿频率方向积分，则交叉项在积分曲线上并不振荡，不会正负抵消，最终得到的时间边缘积分会体现交叉项——在正交叉项的时刻，则总瞬时功率应大于自项给出的瞬时功率；在负交叉项的时刻，总瞬时功率应小于自项给出的瞬时功率。

这一现象与*拍频*一致。拍频现象是指，如果在同一时间范围内，信号包含两相近频率的分量，那么信号的振幅及瞬时功率出现振荡，振荡频率是两分量的频率差。频率差即@sec:geometry\分析中的 $f_mu$，可见定量上WVD中的交叉项也与拍频一致。

=== 实测实验

理论分析未考虑不规则信号形式、多分量混合等复杂因素，分析结果未必可靠。为进一步验证，我们设计了实测实验，实验设置如@fig:research-setup。

#figure(
  image("fig/实验设置.png"),
  caption: [实验装置：采集同一时刻有多个频率分量的信号]
) <fig:research-setup>

实验步骤如下。
+ 在新食堂二层东南选取一振荡明显的桌子作为实验对象，在桌上放置适当重物以稳定实验结果。
+ 将安装有 #link("https://phyphox.org")[phyphox] 的手机放到桌子上的固定位置，保证手机能与桌子一同振荡。
+ 启动手机加速度传感器的记录模式，记录加速度的浮动范围。
+ 从侧面敲击一下桌面，让桌子开始振动。
+ 观察传感器示数，待振荡逐渐衰减，加速度浮动范围恢复至敲击前的范围后，停止记录。
+ 保存加速度 $y$ 分量#footnote[选取该分量是因为其振幅最大。]的时间序列。
由于桌子有竖直扭转、垂直于长边旋转、垂直于短边旋转等多种振荡模式，敲击后会同时出现多种频率分量，满足拍频出现的条件。

处理采集到的数据，得加速度y分量的功率谱如@fig:g-periodogram。由图可知，信号中存在 $8.5 "Hz"$、$9.9 "Hz"$、$26 "Hz"$ 等多种频率分量，其中前两者频率接近，只相差 $1.4 "Hz"$。

#subpar-grid(
  columns: 2,
  figure(image("fig/g-periodogram.png"), caption: [完整功率谱密度]),
  figure(image("fig/g-periodogram-zoom.png"), caption: [功率谱密度局部放大]),
  caption: [加速度的功率谱密度],
  label: <fig:g-periodogram>,
)

信号的WVD如@fig:g-wvd。在 $9 "Hz"$ 附近放大得@fig:g-wvd-spec，可观察到 $8.5 "Hz"$、$9.9 "Hz"$ 两频率分量的自项（两灰框内的恒正部分）与交叉项（灰框之间正负交替部分）。将WVD与时域波形对齐得@fig:g-wvd-compare。可见在WVD中交叉项正的时刻，时域波形振幅较大；在交叉项负的时刻，时域波形振幅较小，甚至接近零。这与理论分析一致。

#subpar-grid(
  columns: 2,
  figure(image("fig/g-wvd-spectrogram.png"), caption: [WVD局部]), <fig:g-wvd-spec>, 
  figure(image("fig/g-wvd-compare.png"), caption: [WVD局部（上）与时域波形（下）]), <fig:g-wvd-compare>,
  caption: [加速度的WVD],
  label: <fig:g-wvd>,
)

此外，由@fig:g-periodogram，$8.5 "Hz"$、$9.9 "Hz"$ 两频率分量的强度相差数倍。在@fig:g-wvd-spec 中，$9.9 "Hz"$ 强分量的自项清晰可见，而 $8.5 "Hz"$ 若分量的自项几乎无法分辨，而它与 $9.9 "Hz"$ 强分量形成的交叉项依然明晰。这也印证了@sec:dectect-the-weak\中检测弱分量的应用价值。

== 旋转时频平面

如果信号的分量没有重合时段，不满足拍频出现的条件，也可用旋转时频平面制造重合时段，让交叉项现象到时域。这一旋转可用分数域Fourier变换（fractional Fourier transform, FrFT）实现，它与WVD的关系如@fig:frft，时域的FrFT对应时频平面的旋转。

#figure(
  block(
    diagram(spacing: (6em, 4em), $
      x edge(label: "FrFT", marks: ->, dash: "dashed")
      edge("d", label: "WVD", ->)
      & x'
      edge("d", label: "WVD", ->)
      \
      WVD_x
      edge(label: "旋转", marks: ->, dash: "dashed")
      & WVD_(x')
    $),
    inset: (bottom: 1em),
  ),
  caption: [FrFT与WVD的关系]
) <fig:frft>

@fig:cat-state 展示了这一过程，其每一小图的左上方为WVD，下方为时域瞬时功率，右方为频域功率谱密度。第一小图时，信号两分量频率相同，时间无重合，故交叉项在时域无反映，但显现到了频域。随着增加FrFT阶数，即旋转时频平面的角度，两分量渐渐重合时间，在时域显现为拍频。

#figure(
  grid(
    columns: 3,
    gutter: 1em,
    ..("01", "10", "12", "13", "14", "16").map(
      n => image("fig/Wigner_function_of_a_Schrödinger_cat_state/" + n + ".jpg", width: auto)
    ),
  ),
  caption: [旋转时频平面（#link("https://commons.wikimedia.org/w/index.php?title=File:Wigner_function_of_a_Schr%C3%B6dinger_cat_state.gif&oldid=850044481")[Wikimedia Commons]，#link("https://physics.stackexchange.com/questions/191260/how-to-visualize-a-schr%c3%b6dinger-cat-state/191272#191272")[Emilio Pisanty]）]
) <fig:cat-state>

旋转时频平面并非只是唯象操作，也有物理意义。我们从时间 $t$、频率 $f$ 切换为位置 $q$、动量 $p$（$j hbar pdv(,q) <-> p$），则时频平面切换为相空间。
考虑谐振子系统，其相空间随时间的演化就是旋转相空间。

具体分析如下。谐振子系统的势能为 $1/2 k q^2$，动能为 $p^2 / (2 m)$，其中 $k$ 是弹性系数，$m$ 是质量。故谐振子系统的Hamiltonian
$ cal(H) = p^2 / (2 m )+ (k q^2) / 2. $
注意 $q,p$ 本来具有不同量纲，无法将某个 $q$ 坐标旋转到 $p$ 轴上；但 $cal(H)$ 用 $m,k$ 这些系统固有的参数在 $q,p$ 之间建立了联系，“将 $1 / sqrt(m) p$ 坐标旋转到 $sqrt(k) q$ 轴上”不再有量纲上的问题。
下面有位置域（对应原来的时域）、相空间（对应原来的时频平面）两种论证。

#[
  #show list: set par(first-line-indent: 0em)
  
  - *位置域（时域）*
  
    记位置表象的概率幅为 $psi$（对应原来信号的时域波形）。由Schrödinger 方程，
    $ -j hbar pdv(psi,t) = cal(H) psi. $
    注意 $q |-> eval(psi)_(t)$ 是一族 $RR -> CC$ 函数。事实上，上述方程等价于 $q |-> eval(psi)_(t=0)$ 与 $q |-> eval(psi)_(t=t)$（适当标准化后）是角度正比于 $t$ 的FrFT变换对@陶然2022。

    在位置域分析需要的概念浅，但计算非常复杂，此处省略。

    // 我们通过求特征函数来解方程，转而考虑定态Schrödinger方程
    // $ E psi = cal(H) psi. $
    
    // 记 $theta := 2pi ((u^2 + v^2)/2 cot alpha - u v csc alpha)$，$A := sqrt(1 - j cot alpha)$ 。一方面，由 $j dv(,alpha) mat(cot alpha; csc alpha) = mat(csc alpha; cot alpha) csc alpha$ 和 $1 + cot^2 alpha = csc^2 alpha$，
    // // 以及 $dv(,alpha,2) mat(cot alpha; csc alpha) = mat(2 csc alpha cot alpha; csc^2 alpha + cot^2 alpha) csc alpha$
    // $
    //   j pdv(,alpha) e^(j theta)
    //   &= e^(j theta) ** 2pi ((u^2 + v^2)/2 csc alpha - u v cot alpha) csc alpha, \
    //   j pdv(,alpha) A
    //   &= -A ** (csc^2 alpha) / (2 (1 - j cot alpha))
    //   = - A ** (1 + j cot alpha) / 2,
    // $
    // 于是
    // $
    //   & j pdv(,alpha) A  e^(j theta) \
    //   &= A e^(j theta) ** (
    //     - (1 + j cot alpha) / 2
    //     + 2pi ((u^2 + v^2)/2 csc alpha - u v cot alpha) csc alpha
    //   ).
    // $
    // 另一方面，由 $pdv(A, u) = 0$ 和 $pdv(theta, u) = 2pi (u cot alpha - v csc alpha)$，
    // $
    //   pdv(,u,2) A e^(j theta)
    //   = A e^(j theta) ** j 2pi (u cot alpha - v csc alpha) 
    // $
  
  - *相空间（时频平面）*

    在相空间可用高层次概念分析，计算更简单。
  
    // https://en.wikipedia.org/wiki/Phase-space_formulation#Simple_harmonic_oscillator
    记相空间上的伪分布为 $W$（对应WVD）。由Moyal方程，
    $ pdv(W, t)  = {{cal(H), W}}, $
    其中 ${{dot, dot}}$ 是Moyal括号。注意 $(q,p) |-> eval(W)_t$ 是一族相空间上的 $RR^2 -> RR$ 函数。事实上，上述方程等价于（适当标准化后）$eval(W)_t$ 等于 $eval(W)_(t=0)$ 绕原点旋转正比于 $t$ 的角度。
  
    仍通过求特征函数来解方程，转而考虑定态方程
    $ E W = cal(H) star W, $
    其中 $star$ 是Moyal star product。由 $star$ 的定义，
    $
      cal(H) star W
      &:= cal(H) exp((j hbar)/2 (arrow.l(diff_q) arrow(diff_p) - arrow.l(diff_p) arrow(diff_q))) W \
      &= ((p - (j hbar)/2 diff_q)^2 / (2m) + (k (q + (j hbar)/2 diff_p)^2)/2) W \
      &= Re(dots.c) + (j hbar)/2 (k q diff_p - p/m diff_q) W.
    $
    而 $E, W in RR$ 要求 $cal(H) star W = E W in RR$，所以上式的虚部必须为零，即
    $ (k q diff_p - p/m diff_q) W === 0. $ <eq:moyal-zero>
    在 $q$--$p$ 平面内，上式左边是 $(k q, -p/m)$ 方向的方向导数。注意 $(k q, -p m)$ 就是圆周“$(k q^2) / 2 + p^2 / (2 m) = "常数"$”的切向，所以@eq:moyal-zero 意味着所有特征函数在这族同心圆周的切向的导数为零，值不变。既然所有定态沿圆周旋转不变，那么一般的演化规律也就是绕原点旋转了（可以证明旋转角速度不随圆周半径变化），即
    $
      W(mat(q; p), t)
      &=== W(
        mat(1/sqrt(k); , sqrt(m))
        mat(
          cos(omega t), - sin(omega t);
          sin(omega t), cos(omega t);
        )
        mat(sqrt(k); , 1/sqrt(m))
        mat(q; p), 0), \
      &=== W(
        mat(
          q cos(omega t) - 1/sqrt(m k) p sin(omega t);
          p cos(omega t) + sqrt(m k) thin q sin(omega t);
        ), 0),
    $
    其中 $omega = sqrt(k \/ m)$。
]

// 未能成功的思路：旋转WVD再累加，反推出FrFT的自相关

#pagebreak(weak: true)
= 信号分析与量子物理的翻译词典 <sec:quantum>

// 此外，Wigner函数在1932年被提出，用于描述量子态在相空间中的分布，而后被Ville引入到信号分析。量子物理与信号分析之间也许存在着某种联系，我们给出了其间的翻译词典。

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

= 附录

== 任务分工

/ 薛龙斌: 主要负责演变谱没有交叉项时的数学证明、Monte Carlo仿真实验、互WVD平移性质的证明，参与交叉项显现到时域实验的数据采集。

/ 徐元昌: 主要负责Monte Carlo仿真实验中误差分析、交叉项几何特征分析以及图像绘制，修复互WVD平移性质中的相位错误，交叉项显现到时域实验设计与信号处理、信号与量子物理的翻译词典。

== 对教材中WVD相关内容的异议

=== §2第19页式 (2-56) 之前未编号的公式

$R_(x_1 x_2)^* (t,tau)$ 中的 $tau$ 应该是 $-tau$，$Re$ 应该是 $caron(Re)$。论证详见本文@eq:expand-sum。

=== §3第8页 $W_(x_1 x_2) (t,f) = dots.c$ 等公式中的相位的“$+-$”

$(f-f_mu) t + f_d (t-t_mu) + f_d t_mu$ 与同页下方的定义 $t_d = t_1 - t_2, f_d = t_1 - t_2$ 矛盾。如果保持 $t_d, f_d$ 定义不变，则该公式是本文@thm:shift 的特例，应该是 $(f-f_mu) t - f_d t$，这样才能给出正确的振荡方向。

同页和第9页的图3-2还讨论了AF的位置，也存在问题。

=== §3第20页图3-6d

#figure(
  image("fig/屏幕截图 2024-12-30 224309.png"),
  caption: [教材图3-6d原版]
) <fig:ch3_page_20-1>

WVD是实函数，有正有负，零特别关键。教材原图（@fig:ch3_page_20-1）取绝对值绘制，丢弃了正负信息，从绘出的图很难推想信号特征。其实交叉项的负面影响没有那么大。若适当选取颜色区分正负零，其实很容易识别图象中的自项与交叉项，并进一步推想信号特征。
  
@fig:ch3_page_20-2 采用PiYG颜色方案（#link("https://matplotlib.org/stable/users/explain/colors/colormaps.html#diverging")[matplotlib]、#link("https://www.mathworks.com/matlabcentral/fileexchange/120088-200-colormap")[MATLAB] 等均可用）重置教材原图作为对照，然后保留WVD的正负信息以改进效果。在改进版中，一眼便可区别自项与交叉项——自项是绿线（恒非负），交叉项是红绿交替区域（有正有负）。

#figure(
  image("fig/ch3_page_20-WVD.png"),
  caption: [教材图3-6d重置版（上）与改进版（下）]
) <fig:ch3_page_20-2>

== 任给一个函数，它都可能是某个信号的WVD吗？

并非如此。

=== WVD的聚集性始终有限

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

// 那函数是一种WVD的充要条件是什么？

=== WVD总是与自身干涉

互WVD总满足下式
$
  abs(WVD_(x y) (t,f))^2
  &= integral.double_(RR^2) W_x (t + t' / 2, f + f' / 2) ** W_y (t - t' / 2, f - f' / 2) dif t' dif f'.
$
取 $x=y$，则上式给出了的对WVD自身的限制。

==== 记号与定义

由于证明中涉及太多变量，直接书写太难理解。这里采用专用记号书写。

===== 卷积

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

===== Fourier变换

$ fourier_t^f [x(t)] := integral_RR x(t) **e^(-j 2pi f t) dif t. $
$fourier^f [x(dot)] := fourier_t^f [x(t)]$。

例如 $c >0$ 倍的缩放性质表示为
$ fourier_t^f [x(c t)] = 1 / c fourier_t^(f\/c) [x(t)]. $
卷积定理则表示为
$ fourier_t^f [x(tau) conv_tau^t y(tau)] = fourier_tau^f [x(tau)] ** fourier_tau^f [y(tau)]. $

===== WVD

$ R_(x,y) (t,tau) := eval(x)_(t + tau / 2) ** eval(y^*)_(t - tau / 2). $

$ WVD_(x y) (t,f) := fourier_tau^f [R_(x y) (t,tau)]. $

$WVD_x := WVD_(x x)$。

==== 干涉公式的证明

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

== 推导Monte Carlo仿真中交叉项的理论幅度

本节推导 @sec:disappear-simulate\的@fig:WignerNoCrossterms 中交叉项幅度的理论值。

理论值是以下三项之积。
- 互WVD幅度 $√2 σ$；
- MATLAB把瞬时自相关`fft`为WVD时，归一化有问题，倍数等于FFT点数，时间点数；
- 随机相位导致 $1 \/ sqrt(2N)$，其中 $N$ 是样本量；
前两点已无问题，以下解释第三点。

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
