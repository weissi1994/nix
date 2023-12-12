
bind \e\[1\;5C forward-bigword
bind \e\[1\;5D backward-bigword

set em_confused "¯\_(⊙︿⊙)_/¯"
set em_crying ಥ_ಥ
set em_cute_bear "ʕ•ᴥ•ʔ"
set em_cute_face "(｡◕‿◕｡)"
set em_excited "☜(⌒▽⌒)☞"
set em_fisticuffs "ლ(｀ー´ლ)"
set em_fliptable "(╯°□°）╯︵ ┻━┻"
set em_table_flip_person "ノ┬─┬ノ ︵ ( \o°o)\\"
set em_person_unflip_table "┬──┬◡ﾉ(° -°ﾉ)"
set em_happy "ヽ(´▽\`)/"
set em_innocent "ʘ‿ʘ"
set em_kirby "⊂(◉‿◉)つ"
set em_lennyface "( ͡° ͜ʖ ͡°)"
set em_lion "°‿‿°"
set em_muscleflex "ᕙ(⇀‸↼‶)ᕗ"
set em_muscleflex2 "ᕦ(∩◡∩)ᕤ"
set em_perky "(\`・ω・\´)"
set em_piggy "( ́・ω・\`)"
set em_shrug "¯\_(ツ)_/¯"
set em_point_right "(☞ﾟヮﾟ)☞"
set em_point_left "☜(ﾟヮﾟ☜)"
set em_magic "╰(•̀ 3 •́)━☆ﾟ.*･｡ﾟ"
set em_shades "(•_•)\n( •_•)>⌐■-■\n(⌐■_■)"
set em_disapprove ಠ_ಠ
set em_wink "ಠ‿↼"
set em_facepalm "(－‸ლ)"
set em_hataz_gon_hate "ᕕ( ᐛ )ᕗ"
set em_salute "(￣^￣)ゞ"

gpg-connect-agent updatestartuptty /bye >/dev/null

function fish_greeting
    bash -c 'COLUMNS=$COLUMNS source ~/.config/greeter.sh'
end
