
#let project(headline: "", title: "", authors: (), date: none, body) = {
  // 0. Document properties

  set document(author: authors.map(a => a.name), title: title)

  set text(font: ("Noto Serif CJK SC", "Source Han Serif"), lang: "zh", region: "CN")
  // Bulletin points should still in the default font
  set list(marker: ([•], [‣], [–]).map(text.with(font: "Libertinus Serif")))

  // 1. Title page

  align(right, image("asset/logo.svg", width: 15%))

  v(2fr)

  // Titles
  block(text(weight: "bold", 2em, headline))
  v(2em, weak: true)
  block(text(weight: "extrabold", 2.5em, title))

  v(1fr)

  // Authors
  pad(
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(center)[
        #set text(size: 1.5em)
        *#author.name* \
        #link("mailto:" + author.email, author.email) \
        #author.id
      ]),
    ),
  )

  v(2fr)

  align(right, text(1.25em, date))

  pagebreak()

  // 2. Front matter

  counter(page).update(1)
  set page(numbering: "I", number-align: center)

  show heading.where(level: 1): set align(center)
  show heading.where(level: 1): set text(size: 1.25em)
  show heading: pad.with(y: 0.25em)

  set par(justify: true)

  outline(indent: 1em)
  pagebreak()

  // 3. Main body

  counter(page).update(1)
  set page(numbering: "1")

  set heading(numbering: "1.1")

  show figure: set image(width: 60%)
  set table(stroke: none)

  set math.equation(numbering: "(1)")

  show strike: set text(gray)
  show link: set text(blue.darken(20%))

  // Source Han Serif 的数字高度和括号不匹配
  show cite: set text(font: "Liberation Serif")

  // https://forum.typst.app/t/how-to-cite-with-a-page-number-in-gb-t-7714-2015-style/1501/4
  show cite.where(style: auto): it => {
    if it.supplement != none {
      let (key, ..args) = it.fields()
      cite(it.key, ..args, style: "cite-with-locator.csl")
    } else {
      it
    }
  }

  body

  // https://typst-doc-cn.github.io/guide/FAQ/bib-etal-lang.html
  import "@preview/modern-nju-thesis:0.3.4": bilingual-bibliography
  bilingual-bibliography(bibliography: bibliography.with("ref.bib"))
}

// https://github.com/typst/typst/issues/3640#issuecomment-2395133217
#let table-header(..headers) = {
  table.header(..headers.pos().map(strong))
}

#let thin-hline = table.hline.with(stroke: 0.5pt)
