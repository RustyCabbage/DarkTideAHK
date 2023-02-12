;;;;;;;;;;;;;;;;;;;;
;; EDIT THIS PART ;;
;;;;;;;;;;;;;;;;;;;;
resolutionX := 1920
resolutionY := 1080
searchTerm := "+25% Damage (Flak"
;;;;;;;;;;;;;;;;;;;;

/* Example Search Terms:
    "+25% Damage ("
    "+20% chance of Curio"
    "Critical Strike Chance"
*/ 

;; Shift F1: Turn on script
; #IfWinExist ahk_exe Darktide.exe ; idk if i want this. probably better to throw an error
+F1::
;; Check if Darktide and Capture2Text are on
if (!isDarkTideOn() || !isCapture2TextOn()) {
    return
}
refineQuick(resolutionX, resolutionY, searchTerm)
Return

;; Shift F2: Toggle script on/off
; #IfWinExist ahk_exe Darktide.exe ; idk if i want this. probably better to throw an error
+F2::
Suspend
Pause,, 1
Return

;; Shift F3: Turn off script.
#IfWinActive
+F3::
ExitApp
Return

isDarkTideOn() {
    SetTitleMatchMode, 2
    if (WinExist("Warhammer 40,000: Darktide")) {
        return true
    } else {
        MsgBox, Darktide is not active. Enable it or press {Shift + F3} to turn off the hotkey.
        return false
    }
}

isCapture2TextOn() {
    DetectHiddenWindows, On
    SetTitleMatchMode, 2
    Sleep, 50
    if (WinExist("Capture2Text")) {
        DetectHiddenWindows, Off
        return true
    } else {
        DetectHiddenWindows, Off
        MsgBox, Capture2Text is not active. Enable it or press {Shift + F3} to turn off the hotkey.
        return false
    }
}

refineQuick(resolutionX, resolutionY, searchTerm) {
    aspectRatio := resolutionX / resolutionY
    ;; Set button location
    if (Abs(aspectRatio - 43/18) < 0.01 && resolutionX > 1920) {
        ; 0.68586 * resolutionX for 43:18 aspect ratios
        buttonX := 0.825 * 1920 + 0.5 * (resolutionX - 1920)
    } else {
        buttonX := 0.825 * resolutionX
    }
    buttonY := 0.825 * resolutionY

    foundMatch := False
    rerollCount := 0
    startTime := A_TickCount

    while (!foundMatch) {
        ;; Check initial perk
        clipInit := grabScreenShot(resolutionX, resolutionY)

        ;; Don't reroll a perk that's already good
        foundMatch := checkForMatch(clipInit, searchTerm, rerollCount, startTime)

        ;; Click Refine and wait for the server to respond
        activateDarktide()
        MouseClick, left, buttonX, buttonY, 1
        rerollCount++
        Sleep, 500

        ;; Check new perk
        clipFinal := grabScreenShot(resolutionX, resolutionY)

        ;; If they are still the same, wait until they are different
        while (clipInit = clipFinal) {
            Sleep, 500
            clipFinal := grabScreenShot(resolutionX, resolutionY)
        }
        ;; If clipboard matches searchTerm, we are done, else try again
        foundMatch := checkForMatch(clipFinal, searchTerm, rerollCount, startTime)
    }
}

activateDarktide() {
    ;; Activate Darktide
    SetTitleMatchMode, 2
    Sleep, 50
    WinActivate, Warhammer 40,000: Darktide
}

checkForMatch(stringToCheck, searchTerm, rerollCount, startTime) {
    if (InStr(stringToCheck, searchTerm)) {
        timeDiffInSeconds := (A_TickCount - startTime)/1000
        MsgBox, Match Found for "%searchTerm%" after %rerollCount% rolls (%timeDiffInSeconds% seconds)
        Exit, true
    }
    return false
}

grabScreenShot(resolutionX, resolutionY) {
    aspectRatio := resolutionX / resolutionY
    ;; Set box dimensions
    if (Abs(aspectRatio - 43/18) < 0.01 && resolutionX > 1920) {
        ; 0.61581 * resolutionX for 43:18 aspect ratios
        topLeftBoxX := 0.7075 * 1920 + 0.5 * (resolutionX - 1920)
        bottomRightBoxX := topLeftBoxX + 0.2325 * resolutionX
        
        topLeftBoxY := 0.63 * resolutionY ; bit larger so it works when materials are still required
        bottomRightBoxY := topLeftBoxY + 0.17 * resolutionY ; bit larger so it works when materials are still required
    } else {
        topLeftBoxX := 0.7075 * resolutionX
        bottomRightBoxX := topLeftBoxX + 0.2325 * resolutionX

        topLeftBoxY := 0.63 * resolutionY ; bit larger so it works when materials are still required
        bottomRightBoxY := topLeftBoxY + 0.17 * resolutionY ; bit larger so it works when materials are still required
    }

    ;; Grab screenshot of perk, use Copy2Text to OCR, copy to clipboard
    activateDarktide()
    Sleep, 50
    MouseMove, topLeftBoxX, topLeftBoxY, 3
    Send, #q
    MouseClick, left, bottomRightBoxX, bottomRightBoxY, 1, 3
    Sleep, 200
    clip := Clipboard
    Return clip
}