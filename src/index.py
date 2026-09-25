from PIL import Image

def clean_exif_data(input_path, output_path):
    with Image.open(input_path) as img:
        # Construct a new Image with the same mode and size and save it to the target path
        clean_img = Image.new(img.mode, img.size)
        clean_img.putdata(list(img.get_flattened_data()))
        clean_img.save(output_path)

if __name__ == "__main__":
    clean_exif_data("photo.jpg", "clean_photo.jpg")