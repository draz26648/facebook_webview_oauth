# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### Added

- Initial release of Facebook WebView OAuth package
- WebView-based Facebook OAuth authentication
- Support for full Business permissions (bypasses Limited Login)
- Comprehensive error handling with detailed status types
- Built-in Facebook Graph API client with common endpoints
- CSRF protection with state parameter validation
- Configurable timeout and session management
- Support for permission re-requests
- Predefined configuration templates (business, ads-only, basic)
- Extensive unit test coverage
- TypeScript-like models using Freezed
- Debug logging for troubleshooting

### Features

- **Authentication Flow**

  - WebView-based OAuth 2.0 implementation
  - Support for custom redirect URIs
  - Automatic token extraction from URL fragments
  - Multiple fallback methods for token detection
  - Fresh session support (clear cookies/cache)

- **Graph API Integration**

  - Built-in HTTP client using Dio
  - Common endpoints: `/me`, `/me/adaccounts`, `/me/businesses`, `/me/accounts`
  - Automatic error parsing and handling
  - Support for custom Graph API requests
  - Long-lived token exchange functionality

- **Security Features**

  - CSRF protection with state parameter
  - URL validation and sanitization
  - Secure token storage recommendations
  - Protection against mobile redirect issues

- **Developer Experience**
  - Comprehensive documentation
  - Example app with common use cases
  - Detailed error messages and troubleshooting guide
  - TypeScript-like type safety with Freezed models
  - Extensive unit tests

### Dependencies

- `flutter_inappwebview: ^6.0.0` - WebView implementation
- `dio: ^5.3.2` - HTTP client for Graph API
- `freezed_annotation: ^2.4.1` - Code generation annotations
- `json_annotation: ^4.8.1` - JSON serialization

### Supported Platforms

- ✅ iOS 11.0+
- ✅ Android API 19+
- ✅ Web (with limitations)

### Known Limitations

- Web platform has limited WebView capabilities
- Requires Facebook App configuration for production use
- Some permissions require Facebook App Review
- Limited Login bypass requires proper Facebook App setup

---

## Future Releases

### Planned for v1.1.0

- [ ] Support for Facebook Login with Custom Tabs (Android)
- [ ] Enhanced error recovery mechanisms
- [ ] Automatic token refresh functionality
- [ ] Support for Facebook App Events integration
- [ ] Performance optimizations for WebView loading

### Planned for v1.2.0

- [ ] Support for Facebook Marketing API endpoints
- [ ] Batch request functionality for Graph API
- [ ] Enhanced debugging tools and logging
- [ ] Support for Facebook Pixel integration
- [ ] Advanced permission management utilities

---

## Migration Guide

This is the initial release, so no migration is needed.

## Breaking Changes

None in this initial release.

## Security Updates

None in this initial release.

---

**Note**: This changelog follows the [Keep a Changelog](https://keepachangelog.com/) format. Each version documents all notable changes including new features, bug fixes, security updates, and breaking changes.
