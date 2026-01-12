from PIL import Image

# Liste der Bilddateien (mittleres Bild NICHT anzeigen -> einfach weglassen)
image_files = [
    "cropped_plot_output_1.png",
    "cropped_plot_output_2.png",
    # "cropped_plot_output_3.png",  # mittleres Bild wird übersprungen
    "cropped_plot_output_4.png",
    "cropped_plot_output_5.png"
]

# Bilder laden
images = [Image.open(img) for img in image_files]

# Breite und Höhe annehmen: wir nehmen die maximale Breite und Höhe der Bilder
max_width = max(img.width for img in images)
max_height = max(img.height for img in images)

# Wir wollen ein 2x2 Layout
cols, rows = 2, 2

# Neue Gesamtgröße berechnen
total_width = cols * max_width
total_height = rows * max_height

# Neues Bild mit weißem Hintergrund erzeugen
combined_img = Image.new("RGBA", (total_width, total_height), (255, 255, 255, 255))

# Bilder in ein 2x2 Raster einfügen
for idx, img in enumerate(images):
    col = idx % cols
    row = idx // cols
    x_offset = col * max_width
    y_offset = row * max_height
    combined_img.paste(img, (x_offset, y_offset))

# Ergebnis speichern
combined_img.save("output_combined_2x2.png", "PNG")
