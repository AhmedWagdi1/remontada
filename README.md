# remontada

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Example: `/team/user-teams` Response

The challenges screen determines whether to show team management widgets based
on the user's teams. This information is retrieved from the `/team/user-teams`
endpoint. A typical successful response looks like:

```json
{
  "status": true,
  "message": "تم التحميل بنجاح",
  "data": [
    {
      "id": 25,
      "name": "test team",
      "status": true,
      "logo_url": null,
      "area_id": 6,
      "bio": "new test team",
      "trophies": {"total": 0}
    }
  ]
}
```
