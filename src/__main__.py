from exif_cleaner import clean_exif_data

if __name__ == '__main__':
    # Clean the image
    output = clean_exif_data('photo.jpg')

    # Save to disk for easy testing
    output.save('clean_photo.jpg')
