# AgroScan model update guide

The raw training dataset does not belong inside the Flutter application. Keep it
in a separate training workspace so the mobile app stays small.

## Files that change after retraining

1. `assets/plant_disease_model.tflite`
   - Exported TensorFlow Lite model.
2. `assets/plant_disease_labels.txt`
   - One class label per line, in the exact output-index order used by the model.
3. Firebase collection `Diseases`
   - Each disease document ID must exactly match its label in the labels file
     (currently: `Bacteria`, `Fungi`, `Healthy`, `Nematode`, `Pest`,
     `Phytophthora`, `Virus`).
   - Expected string fields: `Cultural Practices` and `Chemical Control`.
4. Firebase collection `Soil Condition`
   - Document ID = crop / plant name (prefer Title Case, e.g. `Potato`).
   - Expected string field: `condition` (legacy key `Soil Condition` is also
     accepted by the app).
   - Add or revise the supported crop document when the crop scope changes.
5. Firebase collection `Logs`
   - Document ID = Firebase Auth UID.
   - Field `log`: array of maps with `plantType` (string), `moistureLevel`,
     `nutrientLevel`, and `pesticideVolume` (numbers).

## Safe replacement order

1. Audit and clean the selected dataset.
2. Split original images into training, validation and test sets before applying
   augmentation.
3. Train and evaluate the model.
4. Export the final model to TensorFlow Lite.
5. Export labels in the same order as the model output classes.
6. Back up the current model and labels.
7. Replace the two files in `assets/` without changing their stable filenames.
8. Update matching Firebase disease and soil documents.
9. Run `flutter clean`, `flutter pub get`, `flutter analyze`, and `flutter run`.
10. Test at least one image from every class and record the results.

The app checks at startup that the number of labels equals the number of model
output classes. A mismatch is rejected rather than displaying an incorrect
disease name.
