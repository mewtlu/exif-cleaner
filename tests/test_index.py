import pytest
from PIL import Image
from exif_cleaner import clean_exif_data

# Creates a temporary JPEG image with EXIF data for use in tests.
@pytest.fixture
def image_with_exif(tmp_path: Path) -> Path:
    img_path = tmp_path / "input_with_exif.jpg"

    # Create a sample image, 100x100px, solid red
    img = Image.new("RGB", (100, 100), color="red")

    # Manually add some raw EXIF data
    exif_data = img.getexif()
    exif_data[0x0110] = "Example Camera" # Model
    exif_data[0x0131] = "EXIF Cleaner"   # Software

    # Save image with EXIF data
    img.save(img_path, exif=exif_data.tobytes())

    # Verify the test fixture actually contains some EXIF data
    with Image.open(img_path) as verify_img:
        assert verify_img.getexif(), "Failed to create fixture image, EXIF was not written."

    return img_path

# Tests the clean_exif_data function
def test_clean_exif_data(image_with_exif: Path, tmp_path: Path):
    output_path = tmp_path / "output_clean.jpg"

    # Run the function to clean EXIF data
    clean_exif_data(image_with_exif, output_path)

    # Assert that the output file has been created with no EXIF data
    assert output_path.exists()
    with Image.open(output_path) as clean_img:
        exif = clean_img.getexif()
        assert len(exif) == 0