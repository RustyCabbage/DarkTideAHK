;; Shift F1: Turn on script
+F1::
;; Example Search Terms:
    ;; "+25% Damage ("
    ;; "+20% chance of Curio"
refineQuick(1920, 1080,
    "+25% Damage (Maniac" ; EDIT THIS STRING
    )
Return

;; Shift F2: Toggle script on/off
+F2::
Suspend
Pause,, 1
Return

;; Shift F3: Turn off script.
+F3::
ExitApp
Return

refineQuick(resolutionX, resolutionY, searchTerm) {
    ;; Set button location
    buttonX := 0.833 * resolutionX
    buttonY := 0.833 * resolutionY

    foundMatch := False

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
            MsgBox, Match Found
            return
        }
    }
}

activateDarktide() {
    ;; Activate Darktide
    SetTitleMatchMode, 2
    darktide := "Warhammer 40,000: Darktide"
    WinActivate, %darktide%
    Sleep, 100
}

grabScreenShot(resolutionX, resolutionY) {
    ;; Set box dimensions
    topLeftBoxX := 0.7075 * resolutionX
    ; topLeftBoxY := 0.69 * resolutionY
    topLeftBoxY := 0.63 * resolutionY ; bit larger so it works when materials are still required
    bottomRightBoxX := 0.94 * resolutionX
    ; bottomRightBoxY := 0.78 * resolutionY
    bottomRightBoxY := 0.8 * resolutionY ; bit larger so it works when materials are still required

    ;; Grab screenshot of perk, use Copy2Text to OCR, copy to clipboard
    activateDarktide()
    MouseMove, topLeftBoxX, topLeftBoxY, 4
    Send, #q
    MouseClick, left, bottomRightBoxX, bottomRightBoxY, 1, 4
    Sleep, 200
    clip := Clipboard
    Return clip
}

;;
;; Deprecated
;;
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