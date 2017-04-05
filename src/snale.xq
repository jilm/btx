(:

  Na papíře velikosti A4, naležato, jsou tři objekty označené A, B a C.

  Objekt A je šnek o celkovém průměru 90mm a se třemi spirálami. Vzdálenost
  mezi spirálami je asi 15mm. Střed šneka je 110mm zleva a 80mm zhora.

  Objekt B je šnek o celkovém průměru 70mm, s pěti spirálami o vzdálenosti
  mizi spirálami asi 8mm.

  Třetím objektem jsou čtyři obdélníky pod sebou o velikosti 9x16mm.
  Svislá mezera mezi obdélníky je postupně shora 11mm, 6mm a 3mm.
 
  Parametrická rovnice šneka: r = c * phi / (2pi)

  phi(t+1) = phi(t) + l / phi(t)

  x = c * phi * cos(phi)
  y = c * phi * sin(phi)

:)

declare namespace math = "http://www.w3.org/2005/xpath-functions/math";
declare namespace jilm = "http://www.lidinsky.cz";


declare function jilm:getParameter($phit as xs:double, $l as xs:double, $phiend as xs:double) as xs:double* {

  let $phinext := $phit + $l div $phit
  return if ($phinext gt $phiend)
  then $phinext
  else ($phinext, jilm:getParameter($phinext, $l, $phiend))

};

declare function jilm:getSnaleCoordinates(
    $n as xs:integer, (: počet spirál :)
    $c as xs:double,  (: vzdálenost mezi spirálami [mm] :)
    $l as xs:double   (: velikost kroku :)
  ) as xs:string {

  let $phi-end := $n * 2 * math:pi()
  let $c-corig := $c * 0.5 div math:pi()
  let $d := concat('M',  string-join(
    let $phis := jilm:getParameter(math:pi() div 2, $l, $phi-end)
    for $phi in $phis
      let $x := $c-corig * $phi * math:cos($phi)
      let $y := $c-corig * $phi * math:sin($phi)
      return concat($x, ',', $y)
    , 'L')
  )
  return $d
};

(: paper size A4: 210x297 mm :)
let $paper-width := 297
let $paper-height := 210

let $cx := 150
let $cy := 150
let $n1 := 3
let $c1 := 15
let $cx1 := 110
let $cy1 := 80
let $n2 := 5
let $c2 := 8
let $cx2 := 200
let $cy2 := 80
let $rect-width := 160
let $rect-height := 9
let $rect-x := 80
let $rect-y := 130
let $h1 := 11
let $h2 := 7
let $h3 := 3

let $l := math:pi() div 5
let $rect2-y := $rect-y + $rect-height + $h1
let $rect3-y := $rect2-y + $rect-height + $h2
let $rect4-y := $rect3-y + $rect-height + $h3

return 
<svg xmlns="http://www.w3.org/2000/svg"
     width="{$paper-width}mm" height="{$paper-height}mm"
     viewbox="0 0 {$paper-width} {$paper-height}">

  <rect x="0" y="0" width="{$paper-width}" height="{$paper-height}" 
        style="fill:none;stroke:black;" />
  <path style="fill:none;stroke:black;"
        transform="translate({$cx1},{$cy1})" 
        d="{jilm:getSnaleCoordinates($n1, $c1, $l)}" />
  <path style="fill:none;stroke:black;"
        transform="translate({$cx2},{$cy2})" 
        d="{jilm:getSnaleCoordinates($n2, $c2, $l)}" />
  <rect x="{$rect-x}" y="{$rect-y}" 
        width="{$rect-width}" height="{$rect-height}" 
        style="fill:black;"/>
  <rect x="{$rect-x}" y="{$rect2-y}" 
        width="{$rect-width}" height="{$rect-height}" 
        style="fill:black;"/>
  <rect x="{$rect-x}" y="{$rect3-y}" 
        width="{$rect-width}" height="{$rect-height}" 
        style="fill:black;"/>
  <rect x="{$rect-x}" y="{$rect4-y}" 
        width="{$rect-width}" height="{$rect-height}" 
        style="fill:black;"/>

</svg>
