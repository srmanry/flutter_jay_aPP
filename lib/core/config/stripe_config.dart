const stripePublishableKey = String.fromEnvironment(
  'STRIPE_PUBLISHABLE_KEY',
  defaultValue: 'pk_live_51T9zEpRn7K6s01eQWZEdMVnAMELdRmaqOI5Ny1pMfnkPRFiaY3KkrY2jj1nHiDkOlUg2zng4UOReOOGKup3LVc7700yvnWyVI6',
);
const stripeMerchantIdentifier = String.fromEnvironment('STRIPE_MERCHANT_IDENTIFIER', defaultValue: 'merchant.com.example.spotem');
const stripeUrlScheme = String.fromEnvironment('STRIPE_URL_SCHEME', defaultValue: 'stripe');

bool get hasValidStripePublishableKey {
  final key = stripePublishableKey.trim();
  return key.startsWith('pk_test_') || key.startsWith('pk_live_');
}
