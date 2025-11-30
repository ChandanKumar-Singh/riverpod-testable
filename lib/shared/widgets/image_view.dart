// lib/shared/widgets/image_view.dart
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

/// Perfect for production apps.
class ImageView extends StatefulWidget {
  const ImageView(
    this.source, {
    super.key,
    this.width,
    this.height,
    this.aspectRatio,

    this.fit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
    this.radius = 12,
    this.borderRadius,

    this.color,
    this.blur,
    this.shadow,

    this.showShimmer = true,
    this.showLoadingIndicator = false,
    this.enableFadeAnimation = true,

    this.onTap,
    this.overlay,
    this.placeholder,
    this.errorWidget,

    this.retryOnError = true,
    this.enableZoomViewer = false,
    this.heroTag,
  });
  final String? source;

  final double? width;
  final double? height;
  final double? aspectRatio;

  final BoxFit fit;
  final double radius;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  final Color? color;
  final double? blur;
  final List<BoxShadow>? shadow;

  final bool showShimmer;
  final bool showLoadingIndicator;
  final bool enableFadeAnimation;

  final VoidCallback? onTap;
  final Widget? overlay;
  final Widget? placeholder;
  final Widget? errorWidget;

  final bool retryOnError;
  final bool enableZoomViewer;
  final String? heroTag;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  int _retryNonce = 0;
  bool _assetError = false;
  bool _svgError = false;
  bool _lottieError = false;
  bool _fileError = false;

  bool get _isEmpty => widget.source == null || widget.source!.trim().isEmpty;
  bool get _isNetwork => !_isEmpty && widget.source!.startsWith('http');
  bool get _isSvg => !_isEmpty && widget.source!.toLowerCase().endsWith('.svg');
  bool get _isLottie =>
      !_isEmpty && widget.source!.toLowerCase().endsWith('.json');
  bool get _isAsset =>
      !_isNetwork &&
      !_isSvg &&
      !_isLottie &&
      widget.source!.startsWith('assets/');

  BorderRadius get _effectiveRadius => widget.shape == BoxShape.circle
      ? BorderRadius.zero
      : widget.borderRadius ?? BorderRadius.circular(widget.radius);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final cacheW = _cacheDimension(constraints.maxWidth);
        final cacheH = _cacheDimension(constraints.maxHeight);

        Widget child = _buildCore(
          ctx,
          cacheW ?? widget.width,
          cacheH ?? widget.height,
        );

