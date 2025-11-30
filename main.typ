#import "temp.typ": project
// #import "@preview/diagraph:0.3.5": raw-render, render
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node, shapes
#import "@preview/lilaq:0.5.0" as lq
#import "@preview/lovelace:0.3.0": *
#import "@preview/frame-it:1.2.0": *
#import "@preview/tiaoma:0.3.0"
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/zero:0.5.0": *
#import "@preview/funarray:0.4.0": unzip

#show: codly-init.with()

#codly(languages: codly-languages)
#set text(lang: "pl")

#set math.equation(numbering: "(1.)")

#let weblink(..arg) = text(fill:rgb("c44"), weight: "bold" )[#underline[#link(..arg)] #footnote[#arg.pos().at(0)]]


#let comm(it) = text(fill:luma(100))[ #h(5pt) \\\\ #it]  
#let path = 1.2pt + rgb(255, 100, 100)

#let sdiagram(pads: 10pt, size: 100%, ..args) = pad(rest: pads, scale(
  size,
  reflow: true,
  diagram(edge-stroke: 0.8pt, node-stroke: 0.8pt, ..args),
))

#let (def,twi) = frames(
  def: ("Definicja", red),
  // For each frame kind, you have to provide its supplement title to be displayed
  twi: ("Twierdzenie", red)
  // You can provide a color or leave it out and it will be generated
  // example: ("Example", gray),
  // You can add as many as you want
  // syntax: ("Syntax",),
)

#let pro = frame(kind: "problem", "Problem", red)
// This is necessary. Don't forget this!
#show: frame-style(styles.hint)

#show: frame-style(kind: "problem", styles.hint)


#let rsat = link(<sat>, smallcaps[Sat]) 
#let sat = link(<cnfsat>, smallcaps[CNF-Sat]) 
#let sat3 = link(<sat3>, smallcaps[3-Sat]) 
#let ham = link(<ham>,smallcaps[Directed-Hamiltonian-Cycle])
#let uham = link(<ham>,smallcaps[Hamiltonian-Cycle])
#let vc = link(<vc>,smallcaps[Vertex-Cover])
#let cli = link(<cli>,smallcaps[Clique])
#let subs = link(<subs>,smallcaps[Subset-Sum])
#let part = link(<part>,smallcaps[Partition])
#let bin = link(<bin>,smallcaps[Bin-Packing])
#let tsp = link(<tsp>,smallcaps[Travelling-Salesman])
#let knap = link(<knap>,smallcaps[Knapsack])
#let hit = link(<hit>,smallcaps[Hitting-Set])
#let mip = link(<mip>,smallcaps[Integer-Programming])
#let ind = link(<ind>,smallcaps[Independent-Set])

// #let ham = link(<ham>,smallcaps[Skierowany Cykl Hamiltona])
// #let uham = link(<ham>,smallcaps[Cykl Hamiltona])
// #let vc = link(<vc>,smallcaps[Pokrycie Wierzchołkowe])
// #let cli = link(<cli>,smallcaps[Klika])
// #let subs = link(<subs>,smallcaps[Suma Podzbioru])
// #let part = link(<part>,smallcaps[Partycja])
// #let bin = link(<bin>,smallcaps[Bin-Packing])
// #let tsp = link(<tsp>,smallcaps[Komiwojażer])
// #let knap = link(<knap>,smallcaps[Plecak])
// #let hit = link(<hit>,smallcaps[Hitting-Set])
// #let mip = link(<mip>,smallcaps[Programowanie Całkowitoliczbowe])
// #let ind = link(<ind>,smallcaps[Zbiór niezależny])


#let np = $cal(N P)$
#let p = $cal(P)$

#let tru = $bb(1)$
#let fal = $bb(0)$

#let tak = smallcaps[tak]
#let nie = smallcaps[nie]

#let numb = `num`

#let node = node.with(radius: 1.5em, shape: circle, fill:white)

#let tran = link(<tran>,$cal(T)$)
#let solve = link(<solve>,$cal(S)$)
#let extr = link(<extr>,$cal(E)$)
#let con = link(<con>,$cal(C)$)


#show: project.with(
  title: "Wielomianowe redukcje między trudnymi problemami decyzyjnymi z klasy NP",
  subtitle: "Praca Dyplomowa Inżynierska",
  authors: (
    "Paweł Stanik",
  ),
  mentors: (
    "Prof. dr hab. Paweł Zieliński",
  ),
  school-logo: image("logo PWr kolor pion  bez tla.png"),
  school-desc: (
    university: "Politechnika Wrocławska",
    faculty: "Wydział Informatyki i Telekomunikacji",
    department: "Katedra Podstaw Informatyki",
    course: "Informatyka Algorytmiczna (INA)",
  ),
  city: "Wrocław",
  date: "2025",
  keywords: (
    "Klasa trudności NP",
    "NP-zupełność",
    "Redukcje problemów",
    "Programowanie Całkowitoliczbowe",
  ),
  abstract: [
  Celem pracy jest analiza i implementacja wielomianowych redukcji między wybranymi problemami decyzyjnymi z klasy #np. W ramach projektu stworzono bibliotekę w języku Julia, realizującą drzewo transformacji z korzeniem w problemie #sat, obejmujące takie zagadnienia jak #sat3, #vc, #cli czy #uham .
  
  W pracy przeprowadzono analizę porównawczą metod redukcji, m.in. wybierając dla problemu cyklu Hamiltona metodę Kleinberg-Tardos ze względu na optymalizację rozmiaru grafu. Zaimplementowano również mechanizmy rozwiązywania instancji oparte na redukcji do programowania całkowitoliczbowego. Zastosowanie typów generycznych w strukturach danych pozwoliło na obsługę problemów numerycznych o dużej skali, a przeprowadzone testy potwierdziły wielomianową złożoność opracowanych algorytmów.

  #heading(numbering: none)[Abstract]

  The objective of this thesis is to analyze and implement polynomial reductions between selected decision problems in the #np class. A library was created in the Julia language, implementing a transformation tree rooted in the #sat problem, covering problems such as #sat3, #vc, #cli, and #uham.

  The study involved a comparative analysis of reduction methods, selecting the Kleinberg-Tardos method for the Hamiltonian cycle problem due to graph size optimization. Mechanisms for solving instances based on reduction to Integer Programming were also implemented. The use of generic types in data structures allowed for handling large-scale numerical problems, and conducted tests confirmed the polynomial complexity of the developed algorithms.
  
  ],
  popraw_sieroty: true,
)

#heading(numbering: none, supplement: none)[Wstęp]

Teoria złożoności obliczeniowej i pytanie o równość klas $cal(P)$ i #np stanowią fundament współczesnej informatyki. Kluczowym narzędziem analizy w tym obszarze jest redukcja wielomianowa, która pozwala klasyfikować trudność problemów oraz dostarcza praktycznych metod ich rozwiązywania poprzez transformację instancji. 

Niniejsza praca dyplomowa koncentruje się na analizie oraz implementacji wielomianowych redukcji między wybranymi trudnymi problemami decyzyjnymi z klasy #np. 
Głównym celem pracy jest stworzenie biblioteki programistycznej w języku Julia, realizującej część drzewa redukcji klasycznych problemów NP-zupełnych. Język Julia został wybrany ze względu na swoje ukierunkowanie na obliczenia naukowe oraz wysoką wydajność.

Jako korzeń drzewa redukcji przyjęto problem spełnialności formuł logicznych (#rsat), a w szczególności jego wariant #sat, który stanowi standard w informatycznych zastosowaniach i punkt wyjścia dla dalszych transformacji. W ramach pracy zrealizowano implementację redukcji dla szeregu klasycznych problemów, takich jak: #sat3, #vc, #uham, #subs oraz innych problemów grafowych i optymalizacyjnych.

Praca została podzielona na sześć rozdziałów.

- *Rozdział pierwszy* wprowadza niezbędne podstawy teoretyczne, definiując klasę złożoności NP, pojęcie redukcji w sensie Karpa i Turinga oraz omawiając formalne definicje problemów NP-zupełnych.
- *Rozdział drugi* zawiera szczegółową analizę wybranych redukcji, w tym konstrukcję gadżetów dla problemów grafowych, takich jak redukcja 3-SAT do #vc czy #ham.
- *Rozdział trzeci* przedstawia projekt systemu, założenia dotyczące interfejsów funkcyjnych (transformacja, ekstrakcja, konstrukcja rozwiązania) oraz strukturę grafu redukcji.
- *Rozdział czwarty* opisuje konkretne algorytmy realizujące redukcje, w tym analizę ich złożoności oraz metody odzyskiwania rozwiązań. Omówiono tu również wybór metody Sudkampa dla problemu cyklu Hamiltona.
- *Rozdział piąty* poświęcony jest szczegółom implementacyjnym w języku Julia, hierarchii typów oraz wykorzystanym bibliotekom zewnętrznym, takim jak JuMP czy Graphs.jl.
- *Rozdział szósty* prezentuje wyniki testów weryfikujących poprawność implementacji oraz analizę wydajnościową algorytmów redukcji i ich wpływu na czas rozwiązywania problemów.

Opracowane rozwiązanie pozwala na łączenie problemów w łańcuchy transformacji oraz umożliwia rozbudowę biblioteki o nowe problemy i redukcje, stanowiąc narzędzie o walorach edukacyjnych i badawczych.

= Podstawy teoretyczne <theory>

W tym rozdziale przedstawimy podstawy teoretyczne niezbędne aby zrozumieć istotę przedstawianych zagadnień. Rozpoczniemy definiując wszystkie niezbędne pojęcia potrzebne do zdefiniowania #np - zupełności, która to będzie punktem wyjścia dla zagadnień opisanych w tej pracy.

== Klasa złożoności NP

Definicje w tym podrozdziale zostały zaczerpnięte z książki @ausiello_complexity_1999[Rozdz. 1], będziemy więc operować pojęciami problemów decyzyjnych i algorytmów, definicje tłumaczą się jednak bezpośrednio z bardziej powszechnego podejścia opartego na językach formalnych. Wybrane podejście omija nieistotne dla naszych rozważań szczegóły i jest bliższe programistycznemu podejściu, jakie będzie towarzyszyło nam podczas konstrukcji biblioteki.

Podstawowym pojęciem dla tego tematu jest pojęcie *problemu*, w ogólności problemem nazywamy relację $P subset.eq I times S$ gdzie $I$ jest zbiorem wszystkich poprawnych egzemplarzy problemu (inaczej instancji lub danych wejściowych), a $S$ jest zbiorem wszystkich poprawnych rozwiązań. Jako alternatywę możemy rozważyć predykat $p(x,y)$ który jest prawdziwy wtedy i tylko wtedy gdy $(x,y) in P$. Dla dowolnego egzemplarza problemu $x in P$ będziemy oznaczać jako $x$ zarówno obiekt jak i jego naturalny zapis np. nad alfabetem ${0,1}$.

W podejściu opartym na językach formalnych, stwierdzenie te jest równoważne przynależności do języka $L_P$ tzn. $x in L_P equiv x in Y_P$ warto jednak zaznaczyć że wtedy bierzemy pod uwagę jedynie wszystkie poprawne zapisy tego problemu (zbiór wszystkich poprawnych egzemplarzy jest uniwersum).

Problem $P$ nazywamy *problemem decyzyjnym* jeśli zbiór wszystkich egzemplarzy problemu $I_P$ dzieli się na zbiór $Y_P$ *egzemplarzy pozytywnych* oraz zbiór $N_P$ *egzemplarzy negatywnych*, oraz pytaniem problemu jest: czy dla dowolnego egzemplarza $x in I_P$, $x$ jest egzemplarzem pozytywnym  $x in Y_P$? Pojęcie to jest szczególnie istotne ponieważ pojęcia klas problemów które przedstawimy dotyczą właśnie problemów decyzyjnych, dlatego będziemy w tej pracy operować wyłącznie na nich.

Następnym krokiem jest zdefiniowanie rozwiązywania problemu, zrobimy to za pomocą *algorytmu* który może zwrócić wartość #tak lub #nie, algorytm taki może być wykonywany np. na maszynie Turinga lub dowolnej innej maszynie liczącej.

#def[Algorytm rozwiązujący][
  Problem decyzyjny $P$ jest rozwiązywany przez algorytm $cal(A)$, gdy algorytm zatrzymuje się dla dowolnego egzemplarza $x in I_P$ , oraz zwraca #tak wtedy i tylko wtedy gdy $x in Y_P$. Dodatkowo mówimy że $P$ jest rozwiązywalny w czasie $t(n)$ jeśli złożoność czasowa $A$ wynosi $t(n)$
]

Ponieważ jednak klasa #np opiera się na pojęciu *niedeterminizmu* musimy zdefiniować również algorytm niedeterministyczny. Algorytm taki to różni się od zwykłego tym że potrafi wykonywać operację *guess* $y in {0,1}$. Oznacza to że $y$ może przyjąć wartość 0 lub 1, algorytm taki w gruncie rzeczy potrafi "odgadnąć" jakąś wymaganą wartość. Konstrukcja ta jest bardzo podobna do niedeterministycznej maszyny Turinga. Podczas gdy deterministyczne obliczenia mają przebieg liniowy, obliczenia niedeterministyczne mają strukturę drzewa.

#def[Rozwiązanie niedeterministyczne][
  Problem decyzyjny $P$ jest rozwiązywany przez niedeterministyczny algorytm $cal(A)$, gdy dla dowolnego egzemplarza $x in I_p$, $cal(A)$ zatrzymuje się dla dowolnego ciągu odgadnięć oraz  $x in Y_P$ wtedy i tylko wtedy gdy istnieje co najmniej jeden ciąg odgadnięć dla którego algorytm zwróci #tak
]

Istnienie takiego algorytmu jest równoważne stwierdzeniu że istnieje algorytm weryfikujący problem $P$. Algorytm taki może zweryfikować czy istnieje rozwiązanie egzemplarza problemu jeśli otrzyma jakieś "świadectwo" istnienia rozwiązania.  Połączenie pomiędzy tymi dwoma sposobami możemy zobaczyć na podstawie specyfiki algorytmów niedeterministycznych. Bez straty ogólności możemy założyć że algorytm deterministyczny zgaduje na początku działania jakiś ciąg $C subset {0,1}^*$, a następnie przeprowadza na nim jakieś operacje. Przekłada się to bezpośrednio na wspomniany weryfikator, zamiast jednak zgadywać wartość świadectwa dostaje on je z góry. Definicja oparta na weryfikatorach prowadzi do odrębnej drogi definiowania klasy #np, którą możemy zobaczyć w @rivest_wprowadzenie_2024[Rozdz. 34].

#def[Złożoność algorytmu niedeterministycznego][
  Niedeterministyczny algorytm $cal(A)$ rozwiązuje problem decyzyjny $P$ w złożoności czasowej $t(n)$, gdy dla dowolnego egzemplarza $x in I_p$, $cal(A)$ zatrzymuje się dla dowolnego ciągu odgadnięć oraz  $x in Y_P$ wtedy i tylko wtedy gdy istnieje co najmniej jeden ciąg odgadnięć dla którego algorytm zwróci #tak w czasie co najwyżej $t(n)$
]

Definicja ta z kolei jest równoważna stwierdzeniu że istnieje, weryfikator działający w czasie $t(n)$. Mając te definicje możemy w końcu określić interesujące nas klasy problemów.

#def[Klasa #p][
   jest klasą wszystkich problemów rozwiązywanych przez algorytm działający w czasie wielomianowym
]

#def[Klasa #np][
   jest klasą wszystkich problemów rozwiązywanych przez niedeterministyczny algorytm działający w czasie wielomianowym
] <npdef>

Nazwa #np pochodzi od angielskiego określenia _Nondeterministic-Polynoimial_. Możemy łatwo zauważyć że $#p subset.eq np$, jest to spowodowane faktem że algorytm deterministyczny jest szczególnym przypadkiem algorytmu niedeterministycznego. Równość tych klas jest jednak wciąż nierozstrzygnięta i pozostaje jednym z najważniejszych problemów informatyki.

Z @npdef[definicji] wynika fakt który często jest używany jako nieformalna definicja klasy #np tzn. jeśli istnieje algorytm weryfikujący rozwiązanie problemu $cal(P)$ w czasie wielomianowym (sprawdzający czy rozwiązanie jest poprawne) to $cal(P) in np$. Fakt ten jest bardziej oczywisty dla definicji opartej na weryfikatorach.


== Pojęcie redukcji

Jeśli rozmawiamy o trudności problemów w danej klasie, warto rozpatrzyć je pod względem jakiegoś porządku, oznaczając czy dane problemy są trudniejsze od innych. Sposób w jaki możemy to określić to transformacje egzemplarza jednego problemu do egzemplarza drugiego to znaczy *redukcję*. W gruncie rzeczy redukcja problemu $P_1$ do problemu $P_2$ dostarcza metodę rozwiązywania problemu $P_1$ za pomocą algorytmu dla problemu $P_2$. 

#let karp = $scripts(<=)_m$

#def[Redukowalność w sensie Karpa][
  
  Mówimy że problem decyzyjny $P_1$ jest redukowalny w sensie Karpa do problemu decyzyjnego $P_2$ jeśli istnieje algorytm $cal(R)$ który dla dowolnego egzemplarza $x in I_P_1$ problemu $P_1$, transformuje go w egzemplarz $y in I_P_2$ problemu $P_2$ w taki sposób że $x in Y_P_1$ wtedy i tylko wtedy gdy $y in Y_P_2$. W takim przypadku mówimy że $cal(R)$ jest redukcją Karpa z $P_1$ do $P_2$ i zapisujemy $P_1 karp P_2$. 
  
  Jeśli zachodzi $P_1 karp P_2$ oraz $P_2 karp P_1$ mówimy że są one równoważne w sensie Karpa tj. $P_1 scripts(equiv)_m P_2$
]

Istnienie takiej redukcji mówi nam że problem $P_2$ jest co najmniej tak trudny jak problem $P_1$. Co tworzy nam tak jak wspomnieliśmy, hierarchię pomiędzy problemami, którą to możemy wykorzystać aby określić klasy pochodne będące w zależności z #np. Jeśli algorytm redukcji $cal(R)$ działa w czasie wielomianowym mówimy wtedy że problem jest *wielomianowo redukowalny* co zapisujemy $P_1 karp^p P_2$

#def[#np - trudność][

  Mówimy że problem decyzyjny $P$ jest #np - trudny jeśli dla dowolnego problemu decyzyjnego $P_1 in np$ zachodzi $P_1 karp^p P$, i zapisujemy $P in np H$
]

Jest to więc klasa problemów co najmniej tak trudnych jak dowolny problem z klasy #np. Redukowalność wielomianowa jest ważna w tym przypadku dlatego że zachowuje ona przynależność do klasy, tzn. redukcja wielomianowa $P_1 karp^p P_2$ pozwala rozwiązać problem $P_1$ w czasie wielomianowym o ile posiadamy algorytm rozwiązujący problem $P_2$ w czasie wielomianowym, taka sama zależność zachodzi dla niedeterministycznych algorytmów rozwiązujących. Wiąże się z tym jedna ciekawa właściwość, a mianowicie: jeśli znaleźli byśmy wielomianowy algorytm rozwiązujący dowolny problem w $np H$ od razu wynikałoby z tego że $#p = np$.

#def[#np - zupełność][

  Mówimy że problem decyzyjny $P$ jest #np - zupełny jeśli $P$ jest #np - trudny oraz $P in np$, zapisujemy wtedy $P in np C$
]

Relację pomiędzy tymi klasami ilustruje równanie $np inter np H = np C$.
Z powyższej definicji wynika że jest to klasa problemów z #np które są wzajemnie równoważne w sensie Karpa. Ta równoważność jest kluczowym pojęciem w tej pracy i to właśnie na problemach #np - zupełnych będziemy operować, co wyjaśnimy w późniejszej części pracy.


== Problemy funkcyjne
Z praktycznego jednak względu problemy decyzyjne, choć są lepsze w rozważaniach formalnych, oferują limitowaną funkcjonalność. Dużo bardziej przydatne jest poznanie dokładnej wartości rozwiązania. Wchodzimy wtedy na terytorium *problemów funkcyjnych*, szersze omówienie takich problemów możemy znaleźć w @papadimitriou_zlozonosc_2007[Rozdz. 10.3], w tej pracy omówimy je jedynie pokrótce.

