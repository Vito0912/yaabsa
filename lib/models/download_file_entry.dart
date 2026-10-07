class DownloadFileEntry {
  const DownloadFileEntry({
    required this.inode,
    required this.name,
    required this.downloaded,
    required this.kind,
    this.size,
    this.audioIndex,
  });

  final String inode;
  final String name;
  final bool downloaded;
  final String kind;
  final int? size;
  final int? audioIndex;
}

typedef DownloadFileLocation = ({String path, String? sidecarPath, String? fileKey});
