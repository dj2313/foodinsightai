# Gemini API Setup Guide

## Common Issues and Solutions

### 1. Check Your API Key

Make sure you have a valid Gemini API key in your `.env` file:

```
GEMINI_API_KEY=your_actual_api_key_here
```

**How to get a Gemini API key:**
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Click "Get API Key"
3. Create a new API key or use an existing one
4. Copy the key and paste it in your `.env` file

### 2. Verify .env File Location

The `.env` file should be in the root of your Flutter project:
```
mealplanner/
  ├── .env          ← Here
  ├── lib/
  ├── pubspec.yaml
  └── ...
```

### 3. Check API Key Format

Your API key should look something like:
```
GEMINI_API_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

**Important:** No quotes, no spaces around the `=` sign.

### 4. Restart Your App

After updating the `.env` file:
1. Stop the app completely
2. Run `flutter clean`
3. Run `flutter pub get`
4. Restart the app

### 5. Check Console Logs

When you scan an image, check the console/debug output for:
- "Gemini response: ..." - This shows the AI's response
- Any error messages that will help diagnose the issue

### 6. Common Error Messages

| Error | Solution |
|-------|----------|
| "Invalid API key" | Check your API key in `.env` file |
| "API quota exceeded" | You've hit the free tier limit, wait or upgrade |
| "Network error" | Check your internet connection |
| "AI returned empty response" | The image might not contain recognizable food items |
| "Failed to parse AI response" | Gemini returned unexpected format, try again |

### 7. Test Your API Key

You can test if your API key works by running this in a Dart file:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  print('API Key loaded: ${dotenv.env['GEMINI_API_KEY']?.substring(0, 10)}...');
}
```

### 8. Image Requirements

For best results:
- Use clear, well-lit photos
- Focus on the food items
- Avoid blurry or dark images
- Make sure food items are visible and recognizable

## Debugging Steps

1. **Check if .env is loaded:**
   - Look for console message on app start
   - API key should not be empty

2. **Check network:**
   - Ensure you have internet connection
   - Gemini API requires internet access

3. **Check image format:**
   - JPEG/PNG images work best
   - Very large images might cause issues

4. **Check console logs:**
   - Look for "Gemini response:" in debug output
   - Check for specific error messages

## Still Having Issues?

If you're still experiencing errors:
1. Check the console output for the exact error message
2. Verify your API key is active in Google AI Studio
3. Make sure you haven't exceeded the free tier quota
4. Try with a different, clearer image