#def[Problem funkcyjny][

  Weźmy abstrakcyjny problem zdefiniowany jako relacja $P subset.eq I_P times S_P$. \Problem funkcyjny definiujemy następująco:

  Dla danego $X in I_P$ znajdź rozwiązanie $y in S_P$, takie że $(x,y) in P$, o ile takie rozwiązanie istnieje; jeżeli takie słowo nie istnieje wówczas zwróć #nie
]

Widzimy że istnieje bezpośrednia relacja pomiędzy problemami funkcyjnymi a problemami decyzyjnymi, tzn. każdemu problemowi funkcyjnemu odpowiada problem decyzyjny gdzie zwracamy #tak jeśli istnieje odpowiednie rozwiązanie i #nie jeśli takie nie istnieje. 

W rzeczywistości istnieje swojego rodzaju równoważność pomiędzy problemami decyzyjnymi i funkcyjnymi tzn. jeśli możemy rozwiązać wersję decyzyjną problemu możemy też rozwiązać wersję funkcyjną w podobnym czasie. Jest to oparte na podstawie pojęcia *samoredukowalności* które to zachodzi dla większości problemów $P in np$, omówienie tego pojęcia wykracza jednak poza zakres tej pracy. W ogólności możemy jednak założyć że problem funkcyjny będzie co najmniej tak trudny jak odpowiadający mu problem decyzyjny, tzn. dla decyzyjnego problemu #np - Zupełnego, problem funkcyjny będzie #np - trudny

Dla problemów funkcyjnych istnieje nieco inne, bardziej ogólniejsze pojęcie redukcji które jest bliższe operacjom zaimplementowanym w bibliotece

#def[Wyrocznia][
  Dla danego problemu $P$ obliczenia funkcji $f : I_P -> S_P$, wyrocznią nazywamy abstrakcyjne urządzenie które, dla każdego egzemplarza $x in I_P$, zwraca wartość $f(x) in S_P$. Zakładamy że wyrocznia zwraca tę wartość w jednym kroku obliczeń i oznaczymy ją $cal(O)_P$
]

Wyrocznia jest więc w gruncie rzeczy hipotetycznym algorytmem rozwiązującym problem w jednym kroku obliczeń. W rzeczywistym zastosowaniu zastępujemy ją odpowiednim algorytmem rozwiązującym dany problem (niekoniecznie działającym w jednym kroku obliczeń).

#def[Redukowalność w sensie Turinga][
  Dla denego problemu $P_1$ obliczenia funkcji $f : I_P_1 -> S_P_2$. Mówimy że $P_1$ jest redukowalny w sensie Turinga do problemu $P_2$ jeśli istnieje algorytm $cal(R)$ dla problemu $P_1$ korzystający z wyroczni dla problemu $P_2$. Mówimy wtedy że $cal(R)$ jest redukcją w sensie Turinga z $P_1$ do $P_2$ i zapisujemy $P_1 scripts(<=)_T P_2$
]

Widzimy że redukcja Karpa jest w rzeczywistości szczególnym przypadkiem redukcji Turinga, gdy mamy do czynienia z problemem decyzyjnym. 
Tak samo jak dla redukcji Karpa definiujemy redukcje wielomianowe oznaczane są $P_1 scripts(<=)_T^p P_2$ i to właśnie takie redukcje będą implementowane w tej pracy, podzielimy jedynie algorytm $cal(R)$ na osobne części realizujące poszczególne operacje, tak aby można było je łatwo wykorzystać.  Strukturę redukcji Turinga oraz naszą interpretację zilustrowano na @turing_red[Rysunku]


#figure(sdiagram(
    edge((-0.7,0),(0,0),"->", stroke:path),
  node((0,0),$I_P_1$),
  // edge("->",$solve_P_1$),
  node((1,0),$S_P_1$),
  node((0,1),$I_P_2$),
  edge("->",$solve_P_2$, stroke:path),
  node((1,1),$S_P_2$),
  edge((0,0),(0,1),"->",tran, stroke:path),
  edge((1,0),(1,1),"->",con, shift:5pt, label-side:left),
  edge((1,0),(1,1),"<-",extr, shift:-5pt, stroke:path),
  edge((1,0),(1.7,0),"->", stroke:path),
  
  edge((-4.7,0),(-4,0),"->"),
  node((-4,0),$I_P_1$),
  node((-3,0),$S_P_1$),
  node((-4,1),$I_P_2$),
  edge("->",$cal(O)_P_2$),
  node((-3,1),$S_P_2$),
  edge((-4,0),(-4,1),"->"),
  edge((-3,1),(-3,0),"->"),
  edge((-3,0),(-2.3,0),"->"),
    node(
  align(top)[$cal(R)$],
  enclose: ((-4,0), (-3,1)),
  snap: -1,
  stroke: (paint: gray, thickness: 0.8pt, dash: "dashed"),
  shape: rect,
),

),
caption:[Struktura redukcji Turinga w porównaniu z algorytmami omawianymi w pracy]
) <turing_red>

Jak widzimy redukcja Turinga jest bezpośrednio realizowana za pomocą kilku algorytmów które możemy opisać w następujący sposób. Dodatkowo definiujemy algorytm #con który jest dopełnieniem funkcjonalności w bibliotece.

- #solve - transformacja (redukcja) egzemplarza $x in P_1$ do $x' in P_2$ <tran>
- #solve - rozwiązanie egzemplarza $x' in P_2$, odpowiednik wyroczni <solve>
- #extr - ekstrakcja rozwiązania $y in S_P_1$ z rozwiązania $y' in S_P_2$ <extr>
- #con - konstrukcja rozwiązania $y' in S_P_2$ przy pomocy rozwiązania $y in S_P_1$ <con>

W rzeczywistości transformacja rozwiązań bardzo często wymaga dodatkowych informacji o redukcji które w redukcji Turinga mogą być zachowane w algorytmie. W bibliotece jednak powoduje to potrzebę przekazania do algorytmów #extr i #con zarówno egzemplarza problemu jak i jego rozwiązania.


== Klasyczne problemy NP-zupełne

Mając już zdefiniowane wszystkie pojęcia, możemy zdefiniować formalnie problemy które będą zawarte w pracy. Większość definicji została zaczerpnięta z książki @rivest_wprowadzenie_2024, dla problemów tam nieobecnych wykorzystano definicje z @sudkamp_languages_2006. Wszystkie definicje zostały zarazem zweryfikowane z książką @garey_computers_1990[Appendix] która stanowi doskonały katalog formalnych definicji problemów z klasy #np.

Najbardziej podstawowym problemem z klasy #np jest problem *spełnialności formuł logicznych* w skrócie #rsat. Jest to również pierwszy problem dla którego udowodniono #np - zupełność, o czym mówi *twierdzenie Cook'a* którego dokładniejszy opis możemy zobaczyć w @rivest_wprowadzenie_2024[Lemat 34.6]. W skrócie mówi ono że problem #rsat może w pewien sposób emulować działanie algorytmu niedeterministycznego, a więc można z jego pomocą rozwiązać dowolny inny problem.

#pro[#rsat - Spełnialność formuł logicznych][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $V$ - zbiór zmiennych logicznych, $|V| = n$\
    $phi$ - formuła logiczna złożona z:
    #enum(indent: 1em,
    [$n$ zmiennych logicznych $x_1,x_2,dots,x_n in V$ ],
    [$m$ spójników logicznych np. $and, or, not, ->,<->$],
    [nawiasów (nie występują nadmiarowe nawiasy)]
    )
  ] <sat>

  *Pytanie* : Czy istnieje  wartościowanie $pi : V -> {tru, fal}$ dla którego formuła jest spełniona?
]]

Kolejnym problemem będącym niejako uproszczeniem struktury problemu #rsat jest problem:

#pro[#sat - Spełnialność formuł w postaci koniunkcyjnej normalnej][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $V$ - zbiór zmiennych logicznych, $|V| = n$\
    $phi$ - formuła logiczna zapisana jako koniunkcja $m$ *klauzul* gdzie:
    #list(indent: 1em,
    [*Klauzula* to alternatywa literałów],
    [*Literał* to wystąpienie zmiennej $x in V$, lub jej negacji $not x$]
    )
  ] 

  *Pytanie* : Czy istnieje  wartościowanie $pi : V -> {tru, fal}$ dla którego formuła jest spełniona?
]] <cnfsat>

Znanym jest fakt że dowolna formuła może zostać zapisana w postaci CNF. Wielomianową (a w dodatku liniową) transformację tego typu realizuje transformacja Tseytin @tseitin_complexity_1983, która nie została jednak zawarta w bibliotece. Z powodu równoważności tych problemów, oraz znacznie łatwiejszego, znormalizowanego zapisu problemu #sat to właśnie on jest standardem w informatycznych zastosowaniach problemu spełnialności, i to także on jest bazowym problemem w tej pracy.

#pro[#sat3 - Spełnialność formuł 3-CNF][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $V$ - zbiór zmiennych logicznych, $|V| = n$\
    $phi$ - formuła logiczna w postaci koniunkcyjnej normalnej,\ gdzie każda klauzula zawiera dokładnie 3 różne literały
  ] 

  *Pytanie* : Czy istnieje  wartościowanie $pi : V -> {tru, fal}$ dla którego formuła jest spełniona?
]] <sat3>

Jest to ostatni problem z rodziny problemów spełnialności formuł i dzięki jego jeszcze większej regularności stanowi on często punkt wyjścia dla redukcji do dalszych problemów.

Wychodząc z zagadnienia spełnialności, natrafiamy na różnorakie problemy pochodne, możemy je z grubsza podzielić na kilka grup o podobnej specyfice. W pierwszej z omawianych grup znajdują się problemy pokrycia struktur. Podstawowym problemem jest tutaj #vc definiujący zagadnienie pokrycia wszystkich krawędzi w grafie za pomocą podzbioru wierzchołków.

#pro[#vc - Problem pokrycia wierzchołkowego][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $G =(V,E)$ - Graf nieskierowany \
    $k$ - liczba naturalna
  ] 

  *Pytanie* : Czy istnieje podzbiór wierzchołków $V' subset.eq V$ rozmiaru co najwyżej $k$, taki że:\
  $
  forall (v,u) in E : u in V' or v in V'
  $
]] <vc>

Kolejnymi w grupie są problemy bardzo blisko związanie z #vc

#pro[#cli - Problem kliki][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $G =(V,E)$ - Graf nieskierowany \
    $k$ - liczba naturalna
  ] 

  *Pytanie* : Czy istnieje podzbiór wierzchołków $V' subset.eq V$ rozmiaru co najmniej $k$, w którym każda para wierzchołków jest połączona krawędzią należącą do $E$?
]] <cli>

#pro[#ind - Problem zbioru niezależnego][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $G =(V,E)$ - Graf nieskierowany \
    $k$ - liczba naturalna
  ] 

  *Pytanie* : Czy istnieje podzbiór wierzchołków $V' subset.eq V$ rozmiaru co najmniej $k$, w którym każda para wierzchołków jest połączona krawędzią należącą do $E$?
]]<ind>

Na pierwszy rzut oka powiązanie tych problemów nie jest oczywiste, są to jednak problemy niemalże równoważne, zauważmy że dla grafu $G = (V,E)$ podzbiór $V' subset.eq V$ jest pokryciem wierzchołkowym wtedy i tylko wtedy gdy jego dopełnienie $V \\ V'$ jest zbiorem niezależnym zobacz @kleinberg_algorithm_2006[Tw. 8.3]. Ponadto $V'$ jest zbiorem niezależnym wtedy i tylko wtedy gdy $V'$ jest kliką w dopełnieniu grafu $G^C = (V,E^C)$.

#pro[#hit - Problem zbioru przecinającego][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $S$ - Skończony zbiór \
    #con - skończona rodzina podzbiorów $S$ \
    $k$ - liczba naturalna
  ] 

    *Pytanie* : Czy istnieje podzbiór $S' subset.eq S$ rozmiaru co najwyżej $k$, taki że dla dowolnego podzbioru $C in cal(C)$ przekrój $S' inter C$ jest niepusty?
]] <hit>

Możemy zauważyć że problem #hit jest uogólnieniem problemu #vc na "grafy" gdzie jedna krawędź może łączyć więcej niż 2 wierzchołki.

Następna grupa to problemy dotyczące cykli w grafie, cyklem w grafie $G = (V,E)$ nazywamy ciąg wierzchołków $v_i in V : chevron v_0,v_1,dots,v_k chevron.r$ w którym każde dwa kolejne wierzchołki są połączone krawędzią z $E$ oraz $v_0 = v_k$. Ponadto w poniższych problemach będziemy rozpatrywać *cykle Hamiltona* czyli cykle odwiedzające wszystkie wierzchołki w grafie dokładnie raz.

#pro[#uham - Problem cyklu Hamiltona][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $G =(V,E)$ - Graf nieskierowany \
  ] 

  *Pytanie* : Czy w grafie istnieje cykl odwiedzający każdy wierzchołek dokładnie raz?

]] <uham>

#pro[#ham  \ #h(5.1em) Problem cyklu Hamiltona w grafie skierowanym][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $G =(V,E)$ - Graf skierowany \
  ] 

  *Pytanie* : Czy w grafie istnieje skierowany cykl odwiedzający każdy wierzchołek dokładnie raz?

]] <ham>

#pro[#tsp - Problem komiwojażera][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $G =(V,E)$ - nieskierowany graf pełny \
    $c : V times V -> NN$  - funkcja odległości\
    $k$ - liczba naturalna
  ] 

  *Pytanie* : Czy w grafie istnieje cykl Hamiltona o długości co najwyżej $k$?

]] <tsp>


Ostatnia grupa to problemy sum podzbiorów, w tych problemach zazwyczaj szukamy podzbioru liczb którego suma osiąga jakąś pożądaną wartość:

#pro[#subs - Problem sumy podzbioru][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $S$ - skończony zbiór liczb naturalnych\
    $t$ - liczba naturalna
  ] 

  *Pytanie* : Czy istnieje podzbiór $S' subset.eq S$ taki, że suma jego elementów jest równa $t$?

]]<subs>

#pro[#part - Problem podziału][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $S$ - skończony zbiór liczb naturalnych
  ] 

  *Pytanie* : Czy istnieje podział zbioru $S$ na dwa rozłączne podzbiory o równej sumie elementów?

]]<part>

#pro[#bin - Problem pakowania][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $S$ - skończony zbiór liczb naturalnych\
    $k, m$ - liczby naturalne
  ] 

  *Pytanie* : Czy istnieje podział zbioru $S$ na $k$ rozłącznych podzbiorów $A_1,A_2,dots,A_k$ takich że suma elementów każdego z nich jest równa co najwyżej $m$?

]]<bin>

Możemy zauważyć że powyższe problemy są w zasadzie równoważne, różni je jedynie konfiguracja. Często #subs oraz #part bywają nazywane podproblemami problemu plecakowego który w tej grupie jest zdecydowanie najbardziej popularny.

#pro[#knap - Problem plecakowy][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $S$ - skończony zbiór\
    $s : S -> NN$  - funkcja wagi\
    $v : S -> NN$  - funkcja wartości\
    $b, m$ - liczby naturalne
  ] 

  *Pytanie* : Czy istnieje podzbiór $S' subset.eq S$ taki że: $s(S') <=b$ oraz $ v(S') >= m$?

]]<knap>

Ostatnim z omawianych problemów a zarazem problemem w pewien sposób ukrytym jest problem #mip. Ukrytym ponieważ nie występuje on jawnie w bibliotece, jest on jednak wykorzystywany w algorytmie rozwiązującym: #solve. W rzeczywistości realizujemy więc niejawną redukcję do problemu #mip dla wszystkich wymienionych wcześniej problemów. Jest tak ponieważ rozwiązanie problemów #mip może być łatwo realizowane za pomocą szeroko dostępnych  narzędzi takich jak solvery MIP, które dodatkowo działają porównywalnie szybko. Redukcja do #mip jest również zazwyczaj dosyć łatwa, co sprawiło że metoda ta została wybrana jako domyślny sposób rozwiązywania egzemplarzy problemów w tej bibliotece.

#pro[#mip - Programowanie całkowitoliczbowe][
  
    *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    Układ równań liniowych (ograniczeń) postaci: \
    $A = (a_(i j))$ - macierz liczb całkowitych wymiaru $n times m$\
    $b = (b_i)$ - wektor liczb całkowitych wymiaru $m$, wektor prawych stron \
    oraz\
    $c = (c_j)$ - wektor liczb całkowitych wymiaru $n$, wektor funkcji celu \
    $B$ - liczba całkowita, ograniczenie funkcji celu
  ] 

  *Pytanie* : Czy istnieje wektor liczb całkowitych $x = (x_j)$ wymiaru $n$ taki że:

  $
  c^T x <= d \
  A x <= b \
  x >= 0
  $
] <mip>

== Problemy optymalizacyjne <opt>

W rzeczywistości kilka z wcześniej wymienionych problemów to tak naprawdę problemy optymalizacyjne. *Problem optymalizacyjny* to problem gdzie z każdym dopuszczalnym rozwiązaniem związana jest pewna wartość i chcemy znaleźć rozwiązanie dopuszczalne z najlepszą wartością.

Złożoność obliczeniowa problemów gdzie szukamy minimalnego lub maksymalnego rozwiązania różni się problemów z klasy #np. Istnieje jednak przydatna zależność między problemami optymalizacyjnymi a decyzyjnymi. Możemy zazwyczaj przejść od problemu optymalizacyjnego do pokrewnego problemu decyzyjnego, wprowadzając dodatkowy parametr - ograniczenie optymalizowanej wartości, czego przykład możemy zobaczyć np. w @knap[Problemie #knap], gdzie stała $m$ jest ograniczeniem funkcji celu.
Zależność ta została poza tym wykorzystana w kilku innych problemach wymienionych wyżej.



= Analiza i opis wybranych redukcji

W tym rozdziale opiszemy kilka ciekawych redukcji zaimplementowanych w pracy. Redukcje takie zazwyczaj polegają na imitowaniu struktury jednego problemu za pomocą szczególnego przypadku drugiego. Struktury realizujące tą funkcję nazywamy *gadżetami* (ang. gadgets), słowo to jest w szczególności używane w przypadku problemów grafowych, gdzie są one bardzo często wykorzystywane. W poniższym rozdziale przejdziemy krok po kroku przez proces konstrukcji redukcji uzasadniając kolejne kroki i argumentując podjęte decyzje.

== Redukcje trywialne

Kilka redukcji zawartych w bibliotece jest wyjątkowo łatwych do wykonania jeśli przyjrzymy się ich specyfice. Przykładem tutaj może być redukcja #sat3 do #sat, możemy łatwo zauważyć że #sat3 jest właściwie szczególnym przypadkiem problemu #sat, a egzemplarze tłumaczą się bezpośrednio. Redukcje takie zostały zaimplementowane w bibliotece, szerzej omawiać jednak będziemy te ciekawsze, oparte na pewnym bardziej zaawansowanym procesie.

== Redukcja #sat3 do #vc

Ustalmy problem #sat3 jako: $W = w_1 and w_2 and dots and w_m$ formuła w postaci koniunkcyjnej normalnej gdzie $w_j = u_(j,1) or u_(j,2) or u_(j,3)$ oraz $X = {x_1, x_2, dots, x_n}$ zbiór zmiennych używanych w formułach.

#vc to problem polegający na znalezieniu podzbioru wierzchołków takiego że każda krawędź w grafie dotyka co najmniej jednego wierzchołka z podzbioru, z tym że dla dowolnego $C$ ten problem jest trywialny bo wtedy może być $C = V$, ograniczamy więc jego wielkość parametrem 
$C <= s$.

Żeby emulować problem #sat3 szukamy najpierw struktury emulującej ewaluacje zmiennych w sensie problemu #vc, nietrudno taką znaleźć a wygląda ona tak:

#figure(
  sdiagram(
    node($x$),
    edge("-", label:$e$),
    node((1,0), $not x$),
  ),
  caption:[Przykładowy podgraf zmiennej]
)

widzimy że ma ona 2 możliwe rozwiązania dla $s = 1$ tzn., wybór $x$ lub $not x$ spełnia warunek dla krawędzi $e$. Możemy utworzyć graf z wielu takich struktur jednocześnie ustalając $s$ jako ich ilość i mamy gotową ewaluację dla wielu zmiennych.

