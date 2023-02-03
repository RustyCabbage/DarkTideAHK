# DarkTideAHK
 
### **v1.3.1 "For Dearest Yvanna"**
- Learned the Instr() is in fact, not case-sensitive. Whoops.
- Fixed Capture2Text not being detected in system tray because I forgot a comma. Whoops. Aren't IDEs supposed to catch that?
- Adjusted the button location slightly to support 16:10 aspect ratios (Sorry Yvanna!)
- Fixed a rare case where reroll counter and timer would not be shown on match found (if you use a given set of code more than once, make it a function >:V)
- Slowed down the speed of OCR capture since a match was skipped at least once. Will probably make this configurable eventually.

## How To Use:
1. Install AutoHotKey v1.1: https://www.autohotkey.com/
2. Install Capture2Text: https://capture2text.sourceforge.net/ 
3. Download **PerkReroll.ahk** from the repo
4. Edit script with your game resolution, desired perk
    4b. Be wary that depending on your resolution the picture-to-text might not correctly capture the string. Might need some trial and error on other resolutions.
5. Turn on the script
6. Go to DarkTide refine item screen
7. Press {Shift + F1} to start the script
    7b. {Shift + F2} can be used to toggle the script on/off
    7c. {Shift + F3} will disable close the .ahk file entirely

- Note Capture2Text default OCR keybind is Win + Q so uh don't use those buttons for something else

## To Do:
- Adjust default proportions for different resolutions, UI scaling
    - or automate it idk
- Pictures in guide
- Allow RegEx mode to deal with weird string issues
- Allow custom Capture2Text keybind
- (Suggestions welcome)
