part of './index.dart';

class ObscureTextField extends TextFormField {
  ObscureTextField({
    super.key,
    super.controller,
    String? labelText,
    String? hintText,
    super.initialValue,
    bool initiallyObscured = true,
    super.textInputAction,
    super.onFieldSubmitted,
    super.onSaved,
    super.validator,
    bool super.enabled = true,
    super.autofocus,
    super.autocorrect,
    super.enableSuggestions,
    super.maxLines,
    super.minLines,
    super.maxLength,
    EdgeInsetsGeometry? contentPadding,
    InputBorder? border,
    Widget? prefixIcon,
    List<String>? autofillHints,
    super.focusNode,
    super.style,
    super.obscuringCharacter,
  }) : super(
         obscureText: initiallyObscured,
         autofillHints: autofillHints ?? const [AutofillHints.password],
         decoration: InputDecoration(
           labelText: labelText,
           hintText: hintText,
           contentPadding:
               contentPadding ??
               const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
           border: border ?? InputBorder.none,
           prefixIcon: prefixIcon ?? const Icon(Iconsax.lock),
           suffixIcon: _PasswordVisibilityIcon(
             initiallyObscured: initiallyObscured,
           ),
         ),
       );
}

class _PasswordVisibilityIcon extends StatefulWidget {
  const _PasswordVisibilityIcon({required this.initiallyObscured});
  final bool initiallyObscured;

  @override
  State<_PasswordVisibilityIcon> createState() =>
      _PasswordVisibilityIconState();
}

class _PasswordVisibilityIconState extends State<_PasswordVisibilityIcon> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.initiallyObscured;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _obscured ? Iconsax.eye_slash : Iconsax.eye,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onPressed: () {
        setState(() {
          _obscured = !_obscured;
        });

        // Find the ancestor TextFormField and update its obscureText
        final field = context.findAncestorWidgetOfExactType<TextFormField>();
        if (field != null) {
          // This is a bit tricky since obscureText is final in TextFormField
          // We need to use a different approach
          _updateParentObscureText(!_obscured);
        }
      },
    );
  }

  void _updateParentObscureText(bool obscure) {
    // Since we can't directly modify the parent TextFormField's obscureText,
    // we'll use a callback approach or rebuild the parent
    // For now, we'll use a custom approach with InheritedWidget-like pattern
    final state = context.findAncestorStateOfType<_ObscureTextFieldState>();
    state?.updateObscureText(obscure);
  }
}

// Alternative implementation with more control:
class ObscureTextField2 extends StatefulWidget {
  const ObscureTextField2({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.initiallyObscured = true,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.enabled = true,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.contentPadding,
    this.border,
    this.prefixIcon,
    this.autofillHints,
    this.focusNode,
    this.style,
    this.obscuringCharacter = '*',
    this.onVisibilityChanged,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final bool initiallyObscured;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final Widget? prefixIcon;
  final List<String>? autofillHints;
  final FocusNode? focusNode;
  final TextStyle? style;
  final String obscuringCharacter;
  final ValueChanged<bool>? onVisibilityChanged;

  @override
  State<ObscureTextField2> createState() => _ObscureTextFieldState();
}

class _ObscureTextFieldState extends State<ObscureTextField2> {
  late bool _obscured;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscured = widget.initiallyObscured;
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    // Only dispose the controller if we created it
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void updateObscureText(bool obscure) {
    setState(() {
      _obscured = obscure;
    });
    widget.onVisibilityChanged?.call(obscure);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      obscureText: _obscured,
      obscuringCharacter: widget.obscuringCharacter,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      validator: widget.validator,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      focusNode: widget.focusNode,
      style: widget.style,
      autofillHints: widget.autofillHints ?? const [AutofillHints.password],
      onTapOutside: (_) => primaryFocus?.unfocus(),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: widget.border ?? InputBorder.none,
        prefixIcon: widget.prefixIcon ?? const Icon(Iconsax.lock),
        suffixIcon: IconButton(
          key: const Key('obscure_field_key'),
          icon: Icon(
            _obscured ? Iconsax.eye_slash : Iconsax.eye,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            updateObscureText(!_obscured);
          },
        ),
      ),
    );
  }
}

// Even simpler version using a custom suffix icon builder:
class ObscureTextField3 extends TextFormField {
  ObscureTextField3({
    super.key,
    super.controller,
    String? labelText,
    String? hintText,
    super.initialValue,
    bool initiallyObscured = true,
    super.textInputAction,
    super.onFieldSubmitted,
    super.onSaved,
    super.validator,
    bool super.enabled = true,
    super.autofocus,
    super.autocorrect,
    super.enableSuggestions,
    super.maxLines,
    super.minLines,
    super.maxLength,
    EdgeInsetsGeometry? contentPadding,
    InputBorder? border,
    Widget? prefixIcon,
    List<String>? autofillHints,
    super.focusNode,
    super.style,
    super.obscuringCharacter,
    ValueChanged<bool>? onVisibilityChanged,
  }) : super(
         obscureText: initiallyObscured,
         autofillHints: autofillHints ?? const [AutofillHints.password],
         decoration: InputDecoration(
           labelText: labelText,
           hintText: hintText,
           contentPadding:
               contentPadding ??
               const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
           border: border ?? InputBorder.none,
           prefixIcon: prefixIcon ?? const Icon(Iconsax.lock),
           suffixIcon: _ObscureSuffixIcon(
             initiallyObscured: initiallyObscured,
             onVisibilityChanged: onVisibilityChanged,
           ),
         ),
       );
}

class _ObscureSuffixIcon extends StatefulWidget {
  const _ObscureSuffixIcon({
    required this.initiallyObscured,
    this.onVisibilityChanged,
  });
  final bool initiallyObscured;
  final ValueChanged<bool>? onVisibilityChanged;

  @override
  State<_ObscureSuffixIcon> createState() => _ObscureSuffixIconState();
}

class _ObscureSuffixIconState extends State<_ObscureSuffixIcon> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.initiallyObscured;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _obscured ? Iconsax.eye_slash : Iconsax.eye,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onPressed: () {
        setState(() {
          _obscured = !_obscured;
        });

        // Notify parent about visibility change
        widget.onVisibilityChanged?.call(_obscured);

        // This approach requires the parent to rebuild with new obscureText
        // For a truly self-contained solution, use ObscureTextField2
      },
    );
  }
}
