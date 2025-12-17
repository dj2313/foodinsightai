# Vision Model Fix - Important Update

## ⚠️ Issue Found

The initial model `qwen/qwen-2.5-coder-32b-instruct:free` **does NOT support vision** (image analysis).

This caused the "Failed to analyze image" error when trying to scan food items.

## ✅ Solution Applied

Changed to: **`google/gemini-flash-1.5:free`**

This model:
- ✅ **Supports vision** (can analyze images)
- ✅ **Free tier** (no cost)
- ✅ **Fast and reliable**
- ✅ **Good at identifying objects** in images

## 🔄 What Changed

**File:** `lib/src/ai/ai_constants.dart`

**Before:**
```dart
static const String openRouterModel = 'qwen/qwen-2.5-coder-32b-instruct:free';
```

**After:**
```dart
static const String openRouterModel = 'google/gemini-flash-1.5:free';
```

## 🎯 Other Free Vision Models

If you want to try alternatives, here are other free models that support vision:

### Option 1: Google Gemini Flash 1.5 (Current - Recommended)
```dart
static const String openRouterModel = 'google/gemini-flash-1.5:free';
```
- ✅ Best for food recognition
- ✅ Fast response
- ✅ Reliable JSON output

### Option 2: Meta Llama 3.2 Vision
```dart
static const String openRouterModel = 'meta-llama/llama-3.2-11b-vision-instruct:free';
```
- ✅ Good vision capabilities
- ⚠️ Slower than Gemini
- ⚠️ May need prompt adjustments

### Option 3: Qwen 2 VL
```dart
static const String openRouterModel = 'qwen/qwen-2-vl-7b-instruct:free';
```
- ✅ Supports vision
- ⚠️ Smaller model (7B parameters)
- ⚠️ May be less accurate

## 📝 How to Switch Models

1. Open `lib/src/ai/ai_constants.dart`
2. Change the `openRouterModel` value
3. Hot restart the app (`R` in terminal)
4. Test scanning again

## 🚀 Next Steps

1. **Hot Restart** your app (press `R` in the terminal)
2. **Try scanning** a food item again
3. **Check console** for debug logs:
   - "Starting image analysis..."
   - "Response status: 200"
   - "OpenRouter response: ..."

## 🐛 Debugging

If you still get errors, check the console for:

### Error: "API Key"
- Your OpenRouter API key is missing or invalid
- Check `.env` file has `OPENROUTER_API_KEY=sk-or-v1-...`

### Error: "quota exceeded"
- You've hit the rate limit
- Wait a few minutes
- Free tier has generous limits but not unlimited

### Error: "Failed to parse"
- The AI returned unexpected format
- Try a clearer image
- Try a different model

## 📊 Model Comparison

| Model | Vision | Speed | Accuracy | Best For |
|-------|--------|-------|----------|----------|
| Gemini Flash 1.5 | ✅ | ⚡⚡⚡ | ⭐⭐⭐⭐ | Food recognition |
| Llama 3.2 Vision | ✅ | ⚡⚡ | ⭐⭐⭐ | General vision |
| Qwen 2 VL | ✅ | ⚡⚡ | ⭐⭐ | Basic vision |
| Qwen 2.5 Coder | ❌ | ⚡⚡⚡ | N/A | Code only (no vision) |

## ✨ Why This Works

**Gemini Flash 1.5** via OpenRouter:
- Same underlying model as Google's Gemini API
- Accessed through OpenRouter's unified interface
- No regional restrictions
- Free tier available
- Excellent at vision tasks

## 🔗 Resources

- [OpenRouter Models](https://openrouter.ai/models)
- [Model Capabilities](https://openrouter.ai/docs#models)
- [Vision Models List](https://openrouter.ai/models?supported_parameters=vision)
