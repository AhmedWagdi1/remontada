# Flutter Development Best Practices

## Code Organization
- Follow BLoC pattern for state management
- Use get_it for dependency injection
- Organize widgets in separate files for reusability
- Keep business logic separate from UI components

## Performance Guidelines
- Use `const` constructors wherever possible
- Implement proper disposal in StatefulWidgets
- Use `flutter_screenutil` for responsive design
- Cache network images with `cached_network_image`

## Asset Management
- Place images in `assets/images/`
- Store translations in `assets/translations/`
- Use `flutter_svg` for vector graphics
- Optimize image sizes for different screen densities

## Testing
- Write unit tests for business logic
- Use widget tests for UI components
- Test BLoC states and events
- Mock external dependencies with get_it

## Localization
- Use `easy_localization` for internationalization
- Keep translation keys organized and descriptive
- Test app in different languages during development