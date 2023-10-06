# Isolectin_Dextran

* **Developed for:** Iris
* **Team:** Germain
* **Date:** May 2023
* **Software:** Fiji

### Images description

2D images of sections of mouse heart taken with a x20 objective.

2 channels:
  1. *CSU_561:* Dextran
  2. *CSU_635:* Isolectin

### Macro description

* Detect vessels in isolectin channel with Gaussian blur filtering + Huang thresholding
* Fill in dark isolectin mask in dextran channel
* Detect extravasated dextran in dextran channel with Gaussian blur filtering + Otsu thresholding
* Give isolectin and extravasated dextran masks areas

### Version history

Version 1 released on May 30, 2023.
