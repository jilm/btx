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

(: Object A parameters :)
let $n1 := 3
let $c1 := 15
let $cx1 := $paper-width * 0.25
let $cy1 := $paper-height * 0.25

(: Object B parameters :)
let $n2 := 5
let $c2 := 8
let $cx2 := $paper-width * 0.75
let $cy2 := $paper-height * 0.25

(: Object C parameters :)
let $rect-width := 160
let $rect-height := 9
let $rect-x := ($paper-width - $rect-width) * 0.5
let $rect-y := 130
let $h1 := 11
let $h2 := 7
let $h3 := 3

let $l := math:pi() div 5
let $rect2-y := $rect-y + $rect-height + $h1
let $rect3-y := $rect2-y + $rect-height + $h2
let $rect4-y := $rect3-y + $rect-height + $h3
let $RA := $n1 * $c1
let $RB := $n2 * $c2

return 
<svg xmlns="http://www.w3.org/2000/svg"
     width="{$paper-width}mm" height="{$paper-height}mm"
     viewbox="0 0 {$paper-width} {$paper-height}"
     style="stroke-width:0.5;">

  <rect x="0" y="0" width="{$paper-width}" height="{$paper-height}" 
        style="fill:none;stroke:black;" />

  <!-- Object A -->

  <g transform="translate({$cx1}, {$cy1})">

    <path style="fill:none;stroke:black;"
          d="{jilm:getSnaleCoordinates($n1, $c1, $l)}" />

    <circle cx="0" cy="0" r="3" 
            style="fill:none;stroke:black;" />

    <circle cx="0" cy="0" r="0.5" 
            style="fill:black;" />

    <g transform="translate({$RA - 0.5 * $c1}, 0)">
      <circle cx="0" cy="0" r="3" 
              style="fill:none;stroke:black;" />
      <circle cx="0" cy="0" r="0.5" 
            style="fill:black;" />
    </g>

    <text x="50" y="-30" style="font-family:sans-serif;stroke:none;">A.</text>

  </g>

  <!-- Object B -->

  <g transform="translate({$cx2}, {$cy2})">

    <path style="fill:none;stroke:black;"
        d="{jilm:getSnaleCoordinates($n2, $c2, $l)}" />

    <circle cx="0" cy="0" r="3" 
            style="fill:none;stroke:black;" />

    <circle cx="0" cy="0" r="0.5" 
            style="fill:black;" />

    <text x="50" y="-30" style="font-family:sans-serif;stroke:none;">B.</text>

    <g transform="translate({$RB - 0.5 * $c2}, 0)">
      <circle cx="0" cy="0" r="3" 
              style="fill:none;stroke:black;" />
      <circle cx="0" cy="0" r="0.5" 
            style="fill:black;" />
    </g>


  </g>

  <!-- Object C -->

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

  <text x="270" y="130" style="font-family:sans-serif;">C.</text>

  <g transform="translate({$rect-x}, {$rect-y + $rect-height + $h1 * 0.5})">
    <circle cx="-10" cy="0" r="3" 
            style="fill:none;stroke:black;" />
    <circle cx="-10" cy="0" r="0.5" 
            style="fill:black;" />
    <circle cx="{$rect-width + 10}" cy="0" r="3" 
            style="fill:none;stroke:black;" />
    <circle cx="{$rect-width + 10}" cy="0" r="0.5" 
            style="fill:black;" />
  </g>

  <g transform="translate({$rect-x}, {$rect2-y + $rect-height + $h2 * 0.5})">
    <circle cx="-10" cy="0" r="3" 
            style="fill:none;stroke:black;" />
    <circle cx="-10" cy="0" r="0.5" 
            style="fill:black;" />
    <circle cx="{$rect-width + 10}" cy="0" r="3" 
            style="fill:none;stroke:black;" />
    <circle cx="{$rect-width + 10}" cy="0" r="0.5" 
            style="fill:black;" />
  </g>

  <g transform="translate({$rect-x}, {$rect3-y + $rect-height + $h3 * 0.5})">
    <circle cx="-10" cy="0" r="3" 
            style="fill:none;stroke:black;" />
    <circle cx="-10" cy="0" r="0.5" 
            style="fill:black;" />
    <circle cx="{$rect-width + 10}" cy="0" r="3" 
            style="fill:none;stroke:black;" />
    <circle cx="{$rect-width + 10}" cy="0" r="0.5" 
            style="fill:black;" />
  </g>

  <g transform="translate(22, 22)">
    <circle rx="0" ry="0" r="8" style="fill:none;stroke:black;"/>
    <line x1="-11" x2="11" y1="0" y2="0" style="stroke:black;"/>
    <line y1="-11" y2="11" x1="0" x2="0" style="stroke:black;"/>
    <!--<path d="M0,0 L8,0 A8 8 0 0 1 0 8 L0,-8 A8 8 1 0 0 -8 0 L0,0" />-->
  </g>


  <g transform="translate(22, 192)">
    <circle rx="0" ry="0" r="8" style="fill:none;stroke:black;"/>
    <line x1="-11" x2="11" y1="0" y2="0" style="stroke:black;"/>
    <line y1="-11" y2="11" x1="0" x2="0" style="stroke:black;"/>
    <!--<path d="M0,0 L8,0 A8 8 0 0 1 0 8 L0,-8 A8 8 1 0 0 -8 0 L0,0" />-->
  </g>

  <g transform="translate(280, 192)">
    <circle rx="0" ry="0" r="8" style="fill:none;stroke:black;"/>
    <line x1="-11" x2="11" y1="0" y2="0" style="stroke:black;"/>
    <line y1="-11" y2="11" x1="0" x2="0" style="stroke:black;"/>
    <!--<path d="M0,0 L8,0 A8 8 0 0 1 0 8 L0,-8 A8 8 1 0 0 -8 0 L0,0" />-->
  </g>

  <line y1="{$paper-height * 0.5}" 
        y2="{$paper-height * 0.5}" 
        x1="0" x2="{$paper-width}" 
        style="stroke:black;"/>

  <line y1="0" 
        y2="{$paper-height * 0.5}" 
        x1="{$paper-width * 0.5}" 
        x2="{$paper-width * 0.5}" 
        style="stroke:black;"/>

</svg>
