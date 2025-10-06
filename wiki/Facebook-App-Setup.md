# Facebook App Setup

This guide walks you through setting up your Facebook App to work with the Facebook WebView OAuth package. Proper configuration is crucial for successful authentication and avoiding Limited Login restrictions.

## 🏗️ Creating a Facebook App

### 1. Access Facebook Developers

1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Log in with your Facebook account
3. Click **"My Apps"** in the top navigation
4. Click **"Create App"**

### 2. Choose App Type

Select the appropriate app type based on your needs:

- **Business**: For business applications (recommended for most use cases)
- **Consumer**: For consumer-facing applications
- **Gaming**: For gaming applications

### 3. Basic App Information

Fill in the required information:

```
App Name: Your App Name
App Contact Email: your-email@example.com
Business Account: Select your business account (if applicable)
```

## 🔧 Configure Facebook Login

### 1. Add Facebook Login Product

1. In your app dashboard, click **"Add Product"**
2. Find **"Facebook Login"** and click **"Set Up"**
3. Choose **"Web"** as your platform

### 2. Configure OAuth Settings

Navigate to **Facebook Login > Settings** and configure:

#### Valid OAuth Redirect URIs

Add the following redirect URIs:

**For Default Configuration:**

```
https://www.facebook.com/connect/login_success.html
```

**For Custom Redirect URI:**

```
https://yourdomain.com/auth/facebook/callback
```

**For Development/Testing:**

```
https://localhost:3000/auth/facebook/callback
http://localhost:3000/auth/facebook/callback
```

#### Client OAuth Settings

Configure the following settings:

- ✅ **Use Strict Mode for Redirect URIs**: Enabled
- ✅ **Enforce HTTPS**: Enabled (for production)
- ✅ **Embedded Browser OAuth Login**: Enabled
- ❌ **Login from Devices**: Disabled (unless needed)

### 3. App Domains (Required for Custom Redirect URIs)

If using custom redirect URIs, add your domain to **Settings > Basic > App Domains**:

```
yourdomain.com
localhost (for development)
```

## 🔐 Business Verification (Production)

For production apps requiring business permissions, complete business verification:

### 1. Business Verification Process

1. Go to **Settings > Basic**
2. Scroll to **Business Verification**
3. Click **"Start Verification"**
4. Provide required business documents:
   - Business license
   - Tax documents
   - Proof of business address

### 2. Required Information

- Legal business name
- Business address
- Business phone number
- Business website
- Tax ID or business registration number

## 📋 Permission Configuration

### 1. Basic Permissions (No Review Required)

These permissions are available immediately:

- `public_profile` - Basic profile information
- `email` - User's email address

### 2. Business Permissions (May Require Review)

For business features, you may need to request:

- `ads_management` - Manage ads and ad accounts
- `ads_read` - Read ads and ad account data
- `business_management` - Manage business assets
- `pages_show_list` - Access list of pages
- `instagram_basic` - Basic Instagram access

### 3. App Review Process

For permissions requiring review:

1. Go to **App Review > Permissions and Features**
2. Request the required permissions
3. Provide detailed use case descriptions
4. Submit screencast demonstrating usage
5. Wait for Facebook's review (typically 3-7 days)

## ⚙️ Advanced Configuration

### 1. App Configuration ID (Recommended)

To avoid Limited Login, create an App Configuration:

1. Go to **Facebook Login > Settings**
2. Scroll to **App Configuration**
3. Click **"Create Configuration"**
4. Configure the following:

```json
{
  "name": "Business Configuration",
  "description": "Configuration for business users",
  "permissions": [
    "public_profile",
    "email",
    "ads_management",
    "ads_read",
    "business_management"
  ]
}
```

5. Copy the **Configuration ID** for use in your app

### 2. Rate Limiting

Configure rate limiting in **Settings > Advanced**:

- **API Version**: Use the latest stable version (v18.0+)
- **Rate Limiting**: Enable for production apps

### 3. Security Settings

Configure security settings in **Settings > Advanced**:

- ✅ **Require App Secret**: Enabled
- ✅ **Client IP Whitelist**: Configure for production
- ✅ **Server IP Whitelist**: Configure for server-side calls

