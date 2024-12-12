#import "@preview/quick-maths:0.2.0": shorthands
#show: shorthands.with(($**$, $times$))

#import "@preview/physica:0.9.3": bra, ket, expval, eval, Re, Im

#import "@preview/cetz:0.3.1"

#import "template.typ": project, table-header, thin-hline, bilingual-bibliography
#show: project.with(
  title: "Wigner–Ville分布中交叉项的意义",
  authors: (
    (name: "薛龙斌", email: "3120245441@bit.edu.cn", id: "3120245441"),
    (name: "徐元昌", email: "y_d_x@bit.edu.cn", id: "3120245440"),
  ),
  date: datetime.today().display("[year]年[month]月[day]日"),
)

#let expect = math.op(sym.EE)
#let WVD = math.op("WVD")
#let fourier = math.cal("F")
#let hbar = sym.planck.reduce

#let hl = text.with(red)

// 如果卷积不用强调变量，直接写`*`即可。
#let conv = math.op(sym.ast, limits: true)

= 意义

Fourier变换、Wigner–Ville分布的“刚性”比较强，它们不像短时Fourier变换、小波变换、Cohen类那样有人为因素（如窗的形式、尺寸、作用域）可调。它们给出的结果基本可认为是信号所固有的。如果它们给出的结论不符合人的直观，恐怕意味着人的直观需要修正，而未必是它们错了。

- Fourier变换分析正弦信号

  以往直观认为单频，Fourier变换却说有正负两频率。

  - 把复频率弄掉 ⇒ 解析信号、Hilbert变换。
  - 就用正负频率分析 ⇒ 正交调制、频谱循环混叠……

- Wigner–Ville分布分析双分量信号

  以往直观认为有两块能量，WVD却说有三块。

  - 把交叉项弄掉 ⇒ Choi-Williams分布等加窗WVD。
  - 就用交叉项分析 ⇒ ？

= 问题

== 交叉项

=== 没有交叉项的条件

==== 正负波包

==== 均匀随机相位差

#figure(
  image("fig/cross_intensity.png"),
  caption: [TODO：理论差个系数],
)

公式 (3.3)@hlawatsch1997[page. 7] 中，令 $c_1 = 1$，将 $c_2$ 改为模固定为 $1$、相位均匀分布的随机变量。这时 $WVD$ 中，自项没有随机性，交叉项的期望为零。

构造含有两个分量的随机信号形式如下：
$
  X(t) = x_1 (t) + C x_2(t),
$
其中，$x_1 (t)$ 和 $x_2 (t)$ 是确定信号，$C = e^(j theta)$，$theta ~ U(0, 2 pi)$。

随机信号 $ X(t)$ 的WVD变换的数学期望为：
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
$
上式中，第一项和第三项为自项，第二项为交叉项。
$
  & 2 Re expect integral_RR C x_1(t+tau/2)x_2^*(t-tau/2) e^(-j 2pi f tau) dif tau \
  & = 2 Re integral_RR dif tau integral_0^(2pi) (dif theta)/(2pi) C x_1(t+tau/2) x_2^*(t-tau/2) e^(-j 2pi f tau) \
  & = 2 Re integral_0^(2pi) C (d theta)/(2pi) **
    integral_RR x_1(t+tau/2)x_2^*(t-tau/2) e^(-j 2pi f tau) dif tau.
$
因为 $integral_0^(2pi) C (d theta)/(2pi) = 0$，所以随机信号 $X(t)$ 的交叉项为0，也就是刚好没有交叉项。

// TODO: Monte Carlo仿真结果

=== 交叉项反映什么东西？

==== 互WVD反映相对相位

// TODO: `relative-phase.mp4`

两分量形式相同时，等相位面平行于两个时频中心的连线，源于公式 (3.3)@hlawatsch1997[page. 7] 中的 $cos$ 项，*看具体推导*，并考虑推广到形式不同的情况。

==== 关于两个不同的信号分量的交叉项的推导

假设确定信号 $x(t)$ 由两个信号分量 $x_1(t)$ 和 $x_2(t)$ 组成，即 $x(t)=c_1x_1(t)+c_2x_2(t)$。
为简单起见，先忽略两个信号分量的系数 $c_1$ 和 $c_2$，考虑 $x_1, x_2$ 的互WVD
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

同一时刻有多个频率分量，交叉项就会体现为拍频。拍频的频率正是公式 (3.3)@hlawatsch1997[page. 7] 中 $(t,f)$ 平面内交叉项
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
      table-header[信号][量子物理],
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

- #strike[WVD的交叉项不是同时分析两个信号分量时才会出现的嘛，你举的例子好像只有一个信号吧]

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

令 $theta$ 均匀分布于 $[0,2pi)$，则 $e^(j theta)$ 是个复随机变量。

可知
$
  expect e^(j theta)
  // = expect Re e^(j theta) + j Im expect e^(j theta)
  &= integral_0^(2pi) e^(j theta) ** (dif theta)/(2pi)
  &= 0.
  \
  expect abs(e^(j theta))^2
  &= expect 1 &= 1.
  \
  expect (Re e^(j theta))^2
  &= integral_0^(2pi) cos^2 theta ** (dif theta)/(2pi)
  &= 1/2.
  \
  expect (Im e^(j theta))^2
  &= expect abs(e^(j theta))^2 - expect (Re e^(j theta))^2
  &= 1/2.
  \
  expect Re e^(j theta) Im e^(j theta)
  &= integral_0^(2pi) cos theta sin theta ** (dif theta)/(2pi)
  = integral_0^(2pi) (sin(2theta))/2 ** (dif theta)/(2pi)
  &= 0.
