#import "temp.typ": project
#import "@preview/diagraph:0.3.5": raw-render, render
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node, shapes
#import "@preview/lilaq:0.4.0" as lq
#import "@preview/lovelace:0.3.0": *
#import "@preview/frame-it:1.2.0": *

#set text(lang: "pl")

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

#let problem-stype(title,tags,body,supplement,number,arg) = {
  
}

#show: frame-style(kind: "problem", styles.hint)


#let rsat = smallcaps[Sat]
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

#let np = $cal(N P)$

#let tru = $bb(1)$
#let fal = $bb(0)$

#let num = `num`

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
    "Redukcje problemów",
    "Programowanie Całkowitoliczbowe",
  ),
  abstract: [W pracy przewiduje się analizę wielomianowych redukcji między trudnymi problemami decyzyjnymi z klasy NP.
    W ramach pracy planuje się implementacje w języku julia części drzewa redukcji klasycznych problemów NP-zupełnych.
    Korzeniem tego drzewa będzie problem spełnialności formuł logicznych.
    Implementacja ta ma pozwolić na dołączanie do drzewa kolejnych problemów NP-zupełnych.],
  popraw_sieroty: true,
)

= Wstęp

Celem pracy jest stworzenie biblioteki redukcji problemów klasy NP w języku programowania #link("https://julialang.org/")[Julia]. W bibliotece zaimplementowano następującą część drzewa konwersji problemów klasy NP. 

#let node = node.with(radius: 1.5em, shape: circle, fill:white)


= Podstawy teoretyczne <theory>

W tym rozdziale przedstawimy podstawy teoretyczne niezbędne aby zrozumieć istotę przedstawianych w tej pracy zagadnień. Rozpoczniemy od pojęcia np-zupełności które to jest punktem wyjścia dla rozważań zawartych w tej pracy

== Klasa złożoności NP
Na początku określmy kilka pojęć z których będziemy korzystać:

- Instancję problemu decyzyjnego $X$ oznaczamy $I_X$
- Rozwiązanie instancji problemu $X$ oznaczamy $S_X$
- Algorytm rozwiązujący instancję oznaczamy $cal(A)'_X (I_X) in {0,1} $
- Algorytm zwracający rozwiązanie instancji problemu $cal(A)_X (I_X) in {S_X union emptyset } $
- Algorytm weryfikujący dane rozwiązanie oznaczamy $cal(V)_X (I_X,S_X) in {0, 1}$

Pojęcie problemu decyzyjnego odpowiada w naszym przypadku pojęciu słowa $I_X$ które należy do języka $X$ jeśli istnieje rozwiązanie $S_X$. Pojęcia tłumaczą się bezpośrednio z tych w @rivest_wprowadzenie_2024 @sudkamp_languages_2006 @kleinberg_algorithm_2006, będziemy jednak używać w tym przypadku nazewnictwa bardziej programistycznego. Mając zdefiniowane te pojęcia możemy zacząć definiować omawiane zagadnienia.

#def[Klasa złożoności $cal(P)$][
  Klasa $cal(P)$ to klasa wszystkich problemów dla których istnieje algorytm $cal(A)'$ rozwiązujący instancję problemu, działający w czasie wielomianowym $cal(A)' in O(n^k)$ 
]

// #def[Klasa złożoności $np$][Klasa $np$ to klasa wszystkich problemów $X$ dla których istnieje algorytm $cal(V)_X$ weryfikujący rozwiązanie instancji problemu , który działa w czasie wielomianowym. tzn. $cal(V)_X in O(n^k), k in NN$ @kleinberg_algorithm_2006
// ]

#def[Klasa złożoności $np$][Klasa $np$ to klasa wszystkich problemów $X$ dla których istnieje działający w czasie wielomianowym algorytm certyfikujący $cal(C)_X in O(n^k)$, gdzie $C_X$ jest certyfikatem rozwiązywalności problemu, taki że: \
#align(center)[
  $forall I_X : cal(A)'_X (I_X) = 1 <=> exists C_X  |C_X| = O(|I_X|^c) : cal(C)_X (I_X,C_X) = 1$
]
]



