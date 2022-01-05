--[[
KRZYWE - WERSJA PODSTAWOWA

Program rysujący krzywe Lissajous.

Tworzymy dwa okręgi, po których krążą punkty, każdy z tych punktów ma inną
dowolną prędkość. Za pomocą tych punktów będziemy rysować kolejny "wypadkowy"
kształt. Polega to na tym, że z jednego podstawowego punktu bierzemy
współrzędną X, a z drugiego współrzędną Y i tworzymy kształt wypadkowy.

Najlepiej zacząć od stworzenia okręgu na górze i po lewej stronie,
a dopiero potem przejść do tworzenia krzywej.
]]

-----------------------SETUP--------------------
kat = 0
wielkosc_okna = 400
ilosc_okregow = 1 --W wersji podstawowej zmienna ma zawsze wartość 1
szybkosc_gornego = 1
szybkosc_lewego = 4

------------------FUNKCJE GŁÓWNE----------------
function love.load()
  love.window.setMode(wielkosc_okna, wielkosc_okna)
  love.window.setTitle("Krzywe wersja podstawowa")
  math.randomseed(os.time())
  love.graphics.setLineJoin("none") --opcja dzięki, której linia będzie poprawnie
  --narysowana bez żadnych artefaktów

  --Tablice
  szybkosc = {}
  --Obliczamy jaki powinien być promień okręgu,żeby zmieścił się w oknie.
  promien = wielkosc_okna/(5.5*ilosc_okregow) --obliczamy promień okręgu
  przesuniecie = 1.5*promien --dla 1 okręgu jest to po prostu x środka okręgu

  ----------------------OSIE--------------------
  okrag = {}
  --Będziemy opisywać okręgi na górze i po lewej stronie
  --Należy napisać gdzie mają znaleźć się ich środki - srodek_x i srodek_y,
  --dobrać przypadkowy kolor oraz stworzyć miejsce na zapis pozycji punktu,
  --który będzie krążył po okręgu

    --------------------OŚ GÓRNA------------------
    okrag.gora = {}
    okrag.gora.srodek_x = przesuniecie + 2.5*promien
    okrag.gora.srodek_y = przesuniecie
    okrag.gora.x = nil
    okrag.gora.y = nil
    okrag.gora.kolor = {math.random(), math.random(), math.random()}

    --UWAGA!
    --Prędkość musi być zawsze liczbą całkowitą dzięki temu uzyskujemy krotność
    --2*math.pi, ponieważ 2*pi radianów to pełen obrót, co omawialiśmy już na
    --zajęciach.
    szybkosc.gora = szybkosc_gornego

    ---------------------OŚ LEWA------------------
    okrag.lewa = {}
    okrag.lewa.srodek_x = przesuniecie
    okrag.lewa.srodek_y = przesuniecie + 2.5*promien
    okrag.lewa.x = nil
    okrag.lewa.y = nil
    okrag.lewa.kolor = {math.random(), math.random(), math.random()}
    szybkosc.lewa = szybkosc_lewego

  ----------------KRZYWA----------------
  --W poniższej tablicy będziemy zbierać punkty opisujące krzywą
  krzywa = {}
  kolor_krzywej = {math.random(), math.random(), math.random()}
end

function love.update(dt)
  kat = kat + 0.01 --Zwiększamy kąt -> obrót

  --poniżej wykorzystujemy pairs() do wylicznia stronay, czyli "gora" i "lewa"
  for strona, wartosc in pairs(okrag) do
    --Opisujemy ruch po okręgu punktów na osiach
    okrag[strona].x = okrag[strona].srodek_x + promien*math.sin(szybkosc[strona] * kat)
    okrag[strona].y = okrag[strona].srodek_y + promien*math.cos(szybkosc[strona] * kat)
  end

  if kat - 0.1 <= 2*math.pi then --Punktów nie trzeba dodawać w nieskończoność
  --Po przekroczeniu maksymalnego kąta, czyli 2*math.pi, można zakończyć
  --dodawanie kolejnych punktów

    --Doczepiamy kolejne punkty do tabeli, w której znajdują się wszystkie punkty
    --tworzonego kształu. Punkty muszą być podane w odpowiedniej kolejności
    --krzywa = {x1, y1, x2, y2, x3, y3} <- w ten sposób
    table.insert(krzywa, okrag.gora.x)
    table.insert(krzywa, okrag.lewa.y)
  end

end

function love.draw()
  --Okręgi podstawowe
  for strona, wartosc in pairs(okrag) do
      love.graphics.setColor(okrag[strona].kolor) --ustawiamy wcześniej wybrany kolor
      --Rysujemy punkt krążący po okręgu
      love.graphics.circle("fill", okrag[strona].x, okrag[strona].y, promien/10, 10)
      --oraz sam okrąg
      love.graphics.circle("line", okrag[strona].srodek_x, okrag[strona].srodek_y, promien, 30)
  end

  --Stworzony kształt
  love.graphics.setColor(kolor_krzywej)
  love.graphics.circle('fill', okrag.gora.x, okrag.lewa.y, promien/10, 10) --punkt

  if #krzywa > 2 then --Zaczynamy rysować dopierow wtedy kiedy
    --mamy do dyspozycji ponad dwa punkty
    love.graphics.line(krzywa) --kształt stworzony
  end
end
