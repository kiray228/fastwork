"""Рисует иконки приложения — и для телефона, и для сайта.

Зачем скриптом, а не руками в редакторе.

Иконок нужно одиннадцать штук: Android хочет пять размеров, браузер — свои,
iPhone — свой. Нарисовать их по одной несложно; трудно потом поменять цвет и
не забыть ни одну. Здесь картинка описана один раз, а размеры получаются
из неё — как «набрано» считается из откликов, а не хранится отдельно.

Запуск:  python3 tool/make_icons.py
"""

from PIL import Image, ImageDraw

# Фирменные цвета — те же, что в lib/theme/app_colors.dart.
BRAND = (15, 163, 107)      # изумрудный
BRAND_DARK = (11, 122, 80)  # он же потемнее, для перехода
WHITE = (255, 255, 255)

# Молния в квадрате 100×100. Точки обходят её контур по часовой стрелке.
# Держим фигуру ближе к середине: у маскируемых иконок Android обрезает
# края, и то, что у самого борта, просто не увидят.
BOLT = [
    (63, 10), (27, 57), (49, 57), (39, 90), (73, 43), (51, 43),
]


def draw(size, *, rounded):
    """Одна иконка нужного размера.

    `rounded` — скруглять ли углы самим. Для сайта скругляем: там иконку
    показывают как есть. Для Android и iPhone — нет: система обрежет её
    под свою форму, и наше скругление дало бы двойную рамку.
    """
    # Рисуем крупно и уменьшаем: так края получаются гладкими.
    # Приём называется сглаживанием через увеличение.
    scale = 4
    big = size * scale
    image = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    canvas = ImageDraw.Draw(image)

    box = [0, 0, big, big]
    if rounded:
        canvas.rounded_rectangle(box, radius=int(big * 0.22), fill=BRAND)
    else:
        canvas.rectangle(box, fill=BRAND)

    # Лёгкий переход цвета снизу: плоская заливка выглядит мёртвой.
    shade = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    ImageDraw.Draw(shade).rectangle([0, big // 2, big, big], fill=BRAND_DARK)
    image = Image.alpha_composite(image, _fade(shade, big))

    canvas = ImageDraw.Draw(image)
    canvas.polygon([(x / 100 * big, y / 100 * big) for x, y in BOLT],
                   fill=WHITE)

    return image.resize((size, size), Image.LANCZOS)


def _fade(shade, big):
    """Делает нижнюю половину полупрозрачной сверху вниз."""
    alpha = Image.new('L', (big, big), 0)
    pixels = alpha.load()
    for y in range(big // 2, big):
        # 0 в середине картинки и до 70 у нижнего края.
        value = int((y - big / 2) / (big / 2) * 70)
        for x in range(big):
            pixels[x, y] = value
    shade.putalpha(alpha)
    return shade


def save(image, path):
    image.save(path)
    print(path)


# --- сайт: обычные и маскируемые -------------------------------------------
for size in (192, 512):
    save(draw(size, rounded=True), f'web/icons/Icon-{size}.png')
    save(draw(size, rounded=False), f'web/icons/Icon-maskable-{size}.png')

# Значок вкладки в браузере.
save(draw(64, rounded=True), 'web/favicon.png')

# iPhone добавляет своё скругление, поэтому отдаём квадрат.
save(draw(180, rounded=False), 'web/icons/apple-touch-icon.png')

# --- Android: по иконке на каждую плотность экрана -------------------------
# mdpi — самые редкие экраны, xxxhdpi — самые плотные. Одна картинка на всех
# смотрелась бы мылом на хороших экранах и тормозила бы на слабых.
for folder, size in [
    ('mdpi', 48), ('hdpi', 72), ('xhdpi', 96),
    ('xxhdpi', 144), ('xxxhdpi', 192),
]:
    save(draw(size, rounded=False),
         f'android/app/src/main/res/mipmap-{folder}/ic_launcher.png')
