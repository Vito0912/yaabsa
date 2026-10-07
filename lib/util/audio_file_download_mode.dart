enum AudioFileDownloadMode {
  all('All files'),
  custom('Custom'),
  fromCurrent('All files starting from current');

  const AudioFileDownloadMode(this.label);

  final String label;
}
