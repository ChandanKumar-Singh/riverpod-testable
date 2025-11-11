part of 'index.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OnTapScaler(
      child: GestureDetector(
        onTap: () {
          context.maybePop();
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          height: 32,
          width: 32,
          child: Icon(
            Icons.close,
            size: 22,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
