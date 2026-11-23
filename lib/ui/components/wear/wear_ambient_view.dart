import 'package:material_ui/material_ui.dart';

class WearAmbientView extends StatelessWidget {
  const WearAmbientView({this.title, this.author, this.nowOverride, super.key});

  final String? title;
  final String? author;
  final DateTime? nowOverride;

  @override
  Widget build(BuildContext context) {
    final now = nowOverride ?? DateTime.now();
    final time = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final mediaTitle = title?.trim();
    final mediaAuthor = author?.trim();

    return SizedBox.expand(
      child: Material(
        color: Colors.black,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.16,
                vertical: constraints.maxHeight * 0.16,
              ),
              child: Center(
                child: Transform.translate(
                  offset: Offset((now.minute % 3 - 1) * 2.0, (now.minute ~/ 3 % 3 - 1) * 2.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 26,
                          fontWeight: FontWeight.w300,
                          height: 1.1,
                          color: Colors.white70,
                        ),
                      ),
                      if (mediaTitle != null && mediaTitle.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Flexible(
                          child: Text(
                            mediaTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 12,
                              height: 1.3,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                      if (mediaAuthor != null && mediaAuthor.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            mediaAuthor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 12,
                              height: 1.3,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
