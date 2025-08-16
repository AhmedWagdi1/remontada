# Development Workflow

## Getting Started
1. Ensure FVM is installed and Flutter stable version is available
2. Run `fvm flutter pub get` to install dependencies
3. Check `env.json` configuration for environment variables
4. Verify Firebase configuration is properly set up

## Common Development Tasks
- **Hot Reload**: Use `r` in terminal during `fvm flutter run`
- **Hot Restart**: Use `R` in terminal during `fvm flutter run`
- **Debug**: Use `fvm flutter run --debug` for development
- **Profile**: Use `fvm flutter run --profile` for performance testing
- **Release**: Use `fvm flutter run --release` for production testing

## Code Generation
- Run `fvm flutter packages pub run build_runner build` if using code generation
- Use `--delete-conflicting-outputs` flag to resolve conflicts

## Debugging Tips
- Use `flutter_smart_dialog` for user notifications
- Implement proper error handling with BLoC
- Use `pretty_dio_logger` to debug network requests
- Check device permissions with `permission_handler`

## Performance Monitoring
- Use Flutter Inspector for widget tree analysis
- Monitor memory usage during development
- Test on different device sizes using responsive_framework
- Verify smooth animations and transitions