$
这说明 $Re e^(j theta), Im e^(j theta)$ 是两个不线性相关、零均值、方差为 $1/2$ 的随机变量。

更进一步，令 ${theta_i}_(i=1)^N$ 是一组均匀分布于 $[0,2pi)$ 的独立随机变量，则 ${e^(j theta_i)}_i$ 也是一组独立随机变量。
$
  expect overline(e^(j theta))
  &= overline(expect e^(j theta)) = overline(0) &= 0.
  \
  // expect overline((Re e^(j theta))^2)
  // &= overline(expect (Re e^(j theta))^2) = overline(1/2) &= 1/2.
  // \
  expect overline(Re e^(j theta))^2
  &= 1/N ** overline(expect (Re e^(j theta))^2 + 0)
  &= 1/(2N).
  \
  expect overline(Im e^(j theta))^2
  &= expect overline(Re e^(j (theta + pi\/2)))^2
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

#bilingual-bibliography(bibliography: bibliography.with("ref.bib"))

#set page(height: auto)
#pagebreak()
= 幻灯片

== 薛

  $
    W_x (t,f) = integral underbrace(x(t+tau/2) x^*(t-tau/2), "") ** e^(-j 2pi f tau ) dif tau
  $
  $x(t)$ 是确定信号\
  
  $X(t)$ 
  $
    R_x (t,tau) 
    
  $
  $
     W_X (t,f) = expect integral underbrace(X(t+tau/2) X^*(t-tau/2), "") ** e^(-j 2pi f tau ) dif tau
  $

  $
    R_X (t,tau) 
    
  $
  $ z(t) = x(t) + y(t) $
  $ W_z (t,f) = & W_x (t,f) + W_y (t,f) \  
                & + thin hl(underbrace(2 Re W_(x,y) (t,f) ))  $
  $ Z(t) = X(t) + Y(t) $
  $ W_Z (t,f) = & expect W_X (t,f) + expect W_Y (t,f) \  
                & + thin hl(underbrace(2 Re expect W_(X,Y) (t,f) ))  $
  $ 
    Z(t) = x(t) + C y(t)
  $
  $
    y(t)
  $
  $ C=e^(j theta) $
  $ W_(x,y) (t,f) = integral x(t+tau/2) y^(*)(t-tau/2) e^(-j 2pi f tau) dif tau $
  $ 
    I(t,f) & = expect [C (W_(x,y) (t,f) + W_(y,x)(t,f))] \
           & = (integral_(0)^(2pi) e^(j theta) (dif theta) / (2 pi))**(2 Re W_(x,y)(t,f)) \
           & = 0
  $
  $
    I(t,f)
    = 2  WVD_(x, y)(t-t_(12),f-f_(12)) cos[2pi(v_(12)t-f tau_(12))]
  $
#pagebreak()
== 徐

=== 3交叉项的物理意义·时域定性

$ R_(x+y) = underbrace(R_x + R_y) + underbrace(R_(x y) + R_(y x)) $
$ W_(x+y) = overbrace(W_x + W_y) + overbrace(2 Re W_(x y)) $

$ fourier_f^tau #h(0em) stretch(arrow.b, size: #3em) $

$
  R_(x y) (t,tau) := x(t+tau/2) y^* (t - tau/2) \
  arg x - arg y
$

=== 3交叉项的物理意义·引理

$
  cases(x(t), y(t)) 
  &quad
  cases(
    x' (t) = x(t - t_x) ** e^(j 2pi f_x),
    y' (t) = y(t - t_y) ** e^(j 2pi f_y),
  ) \
  W_(x,y) (t, f)
$
$
  & W_(x' y') (t,f) \
  &= W_(x y) (t - (t_x + t_y) / 2, f - (f_x + f_y) / 2) ** e^(-j 2pi f (t_x - t_y)) ** e^(j 2pi t (f_x - f_y)) \
$

$x$
$y$
$W_(x y)$

$x'$
$y'$
$W_(x' y')$

=== 3交叉项的物理意义·频域定量

$ z = x + y $

$ x' quad y' $

$ W_(x' y') $

$ 2 Re W_(x y) prop abs(W_(x' y')) ** cos(2pi ((f_x - f_y) t - (t_x - t_y) f) + phi) $


#figure(cetz.canvas(length: 3cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 0.4pt, cap: "round"),
    angle: (
      radius: 0.3,
      label-radius: .22,
      fill: green.lighten(80%),
      stroke: (paint: green.darken(50%))
    ),
    content: (padding: 1pt)
  )

  grid((-1.5, -1.5), (1.4, 1.4), step: 0.5, stroke: gray + 0.2pt)

  line((-1.5, 0), (1.5, 0), mark: (end: "stealth"))
  content((), $ t $, anchor: "west")
  line((0, -1.5), (0, 1.5), mark: (end: "stealth"))
  content((), $ f $, anchor: "south")
}))

#text(green, $x thick x'$)
#text(purple, $y thick y'$)

=== 4交叉项显现到时域·拍频

$ hl(integral dif f) $
