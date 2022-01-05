--[[
CIRCLES - WERSJA ROZSZERZONA

Tą wersję można zrobić, jeżeli według Was grupa poradzi sobie z taką ilością
tablic. Jeśli nie, to wersja podstawowa zupełnie wystarczy.

Program rysujący krzywe Lissajous.

Tworzymy dwa okręgi, po których krążą punkt_stworzony, każdy z tych punktów ma
inną dowolną prędkość. Za pomocą tych punktów będziemy rysować kolejny
"wypadkowy" kształt. Polega to na tym, że z jednego podstawowego punktu
bierzemy współrzędną X, a z drugiego współrzędną Y i tworzymy kształt wypadkowy.
]]

-----------------------SETUP--------------------
kat = 0
wielkosc_okna = 1000 --px
ilosc_okregow_w_osi = 12 --ilość okręgów w osi

function rysuj_okregi_podstawowe()
  kat = kat + 0.01 --zwiększamy kąt
  for strona, wartosc in pairs(okrag) do --wyliczamy rodzaje (góra, lewo)
    for i=1, ilosc_okregow_w_osi, 1 do
      --Rysujemy okręgi na osiach
      okrag[strona][i].x = okrag[strona][i].srodek_x + promien*math.sin(predkosc[i] * kat)
      okrag[strona][i].y = okrag[strona][i].srodek_y + promien*math.cos(predkosc[i] * kat)
    end
  end
end

function rysuj_krzywe()
  for i=1, ilosc_okregow_w_osi, 1 do
    for j=1, ilosc_okregow_w_osi,1 do
      if kat - 0.1 <= 2*math.pi then
        table.insert(krzywa[i][j], okrag.gora[i].x)
        table.insert(krzywa[i][j], okrag.lewa[j].y)
      end
    end
  end
end

function love.load()
  predkosc = {}
  krzywa = {}
  kolor = {}
  promien = wielkosc_okna/(2.8*ilosc_okregow_w_osi)
  przesuniecie = 1.5*promien

  love.window.setMode(wielkosc_okna, wielkosc_okna)
  love.window.setTitle("Krzywe wersja rozszerzona")
  love.graphics.setLineJoin("none")
  math.randomseed(os.time())

  ----------------------OSIE--------------------
  okrag = {}
  okrag.gora = {}
  okrag.lewa = {}

  --Będziemy opisywać okręgi na górze i po lewej stronie
  --Należy napisać gdzie mają znaleźć się ich środki, srodek_x i srodek_y
  --dobrać przypadkowy kolor oraz stworzyć miejsce na zapis pozycji punktu,
  --który będzie krążył po okręgu

  for i=1, ilosc_okregow_w_osi, 1 do
    okrag.gora[i] = {}
    okrag.gora[i].srodek_x = przesuniecie + i*2.5*promien
    okrag.gora[i].srodek_y = przesuniecie
    okrag.gora[i].x = nil
    okrag.gora[i].y = nil
    okrag.gora[i].kolor = {math.random(), math.random(), math.random()}
  end

  for i=1, ilosc_okregow_w_osi, 1 do
    okrag.lewa[i] = {}
    okrag.lewa[i].srodek_x = przesuniecie
    okrag.lewa[i].srodek_y = przesuniecie + i*2.5*promien
    okrag.lewa[i].x = nil
    okrag.lewa[i].y = nil
    okrag.lewa[i].kolor = {math.random(), math.random(), math.random()}
  end

  for i=1, ilosc_okregow_w_osi, 1 do
    predkosc[i] = i --prędkość kątowa kolejnych punktów na okręgach zwiększa się
    krzywa[i] = {}
    kolor[i] = {}
    for j=1, ilosc_okregow_w_osi, 1 do
      krzywa[i][j] = {}
      kolor[i][j] = {math.random(), math.random(), math.random()}
    end
  end
end

function love.update(dt)
  rysuj_okregi_podstawowe()
  rysuj_krzywe()
end

function love.draw()
  --Okręgi podstawowe
  for strona, wartosc in pairs(okrag) do
    for i=1, ilosc_okregow_w_osi, 1 do
      love.graphics.setColor(okrag[strona][i].kolor)
      love.graphics.circle("fill", okrag[strona][i].x, okrag[strona][i].y, promien/10, 10)
      love.graphics.circle("line", okrag[strona][i].srodek_x, okrag[strona][i].srodek_y, promien, 30)
    end
  end

  --Okręgi, które połączone
  for i=1, ilosc_okregow_w_osi, 1 do
    for j=1, ilosc_okregow_w_osi, 1 do
      love.graphics.setColor(kolor[i][j])
      love.graphics.circle("fill", okrag.gora[j].x, okrag.lewa[j].y, promien/10, 10)
      if #krzywa[i][j] > 2 then
        love.graphics.line(krzywa[i][j])
      end
    end
  end
end
