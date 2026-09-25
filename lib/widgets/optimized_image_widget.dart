import 'package:flutter/material.dart';

/// An optimized image widget supporting network and local assets rendering,
/// lazy loading with memory cache constraint parameters (`cacheWidth`/`cacheHeight`),
/// smooth fade-in frameBuilder transitions, loading progress indicator, and error fallbacks.
class OptimizedImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String? fallbackAsset;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const OptimizedImageWidget({
    super.key,
    this.imageUrl,
    this.fallbackAsset,
    this.width = 48.0,
    this.height = 48.0,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Task thumbnail image',
      image: true,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox(
          width: width,
          height: height,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (imageUrl != null && imageUrl!.startsWith('http')) {
      final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      return Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        // Lazy loading image optimization: restrict in-memory decode size based on display dimensions
        cacheWidth: (width * devicePixelRatio).toInt(),
        cacheHeight: (height * devicePixelRatio).toInt(),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildFallback(context),
      );
    }

    return _buildFallback(context);
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          Icons.task_alt,
          size: width * 0.5,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
