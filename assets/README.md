# Assets Folder

This folder contains the TensorFlow Lite models and label files required for object detection.

## Required Files

### 1. TFLite Model (`assets/models/`)

You need to place your TensorFlow Lite model file here.

**Recommended model:** `ssd_mobilenet.tflite`

#### Where to get the model:

1. **TensorFlow Hub**:
   - Visit: https://tfhub.dev/
   - Search for "SSD MobileNet" or "Object Detection"
   - Download the TFLite model

2. **Pre-trained Models**:
   - SSD MobileNet V1: https://storage.googleapis.com/download.tensorflow.org/models/tflite/coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip
   - Download and extract, then place the `.tflite` file in `assets/models/`

3. **Custom Model**:
   - Train your own model using TensorFlow
   - Convert it to TFLite format
   - Place it in `assets/models/`

### 2. Labels File (`assets/labels/`)

You need to place a `labels.txt` file here containing the object class names.

**File format:** One label per line

```
person
bicycle
car
motorcycle
...
```

#### Where to get labels:

1. **COCO Labels** (for SSD MobileNet):
   - Download from: https://storage.googleapis.com/download.tensorflow.org/models/tflite/coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip
   - Extract and rename `labelmap.txt` to `labels.txt`
   - Place it in `assets/labels/`

2. **Custom Labels**:
   - If you trained a custom model, create a text file with your class names
   - One name per line
   - Save as `labels.txt` in `assets/labels/`

## Quick Start

### Option 1: Download Pre-trained Model

```bash
# 1. Download the model
cd assets/models
curl -O https://storage.googleapis.com/download.tensorflow.org/models/tflite/coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip

# 2. Extract
unzip coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip

# 3. Rename the model file
mv detect.tflite ssd_mobilenet.tflite

# 4. Move labels
cd ../labels
mv ../models/labelmap.txt labels.txt
```

### Option 2: Manual Download

1. Go to the TensorFlow model repository
2. Download your preferred object detection model
3. Place the `.tflite` file in `assets/models/` and rename it to `ssd_mobilenet.tflite`
4. Place the corresponding labels file in `assets/labels/` and name it `labels.txt`

## Updating Model Path

If you use a different model name, update the path in `lib/utils/constants.dart`:

```dart
static const String modelPath = 'assets/models/your_model_name.tflite';
```

## Supported Models

This app works with:

- SSD MobileNet (recommended for mobile devices)
- YOLO models (converted to TFLite)
- Custom trained models
- Any TFLite object detection model

## Notes

- Model file should be in `.tflite` format
- Larger models provide better accuracy but slower inference
- For children's app, prioritize speed over extreme accuracy
- Test different models to find the best balance
