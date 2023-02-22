;;;;;;;;;;;;;;;;;;;;
;; EDIT THIS PART ;;
;;;;;;;;;;;;;;;;;;;;
searchTerm := "+25% Damage (Flak"
buttonX := 350
buttonY := 900
perkTopLeftX := 170
perkTopLeftY := 760
perkBottomRightX := 550
perkBottomRightY := 785

; TODO I fix this eventually or deprecate it's kinda inconvenient anyways
; resolutionX := 1920
; resolutionY := 1080
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
createLogEntry("Initialize")
; refineQuick(resolutionX, resolutionY, searchTerm)
refineManual(searchTerm, buttonX, buttonY, perkTopLeftX, perkTopLeftY, perkBottomRightX, perkBottomRightY)
Return

;; Shift F2: Toggle script on/off
; #IfWinExist ahk_exe Darktide.exe ; idk if i want this. probably better to throw an error
+F2::
Suspend
Pause,, 1
createLogEntry("Toggle")
Return

;; Shift F3: Turn off script.
#IfWinActive
+F3::
createLogEntry("Exit")
ExitApp
Return

;; Shift F4: Get current position of mouse
+F4::
MouseGetPos, xPos, yPos 
ToolTip, The cursor is at X=%xPos% Y=%yPos%., %xPos%, %yPos%
SetTimer, removeToolTip, -5000
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

activateDarktide() {
    SetTitleMatchMode, 2
    Sleep, 50
    WinActivate, Warhammer 40,000: Darktide
}

checkForMatch(stringToCheck, searchTerm, rerollCount, startTime) {
    if (InStr(stringToCheck, searchTerm)) {
        timeDiffInSeconds := (A_TickCount - startTime)/1000
        createLogEntry("FoundMatch")
        MsgBox, Match Found for "%searchTerm%" after %rerollCount% rolls (%timeDiffInSeconds% seconds)
        Exit, true
    }
    return false
}

createLogEntry(reason) {
    FormatTime, logTime,, yyyy-MM-dd hh:mm:ss tt
    logLineDivider = ----------------------------------------------------------------------------------------------------`n
    switch (reason) {
        case "Initialize":
            logLine = %logTime% - Initializing Perk Reroll Script`n
            FileAppend, %logLineDivider%%logLine%, PerkRerollLog.txt
        case "Toggle":
            logLine = %logTime% - Toggling Perk Reroll Script`n
            FileAppend, %logLine%, PerkRerollLog.txt
        case "Exit":
            logLine = %logTime% - Exiting Perk Reroll Script`n
            FileAppend, %logLine%%logLineDivider%, PerkRerollLog.txt
        case "FoundMatch":
            logLine = %logTime% - Match found`n
            FileAppend, %logLine%%logLineDivider%, PerkRerollLog.txt
    }
    return
}

createPerkRerollLogEntry(stringToCheck, rerollCount) {
    ; get current time
    FormatTime, logTime,, yyyy-MM-dd hh:mm:ss tt
    ; start from approximately the box and remove any new lines
    ; logStr := StrReplace(SubStr(stringToCheck, 100), "`r", A_Space)
    ; logStr := StrReplace(logStr, "`n", A_Space)
    logStr := stringToCheck
    logLine = %logTime% - Reroll number %rerollCount%: %logStr%`n
    FileAppend, %logLine%, PerkRerollLog.txt
    return
}

refineManual(searchTerm, buttonX, buttonY, topLeftBoxX, topLeftBoxY, bottomRightBoxX, bottomRightBoxY) {
    foundMatch := False
    rerollCount := 0
    startTime := A_TickCount
    boxCenterX := (topLeftBoxX+bottomRightBoxX)/2
    boxCenterY := (topLeftBoxY+bottomRightBoxY)/2

    while (!foundMatch) {
        ;; Check initial perk
        MouseClick, left, boxCenterX, boxCenterY, 1
        clipInit := grabScreenShotManual(topLeftBoxX, topLeftBoxY, bottomRightBoxX, bottomRightBoxY)

        ;; Don't reroll a perk that's already good
        foundMatch := checkForMatch(clipInit, searchTerm, rerollCount, startTime)

        ;; Click Refine and wait for the server to respond
        activateDarktide()
        MouseClick, left, buttonX, buttonY, 1
        rerollCount++
        timeDiffInSeconds := (A_TickCount - startTime)/1000
        ToolTip, Reroll number: %rerollCount% (%timeDiffInSeconds% seconds)
        SetTimer, removeToolTip, -1000
        Sleep, 500

        ;; Check new perk
        clipFinal := grabScreenShotManual(topLeftBoxX, topLeftBoxY, bottomRightBoxX, bottomRightBoxY)

        ;; If they are still the same, wait until they are different
        while (clipInit = clipFinal) {
            Sleep, 500
            clipFinal := grabScreenShotManual(topLeftBoxX, topLeftBoxY, bottomRightBoxX, bottomRightBoxY)
        }
        ;; If clipboard matches searchTerm, we are done, else try again
        createPerkRerollLogEntry(clipFinal, rerollCount)
        foundMatch := checkForMatch(clipFinal, searchTerm, rerollCount, startTime)
    }
    return
}

grabScreenShotManual(topLeftBoxX, topLeftBoxY, bottomRightBoxX, bottomRightBoxY) {
    ; Grab screenshot of perk, use Copy2Text to OCR, copy to clipboard
    activateDarktide()
    Sleep, 50
    MouseMove, topLeftBoxX, topLeftBoxY, 3
    Send, #q
    MouseClick, left, bottomRightBoxX, bottomRightBoxY, 1, 3
    Sleep, 200
    clip := Clipboard
    Return clip
}

removeToolTip() {
    ToolTip
    return
}

refineQuick(resolutionX, resolutionY, searchTerm) {
    aspectRatio := resolutionX / resolutionY
    ; Set button location
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
        createPerkRerollLogEntry(clipFinal, rerollCount)
        foundMatch := checkForMatch(clipFinal, searchTerm, rerollCount, startTime)
    }
}

grabScreenShot(resolutionX, resolutionY) {
    aspectRatio := resolutionX / resolutionY
    ; Set box dimensions
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

    ; Grab screenshot of perk, use Copy2Text to OCR, copy to clipboard
    activateDarktide()
    Sleep, 50
    MouseMove, topLeftBoxX, topLeftBoxY, 3
    Send, #q
    MouseClick, left, bottomRightBoxX, bottomRightBoxY, 1, 3
    Sleep, 200
    clip := Clipboard
    Return clip
}