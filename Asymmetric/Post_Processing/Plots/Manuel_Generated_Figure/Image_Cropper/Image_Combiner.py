from PIL import Image
import os

# Liste der Bilddateien
image_files = [
    "cropped_plot_output_1.png",
    "cropped_plot_output_2.png",
    "cropped_plot_output_3.png",
    "cropped_plot_output_4.png",
    "cropped_plot_output_5.png"#,
    #"cropped_plot_output_6.png",
    #"cropped_plot_output_7.png",
    #"cropped_plot_output_8.png"
]

# Bilder laden
images = [Image.open(img) for img in image_files]

# Gesamtbreite berechnen und maximale Höhe bestimmen
total_width = sum(img.width for img in images)
max_height = max(img.height for img in images)

# Neues Bild mit weißem Hintergrund erzeugen
combined_img = Image.new("RGBA", (total_width, max_height), (255, 255, 255, 255))

# Bilder nebeneinander anordnen (oben ausgerichtet)
x_offset = 0
for img in images:
    combined_img.paste(img, (x_offset, 0))  # top aligned
    x_offset += img.width

# Ergebnis speichern
combined_img.save("output_combined.png", "PNG")
