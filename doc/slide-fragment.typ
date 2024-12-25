#import "@preview/cetz:0.3.1"

#import "alias.typ": *

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
$
  W_z (t,f) = & W_x (t,f) + W_y (t,f) \
  & + thin hl(underbrace(2 Re W_(x,y) (t,f) ))
$
$ Z(t) = X(t) + Y(t) $
$
  W_Z (t,f) = & expect W_X (t,f) + expect W_Y (t,f) \
  & + thin hl(underbrace(2 Re expect W_(X,Y) (t,f) ))
$
$
  Z(t) = x(t) + C y(t)
$
$
  y(t)
$
$ C=e^(j theta) $
$ W_(x,y) (t,f) = integral x(t+tau / 2) y^(*)(t-tau / 2) e^(-j 2pi f tau) dif tau $
$
  I(t,f) & = expect [C (W_(x,y) (t,f) + W_(y,x)(t,f))] \
  & = (integral_(0)^(2pi) e^(j theta) (dif theta) / (2 pi))**(2 Re W_(x,y)(t,f)) \
  & = 0
$
$
  I(t,f)
  = 2 abs(WVD_(x, y)(t-t_(x y),f-f_(x y))) cos[2pi(v_(x y)t-f tau_(x y))+ phi]
$
#pagebreak()
== 徐

=== 3交叉项的物理意义·时域定性

$ R_(x+y) = underbrace(R_x + R_y) + underbrace(R_(x y) + R_(y x)) $
$ W_(x+y) = overbrace(W_x + W_y) + overbrace(2 Re W_(x y)) $

$ fourier_f^tau #h(0em) stretch(arrow.b, size: #3em) $

$
  R_(x y) (t,tau) := x(t+tau / 2) y^* (t - tau / 2) \
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


#figure(
  cetz.canvas(
    length: 3cm,
    {
      import cetz.draw: *

      set-style(
        mark: (fill: black, scale: 2),
        stroke: (thickness: 0.4pt, cap: "round"),
        angle: (
          radius: 0.3,
          label-radius: .22,
          fill: green.lighten(80%),
          stroke: (paint: green.darken(50%)),
        ),
        content: (padding: 1pt),
      )

      grid((-1.5, -1.5), (1.4, 1.4), step: 0.5, stroke: gray + 0.2pt)

      line((-1.5, 0), (1.5, 0), mark: (end: "stealth"))
      content((), $ t $, anchor: "west")
      line((0, -1.5), (0, 1.5), mark: (end: "stealth"))
      content((), $ f $, anchor: "south")
    },
  ),
)

#text(green, $x thick x'$)
#text(purple, $y thick y'$)

=== 4交叉项显现到时域·拍频

$ hl(integral dif f) $
