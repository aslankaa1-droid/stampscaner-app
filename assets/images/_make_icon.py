"""
Generates StampScaner brand icon set.
Run: python _make_icon.py
Outputs:
  icon.png              — 1024x1024 composed icon
  icon_foreground.png   — transparent bg + S motif (for Android adaptive)
  icon_background.png   — solid burgundy (for Android adaptive)
  splash.png            — 1024x1024 splash artwork
"""
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import math, os, sys

SZ = 1024
BURGUNDY = (107, 31, 46)         # #6B1F2E
BURGUNDY_DEEP = (77, 21, 32)     # #4D1520
GOLD = (184, 146, 76)            # #B8924C
GOLD_LIGHT = (217, 185, 122)     # #D9B97A
CREAM = (245, 237, 220)          # #F5EDDC
INK = (26, 20, 16)


def load_serif_font(px):
    candidates = [
        r"C:\Windows\Fonts\georgiab.ttf",
        r"C:\Windows\Fonts\georgia.ttf",
        r"C:\Windows\Fonts\timesbd.ttf",
        r"C:\Windows\Fonts\times.ttf",
    ]
    for p in candidates:
        if os.path.exists(p):
            return ImageFont.truetype(p, px)
    return ImageFont.load_default()


def draw_perforated_border(img, color, padding=70, dot_r=14, gap=42):
    """Cuts perforation-style holes around a square stamp border."""
    draw = ImageDraw.Draw(img)
    w, h = img.size
    inner = padding
    # corners + sides — circles biting into the stamp body
    for x in range(inner, w - inner, gap):
        for y in (inner - dot_r, h - inner - dot_r):
            draw.ellipse([x - dot_r, y, x + dot_r, y + 2 * dot_r],
                         fill=color)
    for y in range(inner, h - inner, gap):
        for x in (inner - dot_r, w - inner - dot_r):
            draw.ellipse([x, y - dot_r, x + 2 * dot_r, y + dot_r],
                         fill=color)


def make_icon():
    img = Image.new('RGBA', (SZ, SZ), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Outer rounded corner background — burgundy gradient simulation
    margin = 32
    inset = SZ - margin * 2

    # Solid burgundy field
    draw.rounded_rectangle(
        [margin, margin, SZ - margin, SZ - margin],
        radius=180,
        fill=BURGUNDY,
    )

    # Inner stamp frame — gold outline
    stamp_pad = 110
    draw.rounded_rectangle(
        [stamp_pad, stamp_pad, SZ - stamp_pad, SZ - stamp_pad],
        radius=24,
        outline=GOLD,
        width=8,
    )

    # Subtle highlight gradient (top-left)
    overlay = Image.new('RGBA', (SZ, SZ), (0, 0, 0, 0))
    odraw = ImageDraw.Draw(overlay)
    odraw.rounded_rectangle(
        [margin, margin, SZ - margin, SZ - margin],
        radius=180,
        fill=(255, 220, 180, 38),
    )
    overlay = overlay.filter(ImageFilter.GaussianBlur(120))
    img = Image.alpha_composite(img, overlay)
    draw = ImageDraw.Draw(img)

    # Big serif "S" — Cormorant-ish via Georgia Bold
    font = load_serif_font(620)
    text = 'S'
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    tx = (SZ - tw) // 2 - bbox[0]
    ty = (SZ - th) // 2 - bbox[1] - 30
    # Soft shadow
    shadow = Image.new('RGBA', (SZ, SZ), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).text((tx + 6, ty + 10), text,
                                font=font, fill=(0, 0, 0, 140))
    shadow = shadow.filter(ImageFilter.GaussianBlur(16))
    img = Image.alpha_composite(img, shadow)
    draw = ImageDraw.Draw(img)
    draw.text((tx, ty), text, font=font, fill=CREAM)

    # Magnifier on bottom-right (subtle, premium hint)
    cx, cy, r = int(SZ * 0.72), int(SZ * 0.74), 110
    draw.ellipse([cx - r, cy - r, cx + r, cy + r],
                 outline=GOLD_LIGHT, width=18)
    # Handle
    hx1, hy1 = int(cx + r * 0.7), int(cy + r * 0.7)
    hx2, hy2 = int(cx + r * 1.35), int(cy + r * 1.35)
    draw.line([(hx1, hy1), (hx2, hy2)], fill=GOLD_LIGHT, width=22)

    # Perforation
    draw_perforated_border(img, BURGUNDY_DEEP, padding=stamp_pad + 18,
                           dot_r=18, gap=58)

    img.save('icon.png', 'PNG')
    print('icon.png saved', img.size)
    return img


def make_foreground():
    """Transparent foreground for Android adaptive."""
    img = Image.new('RGBA', (SZ, SZ), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    font = load_serif_font(520)
    text = 'S'
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    tx = (SZ - tw) // 2 - bbox[0]
    ty = (SZ - th) // 2 - bbox[1] - 20
    draw.text((tx, ty), text, font=font, fill=CREAM)

    # Gold underline
    uw = int(SZ * 0.18)
    ux = (SZ - uw) // 2
    uy = ty + th + 36
    draw.rectangle([ux, uy, ux + uw, uy + 10], fill=GOLD)

    img.save('icon_foreground.png', 'PNG')
    print('icon_foreground.png saved')


def make_background():
    img = Image.new('RGBA', (SZ, SZ), BURGUNDY + (255,))
    img.save('icon_background.png', 'PNG')
    print('icon_background.png saved')


def make_splash():
    img = Image.new('RGBA', (SZ, SZ), CREAM + (255,))
    draw = ImageDraw.Draw(img)

    # Centered burgundy stamp medallion ~ 60% of canvas
    pad = int(SZ * 0.22)
    draw.rounded_rectangle([pad, pad, SZ - pad, SZ - pad],
                           radius=44, fill=BURGUNDY)
    draw.rounded_rectangle([pad + 24, pad + 24, SZ - pad - 24, SZ - pad - 24],
                           radius=20, outline=GOLD, width=6)

    font = load_serif_font(360)
    text = 'S'
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    draw.text(((SZ - tw) // 2 - bbox[0],
               (SZ - th) // 2 - bbox[1] - 20),
              text, font=font, fill=CREAM)

    # Tagline
    tag_font = load_serif_font(56)
    tag = 'STAMPSCANER'
    tbbox = draw.textbbox((0, 0), tag, font=tag_font)
    tw = tbbox[2] - tbbox[0]
    draw.text(((SZ - tw) // 2 - tbbox[0], int(SZ * 0.82)),
              tag, font=tag_font, fill=BURGUNDY)

    img.save('splash.png', 'PNG')
    print('splash.png saved')


if __name__ == '__main__':
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    make_icon()
    make_foreground()
    make_background()
    make_splash()
    print('Done.')
