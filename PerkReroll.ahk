+F1::
; Example Search Terms:
; "+25% Damage ("
; "+20% chance of Curio"
refine(1920, 1080, "20% chance of")

refine(resolutionX, resolutionY, searchTerm) {
    SetTitleMatchMode, 2
    WinActivate, Darktide
    Sleep, 200
    buttonX := 0.833 * resolutionX
    buttonY := 0.833 * resolutionY
    topLeftBoxX := 0.705 * resolutionX
    topLeftBoxY := 0.69 * resolutionY
    bottomRightBoxX := 0.94 * resolutionX
    bottomRightBoxY := 0.78 * resolutionY
    MouseClick, left, buttonX, buttonY, 1
    Sleep, 6000
    MouseMove, topLeftBoxX, topLeftBoxY, 4
    Send, #q
    MouseClick, left, bottomRightBoxX, bottomRightBoxY, 1, 4
    Sleep, 500
    clip := Clipboard
    If (InStr(clip, searchTerm)) {
        MsgBox, Match Found
        return
    } else {
        refine(resolutionX, resolutionY, searchTerm)
    }
}