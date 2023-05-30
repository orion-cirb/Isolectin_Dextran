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

* Detect vessels in isolectin channel with gaussian blur + threshold
* Fill with dark isolectin mask in dextran channel
* Detect dextran with threshold
* Give isolectin and dextran masks areas + areas ratio

### Version history

Version 1 released on May 30, 2023.
