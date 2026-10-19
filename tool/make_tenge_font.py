"""Шрифт из одного знака — тенге «₸».

Основной шрифт приложения (Manrope) знака тенге не знает. В браузере
Flutter тогда сам скачивает запасной шрифт из интернета, и первые
секунды рядом с каждой суммой стоит пустой прямоугольник — ровно там,
куда человек смотрит первым делом. Этот шрифт лежит в самом приложении и
грузится вместе с ним, поэтому знак виден сразу.

Знак простой: две горизонтальные черты и ножка от нижней. Рисуем его
сами — так шрифт целиком наш, без чужих лицензий.

Запуск (нужен fonttools: pip install fonttools):

    python tool/make_tenge_font.py

Получаются assets/fonts/tenge-regular.ttf и tenge-bold.ttf.
"""

from pathlib import Path

from fontTools.fontBuilder import FontBuilder
from fontTools.pens.ttGlyphPen import TTGlyphPen

# Высота прописных у Manrope — около 0,72 кегля: знак стоит вровень с
# цифрами.
CAP = 720
EM = 1000


def rect(pen, x0, y0, x1, y1):
    # TrueType: внешний контур — по часовой стрелке.
    pen.moveTo((x0, y0))
    pen.lineTo((x0, y1))
    pen.lineTo((x1, y1))
    pen.lineTo((x1, y0))
    pen.closePath()


def build(path, weight, stroke, width):
    pen = TTGlyphPen(None)
    left, right = 40, width - 40
    gap = stroke * 3 // 5  # просвет между чертами — чуть уже их самих
    top = (CAP - stroke, CAP)
    second = (CAP - 2 * stroke - gap, CAP - stroke - gap)
    rect(pen, left, top[0], right, top[1])
    rect(pen, left, second[0], right, second[1])
    middle = width // 2
    rect(pen, middle - stroke // 2, 0, middle + stroke - stroke // 2,
         second[0])
    tenge = pen.glyph()

    empty = TTGlyphPen(None).glyph()

    name = 'Tenge'
    style = 'Bold' if weight >= 700 else 'Regular'
    fb = FontBuilder(EM, isTTF=True)
    fb.setupGlyphOrder(['.notdef', 'tenge'])
    fb.setupCharacterMap({0x20B8: 'tenge'})
    fb.setupGlyf({'.notdef': empty, 'tenge': tenge})
    fb.setupHorizontalMetrics({'.notdef': (500, 0), 'tenge': (width, left)})
    # Невысокие подъём и спуск: строка с суммой не должна стать выше
    # соседних из-за одного знака.
    fb.setupHorizontalHeader(ascent=900, descent=-200)
    fb.setupNameTable({'familyName': name, 'styleName': style})
    fb.setupOS2(
        usWeightClass=weight,
        sTypoAscender=900,
        sTypoDescender=-200,
        usWinAscent=900,
        usWinDescent=200,
        sCapHeight=CAP,
        fsSelection=0x20 if style == 'Bold' else 0x40,
    )
    fb.updateHead(macStyle=1 if style == 'Bold' else 0)
    fb.setupPost()
    fb.save(str(path))


if __name__ == '__main__':
    out = Path(__file__).resolve().parent.parent / 'assets' / 'fonts'
    out.mkdir(parents=True, exist_ok=True)
    build(out / 'tenge-regular.ttf', 400, stroke=80, width=620)
    build(out / 'tenge-bold.ttf', 700, stroke=125, width=650)
    print('ok:', out)