Istnieje kilka równoznacznych definicji tego pojęcia, nazwa $np$ oznacza _Nondeterministic Polynomial_ i wywodzi się z definicji opartej na niedeterministycznych maszynach Turinga, więcej informacji na ten temat prezentuje książka @sudkamp_languages_2006. Z reguły certyfikatem będzie rozwiązanie problemu $S_X$, a algorytmem $cal(C)_X$ algorytm weryfikujący rozwiązanie $cal(V)_X$, spełniają one powyższe wymagania, nie są jednak jedynymi.

Można od razu zauważyć że klasa #np zawiera problemy rozwiązywalne w czasie wielomianowym, możemy bowiem ustalić $cal(C)_X (I_X, c) = cal(A)_X (I_X)$ co spełnia wszystkie wymagania. Zatem widzimy że $cal(P) subset.eq np$, równość tych klas jednak do tej pory pozostaje nierozstrzygnięta. Wiemy jednak że do klasy $np$ należą również problemy dla których nie znamy wielomianowego algorytmu, to znaczy najlepszy algorytm jaki znamy działa w czasie eksponencjalnym.

== Pojęcie redukcji

Jeśli rozmawiamy o trudności problemów w danej klasie, warto rozpatrzyć je pod względem jakiegoś porządku, oznaczając czy dane problemy są trudniejsze od innych. Sposób w jaki możemy to określić to transformacje instancji jednego problemu do instancji drugiego to znaczy *redukcję*. Oznaczmy algorytm transformacji instancji problemu $X -> Y$ jako $cal(T)_(X Y)(I_X) = I_Y$

#def[Redukcja wielomianowa][Jeśli dla dowolniej instacji $I_X$ problemu $X$ istnieje algorytm wielomianowy $cal(T)_(X Y)$ taki że $cal(T)_(X Y)(I_X) = I_Y$ ma rozwiązanie wtedy i tylko wtedy gdy $I_X$  ma rozwiązanie, wtedy problem $X$ jest wielomianowo redukowalny do $Y$, co oznaczamy $X <=_P Y $ @sudkamp_languages_2006
// #align(center)[
//   $X <=_P Y$ \
//   $equiv$ \
//   $exists cal(T)_(X Y) in O(n^k) : forall I_X : cal(T)_(X Y)(I_X) = I_Y -> cal(A)_Y (I_Y) != emptyset  <=> cal(A)_X (I_X) != emptyset$
// ]
]

W naszym przypadku redukcja musi być wielomianowa ponieważ zachowuje ona wtedy przynależność do klasy, o czym mówi twierdzenie:

#twi[Hierarchia redukcji][Jeśli $X$ jest redukowalny do $Y$ w czasie wielomianowym: $X <=_P Y$, oraz $Y in cal(P)$ wtedy $X in cal(P)$, równoważnie gdy $X in.not cal(P)$ wtedy $Y in.not cal(P)$ @sudkamp_languages_2006]

Co łatwo dowieść ponieważ gdy $cal(A)'_Y in O(n^k)$ oraz $cal(T)_(X Y) in O(n^k)$ wtedy $cal(A)'_Y compose cal(T)_(X Y) in O(n^k)$ rozwiązuje problem $X$ w czasie wielomianowym (interesuje nas w tym przypadku to czy rozwiązanie istnieje a nie jego wartość).

Powyższe twierdzenie mówi więc w gruncie rzeczy że problem $X$ jest *co najmniej* tak trudny jak problem $Y$. Możemy więc za pomocą tego kryterium podzielić problemy w klasie #np.

#def[NP-hard][Weźmy problem $X$, jeśli dla każdego $Y in np$ zachodzi $Y <=_P X$ mówimy że problem $X$ jest *NP-trudny*]

Co oznacza że te problemy są co najmniej tak trudne jak cała klasa #np, mogą one jednak nie należeć do #np dlatego wprowadzamy ostatnią definicję.

#def[NP-complete][
  Jeśli problem $X$ jest NP-trudny oraz $X in np$ to mówimy że problem $X$ jest *NP-zupełny*
]

Są to więc najtrudniejsze problemy z klasy #np, rozwiązanie jednego z nich pozwala na rozwiązanie wszystkich problemów z klasy, a stworzenie wielomianowego algorytmu do jednego z nich pozwala udowodnić że $cal(P) = np$ oraz vice versa: udowodnienie że któryś z nich nie należy do $cal(P)$ pozwala udowodnić $cal(P) != np$. W zasadzie więc mamy do czynienia z najciekawszymi problemami z tej klasy, i to nimi będziemy się zajmować w tej pracy.

