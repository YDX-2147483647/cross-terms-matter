// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
#let project(title: "", authors: (), date: none, body) = {
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  set page(numbering: "1", number-align: center)

  set text(font: "Noto Serif CJK SC", lang: "zh", region: "CN")
  // Bulletin points should still in the default font
  set list(marker: ([•], [‣], [–]).map(text.with(font: "Libertinus Serif")))

  set heading(numbering: "1.1")

  // Title row.
  align(center)[
    #block(text(weight: 700, 1.75em, title))
    #v(1em, weak: true)
    #date
  ]

  // Author information.
  pad(
    top: 0.5em,
    bottom: 0.5em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(center)[
        *#author.name* \
        #link("mailto:" + author.email, author.email) \
        #author.id
      ]),
    ),
  )

  outline(indent: 1em)

  // Main body.
  set par(justify: true)

  show figure: set block(breakable: true)
  show figure: set image(width: 60%)
  set table(stroke: none)

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
}

// https://github.com/typst/typst/issues/3640#issuecomment-2395133217
#let table-header(..headers) = {
  table.header(..headers.pos().map(strong))
}

#let thin-hline = table.hline.with(stroke: 0.5pt)


// https://typst-doc-cn.github.io/guide/FAQ/bib-etal-lang.html
#import "@preview/modern-nju-thesis:0.3.4": bilingual-bibliography
