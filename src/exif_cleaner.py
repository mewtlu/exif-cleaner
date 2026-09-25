from PIL import Image
import io

# input can either be a file path or a file-like object
def clean_exif_data(input):
    with Image.open(input) as img:
        # Construct a new Image with the same mode and size, and save it to the target path
        clean_img = Image.new(img.mode, img.size)
        clean_img.putdata(list(img.get_flattened_data()))
        return clean_img