W pracy omawiane będą również transformacje rozwiązań. Użyteczne są dwa typy takich transformacji, tzn. dla określonej transformacji $cal(T)_(X Y)$ : algorytm $cal(K)_(X Y)$ działający w tym samym kierunku co transformacja który będziemy nazywać "konstrukcją" rozwiązania dla problemu będącego wynikiem transformacji, oraz algorytm $cal(E)_(Y X)$ działający w kierunku przeciwnym który będziemy nazywać "ekstrakcją" rozwiązania dla źródłowego problemu. Algorytm $cal(K)$ będzie zawsze istniał ponieważ bezpośredio odpowiada on algorytmowi transformacji, algorytm $cal(E)$ nie musi istnieć jednak pokażemy że stosując odpowiednie techniki często da się go skonstruować.

Zdefiniowaliśmy więc wszytkie potrzebne nam algorytmy, a ich wzajemna relacja w uproszczeniu prezentuje się następująco:

#figure(sdiagram(
  node($I_X$),
  edge("->",$cal(A)_X$),
  node((1,0),$S_X$),
  node((0,1),$I_Y$),
  edge("->",$cal(A)_Y$),
  node((1,1),$S_Y$),
  edge((0,0),(0,1),"->",$cal(T)_(X Y)$),
  edge((1,0),(1,1),"->",$cal(C)_(X Y)$, shift:5pt, label-side:left),
  edge((1,0),(1,1),"<-",$cal(E)_(Y X)$, shift:-5pt),
),
caption:[Zdefiniowane algorytmy]
)



== Klasyczne problemy NP-zupełne

Mając już zdefiniowane wszystkie pojęcia, możemy podać kilka przykładów problemów NP-zupełnych. Zaczniemy od problemu *spełnialności formuł logicznych* w skrócie #rsat, jest to najbardziej podstawowy problem NP-zupełny a zarazem pierwszy dla którego udowodniono NP-zupełność o czym mówi *Twierdzenie Cook'a* @sudkamp_languages_2006. 

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
  ] 

  *Pytanie* : Czy istnieje  wartościowanie $pi : V -> {tru, fal}$ dla którego formuła jest spełniona?
]]

Pominiemy formalną definicję dobrze zbudowanej formuły, ponieważ to jak wygląda formuła logiczna jest oczywiste, warto jedynie zaznaczyć że formuła $phi$ musi być skończona. Następujące problemy są podproblemami problemu #rsat.

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

Znanym jest fakt że dowolna formuła może zostać zapisana w postaci CNF, przy czym są to również transformacje wielomianowe. Ten typ redukcji realizuje na przykład transformacja Tseytin @tseitin_complexity_1983. Z tego powodu, oraz z racji łatwości w zapisie to #sat jest używany jako bazowy format problemu spełnialności i to on jest bazowym problemem w tej pracy.

#pro[#sat3 - Spełnialność formuł 3-CNF][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $V$ - zbiór zmiennych logicznych, $|V| = n$\
    $phi$ - formuła logiczna w postaci koniunkcyjnej normalnej,\ gdzie każda klauzula zawiera dokładnie 3 różne literały
  ] 

  *Pytanie* : Czy istnieje  wartościowanie $pi : V -> {tru, fal}$ dla którego formuła jest spełniona?
]] <sat3>

Jest to ostatni problem z rodziny problemów spełnialności formuł i stanowi on często punkt wyjścia dla redukcji do dalszych problemów.


Pozostałe problemy to popularne problemy pochodne, możemy podzielić je na 3 grupy gdzie pierwsza grupa to problemy pokrycia:

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

#pro[#cli - Problem kliki][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $G =(V,E)$ - Graf nieskierowany \
    $k$ - liczba naturalna
  ] 

  *Pytanie* : Czy istnieje podzbiór wierzchołków $V' subset.eq V$ rozmiaru co najmniej $k$, w którym każda para wierzchołków jest połączona krawędzią należącą do $E$?
]] <cli>

