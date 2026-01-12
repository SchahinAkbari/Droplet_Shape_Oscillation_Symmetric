from PIL import Image, ImageChops, ImageOps
import os

def crop_image_auto(input_path, output_path, background_color=(255, 255, 255), margin_percent=25):
    img = Image.open(input_path).convert("RGB")

    bg = Image.new("RGB", img.size, background_color)
    diff = ImageChops.difference(img, bg)
    bbox = diff.getbbox()

    if bbox:
        cropped_img = img.crop(bbox)

        # 5% Rand wieder hinzufügen
        width, height = cropped_img.size
        margin_x = int(width * margin_percent / 100)
        margin_y = int(height * margin_percent / 300)
        padded_img = ImageOps.expand(cropped_img, border=(margin_x, margin_y), fill=background_color)

        padded_img.save(output_path)
        print(f"[OK] Gespeichert: {output_path}")
    else:
        print(f"⚠️  Kein Zuschnitt nötig: {input_path}")

def crop_all_png_in_folder(folder_path):
    for filename in os.listdir(folder_path):
        if filename.lower().endswith(".png"):
            input_path = os.path.join(folder_path, filename)
            output_path = os.path.join(folder_path, "cropped_" + filename)
            crop_image_auto(input_path, output_path)

# 🟢 Hauptaufruf
if __name__ == "__main__":
    current_folder = os.path.dirname(os.path.abspath(__file__))  # aktueller Ordner
    crop_all_png_in_folder(current_folder)
