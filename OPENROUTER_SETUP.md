# OpenRouter API Setup Guide

## Getting Started with OpenRouter

OpenRouter provides access to multiple AI models through a single API. This app uses the **Qwen 2.5 Coder** model (free tier).

### 1. Get Your OpenRouter API Key

1. Go to [OpenRouter](https://openrouter.ai/)
2. Sign up or log in
3. Navigate to [API Keys](https://openrouter.ai/keys)
4. Click "Create Key"
5. Copy your API key

### 2. Add API Key to .env File

Create or update the `.env` file in your project root:

```
OPENROUTER_API_KEY=sk-or-v1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Important:** 
- No quotes around the value
- No spaces around the `=` sign
- The file should be named exactly `.env` (with the dot)

### 3. Verify .env File Location

```
mealplanner/
  ├── .env          ← Your API key goes here
  ├── lib/
  ├── pubspec.yaml
  └── ...
```

### 4. Restart Your App

After updating the `.env` file:
1. Stop the app completely
2. Run `flutter clean` (optional but recommended)
3. Run `flutter pub get`
4. Restart the app with `flutter run`

## Using the Free Tier

The app is configured to use **`qwen/qwen-2.5-coder-32b-instruct:free`** which is:
- ✅ **Free** to use
- ✅ Supports **vision** (image analysis)
- ✅ Good for **code and structured output**
- ✅ No credit card required

### Free Tier Limits
- Rate limits may apply
- Check [OpenRouter Pricing](https://openrouter.ai/docs#limits) for current limits

## Alternative Models

You can change the model in `lib/src/ai/ai_constants.dart`:

### Free Models with Vision Support:
```dart
static const String openRouterModel = 'qwen/qwen-2.5-coder-32b-instruct:free';
static const String openRouterModel = 'google/gemini-flash-1.5:free';
static const String openRouterModel = 'meta-llama/llama-3.2-11b-vision-instruct:free';
```

### Paid Models (Better Quality):
```dart
static const String openRouterModel = 'anthropic/claude-3.5-sonnet';
static const String openRouterModel = 'openai/gpt-4-vision-preview';
static const String openRouterModel = 'google/gemini-pro-1.5';
```

## Common Issues and Solutions

### Error: "Invalid API key"
- ✅ Check your API key in `.env` file
- ✅ Make sure it starts with `sk-or-v1-`
- ✅ Verify the key is active on [OpenRouter Keys](https://openrouter.ai/keys)

### Error: "API quota exceeded"
- ✅ You've hit the rate limit
- ✅ Wait a few minutes and try again
- ✅ Consider upgrading to a paid plan

### Error: "Network error"
- ✅ Check your internet connection
- ✅ Verify OpenRouter is accessible from your network
- ✅ Try again in a few moments

### Error: "Failed to parse AI response"
- ✅ The model returned unexpected format
- ✅ Try scanning again
- ✅ Try a different image with clearer food items

### App doesn't load .env file
- ✅ Make sure `.env` is in the project root (not in `lib/`)
- ✅ Restart the app completely (not just hot reload)
- ✅ Check that `flutter_dotenv` is in `pubspec.yaml`
- ✅ Verify `.env` is listed in `assets` in `pubspec.yaml`

## Testing Your Setup

### 1. Check API Key Loading
Add this to your main.dart temporarily:
```dart
print('API Key loaded: ${AIConstants.openRouterApiKey.substring(0, 10)}...');
```

### 2. Test Image Scanning
1. Take a clear photo of some fruits or vegetables
2. Use the scan button in the app
3. Check console for "OpenRouter response:" message
4. Items should be added to your pantry

### 3. Test Recipe Generation
1. Add some items to your pantry
2. Click "Magic Meal" on the home screen
3. Wait for the AI to generate a recipe
4. Recipe should appear with ingredients and instructions

## Image Requirements

For best results when scanning:
- ✅ Use **clear, well-lit** photos
- ✅ Focus on the **food items**
- ✅ Avoid **blurry or dark** images
- ✅ Make sure items are **visible and recognizable**
- ✅ One or more items per image

## Debugging

### Enable Debug Logs
The app already prints debug information:
- Check your console/terminal for:
  - `OpenRouter response: ...`
  - `Chef AI response: ...`
  - Any error messages

### Check API Usage
Visit [OpenRouter Activity](https://openrouter.ai/activity) to see:
- Your API calls
- Token usage
- Any errors from the API side

## Cost Tracking

Even though we're using free models, you can monitor usage:
1. Go to [OpenRouter Activity](https://openrouter.ai/activity)
2. View your request history
3. See token usage per request

## Support

If you're still having issues:
1. Check the [OpenRouter Documentation](https://openrouter.ai/docs)
2. Verify your API key is valid
3. Try a different model
4. Check the console logs for specific error messages

## Model Comparison

| Model | Cost | Vision | Speed | Quality |
|-------|------|--------|-------|---------|
| Qwen 2.5 Coder (free) | Free | ✅ | Fast | Good |
| Gemini Flash 1.5 (free) | Free | ✅ | Fast | Good |
| Claude 3.5 Sonnet | Paid | ✅ | Medium | Excellent |
| GPT-4 Vision | Paid | ✅ | Slow | Excellent |

## Privacy & Security

- ✅ Your API key is stored locally in `.env`
- ✅ Never commit `.env` to version control
- ✅ Images are sent to OpenRouter for processing
- ✅ Check [OpenRouter Privacy Policy](https://openrouter.ai/privacy)