#pro[#hit - Problem zbioru przecianjącego][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $S$ - Skończony zbiór \
    $cal(C)$ - skończona rodzina podzbiorów $S$ \
    $k$ - liczba naturalna
  ] 

    *Pytanie* : Czy istnieje podzbiór $S' subset.eq S$ rozmiaru co najwyżej $k$, taki że dla dowolnego podzbioru $C in cal(C)$ przekrój $S' inter C$ jest niepusty?
]] <hit>

Następna grupa to problemy dotyczące cykli w grafie:

#pro[#uham - Problem cyklu Hamiltona][
  #pad(left:1em)[
  *Dane wejściowe* : #box(baseline: 100% - 7pt)[
    $G =(V,E)$ - Graf nieskierowany \
  ] 

  *Pytanie* : Czy w grafie istnieje cykl odwiedzający każdy wierzchołek dokładnie raz?

]] <uham>

#pro[#ham - \ #h(5.1em) Problem cyklu Hamiltona w grafie skierowanym][
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


Ostatnia grupa to problemy sum podzbiorów:

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

= Analiza i opis wybranych redukcji

== Redukcja #sat3 do #vc

Ustalmy problem #sat3 jako: $W = w_1 and w_2 and dots and w_m$ formuła w postaci koniunkcyjnej normalnej gdzie $w_j = u_(j,1) or u_(j,2) or u_(j,3)$ oraz $X = {x_1, x_2, dots, x_n}$ zbiór zmiennych używanych w formułach.

#vc to problem polegający na znalezieniu podzbioru wierzchołków w grafie nieskierowanym $G=(V,E), E subset.eq V times V$ takiego że:

$
C subset V and |C|<=n and forall (v,u) in E : v in C or u in C 
$

To znaczy, szukamy podzbioru wierzchołków takiego że każda krawędź w grafie dotyka co najmniej jednego wierzchołka z podzbioru, z tym że dla dowolnego $C$ ten problem jest trywialny bo wtedy może być $C = V$, ograniczamy więc jego wielkość parametrem 
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

// === Algorytm

Algorytm jest dosyć elementarny i sam nasuwa się na myśl jeżeli zrozumieliśmy zasadę działania konwersji, wystarczy jedynie ustalić odpowiednie numerowanie wierzchołków aby ułatwić ich łączenie, wierzchołki numerujemy kolejnymi liczbami naturalnymi z przedziału $angle.l 1 , 2n+3m angle.r$ gdzie $n$ to ilość zmiennych a $m$ ilość klauzul.

$
num(x_i) &= i \
num(not x_i) &= n + i \
num(u_(i,j)) &= 2n + 3i + j  \
$

Numerowanie w tym wypadku oznacza unilalne przyporządkowanie wierzchołkom liczb narutalnych, co jest bardzo naturalne jeśli rozważamy struktury komputerowe, jest to więc funckja róznowartościowa przyporządkowująca elementom liczby naturalne, przy czym implementacja komputerowa algorytmów wymaga aby była to funkcja "na" przedział liczb naturalnych rozboczynający się od liczby 1.

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

#pagebreak()

=== Odzyskanie rozwiązania

Odpakowanie rozwiązania oryginalnego problemu #sat3 jest bardzo łatwe, dzięki odpowiedniemu numerowaniu wierzchołków którego użyliśmy. Wystarczy jedynie sprawdzić dla wierzchołków $1dots n$  czy znajdują się one w zbiorze #vc.

#figure(
  kind: "algorithm",
  supplement: [Algorytm],
  pseudocode-list(booktabs: true, numbered-title: [Odzyskanie rozwiązania #sat3 z #vc])[
  + *function* Unpack-Hamiltonian *begin*
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


== Redukcja #sat3 do #ham

Ustalmy problem #sat3 jako: $W = w_1 and w_2 and dots and w_m$ formuła w postaci koniunkcyjnej normalnej gdzie $w_j = u_(j,1) or u_(j,2) or u_(j,3)$ oraz $X = {x_1, x_2, dots, x_n}$ zbiór zmiennych używanych w formułach.

Problem #ham polega na znalezieniu w grafie cyklu Hamiltona tzn. cyklu który przechodzi przez każdy wierzchołek w grafie dokładnie raz. Formalnie taki cykl $C$ można opisać w ten sposób, dla grafu $G = (V,E subset.eq V times V)$

$
  exists C subset.eq E : forall v in V space ( exists_(=1) (v,y) in C and exists_(=1) (x,v) in C )
$

Naszym celem jest skonstruowanie na podstawie zadanego problemu #sat3 grafu dla którego znalezienie cyklu Hamiltona będzie równoznaczne z rozwiązaniem problemu #sat3. Dokonamy tego w dwóch krokach: najpierw stworzymy podgraf emulujący zachowaniem zmienną a następnie podgraf emulujący zachowaniem klauzulę.

=== Podgraf zmiennej

Podgraf odpowiadający zmiennej musi spełniać następującą właściwość: Cykl Hamiltona może przebiegać przez podgraf na dokładnie dwa sposoby. Podgraf taki można stworzyć na wiele sposobów, ja wybrałem jednak ten (co uzasadnię w dalszej części rozdziału). Długość środkowego łańcucha w podgrafie musi być większa od 2 wierzchołków i może być zwiększona w miarę potrzeb.

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
)

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
  )],
)

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