W następnym kroku szukamy struktury emulującej klauzulę, gdzie odpowiednia ewaluacja zmiennej pozwala na spełnienie danej klauzuli.

#figure(sdiagram(
  node($u_(i,1)$),
  edge("-"),
  node((1,1),$u_(i,2)$),
  edge("-"),
  node((-1,1),$u_(i,3)$),
  edge("ne","-"),
  
  node((2,0),$x_1$),
  edge("ww","-"),
  node((2,1),$x_2$),
  edge("w","-"),
  node((-2,1),$x_3$),
  edge("e","-"),
  node(
  align(left+top)[$w_i$],
  enclose: ((-1.3, -0.5), (1, 1)),
  snap: -1,
  stroke: (paint: gray, thickness: 0.8pt, dash: "dashed"),
  shape: rect,
)
),
caption:[Przykładowy podgraf klauzuli z podpiętymi zmiennymi]
)

Widzimy że aby znaleźć rozwiązanie dla tej struktury w problemie #vc wszystkie 3 wierzchołki w podgrafie $w_i$ muszą należeć do zbioru $C$, chyba że któraś ze zmiennych $x_i in {x_1, x_2, x_3}$ podpiętych do podgrafu znajduje się w zbiorze $C$ - wtedy wystarczą 2 wierzchołki (nie może być to mniej niż 2 wierzchołki ponieważ w innym wypadku krawędzie w 'trójkącie' nie spełniają warunku). Właściwość tą wykorzystamy do skonstruowania właściwego grafu emulującego #sat3. Zwyczajnie tworzymy podgrafy dla zmiennych i klauzul i odpowiednio je łączymy.

#figure(
  sdiagram(
    node($x_1$),
    edge("-"),
    node((1,0),$not x_1$),
    node((2,0),$x_2$),
    edge("-"),
    node((3,0),$not x_2$),
    node((4,0),$x_3$),
    edge("-"),
    node((5,0),$not x_3$),


    node((0,3),$u_(1,1)$),
    edge("-"),
    node((1,2),$u_(1,2)$),
    edge("-"),
    node((2,3),$u_(1,3)$),
    edge("ww","-"),
    node((3,3),$u_(2,1)$),
    edge("-"),
    node((4,2),$u_(2,2)$),
    edge("-"),
    node((5,3),$u_(2,3)$),
    edge("ww","-"),

    node(
    align(left+top)[$w_1$],
    enclose: ((0,3),(1,2),(2, 3)),
    snap: -1,
    stroke: (paint: gray, thickness: 0.8pt, dash: "dashed"),
    shape: rect,
  ),

  node(
    align(left+top)[$w_2$],
    enclose: ((3,3), (4,2),(5,3)),
    snap: -1,
    stroke: (paint: gray, thickness: 0.8pt, dash: "dashed"),
    shape: rect,
  ),

  edge((0,0),(0,3)),
  edge((2,0),(1,2)),
  edge((5,0),(2,3)),
  
  edge((1,0),(3,3)),
  edge((2,0),(4,2)),
  edge((5,0),(5,3)),
                
  ),
  caption: [Przykładowy graf emulacji #sat3]
)

Powyższy przykładowy graf jest równoważny następującej formule #sat3 w sensie problemu #vc.

$
(x_1 or x_2 or not x_3) and (not x_1 or x_2 or not x_3)
$

Mając już gotowy graf emulacji pozostaje nam jedynie ustalenie parametru $n$ ograniczającego wielkość podzbioru wierzchołków w problemie. Każdy podgraf zmiennej wymaga wybrania jednego z wierzchołków a każda spełniona klauzula wymaga wybrania 2 wierzchołków (niespełniona klauzula wymaga 3 wierzchołków), ustalamy więc $s$ jako:

$
s = n + 2m
$

Jeśli istnieje rozwiązanie o takim rozmiarze istnieje odpowiadające mu rozwiązanie zadanego problemu #sat3. Przykładowe rozwiązanie utworzonego problemu #vc przedstawiono poniżej. 

#figure(
  sdiagram(
    node($x_1$, stroke:path),
    edge("-"),
    node((1,0),$not x_1$),
    node((2,0),$x_2$, stroke:path),
    edge("-"),
    node((3,0),$not x_2$),
    node((4,0),$x_3$),
    edge("-"),
    node((5,0),$not x_3$, stroke:path),


    node((0,3),$u_(1,1)$, stroke:path),
    edge("-"),
    node((1,2),$u_(1,2)$),
    edge("-"),
    node((2,3),$u_(1,3)$, stroke:path),
    edge("ww","-"),
    node((3,3),$u_(2,1)$, stroke:path),
    edge("-"),
    node((4,2),$u_(2,2)$),
    edge("-"),
    node((5,3),$u_(2,3)$, stroke:path),
    edge("ww","-"),

    node(
    align(left+top)[$w_1$],
    enclose: ((0,3),(1,2),(2, 3)),
    snap: -1,
    stroke: (paint: gray, thickness: 0.8pt, dash: "dashed"),
    shape: rect,
  ),

  node(
    align(left+top)[$w_2$],
    enclose: ((3,3), (4,2),(5,3)),
    snap: -1,
    stroke: (paint: gray, thickness: 0.8pt, dash: "dashed"),
    shape: rect,
  ),

  edge((0,0),(0,3)),
  edge((2,0),(1,2)),
  edge((5,0),(2,3)),
  
  edge((1,0),(3,3)),
  edge((2,0),(4,2)),
  edge((5,0),(5,3)),
                
  ),
  caption: [Przykładowe rozwiązanie problemu #vc]
)

Widzimy że zawiera ono $3 + 2 dot 2 = 7$ wierzchołków a więc spełnia nasze wymogi i odpowiada następującemu rozwiązaniu #sat3

$
x_1 = bb(1) quad x_2 = bb(1) quad x_3 = bb(0), 
$
Którego poprawnośc możemy łatwo sprawdzić:
$
(x_1 or x_2 or not x_3) and (not x_1 or x_2 or not x_3) = \
(bb(1) or bb(1) or not bb(0)) and (not bb(1) or bb(1) or not bb(0)) = \
(bb(1) or bb(1) or bb(1)) and (bb(0) or bb(1) or bb(1)) = bb(1)
$

#pagebreak()
== Redukcja #sat3 do #subs

Ustalmy problem #sat3 jako: $W = w_1 and w_2 and dots and w_m$ formuła w postaci koniunkcyjnej normalnej gdzie $w_j = u_(j,1) or u_(j,2) or u_(j,3)$ oraz $X = {x_1, x_2, dots, x_n}$ zbiór zmiennych używanych w formułach.

Aby zredukować problem #sat3 do #subs musimy przedstawić egzemplarz problemu spełnialności jako zbiór liczb naturalnych a prawidłową ewaluację jako liczbę naturalną. Aby skonstruować tą nieoczywistą redukcję musimy rozpatrzyć liczbę jako ciąg cyfr gdzie każda z cyfr realizuje osobną funkcję.

Wstępny przegląd literatury pokazał istnienie dwóch bardzo podobnych metod: metoda _Cormena_ @rivest_wprowadzenie_2024 oraz metoda _Sudkampa_ @sudkamp_languages_2006. Szybkie porównanie pokazało jednak że metoda Sudkampa pozwala na wykorzystanie liczb w systemie *czwórkowym* tzn. o bazie 4, co gdy operujemy na cyfrach liczb ma znaczący wpływ na ich wielkość. Dlatego ostatecznie została wykorzystana metoda Sudkampa @sudkamp_languages_2006[Tw. 16.3.3].

W redukcji każda liczba $s in S$ będzie odpowiadała ewaluacji zmiennej $x$, tzn definiujemy $2n$ liczb z których połowa będzie odpowiadała pozytywnym ewaluacjom zmiennych a druga połowa negatywnym ewaluacjom zmiennych. Sprawia to że wynikowy podzbiór $S' subset.eq S$ będzie zawierał liczby odpowiadające odpowiednim ewaluacjom zmiennych, musimy jednak odpowiednio zdefiniować same liczby aby uniknąć wyboru dwóch ewaluacji dla jednej zmiennej oraz odpowiednio emulować specyfikę problemu #sat3.

Liczby $s in S$ zdefiniujemy w następujący sposób:

#figure(
  table(
    columns: 6,
    align: (right,center,center,center,center,center),
    stroke: (x,y) => if y == 0 and x >= 1 {
    (bottom: 0.7pt + black)
  } else if x == 0 and y >= 1 {
    (right: 0.7pt + black)
  },
    table.header(
      [],$w_2$, $w_1$, $x_3$, $x_2$, $x_1$, 
    ),
    $x_1$, [1], [0], [0], [0], [3],
    $not x_1$, [0], [1], [0], [0], [3],
    $dots.v$, [], [], $dots.c$, [], [],
    table.hline(),
    $k$, [3], [3], [3], [3], [3],
  ),
  caption: [Liczby odpowiadające ewaluacji zmiennych]
)

Każda z liczb będzie składać się z $n + m$ cyfr, gdzie cyfry $chevron 1, n chevron.r$ będą oznaczać wykorzystanie danej zmiennej, a cyfry $chevron n+1,n+m chevron.r$ będą oznaczać zaspokajanie danej klauzuli przez daną ewaluację zmiennej. Sumę docelową określimy natomiast jako liczbę odpowiedniej długości o wszystkich cyfrach równych 3. Możemy łatwo zauważyć że taka konstrukcja zapewnia nam wybór dokładnie jednej ewaluacji do podzbioru, wybór dwóch skutkowałby pojawieniem się w sumie cyfry 2 a nie wybranie ewaluacji sprawia że wystąpi tam cyfra 0.

Widzimy jednak że taka konstrukcja powoduje że każda ze zmiennych w klauzuli musiałaby posiadać prawidłową ewaluację, co jest sprzeczne z definicją problemu #sat3. Dlatego wprowadzamy dodatkowe liczby wypełniające, pozwalające na wybór co najmniej jednej ewaluacji dla klauzuli. Liczby te nie mają żadnego wpływu na cyfry zmiennych, pozwalają one jednak na wypełnienie danej cyfry klauzuli aby osiągnąć wartość 3 w wypadku gdy dla sumy ewaluacji ta cyfra wynosi 1 lub 2.

#figure(
  table(
    columns: 6,
    align: (right,center,center,center,center,center),
    stroke: (x,y) => if y == 0 and x >= 1 {
    (bottom: 0.7pt + black)
  } else if x == 0 and y >= 1 {
    (right: 0.7pt + black)
  },
    table.header(
      [],$w_2$, $w_1$, $x_3$, $x_2$, $x_1$, 
    ),
    $dots.v$, [], [], $dots.c$, [], [],
    $y_1$, [0], [1], [0], [0], [0],
    $y'_1$, [0], [1], [0], [0], [0],
    $dots.v$, [], [], $dots.c$, [], [],
  ),
  caption: [Liczby wypełniające]
)

Widzimy że konstrukcja wzbogacona o liczby wypełniające jest już równoważna problemowi #sat3. Przeprowadzimy więc redukcję dla przykładowego egzemplarza: 

$
(x_1 or x_2 or not x_3) and (not x_1 or x_2 or not x_3)
$

#let chosen = (1,3,5,7,8,9)

#figure(
  grid(
    columns: (1fr,1fr),
    [
#figure(
  table(
    columns: 6,
    align: (right,center,center,center,center,center),
    stroke: (x,y) => if y == 0 and x >= 1 {
    (bottom: 0.7pt + black)
  } else if x == 0 and y >= 1 {
    (right: 0.7pt + black)
  },
    fill: (x,y) => if chosen.contains(y) {
      luma(200)
    },
    table.header(
      [],$w_2$, $w_1$, $x_3$, $x_2$, $x_1$, 
    ),
    $x_1$, [1], [0], [0], [0], [3],
    $not x_1$, [0], [1], [0], [0], [3],
    $x_2$, [1], [1], [0], [3], [0],
    $not x_2$, [0], [0], [0], [3], [0],
    $x_3$, [0], [0], [3], [0], [0],
    $not x_3$, [1], [1], [3], [0], [0],
    $y_1$, [0], [1], [0], [0], [0],
    $y'_1$, [0], [1], [0], [0], [0],
    $y_2$, [1], [0], [0], [0], [0],
    $y'_2$, [1], [0], [0], [0], [0],
    table.hline(),
    $k$, [3], [3], [3], [3], [3],
  ),
)
    ],
    $
    \ \ \ \ \
    & 10003_4 + \
    & 11030_4 + \
    & 00300_4 + \
    & 01000_4 + \
    & 01000_4 + \
    & 10000_4 \
    = & 33333_4
    $
  ),
  caption: [Przykładowy egzemplarz wynikowy #subs z zaznaczonym podzbiorem]
)

Widzimy że pokazany powyżej podzbiór liczb jest poprawnym rozwiązaniem, co pokazuje suma jego elementów pokazana na , co więcej odpowiada on ewaluacji $x_1 = 1, x_2 = 1, x_3 = 1$ która jest poprawnym rozwiązaniem źródłowego egzemplarza problemu #sat3.

#pagebreak()
== Redukcja #sat3 do #ham

Ustalmy problem #sat3 jako: $W = w_1 and w_2 and dots and w_m$ formuła w postaci koniunkcyjnej normalnej gdzie $w_j = u_(j,1) or u_(j,2) or u_(j,3)$ oraz $X = {x_1, x_2, dots, x_n}$ zbiór zmiennych używanych w formułach.

Problem #ham polega na znalezieniu w grafie cyklu Hamiltona tzn. cyklu który przechodzi przez każdy wierzchołek w grafie dokładnie raz. 

Naszym celem jest skonstruowanie na podstawie zadanego problemu #sat3 grafu dla którego znalezienie cyklu Hamiltona będzie równoznaczne z rozwiązaniem problemu #sat3. Dokonamy tego w dwóch krokach: najpierw stworzymy podgraf emulujący zachowaniem zmienną a następnie podgraf emulujący zachowaniem klauzulę.

=== Podgraf zmiennej

Podgraf odpowiadający zmiennej musi spełniać następującą właściwość: Cykl Hamiltona może przebiegać przez podgraf na dokładnie dwa sposoby. Podgraf taki można stworzyć na wiele sposobów, wybrana została jednak wersja przedstawiona na @zmien[Rysunku] Długość środkowego łańcucha w podgrafie musi być większa od 2 wierzchołków i może być zwiększona w miarę potrzeb.

#figure(
  sdiagram(
    size: 110%,
    node([$n_1$], name: "n1"),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((1, 0), [$n_2$]),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((2, 0), [$n_3$]),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((3, 0), [$dots$], stroke: 0pt),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((4, 0), [$n_(k-1)$]),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((5, 0), [$n_(k)$]),

    edge((0, -1), (0, 0), "-|>", dash: "dashed"),
    edge((1, -1), (0, 0), "-|>", dash: "dashed"),
    edge((5, -1), (5, 0), "-|>", dash: "dashed"),
    edge((4, -1), (5, 0), "-|>", dash: "dashed"),

    edge((0, 0), (0, 1), "-|>", dash: "dashed"),
    edge((0, 0), (1, 1), "-|>", dash: "dashed"),
    edge((5, 0), (5, 1), "-|>", dash: "dashed"),
    edge((5, 0), (4, 1), "-|>", dash: "dashed"),
  ),
  caption: [$X_i$ - Podgraf zmiennej $x_i$],
) <zmien>

#let grid_size = 85%
#figure(
  grid(
    columns: (1fr, 1fr),
    // 2 means 2 auto-sized columns
    // space between columns
    [true: $x_i = bb(1)$
      #sdiagram(
        size: grid_size,
        node([$n_1$], name: "n1"),
        edge("-|>", shift: 5pt, stroke: path),
        edge("<|-", shift: -5pt),
        node((1, 0), [$n_2$]),
        edge("-|>", shift: 5pt, stroke: path),
        edge("<|-", shift: -5pt),
        node((2, 0), [$n_3$]),
        edge("-|>", shift: 5pt, stroke: path),
        edge("<|-", shift: -5pt),
        node((3, 0), [$n_4$]),

        edge((0, -1), (0, 0), "-|>", dash: "dashed", stroke: red),
        edge((1, -1), (0, 0), "-|>", dash: "dashed", stroke: red),
        edge((3, -1), (3, 0), "-|>", dash: "dashed"),
        edge((2, -1), (3, 0), "-|>", dash: "dashed"),

        edge((0, 0), (0, 1), "-|>", dash: "dashed"),
        edge((0, 0), (1, 1), "-|>", dash: "dashed"),
        edge((3, 0), (3, 1), "-|>", dash: "dashed", stroke: red),
        edge((3, 0), (2, 1), "-|>", dash: "dashed", stroke: red),
      )
    ],
    [false: $x_i = bb(0)$
      #sdiagram(
        size: grid_size,
        node([$n_1$], name: "n1"),
        edge("-|>", shift: 5pt),
        edge("<|-", shift: -5pt, stroke: path),
        node((1, 0), [$n_2$]),
        edge("-|>", shift: 5pt),
        edge("<|-", shift: -5pt, stroke: path),
        node((2, 0), [$n_3$]),
        edge("-|>", shift: 5pt),
        edge("<|-", shift: -5pt, stroke: path),
        node((3, 0), [$n_4$]),

        edge((0, -1), (0, 0), "-|>", dash: "dashed"),
        edge((1, -1), (0, 0), "-|>", dash: "dashed"),
        edge((3, -1), (3, 0), "-|>", dash: "dashed", stroke: red),
        edge((2, -1), (3, 0), "-|>", dash: "dashed", stroke: red),

        edge((0, 0), (0, 1), "-|>", dash: "dashed", stroke: red),
        edge((0, 0), (1, 1), "-|>", dash: "dashed", stroke: red),
        edge((3, 0), (3, 1), "-|>", dash: "dashed"),
        edge((3, 0), (2, 1), "-|>", dash: "dashed"),
      )
    ],
  ),
  caption: [Możliwe przebiegi cyklu Hamiltona w podgrafie $X_i$],
)

Oznaczymy ten podgraf jako $X_i$ i będzie on odpowiadał zmiennej $x_i$. Łatwo możemy zobaczyć że posiada on dokładnie 2 możliwe ścieżki Hamiltona. Ustalmy więc że ścieżka idąca po wierzchołkach w prawą stronę oznacza ewaluację zmiennej $x$ na `true` a w lewą stronę na `false`.

