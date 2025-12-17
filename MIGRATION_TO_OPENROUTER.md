# Migration from Gemini to OpenRouter - Summary

## ✅ Changes Completed

### 1. Updated Dependencies (`pubspec.yaml`)
- ❌ Removed: `google_generative_ai: ^0.4.7`
- ✅ Added: `http: ^1.2.0`
- ✅ Kept: `uuid: ^4.5.1` (for generating unique IDs)

### 2. Updated AI Constants (`lib/src/ai/ai_constants.dart`)
**Before:**
```dart
static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
static const String geminiModel = 'gemini-2.0-flash-exp';
```

**After:**
```dart
static String get openRouterApiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';
static const String openRouterModel = 'qwen/qwen-2.5-coder-32b-instruct:free';
static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
```

### 3. Rewrote Vision Service (`lib/src/ai/vision_service.dart`)
- ✅ Replaced Google Gemini SDK with OpenRouter HTTP API
- ✅ Converts images to base64 for API requests
- ✅ Supports vision analysis using OpenRouter's chat completions endpoint
- ✅ Better error handling with specific error messages
- ✅ Debug logging for troubleshooting

### 4. Rewrote Chef Service (`lib/src/ai/chef_service.dart`)
- ✅ Replaced Google Gemini SDK with OpenRouter HTTP API
- ✅ Uses same OpenRouter endpoint for recipe generation
- ✅ Maintains same functionality (generates recipes from pantry items)
- ✅ Better error handling

### 5. Created Setup Guide (`OPENROUTER_SETUP.md`)
- ✅ Complete guide for getting OpenRouter API key
- ✅ Instructions for configuring `.env` file
- ✅ Troubleshooting common issues
- ✅ Model comparison and alternatives
- ✅ Testing and debugging tips

## 📋 Required Actions

### 1. Update Your `.env` File
Change from:
```
GEMINI_API_KEY=your_gemini_key_here
```

To:
```
OPENROUTER_API_KEY=sk-or-v1-your_openrouter_key_here
```

### 2. Get OpenRouter API Key
1. Visit [OpenRouter](https://openrouter.ai/)
2. Sign up or log in
3. Go to [API Keys](https://openrouter.ai/keys)
4. Create a new key
5. Copy and paste into `.env` file

### 3. Restart the App
```bash
flutter clean
flutter pub get
flutter run
```

## 🎯 Benefits of OpenRouter

### Advantages:
1. **Free Tier Available** - Qwen 2.5 Coder is completely free
2. **Multiple Models** - Easy to switch between different AI models
3. **Vision Support** - Supports image analysis for food scanning
4. **No Regional Restrictions** - Works globally
5. **Better Rate Limits** - More generous free tier
6. **Unified API** - Access to multiple providers (OpenAI, Anthropic, Google, etc.)

### Model Used:
- **`qwen/qwen-2.5-coder-32b-instruct:free`**
  - ✅ Free to use
  - ✅ Supports vision (image analysis)
  - ✅ Good for structured JSON output
  - ✅ Fast response times
  - ✅ No credit card required

## 🔧 Technical Details

### API Endpoints:
- **Base URL:** `https://openrouter.ai/api/v1`
- **Endpoint:** `/chat/completions` (OpenAI-compatible)

### Request Format:
```json
{
  "model": "qwen/qwen-2.5-coder-32b-instruct:free",
  "messages": [
    {
      "role": "user",
      "content": [
        {"type": "text", "text": "..."},
        {"type": "image_url", "image_url": {"url": "data:image/jpeg;base64,..."}}
      ]
    }
  ]
}
```

### Response Format:
```json
{
  "choices": [
    {
      "message": {
        "content": "JSON response here"
      }
    }
  ]
}
```

## 🐛 Debugging

### Check if API Key is Loaded:
Add to `main.dart`:
```dart
print('OpenRouter API Key: ${AIConstants.openRouterApiKey.substring(0, 10)}...');
```

### Check API Responses:
Look for these in console:
- `OpenRouter response: ...` (from VisionService)
- `Chef AI response: ...` (from ChefService)

### Common Errors:

| Error | Cause | Solution |
|-------|-------|----------|
| "Invalid API key" | Wrong or missing API key | Check `.env` file |
| "API quota exceeded" | Rate limit hit | Wait or upgrade plan |
| "Network error" | No internet | Check connection |
| "Failed to parse" | Unexpected AI response | Try again or different image |

## 📊 Comparison: Gemini vs OpenRouter

| Feature | Gemini | OpenRouter |
|---------|--------|------------|
| Free Tier | Limited | ✅ Generous |
| Vision Support | ✅ Yes | ✅ Yes |
| Regional Availability | Limited | ✅ Global |
| Model Options | Google only | Multiple providers |
| Setup Complexity | Medium | Easy |
| API Stability | Good | ✅ Excellent |

## 🚀 Next Steps

1. ✅ Get OpenRouter API key
2. ✅ Update `.env` file
3. ✅ Restart the app
4. ✅ Test image scanning
5. ✅ Test recipe generation
6. ✅ Monitor usage on [OpenRouter Activity](https://openrouter.ai/activity)

## 📝 Notes

- The app will work exactly the same from a user perspective
- All existing features (scanning, recipe generation) remain unchanged
- Better error messages for easier debugging
- Free tier should be sufficient for personal use
- Can easily switch to paid models if needed

## 🔗 Resources

- [OpenRouter Documentation](https://openrouter.ai/docs)
- [OpenRouter Models](https://openrouter.ai/models)
- [OpenRouter Pricing](https://openrouter.ai/docs#limits)
- [API Keys Management](https://openrouter.ai/keys)
- [Usage Activity](https://openrouter.ai/activity)