Mając już strukturę emulującą zachowanie zmiennych, musimy zająć się następnie klauzulami. Szukamy podgrafu który w zachowaniu względem cyklu Hamiltona będzie do napisu $x and y and z$ tzn. szukamy podgrafu który stanie się częścią poprawnego cyklu wtedy i tylko wtedy gdy jedna z odpowiadających mu zmiennych w grafie ewaluacji otrzyma odpowiednią wartość. Podgraf taki można skonstruować w następujący sposób:

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

Jako podgraf klauzuli może posłużyć jeden z wierzchołków, podłączamy go "równolegle" do odpowiedniej krawędzi w podgrafie. Widzimy że może on zostać podłączony na kilka sposobów: w lewą stronę lub w prawą stronę, co definiuje jaka ewaluacja zmiennej powinna zaspokoić daną klauzulę. Na powyższym @klauzula[rysunku] ewaluacja zmiennej na `true` zaspokaja klauzulę $V_1$ zaś ewaluacja zmiennej na `false` zaspokaja klauzulę $V_2$. 

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
    size: 100%,
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

Otrzymaliśmy więc prawidłowy graf emulujący za pomocą `HAMILTIONIAN-CIRCUIT` problem #sat3, przykładową ewaluację #sat3 możemy zobaczyć na @3sat-ham[Rysunku]. 


=== Optymalizacja

W trakcie przygotowania do tego rozdziału natrafiłem na 2 metody redukcji #sat3 do #ham metodę _Sudkampa_ @sudkamp_languages_2006, oraz metodę _Kleinberg-Tardos_ @kleinberg_algorithm_2006, postanowiłem więc zbadać metody i dowiedzieć się która metoda jest najlepsza. Moim celem było możliwe zmniejszenie liczby wykorzystanych wierzchołków i krawędzi w redukcji. Podczas gdy najbardziej popularna jest metoda K-T, metoda Sudkampa jest bardziej przejrzysta, pomimo że jest zdecydowanie mniej optymalna. Sudkamp w książce @sudkamp_languages_2006 proponuje sprytny podgraf klauzuli który dobrze emuluje tą logikę, podczas gdy K-T w książce @kleinberg_algorithm_2006 jako podgraf klauzuli używają jednego wierzchołka, uproszczenie które wymaga jednak znaczących zmian w podgrafie zmiennej. Jako podgraf zmiennej Sudkamp używa zaś bardziej skomplikowanego grafu który ciężej będzie dynamicznie konstruować w algorytmie.

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

Sprawdziłem wykresy ilości zmiennych dla worst i best case  które pokazują odpowiednio największe i najmniejsze ilości, oraz dla avg case który został obliczony według benchmarkowych problemów #sat3 dostępnych w internecie. W tym przypadku worst-best case zależy od ilości unikalncyh zmiennych w problemie gdzie best case to $|V_"best"| = 3$ (jedynie 3 różne zmienne w klauzulach) a worst case to $|V_"worst"| = 3x$ (każda zmienna w klauzuli jest inna). 

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


Metoda Sudkampa w większym stopniu zależy od ilości klauzul a metoda K-T zależy bardziej od wielkości $U(i)$ sprawdzą się one więc w innych wypadkach. Zbadałem więc jak wygląda typowy problem #sat3 i według udostępnionych w internecie przykładów występuje średnio 4 razy więcej klauzul niż zmiennych i średnia wartość $U(i) approx 7.5$ czego wpływ na wielkości grafu możemy zobaczyć na poniższych wykresach.
\
\

