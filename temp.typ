#let IMAGE_BOX_MAX_WIDTH = 120pt
#let IMAGE_BOX_MAX_HEIGHT = 100pt
#import "@preview/hydra:0.6.1": hydra

#let s = state("x", 0)

#let pwr = (
  university: "Politechnika Wrocławska",
  faculty: "Wydział Informatyki i Telekomunikacji",
  department: "Katedra Podstaw Informatyki",
  course: "Informatyka Algorytmiczna (INA)"
)

#let project(title: "", subtitle: none, school-logo: none, school-desc: pwr, company-logo: none, authors: (), mentors: (), jury: (), city: none, date: none, abstract: none, language: "pl", keywords: none, popraw_sieroty: false, body) = {
  
  // Set the document's basic properties.
  let dict = json("resources/i18n/" + language + ".json")
  set par(justify: true, leading: 0.65em)
  set text(lang: language, size: 12pt, costs: ( hyphenation: 100%, runt: 100%, widow: 100%, orphan: 100%, ))
  set heading(numbering: "1.1")
  show figure.caption: set text(11pt)

  

  // show link: it => {
  // text(
  //   fill: rgb(255, 100, 100),  // Light red
  //   weight: "bold",
  //   it.body
  // )
// }
  
  show regex(" ([^\s]{1,3} )+"): it => context {
    let page_num = here().page()
    if page_num > 1 and popraw_sieroty [#it.text.first()#it.text.slice(1).replace(" ", "\u{00A0}")]
    else {it}
  }
  
  set document(author: authors, title: title)
  set page(
    numbering: none,
    // number-align: center,
    header: context {
      // Omit page number on the first page
      let page-number = here().page();
      let page_even = calc.rem(page-number, 2) == 0;

      let chap = hydra(1, book: false)
      if chap != none and chap.fields().keys() == ("children",) {
        chap = [#dict.chapter #chap.children.at(0): #text(weight: "medium")[#chap.children.slice(2).join()]]
      }

      let subch = hydra(2, skip-starting: false, book: false)
              
      let heading = if page_even {
        chap
      } else if subch == none and chap != none {
        chap
      } else {
        subch
      }
      
      if not heading == none {
        text(size: 12pt, weight: "regular")[
          #if page_even {
            [
              #page-number
              #h(1fr)
              #heading
            ]
          } else {
            [
              #heading
              #h(1fr)
              #page-number
            ]
          }
        ]
        v(-7pt)
        line(length: 100%, stroke: 0.5pt)
        s.update(1)
      } else {
        s.update(0)
      }
    },
    footer: context {
      // Omit page number on the first page
      let page-number = here().page();
      if s.get() == 0 and page-number > 1{
        if calc.rem(page-number, 2) == 0 [
          #page-number
          #h(1fr)
        ] else [
          #h(1fr)
          #page-number
        ]
      }
    },
  )

  
  
  
  show heading: it => {
    if it.level == 1 and it.numbering != none {
      pagebreak()
      block()[
      #v(40pt)
      #text(size: 30pt)[#dict.chapter #counter(heading).display() #linebreak()]
      // #v(-10pt)
      #text(size: 30pt, weight: "regular")[#it.body ]
      #v(50pt)
      ]
    } else {
      block()[
        #v(5pt)
        #it
        #v(12pt)
      ]
    }
  }

  place(top)[
    #box(height: IMAGE_BOX_MAX_HEIGHT)[
      #v(8pt)
      #align(top + left)[
        #text(size: 16pt, weight: "extrabold")[#school-desc.university] \
        #h(0.0em) #text(size: 12pt, weight: 700)[#school-desc.faculty] \
        #v(-9pt) #line(length: 100% - IMAGE_BOX_MAX_WIDTH, stroke: 0.5pt, ) #v(-9pt)
        #h(1em) #text(size: 12pt, weight: 400)[#school-desc.department] \
        #h(1em) #text(size: 12pt)[#dict.course:] #text(size: 12pt, weight: "bold")[#school-desc.course]
      ]
    ]
    #h(1fr)
    #box(height: IMAGE_BOX_MAX_HEIGHT, width: IMAGE_BOX_MAX_WIDTH)[
      #align(right + horizon)[
        #if school-logo == none {
          image("logo PWr kolor pion  bez tla.png")
        } else {
          school-logo
        }
      ]
    ]
  ]
  
  // Title box  
  align(center + horizon )[
    #if subtitle != none {
      text(size: 14pt, tracking: 2pt)[
        #smallcaps[
          #subtitle
        ]
      ]
    }
    #line(length: 100%, stroke: 0.5pt)
    #text(size: 20pt, weight: "bold", hyphenate: false)[#par(justify: false)[#title]]
    #line(length: 100%, stroke: 0.5pt)
  ]

  // Credits
  box()
  h(1fr)
  grid(
    columns: (auto, 1fr, auto),
    [
      // Authors
      #if authors.len() > 0 {
          text(weight: "bold")[
            #if authors.len() > 1 {
              dict.author_plural
            } else {
              dict.author
            }
            #linebreak()
          ]
          for author in authors {
            author 
            linebreak()
          }
      }
    ],
    [
      // Mentor
      #if mentors != none and mentors.len() > 0 {
        align(right)[
          #text(weight: "bold")[
            #if mentors.len() > 1 {
              dict.mentor_plural
            } else {
              dict.mentor
            }
            #linebreak()
          ]
          #for mentor in mentors {
            mentor
            linebreak()
          }
        ]
      }
      // Jury
      #if jury != none and jury.len() > 0 {
        align(right)[
          *#dict.jury* #linebreak()
          #for prof in jury [#prof #linebreak()]
        ]
      }
    ]
  )

  place(bottom)[
    #box(width: 100%)[
      #align(center)[
        //replace spaces in elements with nonbreakable space
        #text(size: 12pt)[#par(justify: false)[#dict.keywords: #keywords.map(it => it.replace(" ", "\u{00A0}")).join(", ")]]
    
      #v(20pt)
    
        #if city != none {
          city
        }
        #if date != none {
          date
        }
      ]
    ]
  ]
  
  pagebreak()

  if abstract != none {
    page(header: none)[
      #v(95pt)
      #heading(numbering: none, outlined: false)[#dict.abstract]
      #abstract
    ]
    
  }

  

  pagebreak()
  // Table of contents.
  outline(depth: 3, indent: auto)
  
  // pagebreak()
  // page(footer: none)[]
  // counter(page).update(0);
  // Main body.
  body

  pagebreak()

  set page(numbering: "I")
  counter(page).update(1)
  
  bibliography("biblio.bib", full: true, style: "ieee")
  
  pagebreak()

  let graph-outline(..args) = {
  show outline: set heading(outlined: true)
  outline(..args)
}

