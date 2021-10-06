
let g:slime_target = "tmux"
let g:slime_python_ipython = 1

let g:slime_default_config = {"socket_name": "default", "target_pane": ":.2"}

xmap <c-c><c-c> <Plug>SlimeRegionSend
map <c-c><c-c> <Plug>SlimeParagraphSend
map <c-c>v     <Plug>SlimeConfig

xmap <leader><space> <Plug>SlimeRegionSend
nmap <leader><space> <Plug>SlimeParagraphSend

