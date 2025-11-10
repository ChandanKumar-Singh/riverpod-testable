# Contributing to Testable Flutter App

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Style](#code-style)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. We expect all contributors to:

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on what is best for the community
- Show empathy towards other community members

## 🚀 Getting Started

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/testable.git
   cd testable
   ```

2. **Set up the development environment**
   ```bash
   make setup
   ```

3. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   # OR
   git checkout -b fix/your-bug-fix
   ```

## 💻 Development Workflow

### 1. Make Changes

- Create a feature branch from `main` or `develop`
- Make your changes
- Write or update tests
- Update documentation if needed

### 2. Test Your Changes

```bash
# Run tests
make test

# Check code formatting
make format-check

# Analyze code
make analyze

# Run all checks
make check
```

### 3. Commit Your Changes

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Format: <type>(<scope>): <subject>

# Types:
# - feat: New feature
# - fix: Bug fix
# - docs: Documentation changes
# - style: Code style changes (formatting, etc.)
# - refactor: Code refactoring
# - test: Adding or updating tests
# - chore: Maintenance tasks

# Examples:
git commit -m "feat(auth): add biometric authentication"
git commit -m "fix(network): fix token refresh issue"
git commit -m "docs(readme): update installation instructions"
```

### 4. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

## 📝 Code Style

### Dart Style Guide

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `dart format` to format code
- Follow the existing code style in the project

### Naming Conventions

- **Files**: Use snake_case (e.g., `auth_provider.dart`)
- **Classes**: Use PascalCase (e.g., `AuthProvider`)
- **Variables**: Use camelCase (e.g., `userName`)
- **Constants**: Use lowerCamelCase (e.g., `apiBaseUrl`)

### Code Organization

- Keep files focused and single-purpose
- Use meaningful names
- Add comments for complex logic
- Remove unused code and imports

### Example

```dart
// Good
class UserRepository {
  Future<User?> getUserById(String id) async {
    // Implementation
  }
}

// Bad
class UR {
  Future<U?> get(String id) async {
    // Implementation
  }
}
```

## 🧪 Testing

### Writing Tests

- Write tests for all new features
- Write tests for bug fixes
- Aim for high test coverage (>80%)
- Use descriptive test names

### Test Structure

```dart
group('AuthRepository', () {
  test('should return user when login is successful', () async {
    // Arrange
    final repository = AuthRepository(mockRef);
    
    // Act
    final result = await repository.login('email', 'password');
    
    // Assert
    expect(result.isSuccess, true);
    expect(result.data, isNotNull);
  });
});
```

### Running Tests

```bash
# Run all tests
make test

# Run tests with coverage
make test-coverage

# Run specific test file
flutter test test/features/auth/auth_test.dart
```

## 🔍 Pull Request Process

### Before Submitting

1. ✅ All tests pass (`make test`)
2. ✅ Code is formatted (`make format-check`)
3. ✅ Code analysis passes (`make analyze`)
4. ✅ Documentation is updated
5. ✅ Commit messages follow conventions

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests added/updated
- [ ] All tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests added/updated
```

### Review Process

1. **Automated Checks**: CI/CD pipeline runs automatically
2. **Code Review**: At least one maintainer reviews the PR
3. **Feedback**: Address any feedback or requested changes
4. **Merge**: Once approved, the PR will be merged

## 🐛 Reporting Issues

### Before Reporting

1. Check if the issue already exists
2. Check if it's a known issue
3. Try to reproduce the issue
4. Gather relevant information

### Issue Template

```markdown
## Description
Clear and concise description of the issue

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. See error

## Expected Behavior
What you expected to happen

## Actual Behavior
What actually happened

## Environment
- Flutter version: [e.g., 3.8.1]
- Dart version: [e.g., 3.8.1]
- OS: [e.g., iOS 16, Android 13]
- Device: [e.g., iPhone 14, Pixel 7]

## Screenshots
If applicable, add screenshots

## Additional Context
Any other relevant information
```

## 📚 Documentation

### Updating Documentation

- Update README.md for user-facing changes
- Update code comments for API changes
- Update architecture docs for structural changes
- Add examples for new features

### Documentation Style

- Use clear and concise language
- Include code examples
- Add screenshots for UI changes
- Keep documentation up to date

## 🎯 Feature Requests

### Suggesting Features

1. Check if the feature already exists
2. Open an issue with the `enhancement` label
3. Describe the feature and its use case
4. Discuss implementation approach

### Feature Request Template

```markdown
## Feature Description
Clear and concise description of the feature

## Use Case
Why is this feature needed?

## Proposed Solution
How should this feature work?

## Alternatives Considered
Other approaches you considered

## Additional Context
Any other relevant information
```

## 🤝 Getting Help

- **Documentation**: Check the [README.md](README.md) and [docs/](docs/) directory
- **Issues**: Search existing issues or create a new one
- **Discussions**: Use GitHub Discussions for questions
- **Email**: Contact maintainers directly

## 🙏 Thank You!

Thank you for contributing to this project! Your contributions make this project better for everyone.

---

**Happy Coding! 🚀**