        if (widget.blur != null && widget.blur! > 0) {
          child = ClipRRect(
            borderRadius: _effectiveRadius,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: widget.blur!,
                sigmaY: widget.blur!,
              ),
              child: child,
            ),
          );
        }

        if (widget.overlay != null) {
          child = Stack(
            fit: StackFit.passthrough,
            children: [
              child,
              Positioned.fill(child: widget.overlay!),
            ],
          );
        }

        if (widget.heroTag != null) {
          child = Hero(tag: widget.heroTag!, child: child);
        }

        if (widget.onTap != null || widget.enableZoomViewer) {
          child = InkWell(
            borderRadius: _effectiveRadius,
            onTap: () {
              widget.onTap?.call();
              if (widget.enableZoomViewer) _openZoom(ctx);
            },
            child: child,
          );
        }

        if (widget.aspectRatio != null) {
          child = AspectRatio(aspectRatio: widget.aspectRatio!, child: child);
        }

        return child;
      },
    );
  }

  int? _cacheDimension(double size) {
    if (size <= 0 || size.isInfinite || size.isNaN) return null;
    return size.toInt();
  }

  Widget _buildCore(BuildContext ctx, num? cw, num? ch) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        shape: widget.shape,
        borderRadius: widget.shape == BoxShape.circle ? null : _effectiveRadius,
        boxShadow: widget.shadow,
      ),
      clipBehavior: Clip.hardEdge,
      child: _buildType(ctx, cw?.toInt(), ch?.toInt()),
    );
  }

  Widget _buildType(BuildContext ctx, int? cw, int? ch) {
    if (_isEmpty) return _errorBox(ctx, 'Invalid Image');

    // Handle errors first
    if (_assetError && _isAsset) return _errorBox(ctx, 'Asset not found');
    if (_svgError && _isSvg) return _errorBox(ctx, 'SVG load failed');
    if (_lottieError && _isLottie) return _errorBox(ctx, 'Lottie load failed');
    if (_fileError && !_isAsset && !_isNetwork && !_isSvg && !_isLottie) {
      return _errorBox(ctx, 'File not found');
    }

    if (_isLottie) {
      return _buildLottie();
    }

    if (_isSvg) {
      return _buildSvg(cw, ch);
    }

    if (_isAsset) {
      return _buildAsset(cw, ch);
    }

    if (_isNetwork) {
      return _networkImage(ctx, cw, ch);
    }

    return _buildFile(cw, ch);
  }

  Widget _buildLottie() {
    return Lottie.asset(
      widget.source!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        _lottieError = true;
        return _errorBox(context, 'Lottie Error: ${error.toString()}');
      },
    );
  }

  Widget _buildSvg(int? cw, int? ch) {
    return Builder(
      builder: (context) {
        final isDark = Theme.brightnessOf(context) == Brightness.dark;
        return SvgPicture.asset(
          widget.source!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          colorFilter: widget.color != null
              ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
              : isDark
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : null,
          placeholderBuilder: (context) => _placeholder(),
        );
      },
    );
  }

  Widget _buildAsset(int? cw, int? ch) {
    return _fadeWrap(
      Image.asset(
        widget.source!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        color: widget.color,
        cacheWidth: cw,
        cacheHeight: ch,
        errorBuilder: (context, error, stackTrace) {
          _assetError = true;
          return _errorBox(context, 'Asset Error: ${error.toString()}');
        },
      ),
    );
  }

  Widget _buildFile(int? cw, int? ch) {
    return _fadeWrap(
      Image.file(
        File(widget.source!),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        color: widget.color,
        cacheWidth: cw,
        cacheHeight: ch,
        errorBuilder: (context, error, stackTrace) {
          _fileError = true;
          return _errorBox(context, 'File Error: ${error.toString()}');
        },
      ),
    );
  }

  Widget _networkImage(BuildContext ctx, int? cw, int? ch) {
    final url = widget.source!;
    return CachedNetworkImage(
      imageUrl: url,
      memCacheWidth: cw,
      memCacheHeight: ch,
      imageBuilder: (ctx, provider) {
        return _fadeWrap(
          Image(
            image: provider,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            errorBuilder: (context, error, stackTrace) {
              return _retryBox(ctx, url, 'Network Error: ${error.toString()}');
            },
          ),
        );
      },
      placeholder: (_, __) {
        if (widget.showLoadingIndicator) return _loading();
        if (widget.showShimmer) return _shimmer();
        return _placeholder();
      },
      errorWidget: (_, url, error) {
        return widget.errorWidget ??
            _retryBox(ctx, url, 'Network Error: ${error.toString()}');
      },
    );
  }

  Widget _fadeWrap(Widget child) {
    if (!widget.enableFadeAnimation) return child;
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      child: child,
      builder: (_, v, c) => Opacity(opacity: v, child: c),
    );
  }

  Widget _shimmer() => Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: _placeholder(),
  );

  Widget _loading() => const Center(
    child: SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );

  Widget _placeholder() =>
      widget.placeholder ??
      ColoredBox(
        color: Colors.grey.shade200,
        child: const Center(child: Icon(Icons.image, color: Colors.grey)),
      );

  Widget _errorBox(BuildContext ctx, String message) {
    // Use custom error widget if provided
    if (widget.errorWidget != null) return widget.errorWidget!;

    return ColoredBox(
      color: Colors.grey.shade300,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 32),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'message',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _retryBox(BuildContext ctx, String url, String message) {
    if (!widget.retryOnError) {
      return _errorBox(ctx, message);
    }

    return InkWell(
      onTap: () async {
        // Reset error states
        _assetError = false;
        _svgError = false;
        _lottieError = false;
        _fileError = false;

        // Clear network cache
        if (_isNetwork) {
          await CachedNetworkImage.evictFromCache(url);
        }

        if (mounted) setState(() => _retryNonce++);
      },
      child: ColoredBox(
        color: Colors.grey.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.refresh, color: Colors.red, size: 32),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tap to retry',
                style: TextStyle(color: Colors.blue, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openZoom(BuildContext ctx) {
    final imageChild = _zoomImage();

    Navigator.push(
      ctx,
      PageRouteBuilder(
        opaque: true,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    maxScale: 5,
                    minScale: 0.5,
                    child: imageChild,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
              ],
            ),
          ),
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  Widget _zoomImage() {
    if (_isNetwork) {
      return CachedNetworkImage(
        imageUrl: widget.source!,
        errorWidget: (context, url, error) =>
            _errorBox(context, 'Zoom: $error'),
      );
    }
    if (_isSvg) {
      return SvgPicture.asset(
        widget.source!,
        placeholderBuilder: (context) => _placeholder(),
      );
    }
    if (_isLottie) {
      return Lottie.asset(
        widget.source!,
        errorBuilder: (context, error, stackTrace) =>
            _errorBox(context, 'Zoom: $error'),
      );
    }
    if (_isAsset) {
      return Image.asset(
        widget.source!,
        errorBuilder: (context, error, stackTrace) =>
            _errorBox(context, 'Zoom: $error'),
      );
    }
    return Image.file(
      File(widget.source!),
      errorBuilder: (context, error, stackTrace) =>
          _errorBox(context, 'Zoom: $error'),
    );
  }

  @override
  void didUpdateWidget(ImageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset error states when source changes
    if (widget.source != oldWidget.source) {
      _assetError = false;
      _svgError = false;
      _lottieError = false;
      _fileError = false;
    }
  }
}
