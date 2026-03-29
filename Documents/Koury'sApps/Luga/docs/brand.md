# Luga — Brand & design tokens

## Colors (AppColors constants)
```dart
// core/theme/app_colors.dart

// Primary brand
static const Color primary      = Color(0xFF1A9E92);  // Teal — CTAs, links, active states
static const Color primaryLight = Color(0xFFE0F2EE);  // Teal 50 — light backgrounds
static const Color primaryDark  = Color(0xFF0E7068);  // Teal 600 — hover, pressed

// Accent — ONLY for reward amounts, earnings, payout numbers
static const Color amber        = Color(0xFFF5A623);  // Amber — rewards only
static const Color amberLight   = Color(0xFFFFF4E0);  // Amber 50 — reward bg tint

// Surfaces
static const Color background   = Color(0xFFFFFFFF);  // Page background
static const Color surface      = Color(0xFFF7F8FA);  // Card background, inputs
static const Color surfaceAlt   = Color(0xFFEDEEF0);  // Elevated surface, chips

// Text
static const Color textPrimary   = Color(0xFF1A1D23);  // Headings, important content
static const Color textSecondary = Color(0xFF6B7280);  // Labels, descriptions
static const Color textTertiary  = Color(0xFF9CA3AF);  // Hints, placeholders, timestamps
static const Color textInverse   = Color(0xFFFFFFFF);  // On teal backgrounds

// Borders
static const Color border        = Color(0xFFEDEEF0);  // Default border
static const Color borderStrong  = Color(0xFFC8CAD0);  // Hover / focus border

// Semantic
static const Color success       = Color(0xFF22A559);
static const Color successLight  = Color(0xFFE8F5E9);
static const Color warning       = Color(0xFFF5A623);  // Same as amber
static const Color warningLight  = Color(0xFFFFF3CD);
static const Color danger        = Color(0xFFE53935);
static const Color dangerLight   = Color(0xFFFFEBEE);
static const Color info          = Color(0xFF1565C0);
static const Color infoLight     = Color(0xFFE3F2FD);

// Dark mode surfaces (use with MediaQuery.platformBrightness)
static const Color backgroundDark  = Color(0xFF1A1D23);
static const Color surfaceDark     = Color(0xFF22262E);
static const Color surfaceAltDark  = Color(0xFF2C3038);
```

## Typography (AppTypography constants)
```dart
// core/theme/app_typography.dart
// English: Plus Jakarta Sans | Arabic: IBM Plex Arabic

// Heading 1 — screen titles only
static TextStyle h1(Locale locale) => TextStyle(
  fontFamily: locale.languageCode == 'ar' ? 'IBMPlexArabic' : 'PlusJakartaSans',
  fontSize: 24.sp, fontWeight: FontWeight.w600,
  color: AppColors.textPrimary, height: 1.2,
);

// Heading 2 — section headings
static TextStyle h2(Locale locale) => TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, ...);

// Title — card titles, item names
static TextStyle title(Locale locale) => TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, ...);

// Body — descriptions, chat, content
static TextStyle body(Locale locale) => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, ...);

// Caption — timestamps, labels, hints
static TextStyle caption(Locale locale) => TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400,
  color: AppColors.textTertiary, ...);

// Money — reward amounts, prices (always amber or primary)
static TextStyle money({bool isReward = false}) => TextStyle(
  fontSize: 16.sp, fontWeight: FontWeight.w600,
  color: isReward ? AppColors.amber : AppColors.primary,
  fontFeatures: [FontFeature.tabularFigures()],
);

// Button label
static TextStyle button(Locale locale) => TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500,
  color: AppColors.textInverse, ...);
```

## Spacing (AppSpacing constants)
```dart
// core/theme/app_spacing.dart
static const double xs  = 4;
static const double sm  = 8;
static const double md  = 12;
static const double lg  = 16;
static const double xl  = 24;
static const double xxl = 32;
static const double xxxl = 48;

// Border radii
static const double radiusSm = 6;
static const double radiusMd = 10;   // buttons, inputs
static const double radiusLg = 14;   // cards
static const double radiusXl = 20;   // large cards, modals
static const double radiusFull = 100; // badges, chips (pill shape)
```

## Core components

### LugaButton
```
Primary:   background=AppColors.primary, text=white, height=52.h, radius=radiusMd
Secondary: background=transparent, border=primary, text=primary
Ghost:     background=transparent, no border, text=primary
Danger:    background=AppColors.danger, text=white
Loading:   shows CircularProgressIndicator, ignores onTap
Disabled:  40% opacity
```

### LugaCard
```
background=AppColors.background, border=0.5px AppColors.border,
radius=radiusLg, padding=EdgeInsets.all(AppSpacing.lg)
```

### LugaBadge variants
```
Verified:       background=AppColors.primaryLight, text=AppColors.primary, pill
Trusted:        background=AppColors.amberLight, text=amber, pill
FlightVerified: background=AppColors.primaryLight, icon+text
New:            background=AppColors.surfaceAlt, text=AppColors.textSecondary
```

### LugaRewardBar
```
background=AppColors.surface, border-top=0.5px AppColors.border
height=40.h, padding=horizontal AppSpacing.lg
Left: "Reward" label in AppColors.textSecondary, 11.sp
Right: amount in AppColors.amber, 16.sp, weight 600
```

## Logo
- Primary mark: LUGA wordmark, wide-spaced, teal, route arc above
- Arc: amber dot (origin) → dashed teal line → teal midpoint dot → teal destination dot
- App icon: same mark on teal rounded-rect background
- Never stretch, rotate, or recolor the logo
- Amber is exclusively for the origin dot, reward figures, and earnings — never decorative

## Animation guidelines
- Card entrance: `fadeIn(duration: 300ms)` + `slideY(begin: 0.1)`
- Success state: scale pulse + checkmark draw animation
- Loading to content: shimmer fades out, content fades in (300ms crossfade)
- All animations respect `MediaQuery.disableAnimations`
