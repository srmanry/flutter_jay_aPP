const stripePublishableKey = String.fromEnvironment(
  'STRIPE_PUBLISHABLE_KEY',
  defaultValue: 'pk_test_51T9JeuF7p5AHhj5P2I04wlApjrEhZQm5GIVZQ9FQ52OEf7thLpxVPtzNDsQlxDBtBEp6sH3YL8zrzDIXBwLONokZ00SLItVqhE',
);
const stripeMerchantIdentifier = String.fromEnvironment('STRIPE_MERCHANT_IDENTIFIER', defaultValue: 'merchant.com.example.spotem');
const stripeUrlScheme = String.fromEnvironment('STRIPE_URL_SCHEME', defaultValue: 'stripe');

bool get hasValidStripePublishableKey {
  final key = stripePublishableKey.trim();
  return key.startsWith('pk_test_') || key.startsWith('pk_live_');
}
