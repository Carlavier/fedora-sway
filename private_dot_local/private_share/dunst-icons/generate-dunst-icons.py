import subprocess
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

output = Path.home() / ".local/share/dunst-icons"
output.mkdir(parents=True, exist_ok=True)

font_name = "JetBrainsMono Nerd Font"
font_path = subprocess.check_output(
    ["fc-match", "-f", "%{file}", font_name], text=True
).strip()

font = ImageFont.truetype(font_path, 64)

icons = {
    "notification": "\uf0f3",
    "info": "\uf05a",
    "warning": "\uf071",
    "error": "\uf06a",
    "success": "\uf00c",
    "download": "\uf019",
    "volume": "\uf028",
    "battery": "\uf240",
    "bluetooth": "\uf293",
    "wifi": "\uf1eb",
}

for name, glyph in icons.items():
    image = Image.new("RGBA", (96, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)

    bbox = draw.textbbox((0, 0), glyph, font=font)
    x = (96 - (bbox[2] - bbox[0])) / 2 - bbox[0]
    y = (96 - (bbox[3] - bbox[1])) / 2 - bbox[1]

    draw.text((x, y), glyph, font=font, fill="#ffffff")
    image.save(output / f"{name}.png")

print(f"Generated icons in {output}")
