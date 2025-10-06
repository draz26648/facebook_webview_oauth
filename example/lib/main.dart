import 'package:flutter/material.dart';
import 'package:facebook_webview_oauth/facebook_webview_oauth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook OAuth Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const FacebookOAuthExample(),
    );
  }
}

class FacebookOAuthExample extends StatefulWidget {
  const FacebookOAuthExample({super.key});

  @override
  State<FacebookOAuthExample> createState() => _FacebookOAuthExampleState();
}

class _FacebookOAuthExampleState extends State<FacebookOAuthExample> {
  // Replace with your Facebook App ID
  static const String facebookAppId = 'YOUR_FACEBOOK_APP_ID';
  static const String facebookConfigId = 'YOUR_CONFIG_ID'; // Optional

  String? _accessToken;
  Duration? _tokenExpiresIn;
  Set<String> _grantedScopes = {};
  Set<String> _declinedScopes = {};
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>>? _adAccounts;
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Facebook OAuth Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Login Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Facebook Authentication',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    if (_accessToken == null) ...[
                      const Text(
                        'Click the button below to authenticate with Facebook using WebView OAuth.',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _performFacebookLogin,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.login),
                        label: Text(
                          _isLoading
                              ? 'Authenticating...'
                              : 'Login with Facebook',
                        ),
                      ),
                    ] else ...[
                      const Text(
                        '✅ Successfully authenticated with Facebook!',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Token expires in: ${_tokenExpiresIn?.inHours ?? 0} hours',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Error:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Permissions Section
            if (_grantedScopes.isNotEmpty || _declinedScopes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Permissions',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      if (_grantedScopes.isNotEmpty) ...[
                        const Text(
                          'Granted Permissions:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _grantedScopes
                              .map(
                                (scope) => Chip(
                                  label: Text(scope),
                                  backgroundColor: Colors.green.shade100,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      if (_declinedScopes.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Declined Permissions:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _declinedScopes
                              .map(
                                (scope) => Chip(
                                  label: Text(scope),
                                  backgroundColor: Colors.orange.shade100,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            // User Data Section
            if (_userData != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Information',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      if (_userData!['picture'] != null) ...[
                        Center(
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              _userData!['picture']['data']['url'],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      _buildInfoRow('Name', _userData!['name']),
                      _buildInfoRow('Email', _userData!['email']),
                      _buildInfoRow('ID', _userData!['id']),
                      if (_userData!['first_name'] != null)
                        _buildInfoRow('First Name', _userData!['first_name']),
                      if (_userData!['last_name'] != null)
                        _buildInfoRow('Last Name', _userData!['last_name']),
                    ],
                  ),
                ),
              ),
            ],

            // Ad Accounts Section
            if (_adAccounts != null && _adAccounts!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ad Accounts (${_adAccounts!.length})',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      ...(_adAccounts!
                          .take(3)
                          .map(
                            (account) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: const Icon(Icons.account_balance),
                                title: Text(account['name'] ?? 'Unknown'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ID: ${account['id']}'),
                                    Text(
                                      'Status: ${account['account_status'] ?? 'Unknown'}',
                                    ),
                                    if (account['currency'] != null)
                                      Text('Currency: ${account['currency']}'),
                                  ],
                                ),
                                isThreeLine: true,
                              ),
                            ),
                          )),
                      if (_adAccounts!.length > 3)
                        Text(
                          '... and ${_adAccounts!.length - 3} more accounts',
                        ),
                    ],
                  ),
                ),
              ),
            ],

            // Configuration Info
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuration',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'To use this example app:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Replace YOUR_FACEBOOK_APP_ID with your actual Facebook App ID',
                    ),
                    const Text(
                      '2. Configure your Facebook App with the correct OAuth redirect URI',
                    ),
                    const Text(
                      '3. Add your app domains to Facebook App settings',
                    ),
                    const Text(
                      '4. Request necessary permissions through Facebook App Review',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Current Configuration:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('App ID: $facebookAppId'),
                    Text('Config ID: $facebookConfigId'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  Future<void> _performFacebookLogin() async {
    if (facebookAppId == 'YOUR_FACEBOOK_APP_ID') {
      setState(() {
        _error =
            'Please replace YOUR_FACEBOOK_APP_ID with your actual Facebook App ID';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Configure OAuth parameters
      final params = FacebookWebAuthConfigs.business(
        clientId: facebookAppId,
        configId: facebookConfigId.isNotEmpty ? facebookConfigId : null,
        // Optional: Use custom redirect URI instead of Facebook's default
        // redirectUri: 'https://yourdomain.com/auth/facebook/callback',
        freshSession: true,
        timeout: const Duration(minutes: 5),
      );

      // Perform authentication
      final result = await FacebookWebAuth().signIn(params, context: context);

      await result.when(
        success: (accessToken, expiresIn, grantedScopes, declinedScopes) async {
          setState(() {
            _accessToken = accessToken;
            _tokenExpiresIn = expiresIn;
            _grantedScopes = grantedScopes;
            _declinedScopes = declinedScopes;
          });

          // Fetch user data and ad accounts
          await _fetchFacebookData(accessToken);
        },
        cancelled: (error) {
          setState(() {
            _error = 'Authentication cancelled: ${error ?? "User cancelled"}';
          });
        },
        error: (error) {
          setState(() {
            _error = 'Authentication error: ${error ?? "Unknown error"}';
          });
        },
        permissionsDeclined: (declined, error) {
          setState(() {
            _error = 'Required permissions declined: ${declined.join(", ")}';
          });
        },
        timeout: (error) {
          setState(() {
            _error = 'Authentication timeout: ${error ?? "Request timed out"}';
          });
        },
        stateMismatch: (error) {
          setState(() {
            _error = 'Security error: ${error ?? "State mismatch"}';
          });
        },
      );
    } catch (e) {
      setState(() {
        _error = 'Unexpected error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchFacebookData(String accessToken) async {
    try {
      final client = FacebookGraphClient(accessToken: accessToken);

      // Get user information
      final userData = await client.getMe(
        fields:
            'id,name,email,picture.width(200).height(200),first_name,last_name',
      );

      // Get ad accounts if permission is granted
      List<Map<String, dynamic>>? adAccounts;
      if (_grantedScopes.contains('ads_management') ||
          _grantedScopes.contains('ads_read')) {
        try {
          final adAccountsResponse = await client.getAdAccounts(
            fields: 'id,name,account_status,currency,timezone_name',
            limit: 10,
          );
          adAccounts = List<Map<String, dynamic>>.from(
            adAccountsResponse['data'] ?? [],
          );
        } catch (e) {
          print('Failed to fetch ad accounts: $e');
        }
      }

      client.close();

      setState(() {
        _userData = userData;
        _adAccounts = adAccounts;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch Facebook data: $e';
      });
    }
  }

  void _logout() {
    setState(() {
      _accessToken = null;
      _tokenExpiresIn = null;
      _grantedScopes = {};
      _declinedScopes = {};
      _userData = null;
      _adAccounts = null;
      _error = null;
    });
  }
}