#show figure: set figure.caption(position: top)

#figure(
  lq.diagram(
  // title: [Ilość wierzchołków w grafie],
  xlabel: "Liczba klauzul", 
  ylabel: "Liczba wierzchołków",
  legend: (position: top + left),
  width:12cm,
  height:6cm,
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
  height:6cm,
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

Jak widzimy metoda S-T okazuje się być wyraźnie lepsza dla ilości wierzchołków i nieznacznie lepsza co do ilości krawędzi, wybrałem więc ostatecznie tą metodę i to ona jest przedstawiona w powyższym rozdziale.

#pagebreak()
// === Algorytm

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
#pagebreak()

#pseudocode-list[
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

Jak widać funkcja `next_slot` wybiera krawędź do której należy równolegle podłączyć wierzchołek klauzuli. Funkcja zachowuje odstępy pomiędzy klauzulami wstawiając odpowiednie wierzchołki pomocnicze i  wybierając co 3 wierzchołek.

Wolne miejsca w podgrafach zmiennych są przechowywane w kolejkach zawartych w tablicach $P$ i $N$ odpowiednio dla zwyczajnych i zanegowanych zmiennych. Użycie dwóch kolejek może się wydawać marnowaniem pamięci, jednak w rzeczywistości zawsze co najmniej jedna z nich będzie miała długość równą 1.

Jeśli zmienna nie została użyta w żadnej klauzuli odpowiadające jej kolejki są puste, usuwamy wtedy wierzchołek $b_i : num(b_i) = i $ z grafu za pomocą metody `rem_vertex!()`, aby nie interferował w znajdowaniu cyklu. Zamienia ona wierzchołek $b$ z ostatnim wierzchołkiem w grafie a następnie go usuwa, mając przy tym złożoność $O(max(deg(b),deg(|V|))^2)$ co w naszym grafie gdzie $forall v in V deg(v) <= 6$ oznacza w gruncie rzeczy złożoność $O(1)$. Nie przesuwa ona więc numerowania wierzchołków a na miejscu wierzchołka `b` znajdzie się losowy wierzchołek o numerowaniu: $num(v) >n$.

Pozostaje nam jedynie zbadać złożoność obliczeniową algorytmu, zawiera on operacje:

  + $O(m)$ - inicjalizacja zbioru wierzchołków z wykorzystaniem funkcji $U(i)$
  + $O(m)$ - pętla *for* łącząca podgrafy klauzul z podgrafami zmiennych
    + $O(1)$ - funkcja *next_slot* znajdująca odpowiednie miejsce do podłączenia
  + $O(n)$ - pętla *for* łącząca podgrafy zmiennych

Ponieważ pozostałe operacje są $O(1)$, daje nam to w sumie złożoność $O(n+m)$ a więc złożoność liniową. Jest więc to istotnie wielomianowa konwersja i może posłużyć jako dowód NP złożoności problemu #ham.

=== Odzyskanie rozwiązania
Kolejnym ważnym krokiem jest odzyskanie rozwiązania tzn. odczytanie rozwiązania oryginalnego problemu #sat3 na podstawie rozwiązania utworzonej instancji #ham oraz danych pomocniczych dotyczących redukcji zawartych w instancji problemu.

Aby to zrobić musimy sprawdzić kierunek przejścia cyklu po podgrafach zmiennych co ułatwia nam fakt że ustaliliśmy numerowanie dla dwóch pierwszych wierzchołków w podgrafie zmiennej $x_i$ jako $num(p_i) = i and num(d_i) = n+i$, możemy dzięki temu sprawdzić czy w cyklu znajduje się krawędź $p_i->d_i$ a jeśli tak, cykl idzie w prawo a zmienna jest ewaluowana jako `true`, zaś w p.p. musi istnieć krawędź $d_i -> p_i$, cykl idzie w lewo a zmienna ewaluuje się jako `false`

#figure(
  kind: "algorithm",
  supplement: [Algorytm],
  pseudocode-list(booktabs: true, numbered-title: [Odzyskanie rozwiązania #sat3 z #ham])[
  + *function* Unpack-Hamiltonian *begin*
    - *input:* $C,n$ #comm[cykl Hamiltona $C subset.eq E$, liczba zmiennych #sat3]

    - *output:* $A$ #comm[$A in {bb(0),bb(1)}^n$ ewaluacja zmienych dla #sat3]
    + $A = [fal, fal, dots, fal]$ #comm[tablica o długości $n$]
    + *for* $(v,u) in C$
      + $i <- num(v)$ #comm[numer wierzchołka $v$]
      + *if* $i <= n$ *and* $i + n = num(u)$ #comm[jest to wierzchołek $p_i$ i cykl biegnie w prawo]
        + $A[i] = tru$ #comm[zmienna $x_i$ ewaluowana jest na `true`]
      + *end*
   + *end* 
   + *return* $A$
  + *end*
]
)

Jeśli któraś ze zmiennych $x_i$ nie była nigdy użyta w klauzuli, jej wierzchołki $p_i, d_i$ zostają usunięte a w ich miejsce umieszczamy inne wierzchołki nie będące wierzchołkami początkowymi. Sprawia to że ewaluacja tej zmiennej zostanie odczytana jako losowa, co nie ma jednak żadnego wpływu na poprawność rozwiązania ponieważ ewaluacja zmiennej $x_i$ nie ma znaczenia dla spełnienia klauzul.

= Projekt systemu odwzorowującego graf redukcji

== Założenia i cel projektu
Celem projektu jest stworzenie biblioteki programistycznej implementującej redukcje problemów NP-zupełnych. Biblioteka powinna zapewniać jak najbardziej kompletną funkcjonalność aby stanowiła pomoc w możliwie wielu zastosowaniach i prezentowała dużą wartość dodaną. Oto kilka założeń jakie towarzyszyły mi podczas konstrukcji biblioteki:

+ *Idiomatyczność i Łatwość wykorzystania* - sposób użycia biblioteki powinien być na pierwszy rzut oka możliwie oczywisty dla sprawnego użytkownika, wszystkie nazwy elementów biblioteki powinny być logicznie podparte i nieskomplikowane 

+ *Wydajność* - wszystkie części biblioteki powinny być skonstruowane możliwie optymalnie, aby skrócić czas działania oraz wpływ na skomplikowanie danych wynikowych

+ *Spójność* - wszystkie elementy biblioteki powinny być wzajemnie spójne, powinny dzielić sposoby ich wykorzystania, oraz odpowiednio ze sobą współgrać

+ *Kompatybilność* - ponieważ mamy do czynienia z zagadnieniami które nie są wysoce ustandaryzowanie, biblioteka musi być możliwie kompatybilna z dowolnymi wybranymi przypadkami uzycia, oraz stosować się do przyjętych standardów jeżeli tylko takie istnieją.

== Interfejsy wykorzystywane w systemie

W celu zachowania spójności w bibliotece zastosowano interfejsy funkcyjne. Odpowiadają one bezpośrednio algorytmom zdefiniowanym w @theory[Rozdziale].

- #smallcaps[Transform]$(I_X, Y) = I_Y$ - transformacja (redukcja) instancji problemu $X$ na instancję problemu $Y$ odpowiednik algorytmu $cal(T)_(X Y)$

- #smallcaps[Solve]$(I_X) in {S_X, emptyset}$ - rozwiązanie zadanej instancji problemu, odpowiednik  $cal(A)_X$

- #smallcaps[Extract]$(S_Y,I_X) = S_X$ - odpakowanie rozwiązania instancji $I_Y$ będącej wynikiem transformacji, do rozwiązania źródłowej instancji $I_X$, odpowiednik algorytmu $cal(E)_(Y X)$

- #smallcaps[Construct]$(Y,S_X,I_X) = S_Y$ - skonstruowanie rozwiązania dla instancji $I_Y$ będącej wynikiem transformacji, wykorzystując rozwiązanie źródłowej instancji $S_X$, odpowiednik algorytmu $cal(C)_(X Y)$

- #smallcaps[Validate]$(S_X, I_X) in {tru, fal}$ - sprawdzenie poprawności zadanego rozwiązania instancji problemu $X$, odpowiednik algorytmu $cal(V)_X$

Przedstawione interfejsy prezentują całość funkcjonalności biblioteki

== Implementacja grafu redukcji
Poniższy graf prezentuje problemy dla których zaimplementowano funkcjonalności, gdzie krawędź $X -> Y$ oznacza implementację wszystkich interfejsów dla danej pary problemów $X,Y$.

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
)