## 🧪 Testing Configuration

### 1. Test Users

Create test users for development:

1. Go to **Roles > Test Users**
2. Click **"Create Test Users"**
3. Generate test users with required permissions
4. Use test users during development

### 2. Development Mode

While in development mode:

- App is only accessible to developers, testers, and test users
- No app review required for most permissions
- Limited to 100 users

### 3. Switching to Live Mode

Before going live:

1. Complete business verification (if required)
2. Get necessary permissions approved
3. Test thoroughly with test users
4. Switch app to **Live** mode in **Settings > Basic**

## 📱 Platform-Specific Setup

### iOS Configuration

Add the following to your Facebook App:

1. Go to **Settings > Basic**
2. Click **"+ Add Platform"**
3. Select **"iOS"**
4. Configure:

```
Bundle ID: com.yourcompany.yourapp
iPhone Store ID: (if published)
iPad Store ID: (if published)
```

### Android Configuration

Add Android platform:

1. Click **"+ Add Platform"**
2. Select **"Android"**
3. Configure:

```
Package Name: com.yourcompany.yourapp
Class Name: com.yourcompany.yourapp.MainActivity
Key Hashes: (generate using keytool)
```

Generate key hash:

```bash
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
```

## 🔍 Verification Checklist

Before using your Facebook App:

- [ ] Facebook Login product added and configured
- [ ] Valid OAuth redirect URIs added
- [ ] App domains configured (if using custom redirect URIs)
- [ ] Required permissions requested/approved
- [ ] Business verification completed (if required)
- [ ] App Configuration ID created (recommended)
- [ ] Test users created for development
- [ ] Platform-specific settings configured
- [ ] App switched to Live mode (for production)

## 🚨 Common Configuration Issues

### Issue 1: "Invalid Redirect URI"

**Problem**: OAuth fails with redirect URI error.

**Solutions**:

- Ensure redirect URI exactly matches configuration
- Check for trailing slashes or extra parameters
- Verify HTTPS is used for production

### Issue 2: "App Not Setup for Facebook Login"

**Problem**: Facebook Login product not properly configured.

**Solutions**:

- Add Facebook Login product to your app
- Configure OAuth settings properly
- Ensure app is in correct mode (Development/Live)

### Issue 3: "Permission Denied"

**Problem**: App doesn't have required permissions.

**Solutions**:

- Request permissions through App Review
- Use App Configuration ID to avoid Limited Login
- Ensure business verification is complete

### Issue 4: "Domain Not Allowed"

**Problem**: Custom redirect URI domain not allowed.

**Solutions**:

- Add domain to App Domains in Settings > Basic
- Ensure domain is verified and accessible
- Check domain format (no http/https prefix)

## 📖 Configuration Examples

### Basic Configuration

```dart
final params = FacebookWebAuthConfigs.basic(
  clientId: 'your_facebook_app_id',
);
```

### Business Configuration

```dart
final params = FacebookWebAuthConfigs.business(
  clientId: 'your_facebook_app_id',
  configId: 'your_app_configuration_id', // From Facebook App settings
);
```

### Custom Configuration

```dart
final params = FacebookWebAuthConfigs.custom(
  clientId: 'your_facebook_app_id',
  scopes: [
    'public_profile',
    'email',
    'ads_management',
    'business_management',
  ],
  configId: 'your_app_configuration_id',
  redirectUri: 'https://yourdomain.com/auth/facebook/callback',
);
```

## 🔄 Next Steps

After completing Facebook App setup:

1. **[Quick Start](Quick-Start)** - Implement authentication in your app
2. **[Configuration Options](Configuration-Options)** - Customize authentication flow
3. **[Custom Redirect URIs](Custom-Redirect-URIs)** - Use your own domain

## 🆘 Need Help?

For Facebook App setup issues:

1. Check [Facebook Developer Documentation](https://developers.facebook.com/docs/)
2. Visit [Facebook Developer Community](https://developers.facebook.com/community/)
3. Review our [FAQ](FAQ) for common solutions
4. Contact support: [mohamed.draz1198@gmail.com](mailto:mohamed.draz1198@gmail.com)
