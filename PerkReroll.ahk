+F1::
refine(1920, 1080, "25% Damage")

refine(resolutionX, resolutionY, searchTerm) {
    buttonX := 0.833 * resolutionX
    buttonY := 0.833 * resolutionY
    topLeftBoxX := 0.705 * resolutionX
    topLeftBoxY := 0.69 * resolutionY
    bottomRightBoxX := 0.9 * resolutionX
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
    ;;Send, !{PrintScreen}
    ;;Sleep, 200
    ;;Run, https://www.imagetotext.info/
    ;;Send, !{Tab}
    ;;Sleep, 200
    ;;Send, ^v
    ;;Sleep, 200
    ;;Send, {PgUp}
    ;;Sleep, 500
    ;;MouseClick, left, 950, 750, 1
}