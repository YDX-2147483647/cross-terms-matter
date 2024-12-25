#import "@preview/physica:0.9.3": bra, ket, expval, eval, Re, Im

#let expect = math.op(sym.EE)
#let WVD = math.op("WVD")
#let fourier = math.cal("F")
#let hbar = sym.planck.reduce

#let hl = text.with(red)

// 如果卷积不用强调变量，直接写`*`即可。
#let conv = math.op(sym.ast, limits: true)
