local Translations = {
    success = {
        you_have_been_jailed = "Bạn đã bị giam tù OOC bởi Admin",
        you_lost_job = "Bạn đã bị mất việc hiện tại",
        clear_inv = "Túi đồ của bạn đã bị dọn sạch",
        you_are_free = "Bạn đã được thả khỏi tù OOC",
    },
    error = {
        fill_argument = "Hãy điền đủ thông tin",
        no_permission = "Chỉ có Admin mới có thể dùng lệnh này",
        invalid_argument = "Thông số nhập vào không hợp lí",
    },
    notify = {
        title = "OOC Jail",
        jailed_player = '• HỆ THỐNG • <font color="#C1C1C1">Bạn bị giam OOC <font color="#53A263">%{time} <font color="#C1C1C1"> phút (Xem discord để biết thêm thông tin).',
        released_player = '• HỆ THỐNG • <font color="#C1C1C1">Bạn đã được <font color="#53A263">thả khỏi<font color="#C1C1C1"> tù OOC (Đừng vi phạm gì nữa nhé).',
        check_time = "Bạn vẫn còn %{time} phút giam tù OOC, hãy tiếp tục ăn năn hối lỗi nhé!",
    },
    argument = {
        id = "ID",
        id_help = "ID người chơi",
        time = "Thời gian",
        time_help = "Thời gian giam tù (phút)",
        reason = "Lí do",
        reason_help = "Lí do người này bị giam"
    },
    log = {
        jail_title = "Giam tù",
        jail_description = "`Thời gian giam: %{time} phút`\n`Lí do: %{reason}`\n\n Vui lòng tham gia discord để được hỗ trợ, sẽ không giải quyết nếu ib riêng",
        jail_additional = "**Người bị giam** (%{discord})\n`ID người chơi: %{ID}`\n`Tên in-game: %{fName} %{lName}`\n`Số căn cước: %{CID}`\n\n**Người giam** (%{adDiscord})\n`Tên in-game: %{adFName} %{adLName}`\n%{message}",
    }
}

if GetConvar('qb_locale', 'en') == 'vn' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end