Warto zauważyć że dla niektórych problemów krawędzie biegną w obie strony, w tym wypadku transformacja zarówna jak i inne interfejsy dostępne są w obie strony.

Dla problemów bezpośrednio połączonych wykorzystywane są  zaimplementowane algorytmy, w systemie możliwa jest jednak transformacja wielokrotna o ile istnieje ścieżka pomiędzy zadanymi problemami. Wybór operacji jest określany na podstawie najkrótszej ścieżki pomiędzy problemami względem liczby krawędzi. W tym wypadku zalecane jest wykorzystanie interfejsów dla transformacji łańcuchowych:

- #smallcaps[Transform]$(I_X_1, X_n) = C_(1..n) = (I_X_1,I_X_2,dots,I_X_n)$ - transformacja (redukcja) instancji problemu $X$ na instancję problemu $Y$ zwracająca ciąg wszystkich pośrednich instancji.

- #smallcaps[Extract]$(S_X_n,C_(1..n)) = S_X$ - odpakowanie rozwiązania instancji $I_X_n$ będącej wynikiem transformacji, do rozwiązania źródłowej instancji $I_X_1$

- #smallcaps[Construct]$(S_X,C_(1..n)) = S_Y$ - skonstruowanie rozwiązania dla instancji $I_X_n$ będącej wynikiem transformacji, wykorzystując rozwiązanie źródłowej instancji $S_X_1$, odpowiednik algorytmu $cal(C)_(X Y)$

