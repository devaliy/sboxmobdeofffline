"""One-off build-time script: generates the SuccessBOX app-icon master art.

The source logo (sboxscreens/SuccessBOX-Logo.png) is only 212x56px -- a
horizontal wordmark lockup, and far too low-res to upscale into a crisp
1024x1024 app icon. Instead we draw a clean vector monogram in the brand
palette (Ink Navy -> Brand Blue diagonal, Signal Orange glyph) at full
resolution, so every generated launcher icon size is crisp.

Run once from repo root: python tool/gen_icon.py
"""
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import math

SIZE = 1024
NAVY = (0x23, 0x28, 0x42)
NAVY_DEEP = (0x18, 0x1B, 0x2E)
BLUE = (0x2E, 0x4C, 0x9A)
ORANGE = (0xFF, 0x7A, 0x1A)
ORANGE_LIGHT = (0xFF, 0xA2, 0x4C)
WHITE = (0xFF, 0xFF, 0xFF)


def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def diagonal_gradient(size, c1, c2):
    img = Image.new("RGB", (size, size))
    px = img.load()
    for y in range(size):
        for x in range(size):
            t = (x + y) / (2 * size)
            px[x, y] = lerp(c1, c2, t)
    return img


def rounded_mask(size, radius):
    mask = Image.new("L", (size, size), 0)
    d = ImageDraw.Draw(mask)
    d.rounded_rectangle([0, 0, size - 1, size - 1], radius=radius, fill=255)
    return mask


def build_icon(with_bg: bool, out_path: str):
    pad = int(SIZE * 0.0)
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))

    if with_bg:
        bg = diagonal_gradient(SIZE, NAVY_DEEP, BLUE).convert("RGBA")
        mask = rounded_mask(SIZE, int(SIZE * 0.22))
        canvas.paste(bg, (0, 0), mask)
        glow = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
        gd = ImageDraw.Draw(glow)
        cx, cy, r = int(SIZE * 0.5), int(SIZE * 0.42), int(SIZE * 0.34)
        gd.ellipse([cx - r, cy - r, cx + r, cy + r], fill=(*ORANGE, 90))
        glow = glow.filter(ImageFilter.GaussianBlur(SIZE * 0.06))
        canvas.alpha_composite(glow)

    # Monogram: a stylised upward "S" flame / open-book chevron built from
    # three overlapping rounded diamonds climbing left->right, echoing the
    # crown-like strokes in the source logo, rendered in an orange gradient.
    glyph = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glyph)
    cx = SIZE * 0.5
    base_y = SIZE * 0.66
    heights = [0.30, 0.44, 0.36]
    xs = [SIZE * 0.315, SIZE * 0.5, SIZE * 0.685]
    widths = [0.17, 0.20, 0.17]
    for i, (x, h, w) in enumerate(zip(xs, heights, widths)):
        top = base_y - SIZE * h
        half_w = SIZE * w / 2
        color = lerp(ORANGE_LIGHT, ORANGE, i / 2)
        gd.rounded_rectangle(
            [x - half_w, top, x + half_w, base_y],
            radius=int(half_w * 0.9),
            fill=(*color, 255),
        )
    # baseplate bar (the "shelf" under the strokes, nods to the bookshelf motif)
    bar_h = SIZE * 0.06
    gd.rounded_rectangle(
        [SIZE * 0.26, base_y - SIZE * 0.02, SIZE * 0.74, base_y - SIZE * 0.02 + bar_h],
        radius=int(bar_h * 0.5),
        fill=(*WHITE, 255) if with_bg else (*NAVY, 255),
    )
    canvas.alpha_composite(glyph)

    canvas.save(out_path)
    print("wrote", out_path, canvas.size)


if __name__ == "__main__":
    build_icon(True, "assets/branding/app_icon_master.png")
    build_icon(False, "assets/branding/app_icon_foreground.png")
