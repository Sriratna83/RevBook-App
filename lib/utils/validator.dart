enum validatorImage {
  fieldEmpty,
  notUrl,
  notImage,
  valid,
}

List<String> errorString = [
  "This field empty!",
  "It isn't valid url.",
  "It isn't valid image.",
];

validatorImage isUrlImage(String url) {
  if (url.isEmpty) return validatorImage.fieldEmpty;
  if (!url.startsWith('https') || !url.startsWith('http')) {
    return validatorImage.notUrl;
  }
  return validatorImage.valid;
}