Mający ustalony podgraf, łączymy następnie podgrafy dla poszczególnych zmiennych w jeden wielki cykl który będzie odpowiadał ewaluacji zmiennych $x_i$ problemu #sat3. W kolejnych podgrafach łączymy razem pierwsze i ostatnie wierzchołki w łańcuchu, w następujący sposób.
#grid(
  columns: (1.2fr, 1fr),
  // 2 means 2 auto-sized columns
  gutter: 0pt,
  // space between columns
  align: center + horizon,
    figure(
  sdiagram(
    pads:5pt,
    size:98%,
    let finish = 5,
    for i in range(1, finish + 1) {
      node((0, i), $n_(#i,1)$, name: "1" + str(i))
      edge("-|>", shift: 5pt)
      edge("<|-", shift: -5pt)
      node((1, i), $n_(#i,2)$, name: "2" + str(i))
      edge("-|>", shift: 5pt)
      edge("<|-", shift: -5pt)
      node((2, i), $n_(#i,3)$, name: "3" + str(i))
      node(
        align(left)[$X_#i$],
        enclose: ((-1, i), (2, i)),
        snap: -1,
        stroke: (paint: gray, thickness: 0.8pt, dash: "dashed"),
        shape: rect,
      )
    },
    for j in range(2, finish + 1) {
      edge((name: "1" + str(j - 1)), (name: "1" + str(j)), "-|>")
      edge(
        (name: "3" + str(j - 1), anchor: "south-west"),
        (name: "1" + str(j), anchor: "north-east"),
        "-|>",
      )
      edge(
        (name: "1" + str(j - 1), anchor: "south-east"),
        (name: "3" + str(j), anchor: "north-west"),
        "-|>",
      )
      edge((name: "3" + str(j - 1)), (name: "3" + str(j)), "-|>")
    },
    edge((0, 0), (0, 1), "-|>", dash: "dashed"),
    edge((0.75, 0), (0, 1), "-|>", dash: "dashed"),
    edge((1.25, 0), (2, 1), "-|>", dash: "dashed"),
    edge((2, 0), (2, 1), "-|>", dash: "dashed"),

    edge((0, finish), (0, finish + 1), "-|>", dash: "dashed"),
    edge((0, finish), (0.75, finish + 1), "-|>", dash: "dashed"),
    edge((2, finish), (1.25, finish + 1), "-|>", dash: "dashed"),
    edge((2, finish), (2, finish + 1), "-|>", dash: "dashed"),
  ),
  caption: [Zbliżenie na część przykładowego \ grafu ewaluacji],
),
[#figure(
    [
      #let sqnode = node.with(shape:rect, width:60pt, radius:auto)

#let subg_conn(a,b, shape:"-|>") = {
  edge((name:a, anchor:"south-west"),(name:b, anchor:"north-west"), shape, shift:5pt)
  edge((name:a, anchor:"south-west"),(name:b, anchor:"north-east"), shape, shift:(3pt,-3pt))
  edge((name:a, anchor:"south-east"),(name:b, anchor:"north-west"), shape, shift:(-3pt,3pt))
  edge((name:a, anchor:"south-east"),(name:b, anchor:"north-east"), shape, shift:-5pt)
}

#set math.equation(numbering: none)

#sdiagram(
  pads:5pt,
  size:90%,
  sqnode([$X_1$], name:<v1>),
  sqnode((0,1), $X_2$, name:<v2>),
  sqnode((0,2), $X_3$, name:<v3>),
  sqnode((0,3), $X_4$, name:<v4>),
  sqnode((0,4), $X_5$, name:<v5>),
  sqnode((0,5), $X_6$, name:<v6>),
 


  subg_conn(<v1>,<v2>),
  subg_conn(<v2>,<v3>),
  subg_conn(<v3>,<v4>),
  subg_conn(<v4>,<v5>),
  subg_conn(<v5>,<v6>),

  sqnode((1,0), $X_12$, name:<v12>),
  sqnode((1,1), $X_11$, name:<v11>),
  sqnode((1,2), $X_10$, name:<v10>),
  sqnode((1,3), $X_9$, name:<v9>),
  sqnode((1,4), $X_8$, name:<v8>),
  sqnode((1,5), $X_7$, name:<v7>),

  subg_conn(<v12>,<v11>, shape:"<|-"),
  subg_conn(<v11>,<v10>, shape:"<|-"),
  subg_conn(<v10>,<v9>, shape:"<|-"),
  subg_conn(<v9>,<v8>, shape:"<|-"),
  subg_conn(<v8>,<v7>, shape:"<|-"),


  let degr = -50deg,
  edge((name:<v6>, anchor:"south-west"),(name:<v7>, anchor:"south"), "-|>", bend:degr, shift:(5pt,15pt)),
  edge((name:<v6>, anchor:"south-west"),(name:<v7>, anchor:"south-east"), "-|>", bend:degr, shift:(5pt,5pt)),
  edge((name:<v6>, anchor:"south"),(name:<v7>, anchor:"south"), "-|>", bend:degr, shift:(15pt,15pt)),
  edge((name:<v6>, anchor:"south"),(name:<v7>, anchor:"south-east"), "-|>", bend:degr, shift:(15pt,5pt)),

  let degr = 50deg,
  edge((name:<v1>, anchor:"north-west"),(name:<v12>, anchor:"north"), "<|-", bend:degr, shift:(-5pt,-15pt)),
  edge((name:<v1>, anchor:"north-west"),(name:<v12>, anchor:"north-east"), "<|-", bend:degr, shift:(-5pt,-5pt)),
  edge((name:<v1>, anchor:"north"),(name:<v12>, anchor:"north"), "<|-", bend:degr, shift:(-15pt,-15pt)),
  edge((name:<v1>, anchor:"north"),(name:<v12>, anchor:"north-east"), "<|-", bend:degr, shift:(-15pt,-5pt)),

  node([], enclose: (<v1>,<v5>), shape: shapes.brace.with(dir:left, size:1.5em), snap:-1)

)
    ],
    caption: [Diagram połączenia podgrafów zmiennych w cykl - Graf ewaluacji],
  )<ccycles>],
)
\
Jak widać na @ccycles[rysunku] tworzymy swego rodzaju "cykl" podgrafów, łącząc je w taki sposób aby ewaluacja każdej zmiennej była niezależna od ewaluacji innych. Połączenie takie wykorzystuje 4 krawędzie z których każda odpowiada osobnemu przypadkowi ewaluacji kolejnych zmiennych.

#set math.equation(numbering: "(1.)")

#let vars = (0,1,1,0,1,0)
    #figure(
    sdiagram(
      let finish = 5,
      let width = 6,
      for i in range(1, finish + 1) {
        let sleft = 0.8pt
        let sright = 0.8pt
        if vars.at(i) == 1 {
          sright = path
        } else {
          sleft = path
        }
        node((0, i), $n_(#i,1)$, name: "1" + str(i))
        edge("-|>", shift: 5pt, stroke:sright)
        edge("<|-", shift: -5pt, stroke:sleft)
        node((1, i), $n_(#i,2)$, name: "2" + str(i))
        edge("-|>", shift: 5pt, stroke:sright)
        edge("<|-", shift: -5pt, stroke:sleft)
        node((2, i), $n_(#i,3)$, name: "3" + str(i))
        node(
          align(left)[$X_#i$],
          enclose: ((-1, i), (2, i)),
          snap: -1,
          stroke: (paint: gray, thickness: 0.8pt, dash: "dashed"),
          shape: rect,
        )
      },
      for j in range(2, finish + 1) {
        let paths = (0.8pt,0.8pt,0.8pt,0.8pt)
        let choose = 2*vars.at(j) + vars.at(j -1)
        paths.at(choose) = path
        edge((name: "1" + str(j - 1)), (name: "1" + str(j)), "-|>", stroke:paths.at(2))
        edge(
          (name: "3" + str(j - 1), anchor: "south-west"),
          (name: "1" + str(j), anchor: "north-east"),
          "-|>",
          stroke:paths.at(3)
        )
        edge(
          (name: "1" + str(j - 1), anchor: "south-east"),
          (name: "3" + str(j), anchor: "north-west"),
          "-|>",
          stroke:paths.at(0)
        )
        edge((name: "3" + str(j - 1)), (name: "3" + str(j)), "-|>", stroke:paths.at(1))
      },

      let sleft = 0.8pt,
      let sright = 0.8pt,
      if vars.at(1) == 1 {
        sright = path
      } else {
        sleft = path
      },
      edge((0, 0), (0, 1), "-|>", dash: "dashed", stroke:sright),
      edge((0.75, 0), (0, 1), "-|>", dash: "dashed", stroke:sright),
      edge((1.25, 0), (2, 1), "-|>", dash: "dashed", stroke:sleft),
      edge((2, 0), (2, 1), "-|>", dash: "dashed", stroke:sleft),

      let sleft = 0.8pt,
      let sright = 0.8pt,
      if vars.at(finish) == 0 {
        sright = path
      } else {
        sleft = path
      },
      edge((0, finish), (0, finish + 1), "-|>", dash: "dashed", stroke:sright),
      edge((0, finish), (0.75, finish + 1), "-|>", dash: "dashed", stroke:sright),
      edge((2, finish), (1.25, finish + 1), "-|>", dash: "dashed", stroke:sleft),
      edge((2, finish), (2, finish + 1), "-|>", dash: "dashed", stroke:sleft),
    ),
    caption: [Zbliżenie na część przykładowego grafu ewaluacji z zaznaczonym Cyklem Hamiltona],
  )<przyklad>

Jak widzimy, taki graf ewaluacji posiada $2^n$ cykli Hamiltona gdzie każdy cykl odpowiada konkretnej ewaluacji zmiennych $x_i$, np. pokazany na @przyklad[Rysunku] cykl odpowiada następującej ewaluacji zmiennych:

$
  x_1 = bb(1) quad x_2 = bb(1) quad x_3 = bb(0) quad x_4 = bb(1) quad x_5 = bb(0) quad dots
$

  
=== Podgraf Klauzuli

Mając już strukturę emulującą zachowanie zmiennych, musimy zająć się następnie klauzulami. Szukamy podgrafu który w zachowaniu względem cyklu Hamiltona będzie równoważny do napisu $x and y and z$ tzn. szukamy podgrafu który stanie się częścią poprawnego cyklu wtedy i tylko wtedy gdy jedna z odpowiadających mu zmiennych w grafie ewaluacji otrzyma odpowiednią wartość. Podgraf taki można skonstruować w następujący sposób:

#figure(
  sdiagram(
    size: 100%,
    node([$n_1$], name: "n1"),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((1, 0), [$n_2$]),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((2, 0), [$n_3$]),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((3, 0), [$n_4$],),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((4, 0), [$n_5$]),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((5, 0), [$n_6$]),

    node((2.5, -0.8), [$w_1$]),
    node((2.5, 0.8), [$w_2$]),
    edge((2, 0), (2.5, -0.8), "-|>"),
    edge((3, 0), (2.5, -0.8), "<|-"),
    edge((3, 0), (2.5, 0.8), "-|>"),
    edge((2, 0), (2.5, 0.8), "<|-"),

    edge((0, -1), (0, 0), "-|>", dash: "dashed"),
    edge((1, -1), (0, 0), "-|>", dash: "dashed"),
    edge((5, -1), (5, 0), "-|>", dash: "dashed"),
    edge((4, -1), (5, 0), "-|>", dash: "dashed"),

    edge((0, 0), (0, 1), "-|>", dash: "dashed"),
    edge((0, 0), (1, 1), "-|>", dash: "dashed"),
    edge((5, 0), (5, 1), "-|>", dash: "dashed"),
    edge((5, 0), (4, 1), "-|>", dash: "dashed"),
  ),
  caption: [Podgraf zmiennej z podłączonym podgrafem klauzuli],
)<klauzula>

Jako podgraf klauzuli może posłużyć jeden z wierzchołków, podłączamy go "równolegle" do odpowiedniej krawędzi w podgrafie. Widzimy że może on zostać podłączony na kilka sposobów: w lewą stronę lub w prawą stronę, co definiuje jaka ewaluacja zmiennej powinna zaspokoić daną klauzulę. Na powyższym @klauzula[Rysunku] ewaluacja zmiennej na `true` zaspokaja klauzulę $V_1$ zaś ewaluacja zmiennej na `false` zaspokaja klauzulę $V_2$. 

Równolegle do jednej krawędzi mogą więc zostać podłączone co najwyżej 2 wierzchołki: jeden w prawo a drugi w lewo, w przeciwnym wypadku klauzule podłączone w tym samym kierunku mogły by się wzajemnie wykluczać. Podłączenie w prawo i w lewo z definicji się wyklucza więc może zostać wykonane na tej samej krawędzi

#figure(
  sdiagram(
    let leftp = path,
    let rightp = 1.2pt + green,
    size: 75%,
    node([$n_1$], name: "n1"),
    edge("-|>", shift: 5pt, stroke:rightp),
    edge("<|-", shift: -5pt, stroke:leftp),
    node((1, 0), [$n_2$]),
    edge("-|>", shift: 5pt, stroke:rightp),
    edge("<|-", shift: -5pt, stroke:leftp),
    node((2, 0), [$n_3$]),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((3, 0), [$n_4$],),
    edge("-|>", shift: 5pt, stroke:rightp),
    edge("<|-", shift: -5pt, stroke:leftp),
    node((4, 0), [$n_5$]),
    edge("-|>", shift: 5pt, stroke:rightp),
    edge("<|-", shift: -5pt, stroke:leftp),
    node((5, 0), [$n_6$]),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((6, 0), [$n_7$]),
    edge("-|>", shift: 5pt, stroke:rightp),
    edge("<|-", shift: -5pt, stroke:leftp),
    node((7, 0), [$n_8$]),
      edge("-|>", shift: 5pt, stroke:rightp),
    edge("<|-", shift: -5pt, stroke:leftp),
    node((8, 0), [$n_9$]),

    node((2.5, -0.8), [$w_1$]),
    node((2.5, 0.8), [$w_2$]),
    edge((2, 0), (2.5, -0.8), "-|>", stroke:rightp),
    edge((3, 0), (2.5, -0.8), "<|-", stroke:rightp),
    edge((3, 0), (2.5, 0.8), "-|>", stroke:leftp),
    edge((2, 0), (2.5, 0.8), "<|-", stroke:leftp),

    node((5.5, -0.8), [$w_3$]),
    node((5.5, 0.8), [$w_4$]),
    edge((5, 0), (5.5, -0.8), "-|>", stroke:rightp),
    edge((6, 0), (5.5, -0.8), "<|-", stroke:rightp),
    edge((5, 0), (5.5, 0.8), "-|>", stroke:leftp),
    edge((6, 0), (5.5, 0.8), "<|-", stroke:leftp),

    edge((0, -1), (0, 0), "-|>", dash: "dashed"),
    edge((1, -1), (0, 0), "-|>", dash: "dashed"),
    edge((8, -1), (8, 0), "-|>", dash: "dashed"),
    edge((7, -1), (8, 0), "-|>", dash: "dashed"),

    edge((0, 0), (0, 1), "-|>", dash: "dashed"),
    edge((0, 0), (1, 1), "-|>", dash: "dashed"),
    edge((8, 0), (8, 1), "-|>", dash: "dashed"),
    edge((8, 0), (7, 1), "-|>", dash: "dashed"),
  ),
  caption: [Możliwe podpięcia podgrafu klauzuli],
)

Użycie jednak tak prostej struktury jak jeden wierzchołek do naszego celu sprawia że pojawia się kilka problemów. Możliwe jest że cykl Hamiltona wejdzie do wierzchołka klauzuli z jednej zmiennej a wyjdzie do drugiej. W tym celu wstawiamy do podgrafu zmiennej, pomiędzy klauzulami oraz na końcu i początku dodatkowe wierzchołki pomocnicze, na @klauzula[rysunku] są to wierzchołki $n_2$ oraz $n_5$, dzięki temu cykl będzie zmuszony wrócić do tej samej zmiennej z której wyszedł bo w przeciwnym wypadku jakiś wierzchołek pomocniczy pozostanie poza cyklem, a jego odwiedzenie stanie się niemożliwe.

Ostatecznie więc w podgrafie zmiennej jedynie co 3 krawędź w łańcuchu może zostać wykorzystana do podłączenia klauzuli, co i tak jest rozwiązaniem dosyć optymalnym.

#figure(
  sdiagram(
    size: 90%,
    node([$n_(1,1)$], name: "n1"),
    edge("-|>", shift: 5pt, stroke:path),
    edge("<|-", shift: -5pt),
    node((1, 0), [$n_(1,2)$]),
    edge("-|>", shift: 5pt, stroke:path),
    edge("<|-", shift: -5pt),
    node((2, 0), [$n_(1,3)$]),
    edge("-|>", shift: 5pt, stroke:path),
    edge("<|-", shift: -5pt),
    node((3, 0), [$n_(1,4)$],),
    edge("-X-|>", shift: 5pt),
    edge("<|-X-", shift: -5pt),
    node((4, 0), [$n_(1,5)$], stroke:path),
    edge("-X-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((5, 0), [$n_(1,6)$]),

    node((2.5, 0.5), [$w_2$]),
    edge((3, 0), (2.5, 0.5), "-|>", stroke:path),
    edge((2, 0), (2.5, 0.5), "<|-"),

    edge((3, 1), (2.5, 0.5), "-|>"),
    edge((2, 1), (2.5, 0.5), "<|-", stroke:path),

    node((2.5, -0.5), [$w_1$]),
    node((2.5, 1.5), [$w_3$]),
    edge((2, 0), (2.5, -0.5), "-|>"),
    edge((3, 0), (2.5, -0.5), "<|-"),
    edge((3, 1), (2.5, 1.5), "<|-"),
    edge((2, 1), (2.5, 1.5), "-|>"),

    node((0, 1),[$n_(2,1)$], name: "n1"),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt, stroke:path),
    node((1, 1), [$n_(2,2)$]),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt, stroke:path),
    node((2, 1), [$n_(2,3)$]),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((3, 1), [$n_(2,4)$],),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((4, 1), [$n_(2,5)$]),
    edge("-|>", shift: 5pt),
    edge("<|-", shift: -5pt),
    node((5, 1), [$n_(2,6)$]),

    edge((0, -1), (0, 0), "-|>", dash: "dashed"),
    edge((1, -1), (0, 0), "-|>", dash: "dashed"),
    edge((5, -1), (5, 0), "-|>", dash: "dashed"),
    edge((4, -1), (5, 0), "-|>", dash: "dashed"),

    edge((0, 0), (0, 1), "-|>"),
    edge((0, 0), (0.5, 0.25), "-|" ),
    edge((5, 0), (5, 1), "-|>" ),
    edge((4.5, 0.75), (5, 1), "|-|>" ),
    edge((5, 0), (4.5, 0.25), "-|"),
    edge((0.5, 0.75), (0, 1), "|-|>"),

    edge((0, 1), (0, 2), "-|>", dash: "dashed"),
    edge((0, 1), (1, 2), "-|>", dash: "dashed"),
    edge((5, 1), (5, 2), "-|>", dash: "dashed"),
    edge((5, 1), (4, 2), "-|>", dash: "dashed"),
  
        node(
          align(left)[$X_1$],
          enclose: ((-1, 0), (5, 0)),
          snap: -1,
          stroke: (paint: gray, thickness: 0.8pt, dash: "dashed"),
          shape: rect,
        ),
      node(
          align(left)[$X_2$],
          enclose: ((-1, 1), (5, 1)),
          snap: -1,
          stroke: (paint: gray, thickness: 0.8pt, dash: "dashed"),
          shape: rect,
          layer:-2
        )
  ),
  caption: [Niepoprawny cykl Hamiltona skaczący po zmiennych],
)

Następnie wystarczy jedynie połączyć ze sobą poszczególne podgrafy i graf perfekcyjnie naśladował zachowanie tego problemu. Należy pamiętać jednak że każda klauzula podłączona jest do 3 zmiennych. Na przedstawionych rysunkach pominięto wiele krawędzi na potrzeby czytelności, w rzeczywistości jednak zawsze tam będą. Ilość wierzchołków w podgrafie zmiennej może być również różna - w zależności od potrzeb może zostać zwiększona.

#let omit = ((3,1),)

#let connect(start, end, road, type, strok) = {
  let first = (start.at(0)+0.5, start.at(1)+road)
  let second = (end.at(0)-0.5, start.at(1)+road)
  edge(vertices:(start,first,second,end), type, stroke:strok, crossing: true)
}

#figure(
    sdiagram(
      size:90%,
      let finish = 3,
      let width = 6,
      for i in range(1, finish + 1) {
        let sleft = 0.8pt
        let sright = 0.8pt
        if vars.at(i) == 1 {
          sright = path
        } else {
          sleft = path
        }

        for j in range(1,width) {
          node((j, i), $n_(#i,#j)$, name: str(j) + str(i))
          if not omit.contains((j,i)) {
            edge("-|>", shift: 5pt, stroke:sright)
            edge("<|-", shift: -5pt, stroke:sleft)
          } else {
            edge("-|>", shift: 5pt)
            edge("<|-", shift: -5pt)
          }
        }   
        node((width, i), $n_(#i,3)$, name: str(width) + str(i))
        node(
          align(left)[$X_#i$],
          enclose: ((-0, i), (width, i)),
          snap: -1,
          stroke: (paint: gray, thickness: 0.8pt, dash: "dashed"),
          shape: rect,
        )
      },
      for j in range(2, finish + 1) {
        let paths = (0.8pt,0.8pt,0.8pt,0.8pt)
        let choose = 2*vars.at(j) + vars.at(j -1)
        paths.at(choose) = path
        edge((name: "1" + str(j - 1)), (name: "1" + str(j)), "-|>", stroke:paths.at(2))
        edge(
          (name: str(width) + str(j - 1), anchor: "south-west"),
          (width -0.5, j -0.75),
          "-|",
          stroke:paths.at(3)
        )
        edge(
          (name: "1" + str(j - 1), anchor: "south-east"),
          (1.5,j -0.75),
          "-|",
          stroke:paths.at(0)
        )
        edge(
          (1.5,j -0.25),
          (name: "1" + str(j), anchor: "north-east"),
          "|-|>",
          stroke:paths.at(3)
        )
        edge(
          (width -0.5, j -0.25),
          (name: str(width) + str(j), anchor: "north-west"),
          "|-|>",
          stroke:paths.at(0)
        )

        // edge(
        //   (name: str(width) + str(j - 1), anchor: "south-west"),
        //   (name: "1" + str(j), anchor: "north-east"),
        //   "-|>",
        //   stroke:paths.at(3)
        // )
        // edge(
        //   (name: "1" + str(j - 1), anchor: "south-east"),
        //   (name: str(width) + str(j), anchor: "north-west"),
        //   "-|>",
        //   stroke:paths.at(0)
        // )
        
        edge((name: str(width) + str(j - 1)), (name: str(width) + str(j)), "-|>", stroke:paths.at(1))
      },

      let sleft = 0.8pt,
      let sright = 0.8pt,
      if vars.at(1) == 1 {
        sright = path
      } else {
        sleft = path
      },
      edge((1, 0), (1, 1), "-|>", dash: "dashed", stroke:sright),
      edge((1.75, 0), (1, 1), "-|>", dash: "dashed", stroke:sright),
      edge((width -0.75, 0), (width, 1), "-|>", dash: "dashed", stroke:sleft),
      edge((width, 0), (width, 1), "-|>", dash: "dashed", stroke:sleft),

      let sleft = 0.8pt,
      let sright = 0.8pt,
      if vars.at(finish) == 0 {
        sright = path
      } else {
        sleft = path
      },
      edge((1, finish), (1, finish + 1), "-|>", dash: "dashed", stroke:sright),
      edge((1, finish), (1.75, finish + 1), "-|>", dash: "dashed", stroke:sright),
      edge((width, finish), (width -0.75, finish + 1), "-|>", dash: "dashed", stroke:sleft),
      edge((width, finish), (width, finish + 1), "-|>", dash: "dashed", stroke:sleft),


      node((width +1, 2),$w_1$,name:"v1"),
      connect((3,1),(width +1, 2),-0.7, "-|>", path),
      connect((4,1),(width +1, 2),0.42, "<|-", path),
      connect((4,2),(width +1, 2),-0.42, "-|>", 0.8pt),
      connect((3,2),(width +1, 2),0.42, "<|-", 0.8pt),
      connect((3,3),(width +1, 2),-0.42, "-|>", 0.8pt),
      connect((4,3),(width +1, 2),0.7, "<|-", 0.8pt),

),
caption:[Część kompletnego grafu emulacji #sat3 z zaznaczonym cyklem Hamiltona]
)<3sat-ham>


Jak widzimy Cykl Hamiltona jeśli tylko może "ucieka" do podgrafu klauzuli tzn. odpowiednia ewaluacja zmiennej $x_j$ zaspokaja klauzulę $w_i$. Warto zauważyć również że cykl może uciec jedynie do podgrafu klauzuli który jest podłączony do podgrafu zmiennej w odpowiednim kierunku w przeciwnym wypadku cykl musiałby wrócić z podgrafu zmiennej do wierzchołka będącego już częścią cyklu.

Otrzymaliśmy więc prawidłowy graf emulujący za pomocą #ham problem #sat3, przykładową ewaluację #sat3 możemy zobaczyć na @3sat-ham[Rysunku]. 


= Projekt systemu odwzorowującego graf redukcji <proj>

== Założenia i cel projektu
Celem projektu jest stworzenie biblioteki programistycznej implementującej redukcje problemów NP-zupełnych.  Przy czym głównym zastosowaniem owych redukcji jest wykorzystanie algorytmu dla dowolnego problemu #np - zupełnego do rozwiązania innych problemów z grafu redukcji. Biblioteka powinna zapewniać jak najbardziej kompletną funkcjonalność aby stanowiła pomoc w możliwie wielu zastosowaniach i prezentowała dużą wartość dodaną. Oto kilka założeń jakie towarzyszyły nam podczas konstrukcji biblioteki:

+ *Idiomatyczność i Łatwość wykorzystania* - sposób użycia biblioteki powinien być na pierwszy rzut oka możliwie oczywisty dla sprawnego użytkownika, działanie elementów biblioteki powinno być logicznie podparte i nieskomplikowane, nazewnictwo powinno być intuicyjne i spójne 

+ *Wydajność* - wszystkie części biblioteki powinny być skonstruowane możliwie optymalnie, aby skrócić czas działania oraz możliwie zmniejszyć wzrost rozmiaru egzemplarza. Implementowane redukcje muszą działać w czasie wielomianowym, aby zachować przynależność do klasy #np.

+ *Spójność* - wszystkie elementy biblioteki powinny być wzajemnie spójne, powinny współdzielić sposoby ich wykorzystania, oraz odpowiednio ze sobą współgrać

+ *Kompatybilność* - ponieważ mamy do czynienia z zagadnieniami które nie są wysoce ustandaryzowanie, biblioteka musi być możliwie kompatybilna z dowolnymi wybranymi przypadkami uzycia, oraz stosować się do przyjętych standardów jeżeli tylko takie istnieją.

== Interfejsy wykorzystywane w systemie

W celu ujednolicenia operacji a co za tym idzie zwiększenia spójności, dostęp do funkcjonalności biblioteki zawarto w kilku interfejsach funkcyjnych. Odpowiadają one bezpośrednio algorytmom zdefiniowanym w @theory[Rozdziale].

- #smallcaps[Transform]$(I_P_1,P_2) -> I_P_2$ - transformacja (redukcja) egzemplarza problemu $P_1$ do egzemplarza problemu $P_2$, odpowiednik algorytmu $cal(T)_(P_1->P_2)$

- #smallcaps[Solve]$(I_P) -> {S_P,$ #nie$}$ - rozwiązanie zadanej instancji problemu, odpowiednik  $solve_P$, jest to funkcjonalność opcjonalna, biblioteka przewiduje dostarczenie tego algorytmu przez użytkownika

- #smallcaps[Extract]$(S_P_2,I_P_1) -> S_P_1$ - odpakowanie rozwiązania egzemplarza $I_P_2$ będącego wynikiem transformacji, do rozwiązania źródłowego egzemplarza $I_P_1$, odpowiednik algorytmu $cal(E)_(P_1->P_2)$

- #smallcaps[Construct]$(P_2,S_P_1,I_P_1) -> S_P_2$ - skonstruowanie rozwiązania dla egzemplarza $I_P_2$ będącego wynikiem transformacji, wykorzystując rozwiązanie źródłowego egzemplarza $I_P_1$, odpowiednik algorytmu $cal(C)_(P_1->P_2)$

- #smallcaps[Validate]$(S_X, I_X) -> {$#tak, #nie$}$ - sprawdzenie poprawności zadanego rozwiązania instancji problemu $X$, odpowiednik algorytmu $cal(V)_X$

Przedstawione interfejsy prezentują całość funkcjonalności biblioteki. Warto dodać że funkcja #smallcaps[Transform] poza operacją redukcji musi realizować odpowiednie zachowanie informacji o egzemplarzu źródłowym w celu ułatwienia późniejszej ekstrakcji rozwiązania, więcej w tym temacie opowiemy w  @algos[rozdziale].

== Implementacja grafu redukcji
Poniższy graf prezentuje problemy dla których zaimplementowano funkcjonalności, gdzie krawędź $P_1 -> P_2$ oznacza implementację wszystkich interfejsów dla danej pary problemów $P_1, P_2$.

#let node = fletcher.node

#figure(
  sdiagram(
    node((0,-1), sat),
    edge("<|-|>"),
    node((0,0), sat3),
    edge("s","-|>"),
    edge("se","-|>"),
    edge("sse","-|>", bend:15deg),
    edge("-|>"),
    
    node((-1,1), subs),
    edge((-0.3,4),"-|>"),
    edge("<|-|>"),
    
    node((-1,2.5), part),
    edge((-1,4),"-|>"),
    edge("-|>"),
    node((-0.3,4), knap, stroke:blue),

    node((-0,3), tsp, stroke:blue),
    
    node((-1,4), bin),
    
    node((0,1), ham),
    edge("s","-|>"),
    node((0,2), uham),
    edge("s","-|>"),
    
    node((1,1), cli),
    edge("s","<|-|>"),
    
    node((1,2), vc),
    edge("s","-|>"),
    node((1,3), hit),
  ),
  caption:[Graf redukcji zaimplementowany w bibliotece]
) <tree>

Warto zauważyć że dla niektórych problemów krawędzie biegną w obie strony, w tym wypadku transformacja zarówna jak i inne interfejsy dostępne są w obie strony.

Dla problemów bezpośrednio połączonych wykorzystywane są  zaimplementowane algorytmy, w systemie możliwa jest jednak transformacja wielokrotna o ile istnieje ścieżka pomiędzy zadanymi problemami. Wybór operacji jest określany na podstawie najkrótszej ścieżki pomiędzy problemami względem liczby krawędzi. W tym wypadku zalecane jest wykorzystanie interfejsów dla transformacji łańcuchowych:

- #smallcaps[Transform]$(I_P_1, P_n) = C_(1..n) = (I_P_1,I_P_2,dots,I_P_n)$ - transformacja (redukcja) egzemplarza problemu $P_1$ do egzemplarza problemu $P_2$ zwracająca ciąg egzemplarzy wszystkich pośrednich problemów.

- #smallcaps[Extract]$(S_P_n,C_(1..n)) = S_P_1$ - odpakowanie rozwiązania egzemplarza $I_P_n$ będącego wynikiem transformacji, do rozwiązania źródłowego egzemplarza $I_P_1$

- #smallcaps[Construct]$(S_P_1,C_(1..n)) = S_P_n$ - skonstruowanie rozwiązania dla egzemplarza $I_P_n$ będącego wynikiem transformacji, wykorzystując rozwiązanie źródłowego egzemplarza $I_P_1$,

Wykorzystanie łańcucha instancji $C_(1..n)$ jest wymagane dla interfejsów #smallcaps[Extract] i #smallcaps[Construct] ze względów implementacyjnych, co jest oczywiste jeśli spojrzymy na ich domyślne definicje.

== Możliwość rozbudowy o kolejne problemy

System został zaprojektowany zgodnie z zasadą otwartości na rozbudowę, ważną funkcjonalnością systemu jest rozszerzenie grafu transformacji przez użytkownika, poprzez dodanie kolejnych problemów i redukcji. Rozszerzenie takie będzie współgrać całkowicie z systemem, pod warunkiem przestrzegania przez użytkownika definicji interfejsów, o których było mowa powyżej.

Dostępne jest dodanie dowolnych problemów jako wierzchołków w grafie, oraz dowolnych transformacji jako krawędzi w grafie. Funkcjonalność ta będzie udostępniona użytkownikowi za pomocą funkcji  które należy wywołać. Sam graf redukcji jest natomiast zaimplementowany jako rzeczywista struktura danych, inicjowana statycznie w bibliotece, a wspomniane operacje rzeczywiście modyfikują ten graf.

Operacje realizujące transformacje łańcuchowe wykorzystują graf redukcji do znajdywania odpowiednich ścieżek, przez co jego odpowiednia struktura jest niezbędna dla ich działania

= Wybrane algorytmy redukcji <algos>

W tym rozdziale przedstawimy algorytmy realizujące wybrane, nietrywialne redukcje. Konstrukcja takiego algorytmu nie jest zazwyczaj wysoce skomplikowana, jeśli dobrze zrozumieliśmy proces redukcji. Wykorzystują one jednak pewną właściwość która może się wydać oczywista z programistycznego punktu widzenia, warto jednak o niej wspomnieć. Mowa tutaj o *numerowaniu* czyli przypisywaniu do jakichś obiektów liczb naturalnych. Formalnie możemy zapisać to w taki sposób $N : X -> NN$, dla dowolnego skończonego zbioru $X$. Numerowanie w komputerach jest powszechne i służy jako sposób identyfikacji obiektów, w szczególności w jakiejś strukturze danych. Wybór odpowiedniego numerowania w naszym wypadku jest o tyle ważny ponieważ pozwala on na odpowiednią identyfikację komponentów struktury egzemplarza danego problemu, co z kolei jest często niezbędne do ekstrakcji rozwiązania za pomocą algorytmu #extr. Dlatego właśnie często będziemy definiować specyficzne numerowanie dla egzemplarzy wynikowych algorytmu $cal(R)$ czego przykład możemy zobaczyć w @num_ex[Równaniu]

== Algorytm redukcji #sat3 do #vc

Algorytm jest dosyć elementarny i sam nasuwa się na myśl jeżeli zrozumieliśmy zasadę działania konwersji, wystarczy jedynie ustalić odpowiednie numerowanie wierzchołków aby ułatwić ich łączenie, wierzchołki numerujemy kolejnymi liczbami naturalnymi z przedziału $chevron 1 , 2n+3m chevron.r$ gdzie $n$ to ilość zmiennych a $m$ ilość klauzul.

$
numb(x_i) &= i \
numb(not x_i) &= n + i \
numb(u_(i,j)) &= 2n + 3i + j  \
$ <num_ex>

Numerowanie w tym wypadku oznacza uniklalne przyporządkowanie wierzchołkom liczb narutalnych, co jest bardzo naturalne jeśli rozważamy struktury komputerowe, jest to więc funckja róznowartościowa przyporządkowująca elementom liczby naturalne, przy czym implementacja komputerowa algorytmów wymaga aby była to funkcja "na" przedział liczb naturalnych rozpoczynający się od liczby 1.

// $
// num: V ->^(1-1) bb(N) \
// num[V] = angle.l 1,|V| angle.r inter bb(N) \
// // num(v) = j" - numer wierzchołka" v\
// v_i equiv num^(-1)(i) equiv v in V : num(v) = i\
// num(v_i) = i
// $

// Numerowanie jest to więc funckja róznowartościowa przyporządkowująca elementom liczby naturalne, przy czym implementacja komputerowa algorytmów wymaga aby była to funkcja "na" przedział liczb naturalnych rozboczynający się od liczby 1.

#figure(
  kind: "algorithm",
  supplement: [Algorytm],
  pseudocode-list(booktabs: true, numbered-title: [Redukcja #sat3 do #vc])[
  + *function* 3SAT-VertexCover$(W,n)$
    + $|V| = 2 dot n + 3dot|W|$ #comm[ustalamy zbiór wierzchołków]
    + $G=(V,E)$
    + *for* $i in 1 dots n$ #comm[dla każdej zmiennej]
        + $d<-n+i$
        + $E arrow.l (i,d)$ #comm[łączymy wierzchołek zmiennej z jej negacją]
    + *end*    
    + *for* $w in W$ #comm[dla każdej klauzuli]
      + $c arrow.l$ następny wolny wierzchołek z $V$
      + *for* $u in w$ #comm[dla zmiennych w klauzuli]
        + *if* u < 0 #comm[wybieramy odpowiednie miejsce w podgrafie zmiennych]
          + $d<-n+(-u)$  
        + *else*
          + $d<-u$   
        + *end*
        + $E arrow.l (c,d)$
    + *end*
    + $s <- n + 2dot|W|$
    + *return* ($G$,s)
  + *end*
]
)

Algorytm tworzy najpierw podgrafy zmiennych, a następnie podgrafy klauzul od razu łącząc je z odpowiednimi zmiennymi według przedstawionych wytycznych. Pozostaje nam jedynie zbadać jego złożoność obliczeniową, zawiera on następujące operacje.


  + $O(n)$ - pętla *for* tworząca podgrafy zmiennych
  + $O(m)$ - pętla *for* tworząca podgrafy klauzul

Co daje nam w sumie złożoność $O(n+m)$ a więc złożoność liniową. Jest więc to istotnie wielomianowa konwersja i może posłużyć jako dowód NP złożoności problemu #vc.


=== Odzyskanie rozwiązania

Odpakowanie rozwiązania oryginalnego problemu #sat3 jest bardzo łatwe, dzięki odpowiedniemu numerowaniu wierzchołków którego użyliśmy. Wystarczy jedynie sprawdzić dla wierzchołków $1dots n$  czy znajdują się one w zbiorze #vc.

#figure(
  kind: "algorithm",
  supplement: [Algorytm],
  pseudocode-list(booktabs: true, numbered-title: [Odzyskanie rozwiązania #sat3 z #vc])[
  + *function* Extract-VertexCover *begin*
    - *input:* $C,n$ #comm[zbiór #vc $C subset.eq V$, liczba zmiennych #sat3]

    - *output:* $A$ #comm[$A in {bb(0),bb(1)}^n$ ewaluacja zmienych dla #sat3]
    + $A = (fal, fal, dots, fal)$ #comm[tablica o długości $n$]
    + *for* $i in 1 dots n$
      + *if* $v_i in C$ 
        + $A[i] = tru$
      + *end*
    + *end* 
   + *return* $A$
  + *end*
]
)

Obecność w zbiorze #vc wierzchołka $v_i$ gdzie $i in chevron 1,n chevron.r$ oznacza ewaluację zmiennej $x_i$ na `true`, w p.p. jeśli nie ma tam tego wierzchołka, w zbiorze musi znajdować się wierzchołek $v_(n+i)$ a więc zmienna ewaluowana jest na `false`.

== Algorytm redukcji #sat3 do #subs
Aby skonstruować algorytm realizujący tą redukcję musimy ponownie ustalić odpowiednie numerowanie, w tym wypadku w zupełności wystarczy pierwsze numerowanie nasuwające się na myśl tzn: liczby o numerze nieparzystym to ewaluacje pozytywne a liczby o numerze parzystym to ewaluacje negatywne, liczby wypełniające z kolei umieszczamy na końcu. Ustawienie takie pozwala na łatwe odczytanie czy zmienna została ewaluowana pozytywnie poprzez sprawdzenie czy liczba o numerze odpowiadającym zmiennej znajduje się w podzbiorze. Numerowanie jest realizowane poprzez funkcje:

$
"variable"(x) &= cases(
  x > 0: 2x-1,
  x <= 0: -2x
) \

"clause"(x) &= 2n + 2x
$

Algorytm będzie się składał z 2 pętli, z których pierwsza będzie konstruowała liczby odpowiadające ewaluacjom zmiennych a także liczby wypełnieniowe, w drugiej pętli będziemy przypisywać odpowiednie klauzule do zmiennych.

Ponieważ operujemy na liczbach czwórkowych operacje na cyfrach okazują się być dosyć łatwe. Dzieje się tak ponieważ przez to że 4 jest potęgą 2 możemy operować bezpośrednio na bitach, zakładamy wtedy że każde 2 bity to jedna cyfra. Możemy przez to realizować bitowe operacje takie jak przesunięcie, z tą różnicą że przesuwamy o wartość dwukrotnie większą.

Przypisanie klauzuli do zmiennej osiągnięto poprzez dodanie odpowiedniej liczby wypełnieniowej do liczby zmiennej. Operacja oferuje prostszy sposób dla ustalania cyfry w danej liczbie i jest bardzo szybka, przy czym brak kolizji bitów sprawia że jest równoważna bitowej operacji `OR`.


#figure(
  kind: "algorithm",
  supplement: [Algorytm],
  pseudocode-list(booktabs: true, numbered-title: [Redukcja #sat3 do #subs])[
  + *function* SAT3-SubsetSum *begin*
    - *input:* $W, n$ #comm[klauzule i liczba zmiennych problemu #sat3]
    - *Output:* $S, t$ #comm[zbiór i docelowa suma problemu #subs]
    + *for* $i in 1dots (n+m-1) $
      + $c<-$ *if* $i <= 2n$ *then* 3 *else* 1
      + $S[2i-1], S[2i] <- c << 2i$
    + *end*
    + *for* $i in 1dots |W| $
      + *for* $x in W[i]$
        + $S["variable(x)"] <- S["clause"(i)] + S["variable(x)"]$
      + *end*
    + *end*
    + $t <- 333dots 3_4$ : liczba czwórkowa o długości $n+|W|$ cyfr
   + *return* $S,t$
  + *end*
]
)

Możemy łatwo pokazać że algorytm ten działa w czasie liniowym poprzez analizę jego części składowych, zakładamy że pozostałe niewymienione operacje są złożoności $O(1)$

+ $O(n+m)$ - Pętla konstrukcji liczb
+ $O(m)$ - Pętla przypisania klauzul do zmiennych
+ $O(n+m)$ - Konstrukcja liczby $t$

Co daje nam w sumie złożoność $O(n+m)$ a więc złożoność liniową. Ostatnią częścią redukcji jest pokazanie algorytmu ekstrakcji który dzięki odpowiedniemu numerowaniu jest dosyć elementarny.

#figure(
  kind: "algorithm",
  supplement: [Algorytm],
  pseudocode-list(booktabs: true, numbered-title: [Odzyskanie rozwiązania #sat3 z #subs])[
  + *function* Extract-SubsetSum *begin*
    - *input:* $S',n$ #comm[zbiór #subs $S' subset.eq S$, liczba zmiennych #sat3]

    - *output:* $A$ #comm[$A in {bb(0),bb(1)}^n$ ewaluacja zmienych dla #sat3]
    + $A = (fal, fal, dots, fal)$ #comm[tablica o długości $n$]
    + *for* $s in S'$ *where* $numb(s) <= n$
      + $A[numb(s)] = tru$
    + *end* 
   + *return* $A$
  + *end*
]
)

== Algorytm redukcji #sat3 do #ham

Istnieje kilka równoważnych metod redukcji #sat3 do #ham, w pracy rozważone zostały metody _Sudkampa_ @sudkamp_languages_2006, oraz metoda _Kleinberg-Tardos_ @kleinberg_algorithm_2006, aby wybrać najlepszą metodę zbadaliśmy optymalność redukcji pod względem rozmiaru wynikowego egzemplarza problemu.  Podczas gdy najbardziej popularna jest metoda K-T, metoda Sudkampa jest bardziej przejrzysta, pomimo że jest zdecydowanie mniej optymalna. Sudkamp w książce @sudkamp_languages_2006 proponuje sprytny podgraf klauzuli który dobrze emuluje tą logikę, podczas gdy w książce @kleinberg_algorithm_2006 jako podgraf klauzuli wykorzystany jest jeden wierzchołek, uproszczenie to wymaga jednak znaczących zmian w podgrafie zmiennej. Jako podgraf zmiennej Sudkamp używa zaś bardziej skomplikowanego grafu który trudniej będzie dynamicznie konstruować w algorytmie.

Wzory na ilość wierzchołków i krawędzi w grafie $G=(V,E)$ wyglądają następująco dla $m$-ilość klauzul, $n$-ilość zmiennych, a $U(i)$ to maksimum z liczby wystąpień $x_i$ i wystąpień $not x_i$
#v(5pt)
$
U(i) = max(|{w in u : x_i in w }|,|{w in u : not x_i in w}|) \
$
#v(5pt)
#figure(
  table(
  columns: (auto,auto,auto),
  inset: 10pt,
  align: center,
  [Metoda],[Liczba wierzchołków $|V|$],[Liczba krawędzi $|E|$],
  [Sudkamp],$6m+sum_(i=1)^(n) U(i) + 1$,$6m+9m +sum_(i=1)^(n) 4 + 2(U(i) + 1)$,
  [K-T],$m+sum_(i=1)^(n) 3 dot U(i) + 3$,$6m+sum_(i=1)^(n)4+2(3 dot U(i) + 3)$,
),
caption: [Wzory na liczbę wierzchołków i krawędzi w grafach]
)

Przeprowadziliśmy analizę wykresów ilości zmiennych dla worst i best case  które pokazują odpowiednio największe i najmniejsze ilości, oraz dla average case który został obliczony według benchmarkowych problemów #sat3 dostępnych w internecie. W tym przypadku worst-best case zależy od ilości unikalnych zmiennych w problemie gdzie best case to $|V_"best"| = 3$ (jedynie 3 różne zmienne w klauzulach) a worst case to $|V_"worst"| = 3x$ (każda zmienna w klauzuli jest inna). 

\
#figure(
  table(
  columns: (auto,auto,auto),
  inset: 10pt,
  align: center,
  [Case],[Liczba zmiennych $n$],[Liczba użyć zmiennej $x_i - U(i)$],
  [Best],$3$,$ceil(m/2)$,
  [Avg],$1/4m$,$~7.5$,
  [Worst],$3m$,$1$,
),
caption: [Wzory na liczbę wierzchołków i krawędzi w grafach]
)
\

#let x = lq.linspace(10, 10000)

#let vars = 4

#let avg = 7.5


Metoda Sudkampa w większym stopniu zależy od ilości klauzul a metoda K-T zależy bardziej od wielkości $U(i)$ sprawdzą się one więc w innych wypadkach. Zbadaliśmy więc jak wygląda typowy problem #sat3 i według udostępnionych w internecie przykładów występuje średnio 4 razy więcej klauzul niż zmiennych i średnia wartość $U(i) approx 7.5$ czego wpływ na wielkości grafu możemy zobaczyć na poniższych wykresach.
\


#show figure: set figure.caption(position: top)

#figure(
  lq.diagram(
  // title: [Ilość wierzchołków w grafie],
  xlabel: "Liczba klauzul", 
  ylabel: "Liczba wierzchołków",
  legend: (position: top + left),
  width:12cm,
  height:5cm,
  lq.plot(x, x.map(x => x + 3*x*(3+3)), mark:none, label:[K-T worst], color:rgb("#bbbbff")),
  lq.plot(x, x.map(x => 6*x + 3*x*(1+1)), mark:none, label:[Sud worst], color:rgb("#ffbbbb")),
  lq.plot(x, x.map(x => x + (x/vars)*(3*avg+3)), mark:none, label:[K-T avg], color:rgb("#6666ff")),
  lq.plot(x, x.map(x => 6*x + (x/vars)*(avg+1)), mark:none, label:[Sud avg], color:rgb("#ff6666") ),
  lq.plot(x, x.map(x => x + 3*(3*(x/2)+3)), mark:none, label:[K-T best], color:rgb("#0000ff") ),
  lq.plot(x, x.map(x => 6*x + 3*((x/2)+1)), mark:none, label:[Sud best], color:rgb("#ff0000")  ),
),
  caption:[Porównanie liczby wierzchołków dla metod redukcji],
  // kind: "chart",
  // supplement: [Wykres]
)
\

#figure(
  lq.diagram(
  // title: [Ilość krawędzi w grafie],
  xlabel: "Liczba klauzul", 
  ylabel: "Liczba krawędzi",
  legend: (position: top + left),
  width:12cm,
  height:5cm,
  lq.plot(x, x.map(x => 6*x + 0*x + 3*x*(4+2*(3+1))), mark:none, label:[K-T worst], color:rgb("#bbbbff")),
  lq.plot(x, x.map(x => 6*x + 9*x + 3*x*(4+2*(1+1))), mark:none, label:[Sud worst], color:rgb("#ffbbbb")),
  lq.plot(x, x.map(x => 6*x + 0*x + (x/vars)*(4+2*(3*avg+3))), mark:none, label:[K-T avg], color:rgb("#6666ff")),
  lq.plot(x, x.map(x => 6*x + 9*x + (x/vars)*(4+2*(avg+1))), mark:none, label:[Sud avg], color:rgb("#ff6666") ),
  lq.plot(x, x.map(x => 6*x + 0*x + 3*(4+2*(3*(x/2)+1))), mark:none, label:[K-T best], color:rgb("#0000ff") ),
  lq.plot(x, x.map(x => 6*x + 9*x + 3*(4+2*((x/2)+1))), mark:none, label:[Sud best], color:rgb("#ff0000") ),

),
  caption:[Porównanie liczby krawędzi dla metod redukcji],
  // kind: "chart",
  // supplement: [Wykres]
)

#show figure: set figure.caption(position: bottom)

Jak widzimy metoda K-T okazuje się być wyraźnie lepsza dla ilości wierzchołków i nieznacznie lepsza co do ilości krawędzi, wybrałem więc ostatecznie tą metodę i to ona jest przedstawiona w powyższym rozdziale.


 === Algorytm

Pozostało nam tylko skonstruować algorytm, co nie jest szczególnie skomplikowane. Przechodzimy w nim po klauzulach i stopniowo podłączamy je do odpowiednich zmiennych, dodając tam wierzchołki jeśli jest to wymagane, a na koniec łączymy ze sobą podgrafy zmiennych. Algorytm wykorzystuje funkcję `next_slot` która wybiera odpowiednie, wolne miejsce w podgrafie zmiennej do podłączenia klauzuli według opisanych wcześniej instrukcji. 

#figure(
  kind: "algorithm",
  supplement: [Algorytm],
  pseudocode-list(booktabs: true, numbered-title: [Redukcja #sat3 do #ham])[
  + *function* 3SAT-HamiltonianCircuit *begin*
    - *input:* $W, n$ #comm[klauzule i liczba zmiennych problemu #sat3]
    - *output:* $G$ #comm[graf dla którego będziemy szukać cyklu Hamiltona]
    + $V = [1 dots |W|+sum_(i=1)^(n) 3 dot U(i) + 3]$ #comm[ustalamy zbiór wierzchołków]
    + $G=(V,E)$ #comm[!! Rezerwujemy wierzchołki $1dots 2n$ na wierzchołki startowe $b$]
    + $P[1..n] = "Queue"{}$ #comm[kolejki wierzchołków w podgrafach zmienncyh]
    + $N[1..n] = "Queue"{}$ #comm[jak wyżej, tylko że dla negatywnego użycia zmiennej]
    + *for* $w in W$ #comm[dla każdej klauzuli]
      + $c arrow.l$ następny wolny wierzchołek z $V$
      + *for* $u in w$ #comm[dla zmiennych w klauzuli]
        + *if* u < 0 #comm[wybieramy odpowiednie miejsce w podgrafie zmiennych]
          + $(f,s) arrow.l "next_slot"(-u,N,P,S,G)$
        + *else*
          + $(s,f) arrow.l "next_slot"(u,P,N,S,G)$    
        + *end*
        + $E arrow.l (s arrow c), (c arrow f)$ #comm[podpinamy wierzchołek klauzuli do podgrafu zmiennej]
    + *end*
    + $b_l,e_l <-$ pierwszy i ostatni w. z ostatniego niepustego podgrafu zmiennej
    + *for* i = 1..n #comm[łączymy ze sobą podgrafy zmiennych]
      + $b <- V_i$
      + *if* length$(P[i])$ > 0
        + $e <- "last"(P[i])$    
        + $b_l,e_l <-$ pierwszy i ostatni w. z poprzedniego niepustego podgrafu zmiennej
        + $E <- (b_l->b),(b_l->e),(e_l->b),(e_l->e),$
      + *else*: usuń wierzchołki $V_i, V_(n+i)$ #comm[Zmienna nie jest użyta w żadnej klauzuli]
      + *end*
    + *end*
    + *return* $G$
  + *end*
]
)

#figure(
  kind: "algorithm",
  supplement: [Algorytm],
  pseudocode-list(booktabs: true, numbered-title: [Funkcja obsługi miejsc w podgrafie zmiennej])[
  + *function* next_slot *begin*
    - *input:*
      - $i,n$ #comm[Numer zmiennej, ilość wszystkich zmiennych]
      - $Q_1,Q_2,G$ #comm[Wybrana kolejka, pozostała kolejka, konstruowany graf]       
    - *output:* $(a,b)$ #comm[miejsce gdzie można podpiąć wierzchołek klauzuli]
    + $l <- "len"(Q_1)$
    + *if* $l = 0$ #comm[podgraf jest pusty]
      + $a <- i$ 
      + $b<-i+n$
      + $c <-$ następny wolny wierzchołek z $V$
      + $Q_1[i],Q_2[i] <- c$
      + $E <- (a<->b),(b<->c)$
    + *end*
  
    + *if* $l <= 3$ #comm[podgraf ma za mało wierzchołków]
      + $a,b,c <-$ trzy następne wolne wierzchołki z $V$
      + $Q_1[i] <- c$ #comm[w. $a$ zostanie od razu wykorzystany więc go nie dodajemy]
      + $Q_2[i] <- a,c$ #comm[wierzchołek $a$ i $c$ dodajemy do 2 kolejki]
      + $s <- Q_1[i]$
      + $E <- (s<->a),(a<->b),(b<->c)$
      + *return* $(s,a)$
    + *else* #comm[mamy wystarczającą ilość wierzchołków w kolejce]
      + $s, f <- Q_1[i]$    
      + *return* $(s,f)$      
    + *end*
  + *end*
]
)


Jak widać funkcja `next_slot` wybiera krawędź do której należy równolegle podłączyć wierzchołek klauzuli. Funkcja zachowuje odstępy pomiędzy klauzulami wstawiając odpowiednie wierzchołki pomocnicze i  wybierając co 3 wierzchołek.

Wolne miejsca w podgrafach zmiennych są przechowywane w kolejkach zawartych w tablicach $P$ i $N$ odpowiednio dla zwyczajnych i zanegowanych zmiennych. Użycie dwóch kolejek może się wydawać marnowaniem pamięci, jednak w rzeczywistości zawsze co najmniej jedna z nich będzie miała długość równą 1.

Jeśli zmienna nie została użyta w żadnej klauzuli odpowiadające jej kolejki są puste, usuwamy wtedy wierzchołek $b_i : numb(b_i) = i $ z grafu za pomocą metody `rem_vertex!()`, aby nie interferował w znajdowaniu cyklu. Zamienia ona wierzchołek $b$ z ostatnim wierzchołkiem w grafie a następnie go usuwa, mając przy tym złożoność $O(max(deg(b),deg(|V|))^2)$ co w naszym grafie gdzie $forall v in V deg(v) <= 6$ oznacza w gruncie rzeczy złożoność $O(1)$. Nie przesuwa ona więc numerowania wierzchołków a na miejscu wierzchołka `b` znajdzie się losowy wierzchołek o numerowaniu: $numb(v) >n$.

Pozostaje nam jedynie zbadać złożoność obliczeniową algorytmu, zawiera on operacje:

  + $O(m)$ - inicjalizacja zbioru wierzchołków z wykorzystaniem funkcji $U(i)$
  + $O(m)$ - pętla *for* łącząca podgrafy klauzul z podgrafami zmiennych
    + $O(1)$ - funkcja *next_slot* znajdująca odpowiednie miejsce do podłączenia
  + $O(n)$ - pętla *for* łącząca podgrafy zmiennych

Ponieważ pozostałe operacje są $O(1)$, daje nam to w sumie złożoność $O(n+m)$ a więc złożoność liniową. Jest więc to istotnie wielomianowa konwersja i może posłużyć jako dowód NP złożoności problemu #ham.

=== Odzyskanie rozwiązania
Kolejnym ważnym krokiem jest odzyskanie rozwiązania tzn. odczytanie rozwiązania oryginalnego problemu #sat3 na podstawie rozwiązania utworzonej instancji #ham.

Aby to zrobić musimy sprawdzić kierunek przejścia cyklu po podgrafach zmiennych co ułatwia nam fakt że ustaliliśmy numerowanie dla dwóch pierwszych wierzchołków w podgrafie zmiennej $x_i$ jako $numb(p_i) = i and numb(d_i) = n+i$, możemy dzięki temu sprawdzić czy w cyklu znajduje się krawędź $p_i->d_i$ a jeśli tak, cykl idzie w prawo a zmienna jest ewaluowana jako `true`, zaś w p.p. musi istnieć krawędź $d_i -> p_i$, cykl idzie w lewo a zmienna ewaluuje się jako `false`

#figure(
  kind: "algorithm",
  supplement: [Algorytm],
  pseudocode-list(booktabs: true, numbered-title: [Odzyskanie rozwiązania #sat3 z #ham])[
  + *function* Unpack-Hamiltonian *begin*
    - *input:* $C,n$ #comm[cykl Hamiltona $C subset.eq E$, liczba zmiennych #sat3]

    - *output:* $A$ #comm[$A in {bb(0),bb(1)}^n$ ewaluacja zmienych dla #sat3]
    + $A = [fal, fal, dots, fal]$ #comm[tablica o długości $n$]
    + *for* $(v,u) in C$
      + $i <- numb(v)$ #comm[numer wierzchołka $v$]
      + *if* $i <= n$ *and* $i + n = numb(u)$ #comm[jest to wierzchołek $p_i$ i cykl biegnie w prawo]
        + $A[i] = tru$ #comm[zmienna $x_i$ ewaluowana jest na `true`]
      + *end*
   + *end* 
   + *return* $A$
  + *end*
]
)

Jeśli któraś ze zmiennych $x_i$ nie była nigdy użyta w klauzuli, jej wierzchołki $p_i, d_i$ zostają usunięte a w ich miejsce umieszczamy inne wierzchołki nie będące wierzchołkami początkowymi. Sprawia to że ewaluacja tej zmiennej zostanie odczytana jako losowa, co nie ma jednak żadnego wpływu na poprawność rozwiązania ponieważ ewaluacja zmiennej $x_i$ nie ma znaczenia dla spełnienia klauzul.



== Wybrane metody rozwiązywania <models>

Tak jak wcześniej wspomnieliśmy w  rozwiązanie egzemplarza za pomocą algorytmu #solve odbywa się w znacznej większości poprzez redukcję do problemu #mip. Dlatego więc w tym podrozdziale wymienimy kilka modeli programowania całkowitoliczbowego które zostały wykorzystanie w bibliotece.

 W problemach #mip wymagane jest ustalenie funkcji celu którą będziemy minimalizować lub maksymalizować. Ponieważ jednak niektóre z omawianych problemów to problemy stricte decyzyjne, okazjonalnie jako funkcja celu została wykorzystana funkcja stała $f: X -> {1}$. W tym przypadku nie interesuje nas w ogóle jej wartość, szukamy jedynie wartości spełniających ograniczenia.

W innym wypadku, gdy mamy do czynienia z wersją decyzyjną problemu optymalizacyjnego, musimy zastosować ograniczenie funkcji celu, które zasadniczo jest również zwykłym ograniczeniem. Dla czytelności zapiszemy je jednak przy funkcji celu.

=== #uham

Do rozwiązywania problemów powiązanych z cyklem Hamiltona wykorzystano lekko zmodyfikowaną formulację problemu #tsp autorstwa _Dantzig-Fulkerson-Johnson_ @dantzig_solution_1954. W formulacji tej wykorzystujemy macierz zmiennych decyzyjnych, gdzie zmienna $x_(i j) = 1$ oznacza krawędź w cyklu biegnącą z wierzchołka $i$ do wierzchołka $j$. Przedstawia się ona w następujący sposób:

$
"min" quad &1 \
"przy ograniczeniach" quad & sum_(i=1,i!=j)^n x_(i j) = 1 & j = 1,dots,n \
& sum_(j=1,i!=j)^n x_(i j) = 1 & i = 1,dots,n \
& sum_(i in Q) sum_(j!=i, j in Q) x_(i j) <= |Q| - 1 quad & forall Q subset.neq {1,dots,n}, |Q| >=2 \

& x_(i j) in {0,1}, & i = 1, dots, n quad j = 1,dots,n   \
$<dfj>

Możemy jednak zauważyć że formulacja ta tworzy eksponencjalną liczbę ograniczeń (wszystkie podzbiory ${1,dots,n}$), dlatego ograniczenia te tworzymy dynamicznie. Przed-ostatnie ograniczenie na @dfj[równaniu] sprawia że nie możliwe jest wystąpienie rozwiązania złożonego z kilku mniejszych cykli, odpowiednie ograniczenie utworzymy więc dopiero gdy znajdziemy taki cykl w potencjalnym rozwiązaniu, podzbiorem $Q$ w tym wypadku będą wszystkie krawędzie w tym cyklu.

Z bardziej praktycznego punktu widzenia, funkcjonalność ta może być realizowana przez _solver-independent callbacks_ co jest rozwiązaniem szybszym (jeśli solver je obsługuje), lub dodanie ograniczeń do modelu i ponowne jego rozwiązanie.

=== #subs i pochodne

Formulacja modelu dla problemu #subs i pokrewnych, jest wyjątkowo łatwa, występuje w niej jednak unikatowy problem. Spójrzmy najpierw na model

$
"max" quad &1 \
"przy ograniczeniach" quad & sum_(i=i)^n s_i x_i = t quad &\
& x_i in {0,1}, quad & i = 1, dots, n  \
$

Jak widzimy jedynym ograniczeniem jest suma wybranego podzbioru. Problemem w tym wypadku są solvery które w większości wypadków operują na liczbach zmiennoprzecinkowych, najczęściej 64-bitowych. Powoduje to problem w wypadku gdy liczby w zbiorze $s_i in S$ są zbyt duże, co niestety jest bardzo częste dla egzemplarza wynikowego redukcji z problemu #sat3. W przypadku dużych liczb ich sumowanie może spowodować stratę dokładności a co za tym idzie niedokładny wynik. Testy pokazują że sytuacja ta może wystąpić już dla liczb 13 cyfrowych, jeśli tylko jest ich odpowiednio dużo. Najważniejszym wyznacznikiem wystąpienia tego problemu wydaje się być wielkość sumy wszystkich elementów ze zbioru $sum_(s in S) s$.

=== #cli

Sformułowanie modelu dla problemu kliki nie jest oczywiste, podejście naiwne w tym wypadku skutkuje modelem niepotrzebnie skomplikowanym. Dlatego spróbujemy zastosować mniej oczywiste podejście, wcześniej w @theory[rozdziale] wspomnieliśmy o bliskim związku problemu #cli z problemem #ind, co możemy wykorzystać. Okazuje się że model dla problemu zbioru niezależnego jest dosyć prosty, dlatego możemy go nieco zmodyfikować aby rozwiązywał problem #cli. Model ten został zaczerpnięty z pracy @seda_maximum_2023.

$
"max" quad &z = sum_(t = 1)^n x_t \
"przy ograniczeniach" quad & z >= k \
& x_t + x_j <= 1, quad & forall{v_t,v_j} in.not E\

& x_i in {0,1}, & i = 1, dots, n  \
$

Jak widać operujemy tu implicytnie na grafie dopełnionym, tzn. szukamy zbioru niezależnego w grafie $G^C = (V,E^C)$. Działanie tego modelu można streścić zdaniem: _jeżeli nie istnieje krawędź pomiędzy dwoma wierzchołkami, nie mogą oba jednocześnie należeć do kliki_. Zdanie to jest równoważne definicji problemu #cli.
 

=== #tsp
Problem komiwojażera jest jednym z najbardziej popularnych problemów z klasy #np, jest przedmiotem wielu rozważań, powstało także wiele algorytmów rozwiązujących go, a dodatkowo posiadamy również *Solvery* zajmujące się rozwiązywaniem tego problemu. Jednym z najlepszych solverów dostępnych w internecie jest solver #weblink("https://www.math.uwaterloo.ca/tsp/concorde.html")[*Concorde*], w dodatku jest on dostępny w języku Julia za pomocą biblioteki #weblink("https://github.com/chkwon/Concorde.jl")[*Concorde.jl*]. Solver ten został wykorzystany w bibliotece jako szybsza alternatywa dla modeli #mip. 

= Implementacja systemu

// W tym rozdziale przedstawimy szczegóły implementacyjne biblioteki. Będzie on koncentrował się na przekształceniu opisanej wyżej teorii na praktyczne programy.
== Wybór technologii i środowiska
Jako język programowania został wybrany język #weblink("https://julialang.org/")[Julia], jest to doskonałe narzędzie w szczególności skierowane do zastosowań matematycznych i obliczeń naukowych. Zawarty w nim dynamiczny system typów pozwala na tworzenie elastycznych i łatwych w użyciu systemów, jest on przy tym językiem kompilowanym, z szczególnym naciskiem na wydajność. Język Julia posiada również bogaty wybór bibliotek o zastosowaniach matematyczno-naukowych, następujące z nich zostały użyte w tym projekcie:

- #weblink("https://juliagraphs.org/Graphs.jl/v1.5/")[Graphs.jl] - bardzo szybka biblioteka dostarczająca implementacje grafów skierowanych i nieskierowanych, została wykorzystana jako podstawa reprezentacji problemów grafowych

- #weblink("https://github.com/JuliaCollections/Bijections.jl")[Bijections] - biblioteka oferująca dwukierunkową mapę, używana do translacji typów

- #weblink("https://github.com/JuliaCollections/DataStructures.jl")[DataStructures] - biblioteka oferująca różnorakie struktury danych, kolejka z tej biblioteki jest wykorzystywana w algorytmach redukcji

- #weblink("https://juliapackages.com/p/itertools")[IterTools] - biblioteka oferująca dodatkowe funkcjonalności w szybkim przetwarzaniu danych za pomocą iteratorów

W bibliotece wykorzystano jedną z nowych funkcjonalności języka, a mianowicie *extensions*, czyli rozszerzenia. Umożliwia ona dodanie opcjonalnych funkcjonalności w bibliotece, zależnych od innych zaimportowanych bibliotek. Ręczne zaimportowanie tych bibliotek umożliwia dostęp do dodatkowej funkcjonalności rozwiązywania odpowiednich problemów

- #weblink("https://jump.dev/JuMP.jl/stable/")[JuMP] - biblioteka do modelowania problemów programowania liniowego i całkowitoliczbowego, zapewniająca interfejs do wykorzystania solverów LP i MIP, została użyta do rozwiązywania problemów #mip, a co za tym idzie implementacji algorytmu #solve

- #weblink("https://github.com/chkwon/Concorde.jl")[Concorde.jl] - interfejs do nowoczesnego solvera dla problemu #tsp
== Hierarchia typów i metod

Podstawą biblioteki są typy abstrakcyjne reprezentujące abstrakcyjny egzemplarz problemu oraz abstrakcyjne rozwiązanie. Typy te są rodzicami wszystkich konkretnych typów i umożliwiają definiowanie współdzielonych funkcjonalności

```julia
abstract type NPProblem end
abstract type NPSolution end
struct CNFSAT <: NPProblem ...
```

W bibliotece zastosowano omówione wcześniej w @proj[rozdziale] interfejsy funkcyjne. W postaci ogólnej wyglądają one w następujący sposób:

#figure(
  table(
  columns: 3,
  align: horizon + left,
  table.header(
    [*Funkcja*], [*Argumenty*], [*Rezultat*],
  ),
  [`transform`],[`I::NPProblem` \ `P::Type{<:NPProblem}`], [`NPProblem`],
  [`solve`],[`model_IP` \ `I::NPProblem`], [`NPSolution` \ lub \ `nothing`],
  [`extract`],[`S::NPSolution` \ `I::NPProblem`], [`NPSolution`],
  [`validate`],[`S::NPSolution` \ `I::NPProblem`], [`bool`],
  [`construct`],[`P::Type{<:NPSolution}` \ `S::NPSolution` \ `I::NPProblem`], [`NPSolution`],
),
caption: [Abstrakcyjne interfejsy funkcyjne w bibliotece]
) <interfaces>

// #figure(
//   ```julia
// transform(I::NPProblem, P::Type{<:NPProblem}) -> NPProblem
//     solve(solver, I::NPProblem)               -> NPSolution
//   extract(S::NPSolution, I::NPProblem)        -> NPSolution
//  validate(S::NPSolution, I::NPProblem)        -> bool
// construct(P::Type{<:NPSolution}, S::NPSolution, I::NPProblem)-> NPSolution
// ```,
// supplement: [Schemat],
// caption: [Abstrakcyjne interfejsy funkcyjne w bibliotece]
// ) <interfaces>

 

W bibliotece wykorzystano funkcjonalność języka Julia o nazwie *multiple dispatch*. Pozwala ona na przypisanie do jednej funkcji o określonej nazwie, kilku implementacji zależnych od zadanych argumentów, owe osobne implementacje nazywamy *metodami*. W bibliotece każdy konkretny algorytm został zaimplementowany jako metoda dla odpowiedniej funkcji, przy czym te konkretne metody przyjmują również konkretne egzemplarze problemu.

```julia
function transform(sat3::SAT3, target::Type{VertexCover}) ...
```

Jeśli dla zadanych argumentów konkretna metoda nie istnieje, oznacza to że nie została zaimplementowana redukcja dla wybranych problemów.  Język stara się wtedy znaleźć metodę ogólniejszą, wykonywana wtedy jest metoda przyjmująca abstrakcyjne wersje problemów (taka jak przedstawiono na @interfaces[Schemacie]).

== Implementacja wybranych problemów NP-zupełnych

Każdy egzemplarz problemu reprezentowany jest przez strukturę, będącą podtypem abstrakcyjnego problemu `NPProblem`. Jako podstawa przechowywania danych została wykorzystana standardowa dla języka implementacja dynamicznej tablicy - `Vector`. Wszystkie definicje struktur zostały zawarte w pliku structures.jl. Poniżej przedstawimy i omówimy kilka wybranych implementacji.

W bibliotece zarówno liczby naturalne jak i liczby całkowite zapisujemy wykorzystując typ całkowity `Int`. Podejście unifikujące wszystkie typy całkowite jest zalecane dla języka Julia, eliminuje ono błędy powstałe na skutek niezgodności typów (w szczególności częste w bibliotece JuMP), i powoduje znikomy wpływ na zakres możliwych przechowycwanych wartości. Dodatkowo typ dodatnich liczb całkowitych `UInt` w języku Julia jest utożsamiany z niskopoziomowymi operacjami na bitach. Konwencja ta jest powszechna zarówno w języku jak i bibliotekach.

```julia
struct SAT3 <: NPProblem
    variable_count::Int
    clauses::Matrix{Int}
end
```

Dla problemu #sat3 struktura wygląda w sposób następujący, ponieważ nazwa typu w języku nie może zaczynać się od litery musiała ona zostać nieznacznie zmieniona. Nie określamy zbioru zmiennych, zamiast tego stosujemy uproszczenie: zmienne zaczynają się zawsze od $x_1$ i przechowujemy jedynie ich ilość, czyli `variable_count` $= n$. Klauzule zostały przedstawione jako macierz liczb całkowitych $M_(3 times m)$ gdzie $m$ to liczba klauzul. W macierzy dodatnia liczba całkowita $i$ oznacza użycie zmiennej $x_i$ a liczba $-i$ oznacza użycie negacji tej zmiennej $not x_i$, jest to standardowe podejście używane do zapisu problemów w bazach danych egzemplarzy #sat3 dostępnych w internecie. W ogólności zakładamy również że każda z zmiennych została użyta w klauzuli co najmniej raz, w przeciwnym wypadku niektóre z algorytmów mogą działać niepoprawnie.

```julia
struct CNFSAT <: NPProblem
    variable_count::Int
    clauses::Vector{Vector{Int}}
end
```

Dla problemu #sat długość klauzuli może być dowolna, dlatego musimy zaastosować inne podejście. Zestaw klauzul w tym wypadku zapisujemy jako tablice dynamicznych tablic, co pozwala na przechowywanie klauzul o dowolnej długości.

Dla problemów grafowych graf zapisujemy wykorzystując struktury z wcześniej wspomnianej biblioteki #weblink("https://juliagraphs.org/Graphs.jl/v1.5/")[Graphs.jl], poza tym przechowujemy wszystkie niezbędne parametry wspomniane w definicji problemu jako liczby całkowite.

```julia 
struct VertexCover <: NPProblem
    graph::SimpleGraph
    size::Int
end
```

Dla problemu #tsp graf pełny jest w domyśle i przechowujemy jedynie funkcję celu jako macierz o rozmiarze odpowiadającym macierzy incydencji grafu.

```julia
struct TSP <: NPProblem
    weights::Matrix{Int}
    length::Int
end
```

Dla problemów sum podzbiorów, powszechny jest bardzo duży rozmiar liczb składowych (w szczególności w algorytmach transformacji #tran), dlatego zdecydowaliśmy się na podejście generyczne umożliwiające użycie dowolnego typu całkowitego, na przykład standardowy typ liczb o zmiennej wielkości `BigInt`.

```julia
struct BinPacking{T<:Integer} <: NPProblem
    elements::Vector{T}
    bins::Int
    bin_size::T
end
```
Do oznaczania ilości jednak wykorzystano standardowy typ liczb całkowitych. Robimy tak ponieważ ze względu na ich znaczny wpływ na czas rozwiązywania, wartości te są zazwyczaj stosunkowo małe. Nawet dla maksymalnej dla typu `Int` liczby czas rozwiązywania wyniesie niewyobrażalnie długo. 

== Implementacje egzemplarzy rozwiązań
W następnej części omówimy wybrane implementacje struktur reprezentujących rozwiązania problemów.

Dla problemu #sat rozwiązanie zapisujemy za pomocą struktury `BitVector`, pozwala ona na efektywne zapisywanie wartości Bool'owskich w małym obszarze pamięci. Wykorzystuje ona liczby całkowite do zapisywania wartości zero-jedynkowych bezpośrednio do bitów pamięci.
```julia
struct CNFSATSolution <: NPSolution
    evaluation::BitVector
end
```

Do zapisu podzbiorów na przykład dla problemu #subs, wykorzystujemy strukturę zbioru. W tym przypadku w podzbiorze nie zapisujemy wartości samej liczby, a jedynie jej miejsce w tablicy, w odpowiadającym egzemplarzu problemu. Podejście takie jest bardziej efektywne pamięciowo i jest zgodne z interfejsami jakie ustaliliśmy.

```julia
struct SubsetSumSolution{S<:AbstractSet{Int}} <: NPSolution
    subset::S
end
```

Stosujemy tu ponownie podejście generyczne pozwalające na wybór implementacji zbioru, w zależności od wymagań użytkownika. Algorytmy ekstrakcji i konstrukcji zwracają jednak strukturę `BitSet` która w podobny sposób jak `BitVector` efektywnie zapisuje zbiory gęsto rozmieszczonych liczb całkowitych.

Dla problemów dotyczących cykli, sam cykl zapisujemy za pomocą tablicy gdzie oznaczamy krawędź wychodzącą z danego wierzchołka. To znaczy dla ciągu określającego cykl $(e_1,e_2,dots,e_n)$, wartośc $e_4 = 7$ oznacza że cykl z wierzchołka o numerze 4 przechodzi do wierzchołka o numerze 7.

```julia
struct HamCycleSolution <: NPSolution
    cycle::Vector{Int}
end
```

Istnieje kilka możliwych sposobów zapisywania drogi cyklu, wybrany został jednak sposób powyższy ze względu na stały czas dostępu przy weryfikacji dowolnej krawędzi w cyklu.

== Implementacja redukcji między problemami
Tak jak wspomniano, poszczególne algorytmy zaimplementowano jako metody funkcji `transform`. Wybór odpowiedniej metody zachodzi na podstawie typów argumentów zadanych w funkcji. Jeśli podano poprawną kombinację argumentów, a nie istnieje metoda odpowiadająca zadanym typom, następuje próba przeprowadzenia transformacji łańcuchowej.

Transformacja łańcuchowa służy do transformacji problemów nie połączonych bezpośrednio w grafie redukcji i zakończy się powodzeniem jedynie gdy istnieje odpowiednia ścieżka łącząca problemy w grafie redukcji. Uproszczona wersja wykorzystuje tą samą funkcję `transform` jak zwyczajna transformacja, jeśli jednak wymagane jest również użycie ekstrakcji lub konstrukcji rozwiązań wymagane jest użycie funkcji `chain_transform`.

```julia
chain_transform(I::NPProblem, P::Type{<:NPProblem})
chain_transform(I::NPProblem, C::Vector{Type{<:NPProblem}})
```

Funkcja ta zwraca ciąg wszystkich egzemplarzy problemów utworzonych podczas transformacji łańcuchowej. Przydatna jest ona również w wypadku gdy chcemy uzyskać jeden z problemów pośrednich. Możliwa jest również specyfikacja dokładnej ścieżki transformacji w grafie redukcji, za pomocą drugiej metody tej funkcji.


== Mechanizm konstrukcji i ekstrakcji rozwiązań

Przetwarzanie rozwiązań zaimplementowano, tak jak w przypadku transformacji, jako metody funkcji `extract` i `construct`. Metody te jednak wymagają więcej danych niż egzemplarz rozwiązania, zobacz @interfaces.

- metoda `extract` wymaga dodatkowych informacji o redukcji które są czerpane z źródłowego egzemplarza problemu
- metoda `construct` w strukturze bardzo przypomina algorytm transformacji, z tą różnicą że zamiast konstruować egzemplarz problemu, konstruuje jego rozwiązanie, dlatego jako argumenty potrzebne są zarówno źródłowy egzemplarz problemu jak i rozwiązanie. Dodatkowo musimy podać dla jakiego typu problemu konstruujemy rozwiązanie.

Tak samo jak w wypadku transformacji istnieje możliwość przetwarzania łańcuchowego, z tą różnicą że musimy podać kompletny łańcuch egzemplarzy pośrednich. Wymaganie to jest oczywiste jeśli spojrzymy na zwyczajne interfejsy, a jego ominięcie wymagało by przeprowadzenia redundantnych transformacji.

```julia
  extract(S::NPSolution, C::Vector{NPProblem})
construct(S::NPSolution, C::Vector{NPProblem})
```

W bibliotece zawarto również uproszczone metody realizujące te funkcjonalności bez dostarczania łańcucha egzemplarzy, ich używanie nie jest jednak zalecane z powodu niepotrzebnego powtarzania transformacji egzemplarzy problemów.

== Przykłady działania systemu

W tym rozdziale przedstawimy przykładowy przypadek użycia biblioteki, zarówno funkcji zwyczajnych jak i łańcuchowych, do rozwiązywania wybranych problemów. Zakładamy że posiadamy własny algorytm `my_solve` rozwiązujący problem #vc. Pierwszym krokiem będzie zaimportowanie egzemplarza problemu #sat3, biblioteka umożliwia wczytanie takowego z pliku w formacie `.cnf` lub ręczne utworzenie struktury z wykorzystaniem odpowiednich danych.

#codly(inset: (top: 4pt, bottom: 4pt))

```julia
instance = SAT3("my_inst.cnf") # importujemy egzemplarz
res_inst = transform(instance, VertexCover) # dokonujemy transformacji
red_sol = my_solve(reduced) # rozwiązujemy egzemplarz wynikowy
solution = extract(red_sol, instance) # odpakowywujemy rozwiązanie
@assert validate(solution, instance) # weryfikujemy rozwiązanie
```

Jeśli posiadamy rozwiązanie dla problemu źródłowego możemy użyć funkcji `construct`  aby uzyskać rozwiązanie dla egzemplarza wynikowego redukcji, w następujący sposób.

```julia
instance = SAT3("solved_inst.cnf")
res_inst = transform(instance, HamCycle)
parent_sol = SAT3Solution([1,1,0,1,0,0,1,1,1])
@assert validate(parent_sol, instance)
solution = construct(HamCycleSolution, solution, instance)
@assert validate(solution, res_inst)
```
#pagebreak()
Natomiast wykorzystanie transformacji łańcuchowej wygląda w następujący sposób:

```julia
instance = SAT3("my_inst.cnf")
chain = chain_transform(instance, Knapsack) # funkcja zwracająca łańcuch
parent_sol = my_solve(last(chain))
solution = extract(parent_sol, chain)
@assert validate(solution, instance)
```

Możliwe jest również dokładne ustalenie ścieżki transformacji

```julia
instance = SAT3("my_inst.cnf")
path = [Clique, VertexCover, HittingSet] # ustalona ścieżka redukcji
chain = chain_transform(instance, path) # zwracamy łańcuch
res_inst = transform(instance, path) # lub jedynie wynikowy egzemplarz
@assert last(chain) == res_inst
```


= Testy i analiza działania <tests>

W poniższym rozdziale przedstawimy testy poprawności oraz wydajności biblioteki

== Weryfikacja poprawności implementacji

Poprawność implementacji biblioteki jest testowana na bieżąco za pomocą testów jednostkowych, które w języku julia pomaga realizować standardowa biblioteka #weblink("https://docs.julialang.org/en/v1/stdlib/Test/")[Test]. Testy wykonywane są dla następujących przypadków użycia

+ Wykorzystanie wszystkich interfejsów dla każdej z zaimplementowanych redukcji (patrz @tree)
+ Wykorzystanie funkcji łańcuchowych
+ Rozszerzenie biblioteki o własne problemy i redukcje

Testy jednostkowe można wywołać w bibliotece za pomocą następującego ciągu komend konsolowych, wywoływanych w folderze kodu źródłowego biblioteki

#codly(inset: (top: 2pt, bottom: 2pt))

```
../Conplete.jl> julia --project
julia> ]
(Conplete) pkg> test
  Testing Conplete
```

Aby wywołać testy należy przejść z konsoli `REPL` języka Julia do menadżera pakietów co realizowane jest za pomocą klawisza `]`. Testy jednostkowe zostały umieszczone w pod-module biblioteki w folderze `/test` w pliku `testitems.jl`.


== Analiza złożoności obliczeniowej operacji redukcji

Aby zaprezentować szybkość operacji redukcji oraz wpływ na zasoby komputera zaprezentujemy wyniki testów wydajnościowych dla wybranych transformacji. Testy wydajnościowe zostały przeprowadzone przy pomocy biblioteki #weblink("https://juliaci.github.io/BenchmarkTools.jl/stable/")[BenchmarkTools] służącej właśnie do pomiaru wydajności programów w tym języku. Dodatkowo do operacji statystycznych wykorzystano standardową bibliotekę #weblink("https://docs.julialang.org/en/v1/stdlib/Statistics/")[Statistics]. Skrypty realizujące testy wydajnościowe możemy znaleźć w folderze `/research_scripts` w repozytorium kodu źródłowego biblioteki


#pagebreak()
Parametry komputera na którym zostały przeprowadzone testy to:

#figure(
  table(
    columns: 2,
    [*System*], [Windows 11 Pro 64-bit],
    [*CPU*], [AMD Ryzen 7 7700],
    [*Pamięć RAM*], [32GB Dual-Channel DDR5 6000MHz]
  ),
  caption: [Parametry komputera na którym przeprowadzono testy]
)

#let names = (
  DirHamCycle : link(<ham>,smallcaps[Directed-Ham-Cycle]),
  HamCycle : [#uham],
  TSP : [#tsp],
  Clique : [#cli],
  VertexCover : [#vc],
  HittingSet : [#hit],
  SAT3 : [#sat3],
  "HittingSet{Set{Int64}}" : [#hit],
  SubsetSum : [#subs],
  CNFSAT : [#sat],
)

#set-round(
  mode:       "places",
  precision:  3,
  pad:        false,
  direction:  "nearest",
)

Pierwszymi wynikami jakie zaprezentujemy będą pomiary transformacji z problemu #sat3, transformacje te są jednymi z najbardziej zaawansowanych w zakresie całej biblioteki. Danymi wejściowymi dla pomiarów są jednorodnie losowe egzemplarze #sat3 pozyskane ze strony #weblink("https://www.cs.ubc.ca/~hoos/SATLIB/benchm.html")[SATLIB] o rozmiarze 250 zmiennych i 1065 klauzul. Poniższe tabele prezentują średnie arytmetyczne z testów dla kilkunastu różnych danych wejściowych po 30 wykonań dla jednej danej.
@mem prezentuje pomiary wykorzystania pamięci dla algorytmów transformacji.

#let mjson = json("test_data/trans_pro/cli20251128_00-44-21.226.json")

#let (xses, times, gctimes, memory, allocs, stds, vcs ) = mjson

#let x = mjson.values()

#figure(
  ztable(
  columns: 4,
  align: (left, right, right, right, right),
  format: (none, auto, auto, auto, auto),
  table.header(
    [*Transformacja do \ problemu*],  [*Czas Garbage \ Collectora *], [*Wykorzystana \ pamięć*], [*Alokacje*]
  ),
  ..for x in unzip(x) {(
    [#names.at(x.first())], [#(x.at(2)/1e6)#nonum[ ms]], [#(x.at(3)/1e6)#nonum[ MiB]], [#x.at(4)],
  )}
),
caption: [Średnie koszty pamięciowe poszczególnych redukcji]
) <mem>

W @mem[tabeli] możemy zobaczyć że algorytmy nie wywołują praktycznie Garbage Collector'a oznacza to że nie jest alokowana żadna zbędna pamięć, która musi zostać następnie zwolniona.

#let scale = 1e3

#figure(
  ztable(
  columns: 4,
  align: (left, right, right, right),
  format: (none, auto, auto, auto),
  table.header(
    [*Transformacja do \ problemu*], [*Czas działania*], [*Odchylenie \ standardowe *], [*Współczynnik \ zmienności*]
  ),
  ..for x in unzip(x) {(
    [#names.at(x.first())], [#(x.at(1)/scale)#nonum[ #sym.mu\s]], [#(x.at(5)/scale)#nonum[ #sym.mu\s]], [#(x.at(6))],
  )}
),
caption: [Średnie koszty czasowe poszczególnych redukcji]
) <times>

W @times[tabeli] przedstawiono średnie czasy działania algorytmów wraz z odchyleniem standardowym oraz współczynnikiem zmienności. Pokazuje nam to że zmiana czasu działania w zależności od danych wejściowych (dla danych o tym samym rozmiarze) jest znikoma - współczynnik zmienności wyniósł $<=5%$. Możemy również zobaczyć że trywialna redukcja $sat3 -> sat$ zajmuje stosunkowo mało czasu a redukcja do problemu #cli której wynikiem jest graf bliski pełnemu, zajmuje stosunkowo dużo czasu i pamięci z powodu $O(n^2)$ czasu konstrukcji takiego grafu, w porównaniu do liniowego czasu $O(n)$ działania większości innych algorytmów.

Teoretyczna analiza algorytmów pokazuje nam że redukcje działają w czasie wielomianowym, postaramy się jednak pokazać rzeczywiste dane popierające te wyniki. Testy przeprowadzono dla jednostajnie losowych egzemplarzy #sat3 z bazy danych SATLIB o rozmiarze 20-250 zmiennych.

#let cliq = json("test_data/trans_n/cli_Clique20251124_00-42-00.856.json")
#let subset = json("test_data/trans_n/bin_SubsetSum20251124_00-42-52.105.json")
#let hailton = json("test_data/trans_n/ham_DirHamCycle20251124_00-43-55.546.json")
#let vertex = json("test_data/trans_n/hit_VertexCover20251124_00-42-13.784.json")

#let scale = 1e6
#let satrange = (20,50,75,100,125,150,175,200,225,250)

#figure(
  lq.diagram(
  width: 12cm,
  height: 6cm,
  xlabel:"Rozmiar danych",
  ylabel:[Czas transformacji w ms],
  legend: (position: left + top),
  // yscale:"log",
  // lq.plot(
  //   (20,50,75,100,125,150,175,200,225,250),
  //   cliq.times.map(x => x/scale),
  // ),
  lq.plot(
    satrange,
    subset.times.map(x => x/scale),
    label: [#subs]
  ),
  lq.plot(
    satrange,
    hailton.times.map(x => x/scale),
    label: [#names.at("DirHamCycle")]
  ),
  lq.plot(
    satrange,
    vertex.times.map(x => x/scale),
    label: [#vc]
  ),
),
caption: [Wzrost czasu transformacji przy wzroście rozmiaru danych]
) <w18>

Na @w18[wykresie] możemy zobaczyć przewidywany liniowy wzrost czasu wykonywania, oraz różnice w szybkości pomiędzy algorytmami. Na @w19[wykresie] natomiast możemy zobaczyć kwadratowy wzrost czasu dla transformacji do problemu #cli.

#figure(
  lq.diagram(
  width: 12cm,
  height: 6cm,
  xlabel:"Rozmiar danych",
  ylabel:[Czas transformacji w ms],
  legend: (position: left + top),
  // yscale:"log",
  lq.plot(
    satrange,
    cliq.times.map(x => x/scale),
    label: [#cli]
  ),
  lq.plot(
    satrange,
    satrange.map(x=>(x*x)/1300),
    color: luma(210),
    label: $1/1200 x^2$
  ),
),
caption: [Wzrost czasu transformacji dla problemu #cli]
) <w19>

Testy potwierdzają więc wielomianowy czas działania algorytmów, oraz pokazują ich dosyć szybkie działanie a także niewielkie zużycie pamięci.

// #figure(
//   lq.diagram(
//   width: 10cm,
//   height: 6cm,
//   xaxis: (
//     ticks: xses
//       .map(rotate.with(-45deg, reflow: true))
//       .map(align.with(right))
//       .enumerate(),
//     subticks: none,
//   ),
//   yaxis: (
//     scale: "log",
//     lim: (calc.pow(10,0), calc.pow(10,3)),
//   ),
//   lq.bar(
//     range(5),
//     times.map(x => x / 1e6),
//     base: 1,
//     // yerr: stds.map(x => x / 1e6),
//   )
// )
// )

#pagebreak()

== Wpływ redukcji na szybkość rozwiązania problemu

Z powodu różnej specyfiki badanych problemów trudno pokazać wpływ transformacji na rozmiar danych. Aby jednak zobrazować ten wpływ w pewien sposób, pokażemy wpływ transformacji na czas rozwiązywania problemu. Do rozwiązywania wykorzystano wspomniane w @models[rozdziale] modele programowania całkowitoliczbowego oraz solver *IBM CPLEX* @noauthor_ibm_2025 w wersji 22.1.2

W ogólności przewidywany czas działania dla solvera jest eksponencjalny, testy pokazują jednak doskonałą wydajność rozwiązywania problemów #rsat. Na @satres[wykresie] możemy zobaczyć niemal liniowy stosunek czasu działania do rozmiaru danych, co pokazuje doskonałą technologię współczesnych solverów.



#let (xses, times, gctimes, memory, allocs ) = json("test_data/sol_n/sat_SAT320251123_20-59-35.368.json")
// #let (xses, times, gctimes, memory, allocs ) = json("test_data/sol_n/sat_SAT320251124_06-14-39.158.json")

#figure(
  lq.diagram(
  width: 12cm,
  height: 6cm,
  xlabel:"Rozmiar danych",
  ylabel:[Czas rozwiązania w ms],
  // yscale:"log",
  lq.plot(
    (20,50,75,100,125,150,175,225,250),
    times.map(x => x/1000000),
  )
),
caption: [Czas rozwiązywania #sat3 w stosunku do rozmiaru danych wejściowych]
) <satres>

#let satd = json("test_data/sol_n/hit_SAT320251124_00-35-15.158.json")
#let vcd = json("test_data/sol_n/hit_VertexCover20251124_00-35-15.530.json")
#let hitd = json("test_data/sol_n/hit_HittingSet20251124_00-35-15.532.json")


#figure(
  lq.diagram(
  width: 12cm,
  height: 6cm,
  legend: (position: left + top),
  xlabel:"Rozmiar danych",
  ylabel:[Czas rozwiązania w ms],
  yscale:"log",
  lq.plot(
    (20,50,75,100,125,150,175),
    satd.times.map(x => x/1000000),
    label: [#sat3],
  ),
  lq.plot(
    (20,50,75,100,125,150,175),
    vcd.times.map(x => x/1000000),
    label: [#vc],
  ),
  lq.plot(
    (20,50,75,100,125,150,175),
    hitd.times.map(x => x/1000000),
    label: [#hit],
  ),
),
caption: [Czas rozwiązywania problemów w stosunku do rozmiaru danych wejściowych]
) <asd21>

W przypadku bardziej złożonych problemów czas działania okazuje się jednak być eksponencjalny. Na @asd21[wykresie] możemy zobaczyć czasy działania dla problemów #vc and #hit przedstawione w skali logarytmicznej. 

Testy wydają się pokazywać wzrost czasu działania dla konkretnego rozmiaru danych, na @asd21[wykresie] możemy zaobserwować gwałtowny wzrost czasu działania dla rozmiaru $x = 125$, bliższe zbadanie tego fenomenu zdaje się wykluczać czynniki zewnętrzne a jego dokładny powód nie jest znany.

Następna grupa wykresów porównuje czasy rozwiązywania tego samego egzemplarza #sat3 przed i po kolejnych transformacjach. Wykresy odpowiadają wybranym ścieżki transformacji problemów w grafie redukcji. Na @asd22[wykresie] możemy zobaczyć znaczny wzrost czasu rozwiązania po transformacji do #cli następne transformacje nie mają jednak znacznego wpływu. Dzieje się tak ponieważ dalsze transformacje  to operacje dużo prostsze w porównaniu do tej pierwszej.

#let data = json("test_data/sol_pro/cli20251124_05-49-18.803.json")
#let data2 = json("test_data/sol_pro/hit20251124_05-50-33.409.json")

#figure(
  lq.diagram(
  width: 10cm,
  height: 5cm,
  ylabel:[Czas rozwiązania w ms],
  yscale:"log",
  xaxis: (
    ticks: data.xses.map(x => names.at(x))
      .map(rotate.with(-30deg, reflow: true))
      .map(align.with(right))
      .enumerate(),
    subticks: none,
  ),
  lq.bar(
    (0,1,2,3),
    data.times.map(x => x/1000000),
    base: 1,
    z-index:1,
  ),
  lq.bar(
  (0,2,3),
  data2.times.map(x => x/1000000),
  offset:0.1,
  base: 1,
  z-index:2,
  ),
),
caption: [Wpływ redukcji na czas rozwiązywania problemu]
) <asd22>

Kolorem pomarańczowym zaznaczono alternatywną ścieżkę pomijającą problem #cli, to znaczy transformujemy #sat3 od razu do #vc. Okazuje się że powoduje to znaczący wzrost szybkości rozwiązywania (wykres jest w skali logarytmicznej). Powinna więc być to preferowana metoda redukcji dla tych problemów.

#let data = json("test_data/sol_pro/ham20251129_02-00-47.022.json")

#figure(
  lq.diagram(
  width: 10cm,
  height: 5cm,
  ylabel:[Czas rozwiązania w ms],
  yscale:"log",
  xaxis: (
    ticks: data.xses.map(x => names.at(x))
      .map(rotate.with(-30deg, reflow: true))
      // .map(move.with(dx: -20pt))
      .map(align.with(right))
      .enumerate()
      .map(x => if x.at(0) != 0 {(x.at(0),move(dx:-25pt)[#x.at(1)])} else {x}),
    subticks: none,
  ),
  lq.bar(
    (0,1,2,3),
    data.times.map(x => x/1000000),
    base: 1,
    z-index:1,
  ),
),
caption: [Wpływ redukcji na czas rozwiązywania problemu]
) <asd23>

Kolejny z wykresów (@asd23) prezentuje zmiany czasów rozwiązywania dla problemów cykli w grafie możemy tutaj zaobserwować znaczny wzrost czasu dla kolejnych redukcji, oraz spadek czasu dla problemu #tsp. Pokazuje to znaczny wpływ na rozmiar danych, w szczególności redukcja do #uham która potraja liczbę wierzchołków w grafie.
Spadek czasu dla ostatniego problemu jest natomiast spowodowany użyciem zewnętrznego solvera *Concorde* dla tego problemu.

Testy w gruncie rzeczy potwierdzają więc przewidywania z którymi rozpoczęliśmy: transformacje mają wielomianowy, najczęściej liniowy lub stały, wpływ na rozmiar danych który jednak powoduje eksponencjalne różnice czasów rozwiązywania.


#heading(numbering: none, supplement: none)[Podsumowanie i wnioski]

Celem niniejszej pracy było zaprojektowanie i zaimplementowanie biblioteki redukcji problemów klasy NP w języku Julia, umożliwiającej transformację instancji, a także konstrukcję i ekstrakcję rozwiązań.Cel ten został w pełni zrealizowany poprzez stworzenie systemu obsługującego graf redukcji obejmujący kluczowe problemy NP-zupełne, takie jak #sat, #sat3, #cli, #vc, #uham, czy zagadnienia typu #subs.

W toku prac przeprowadzono analizę teoretyczną i implementacyjną wybranych redukcji. Szczególną uwagę poświęcono optymalizacji rozmiaru instancji wynikowych. W przypadku redukcji problemu 3-SAT do problemu cyklu Hamiltona w grafie skierowanym (#ham) przeprowadzono analizę porównawczą metod Sudkampa oraz Kleinberg-Tardos. Ostatecznie, ze względu na generowanie mniejszej liczby wierzchołków i krawędzi w grafie wynikowym, do implementacji wybrano metodę Kleinberg-Tardos. Zaimplementowano również mechanizmy rozwiązywania problemów (algorytm #solve) oparte głównie na redukcji do programowania całkowitoliczbowego (#mip) z wykorzystaniem solverów MIP oraz dedykowanego solvera Concorde dla problemu komiwojażera.

Przeprowadzone testy i analiza działania systemu (@tests) pozwoliły na sformułowanie następujących wniosków:

+ *Złożoność redukcji*: Zaimplementowane algorytmy transformacji działają w czasie wielomianowym, najczęściej liniowym $O(n+m)$ lub – w przypadku problemu #cli – kwadratowym, co jest zgodne z założeniami teoretycznymi dla klasy #np.

+ *Koszt redukcji*: Choć sama transformacja jest procesem szybkim, jej wpływ na czas rozwiązywania instancji wynikowej jest znaczący. Redukcje zazwyczaj zwiększają rozmiar instancji, co prowadzi do wykładniczego wzrostu czasu potrzebnego na znalezienie rozwiązania przez solver. Zaobserwowano, że bezpośrednie ścieżki redukcji są bardziej efektywne niż ścieżki wieloetapowe.

+ *Stabilność numeryczna*: W przypadku problemów sum podzbiorów (SUBSET-SUM) zidentyfikowano potencjalne problemy z dokładnością operacji zmiennoprzecinkowych w solverach przy bardzo dużych liczbach.

Stworzona biblioteka charakteryzuje się idiomatycznością, spójnością interfejsów oraz otwartością na rozbudowę o kolejne problemy i redukcje przez użytkownika. Wykorzystanie mechanizmu multiple dispatch języka Julia pozwoliło na elastyczne zarządzanie metodami transformacji. System stanowi kompletne narzędzie prezentujące w praktyce teoretyczne zależności między trudnymi problemami obliczeniowymi, realizując założenia postawione we wstępie pracy.

#heading(numbering: none, supplement: none)[Dodatek A - pliki źródłowe i wykorzystane narzędzia]

Pliki źródłowe biblioteki, dokumentu pracy oraz strony z dokumentacją możemy znaleźć w repozytorium Git pod adresem:

#let qrlink(addr) = figure(
  outlined: false,
  table(
  stroke: none,
  columns: (1fr,0.5fr),
  align: (horizon + right, horizon + left ),
  link(addr),
  tiaoma.qrcode(addr),
 )
)

#qrlink("https://github.com/junsevith/Conplete.jl")

Dokumentacja biblioteki jest hostowana na stronie WWW pod adresem:

#qrlink("https://junsevith.github.io/Conplete.jl/dev/")

Ten dokument został utworzony za pomocą nowoczesnej aplikacji do składu tekstu o nazwie *Typst* oraz jej wielu rozszerzeń umożliwiających m.in. generowanie rysunków grafów czy wykresów. Poniżej wylistowano wszystkie użyte rozszerzenia:



#table(
stroke: none,
columns: (auto,auto,1fr),
align: horizon + left,
[*Typst*], [\- skład tekstu], link("https://typst.app/"),
[*Red Agora*], [\- baza wyglądu pracy], link("https://typst.app/universe/package/red-agora"),
[*Fletcher*], [\- rysunki grafów], link("https://typst.app/universe/package/fletcher/"),
[*Lilaq*], [\- wykresy], link("https://typst.app/universe/package/lilaq"),
[*Lovelace*], [\- pseudokody], link("https://typst.app/universe/package/lovelace"),
[*Farme-It*], [\- definicje i twierdzenia], link("https://typst.app/universe/package/frame-it"),
[*Codly*], [\- programy i kod], link("https://typst.app/universe/package/codly"),
[*Tiaoma*], [\- kody QR], link("https://typst.app/universe/package/tiaoma"),
[*Zero*],[\- formatowanie liczb], link("https://typst.app/universe/package/zero"),
)


// #heading(numbering: none, supplement: none)[Dodatek B]

// // Daje nam to więc dwie opcje


// Praca opiera się w istocie gruncie rzeczy na kilku faktach, z których wszystkie powiązane są z klasą obliczeniową #np. Zdefiniujemy je więc zaczynając od pojęcia Złożoności czasowej w szczególnym przypadku Niedeterministycznych maszyn Turinga. Jak wiemy maszyny takie różnią się od standardowych tym że z danego stanu możliwe jest kilka różnych przejść.

// #def[Złożoność czasowa][Weźmy $M$ niedeterministyczną maszynę Turinga. Złożoność czasowa maszyny $M$ jest funkcją $t c_M : bb(N) -> bb(N)$ taką że $t c_M (n)$ oznacza maksymalną liczbę przejść wykonanych w obliczeniu (dla dowolnych możliwych wyborów przejść) na wejściu o długości $n$]

// #def[Klasa złożoności $np$][Język $L$ jest akceptowany w *niedeterministycznym czasie wielomianowym* (ang. Nondeterministic Polynomial time - w skrócie NP) jeśli istnieje niedeterministyczna maszyna Turinga $M$ która akceptuje język $L$ w czasie $t c_M in O(n^r)$, gdzie $r$ jest liczbą naturalną niezależną od $n$. Rodzinę języków akceptowanych w niedeterministycznym czasie wielomianowym nazywamy $np$. ]