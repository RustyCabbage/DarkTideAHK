# v1.3 - "Harder, Better, Faster, Stronger"
- Added a reroll counter
- Added a reroll timer
- Increased the speed from around 3s per reroll to 2.3s per reroll.
- TODO: Fix Capture2Text not being found in system tray.

### **v1.3.1 "For Dearest Yvanna"**
- Learned the Instr() is in fact, not case-sensitive. Whoops.
- Fixed Capture2Text not being detected in system tray because I forgot a comma. Whoops. Aren't IDEs supposed to catch that?
- Adjusted the button location slightly to support 16:10 aspect ratios (Sorry Yvanna!)
- Fixed a rare case where reroll counter and timer would not be shown on match found (if you use a given set of code more than once, make it a function >:V)
- Slowed down the speed of OCR capture since a match was skipped at least once. Will probably make this configurable eventually.

# v1.2 - "Drago-proof"
- Added error handling if Darktide or Capture2Text are not on
- Now Drago-proof (adjusted so that all config is done at the top)
- added changelog :)

### v1.2.1 - "TFW ultra widescreen users exist"
- Removed check for Capture2Text when pausing/unpausing the script. this might be a bad idea idk.
- Added support for 3440 x 1440 and other wider resolutions (i think. needs more testing probably)

# v1.1 - "Serviceable"
- Added script toggle and turn off
- Created faster function that should also be more reliable
- Improved bounding boxes for OCR

### v1.1.1 - "Serviceable, probably"
- Reminder: it's never appropriate to use recursion (fixed a crash that would occur if rerolling for too long without success (i don't know why i didn't use a while loop from the start but shush))
- Code cleanup

### v1.1.2 - "It was in fact, not serviceable. But now is (hopefully)."
- learned AHK doesn't support multi line functions. (fixed the entire script not working)

# v1.0 "Technically viable product"
- initial, probably terrible release. works.