Wykorzystanie łańcucha instancji $C_(1..n)$ jest wymagane dla interfejsów #smallcaps[Extract] i #smallcaps[Construct] ze względów implementacyjnych, co jest oczywiste jeśli spojrzymy na ich domyślne definicje.

== Możliwość rozbudowy o kolejne problemy

Ważną funkcjonalnością systemu jest rozszeczenie grafu transformacji przez użytkownika. Dostępne jest dodanie dowolnych problemów jako wierzchołków w grafie, oraz dowolnych transformacji jako krawędzi w grafie. Rozszerzenie takie będzie współgrać całkowicie z systemem, pod warunkiem przestrzegania przez uzytkownika definicji interfejsów, o których było mowa powyżej.
== Zastosowania

= Implementacja systemu w języku Julia
== Wybór technologii i środowiska
== Hierarchia typów i metod
== Implementacja wybranych problemów NP-zupełnych
== Implementacja redukcji między problemami
== Mechanizm konstrukcji i ekstrakcji rozwiązań
== Przykłady działania systemu

= Testy i analiza działania
== Weryfikacja poprawności implementacji
== Analiza złożoności obliczeniowej operacji redukcji
== Wpływ redukcji na szybkość rozwiązania problemu

= Podsumowanie i wnioski

= Dodatek

// Daje nam to więc dwie opcje


Praca opiera się w istocie gruncie rzeczy na kilku faktach, z których wszystkie powiązane są z klasą obliczeniową #np. Zdefiniujemy je więc zaczynając od pojęcia Złożoności czasowej w szczególnym przypadku Niedeterministycznych maszyn Turinga. Jak wiemy maszyny takie różnią się od standardowych tym że z danego stanu możliwe jest kilka różnych przejść.

#def[Złożoność czasowa][Weźmy $M$ niedeterministyczną maszynę Turinga. Złożoność czasowa maszyny $M$ jest funkcją $t c_M : bb(N) -> bb(N)$ taką że $t c_M (n)$ oznacza maksymalną liczbę przejść wykonanych w obliczeniu (dla dowolnych możliwych wyborów przejść) na wejściu o długości $n$]

#def[Klasa złożoności $np$][Język $L$ jest akceptowany w *niedeterministycznym czasie wielomianowym* (ang. Nondeterministic Polynomial time - w skrócie NP) jeśli istnieje niedeterministyczna maszyna Turinga $M$ która akceptuje język $L$ w czasie $t c_M in O(n^r)$, gdzie $r$ jest liczbą naturalną niezależną od $n$. Rodzinę języków akceptowanych w niedeterministycznym czasie wielomianowym nazywamy $np$. ]