show outline.entry: it => {
  // Check if this entry is for a heading
  let is-heading = it.element.numbering == "1.1"
  if is-heading {
    // Make headings bold
    strong(it)
  } else {
    // Keep figures/non-headings normal
    it
  }
}




  // Table of figures.
  //odstęp pomiędzy numerkiem a wypisanym
  graph-outline(
    title: dict.figures_table,
    target: figure.where(kind: image).or(heading.where(level: 1, numbering:"1.1")).or(figure.where(kind: "chart")),
    indent: 0pt
  )

graph-outline(
    title: dict.tables_table,
    target: figure.where(kind: table)
)

  show link: it => {
  text(
    fill: black,  // Light red
    weight: "regular",
    it.body
  )
}

  show outline.entry: it => {
    if it.element.has("kind") {
      if (it.element.kind == "algorithm") {
        let algorithm = it.element.body
        let algorithm_header_cell = algorithm
          .children
          .find(cell => {
            cell.has(
              "children",
            )
          })
          .children
          .at(0)
        let algorithm_name = algorithm_header_cell.body.children.at(2)

        let outline_content = algorithm_name + it.inner()

        link(it.element.location(), it.indented(it.prefix(), outline_content))
      } else {
        // Return the typst default
        it
      }
    } else {
      // Return the typst default
      it
    }
  }

  graph-outline(
    title: dict.algo_table,
    target: figure.where(kind: "algorithm")
  )


  // pagebreak()


}