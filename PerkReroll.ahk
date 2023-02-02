;;;;;;;;;;;;;;;;;;;;
;; EDIT THIS PART ;;
;;;;;;;;;;;;;;;;;;;;
resolutionX := 1920
resolutionY := 1080
searchTerm := "+25% Damage (Flak" ; CASE SENSITIVE
;;;;;;;;;;;;;;;;;;;;

/* Example Search Terms:
    "+25% Damage ("
    "+20% chance of Curio"
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
    DetectHiddenWindows On
    SetTitleMatchMode, 2
    if (WinExist("Capture2Text")) {
        DetectHiddenWindows, Off
        return true
    } else {
        DetectHiddenWindows, Off
        MsgBox, Capture2Text is not active. Enable it or press {Shift + F3} to turn off the hotkey.
        return false
    }
}

activateDarktide() {
    ;; Activate Darktide
    SetTitleMatchMode, 2
    WinActivate, Warhammer 40,000: Darktide
    Sleep, 100
}

refineQuick(resolutionX, resolutionY, searchTerm) {
    aspectRatio := resolutionX / resolutionY
    ;; Set button location
    if (Abs(aspectRatio - 43/18) < 0.01 && resolutionX > 1920) {
        ; 0.68586 * resolutionX for 43:18 aspect ratios
        buttonX := 0.833 * 1920 + 0.5 * (resolutionX - 1920)
    } else {
        buttonX := 0.833 * resolutionX
    }
    buttonY := 0.833 * resolutionY

    foundMatch := False
    rerollCount := 0
    startTime := A_TickCount

    while (!foundMatch) {
        ;; Check initial perk
        clipInit := grabScreenShot(resolutionX, resolutionY)

        ;; Don't reroll a perk that's already good
        if (InStr(clipInit, searchTerm)) {
            MsgBox, Match Found
            return
        }

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
        if (InStr(clipFinal, searchTerm)) {
            timeDiffInSeconds := (A_TickCount - startTime)/1000
            MsgBox, Match Found after %rerollCount% rolls (%timeDiffInSeconds% seconds)
            return
        }
    }
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
    MouseMove, topLeftBoxX, topLeftBoxY
    Send, #q
    MouseClick, left, bottomRightBoxX, bottomRightBoxY, 1
    Sleep, 200
    clip := Clipboard
    Return clip
}

/* Deprecated
refine(resolutionX, resolutionY, searchTerm) {
    ;; Set button location and box dimensions
    buttonX := 0.833 * resolutionX
    buttonY := 0.833 * resolutionY
    topLeftBoxX := 0.7075 * resolutionX
    ; topLeftBoxY := 0.69 * resolutionY
    topLeftBoxY := 0.63 * resolutionY ; bit larger so it works when materials are still required
    bottomRightBoxX := 0.94 * resolutionX
    ; bottomRightBoxY := 0.78 * resolutionY
    bottomRightBoxY := 0.8 * resolutionY ; bit larger so it works when materials are still required

    ;; Click Refine and wait for the server to respond
    activateDarktide()
    MouseClick, left, buttonX, buttonY, 1
    Sleep, 6000

    ;; Grab screenshot of perk, use Copy2Text to OCR, copy to clipboard
    activateDarktide()
    MouseMove, topLeftBoxX, topLeftBoxY, 4
    Send, #q
    MouseClick, left, bottomRightBoxX, bottomRightBoxY, 1, 4
    Sleep, 100
    clip := Clipboard

    ;; If clipboard matches searchTerm, we are done, else try again
    If (InStr(clip, searchTerm)) {
        MsgBox, Match Found
        return
    } else {
        refine(resolutionX, resolutionY, searchTerm)
    }
}
*/