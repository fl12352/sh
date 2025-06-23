#!/bin/bash

# 静默模式开关
VERBOSE=true
if [[ "$1" == "-q" ]]; then
    VERBOSE=false
fi

# 加载动画函数
function start_spinner() {
    if $VERBOSE; then
        while :; do
            for s in / - \\ \|; do
                printf "\r[%s] 处理中..." "$s"
                sleep 0.1
            done
        done
    fi
}

# 检查目录
current_dir=$(basename "$PWD")
if [[ "$current_dir" != "Yunzai" && "$current_dir" != "Miao-Yunzai" ]]; then
    echo -e "\033[31m[错误]\033[0m 请在 Yunzai 或 Miao-Yunzai 的根目录运行此脚本"
    exit 1
fi

# 创建plugins目录
PLUGINS_DIR="plugins"
if [ ! -d "$PLUGINS_DIR" ]; then
    mkdir -p "$PLUGINS_DIR"
    $VERBOSE && echo -e "\033[32m[创建]\033[0m 目录: $PLUGINS_DIR"
else
    $VERBOSE && echo -e "\033[33m[存在]\033[0m 目录: $PLUGINS_DIR"
fi

cd "$PLUGINS_DIR" || exit

# 插件仓库定义
declare -A REPOS=(
    ["https://gitee.com/xianxincoder/xianxin-plugin"]="闲心插件 (xianxin-plugin)"
    ["https://bgithub.xyz/kissnavel/bujidaoRUN"]="不吉岛插件 (bujidaoRUN)"
    ["https://bgithub.xyz/Ctrlcvs/xiaoyao-cvs-plugin"]="逍遥插件 (xiaoyao-cvs-plugin)"
    ["https://gitee.com/xiaoye12123/xiaoye-plugin"]="小叶插件 (xiaoye-plugin)"
    ["https://gitee.com/xfdown/xiaofei-plugin"]="小飞插件 (xiaofei-plugin)"
    ["https://bgithub.xyz/ZZZure/ZZZ-Plugin"]="绝区零插件 (ZZZ-Plugin)"
    ["https://gitee.com/Rrrrrrray/mora-plugin"]="摩拉插件 (mora-plugin)"
    ["https://gitee.com/wind-trace-typ/wind-plugin"]="风插件 (wind-plugin)"
    ["https://bgithub.xyz/liangshi233/liangshi-calc"]="梁氏伤害计算 (liangshi-calc)"
    ["https://gitee.com/yoimiya-kokomi/miao-plugin"]="喵喵插件 (miao-plugin)"
    ["https://gitee.com/guoba-yunzai/guoba-plugin"]="锅巴插件 (guoba-plugin)"
    ["https://gitee.com/Nwflower/atlas"]="图鉴插件 (atlas)"
    ["https://bgithub.xyz/GangFaDeShenMe/yunzai-yt-dl-plugin"]="YouTube下载插件 (yunzai-yt-dl-plugin)"
    ["https://bgithub.xyz/XasYer/YePanel"]="小叶面板 (YePanel)"
    ["https://bgithub.xyz/wuliya336/clarity-meme"]="清语表情 (clarity-meme)"
    ["https://bgithub.xyz/AIGC-Yunzai/siliconflow-plugin"]="SF插件 (siliconflow-plugin)"
    ["https://bgithub.xyz/ikechan8370/howtocook"]="吃什么插件 (howtocook)"
    ["https://gitee.com/yeyang52/yenai-plugin"]="椰奶插件 (yenai-plugin)"
    ["https://gitee.com/haanxuan/GT-Manual"]="米游社验证 (GT-Manual)"
    ["https://bgithub.xyz/V2233/micro-plugin"]="小微插件 (micro-plugin)"
    ["https://gitee.com/tu-zhengxiong0925/help-plugin"]="帮助插件 (help-plugin)"
    ["https://bgithub.xyz/NotIvny/ark-plugin"]="喵喵排名 (ark-plugin)"
    ["https://gitee.com/yll0614/luoluo-plugin"]="落落插件 (luoluo-plugin)"
    ["https://gitee.com/snowtafir/yuki-plugin"]="优纪插件 (yuki-plugin)"
    ["https://gitee.com/escaped-spark/esca-plugin"]="ESCA插件 (esca-plugin)"
    ["https://gitee.com/memzjs/memz-plugin"]="MEMZ插件 (memz-plugin)"
    ["https://gitee.com/Vremq_vperyod/better-rc"]="BetterRC插件 (better-rc)"
    ["https://bgithub.xyz/DenFengLai/DF-Plugin"]="DF插件 (DF-Plugin)"
    ["https://gitee.com/adrae/dg-lab-play-plugin"]="DG-Lab插件 (dg-lab-play-plugin)"
    ["https://gitee.com/kongkongjiang/miaoyu-plugin"]="喵语插件 (miaoyu-plugin)"
    ["https://gitee.com/fantasy-hx/egg-plugin"]="彩蛋插件 (egg-plugin)"
    ["https://gitee.com/cunyx/xmz-plugin"]="小梦子插件 (xmz-plugin)"
    ["https://bgithub.xyz/erzaozi/imgS-plugin"]="图片搜索插件 (imgS-plugin)"
    ["https://bgithub.xyz/erzaozi/sunoai-plugin"]="SunoAI插件 (sunoai-plugin)"
    ["https://bgithub.xyz/erzaozi/vits-plugin"]="VITS插件 (vits-plugin)"
    ["https://bgithub.xyz/erzaozi/neko-status-plugin"]="猫娘状态插件 (neko-status-plugin)"
    ["https://gitee.com/logier/logier-plugins"]="Logier插件 (logier-plugins)"
    ["https://gitee.com/wind-trace-typ/wind-plugin"]="风插件 (wind-plugin)"
    ["https://gitee.com/xyb12345678qwe/mz-plugin-alemon"]="MZ-Alemon插件 (mz-plugin-alemon)"
    ["https://gitee.com/qiannqq/gi-plugin"]="GI插件 (gi-plugin)"
    ["https://gitee.com/think-first-sxs/reset-qianyu-plugin"]="千羽重置插件 (reset-qianyu-plugin)"
    ["https://bgithub.xyz/Yummy-cookie/biscuit-plugin"]="饼干插件 (biscuit-plugin)"
    ["https://bgithub.xyz/CikeyQi/nsfwjs-plugin"]="NSFW检测插件 (nsfwjs-plugin)"
    ["https://gitee.com/SmallK111407/useless-plugin"]="无用插件 (useless-plugin)"
    ["https://gitee.com/xiaoye12123/ws-plugin"]="WS插件 (ws-plugin)"
    ["https://gitee.com/hewang1an/StarRail-plugin"]="星穹铁道插件 (StarRail-plugin)"
    ["https://gitee.com/wan13877501248/y-tian-plugin"]="Y-天插件 (y-tian-plugin)"
    ["https://bgithub.xyz/AFanSKyQs/FanSky_Qs"]="FanSky插件 (FanSky_Qs)"
    ["https://gitee.com/kyrzy0416/rconsole-plugin"]="远程控制插件 (rconsole-plugin)"
    ["https://bgithub.xyz/ikechan8370/chatgpt-plugin"]="ChatGPT插件 (chatgpt-plugin)"
    ["https://bgithub.xyz/erzaozi/waves-plugin"]="声波插件 (waves-plugin)"
    ["https://bgithub.xyz/Nwflower/flower-plugin"]="小花插件 (flower-plugin)"
    ["https://gitee.com/SmallK111407/earth-k-plugin"]="地球-K插件 (earth-k-plugin)"
    ["https://bgithub.xyz/liuly0322/l-plugin"]="L插件 (l-plugin)"
)

# 检测whiptail可用性
if $VERBOSE && timeout 0.5s bash -c "command -v whiptail" &>/dev/null; then
    USE_WHIPTAIL=true
else
    USE_WHIPTAIL=false
fi

# 获取已安装插件列表
installed_plugins=()
if [ -d "." ]; then
    installed_plugins=($(ls -d */ 2>/dev/null | sed 's|/$||'))
fi

# 显示选择菜单
function show_menu() {
    if $USE_WHIPTAIL; then
        local options=()
        for repo in "${!REPOS[@]}"; do
            repo_name=$(basename "$repo")
            if [[ " ${installed_plugins[@]} " =~ " $repo_name " ]]; then
                options+=("$repo" "${REPOS[$repo]} [已安装]" OFF)
            else
                options+=("$repo" "${REPOS[$repo]}" OFF)
            fi
        done
        
        whiptail --title "插件安装" --noitem --separate-output \
                 --checklist "选择要安装的插件 (共${#REPOS[@]}个)" \
                 20 60 10 "${options[@]}" 3>&1 1>&2 2>&3
    else
        # 文本模式 - 添加分页功能
        $VERBOSE && echo -e "\n\033[36m可用插件:\033[0m"
        
        # 将插件数组转换为索引数组
        local i=1
        local plugin_list=()
        for repo in "${!REPOS[@]}"; do
            plugin_list[$i]=$repo
            ((i++))
        done
        
        local total_plugins=${#plugin_list[@]}
        local page_size=10  # 每页显示的插件数量
        local current_page=1
        local total_pages=$(( (total_plugins + page_size - 1) / page_size ))
        
        while true; do
            $VERBOSE && echo -e "\n\033[36m第 ${current_page}/${total_pages} 页 (共 ${total_plugins} 个插件)\033[0m"
            
            # 显示当前页的插件
            local start_index=$(( (current_page - 1) * page_size + 1 ))
            local end_index=$(( start_index + page_size - 1 ))
            [ $end_index -gt $total_plugins ] && end_index=$total_plugins
            
            for ((i=start_index; i<=end_index; i++)); do
                repo=${plugin_list[$i]}
                repo_name=$(basename "$repo")
                if [[ " ${installed_plugins[@]} " =~ " $repo_name " ]]; then
                    $VERBOSE && printf "\033[33m%3d. %-25s [已安装]\033[0m\n" $i "${REPOS[$repo]}"
                else
                    $VERBOSE && printf "%3d. %-25s\n" $i "${REPOS[$repo]}"
                fi
            done
            
            # 显示导航选项
            $VERBOSE && echo -e "\n\033[36m导航: n-下一页, p-上一页, q-退出选择, 或直接输入要安装的插件编号(多个用空格分隔)\033[0m"
            read -p ">" -a input
            
            if [[ "${input[0]}" == "n" && $current_page -lt $total_pages ]]; then
                ((current_page++))
            elif [[ "${input[0]}" == "p" && $current_page -gt 1 ]]; then
                ((current_page--))
            elif [[ "${input[0]}" == "q" ]]; then
                echo ""
                return
            else
                # 处理插件选择
                local selected_repos=()
                for n in "${input[@]}"; do
                    if [[ -n "${plugin_list[$n]}" ]]; then
                        selected_repos+=("${plugin_list[$n]}")
                    fi
                done
                
                if [ ${#selected_repos[@]} -gt 0 ]; then
                    printf "%s\n" "${selected_repos[@]}"
                    return
                else
                    $VERBOSE && echo -e "\033[31m[错误]\033[0m 无效的选择，请重新输入"
                fi
            fi
        done
    fi
}

# 安装插件函数
function install_plugin() {
    local repo=$1
    local repo_name=$(basename "$repo")
    local display_name=${REPOS[$repo]}
    
    if [[ " ${installed_plugins[@]} " =~ " $repo_name " ]]; then
        $VERBOSE && echo -e "\033[33m[跳过]\033[0m 已安装: $display_name"
        return
    fi
    
    $VERBOSE && echo -e "\033[36m[安装]\033[0m 开始安装: $display_name"
    
    # 启动加载动画
    start_spinner &
    spinner_pid=$!
    
    # 克隆仓库
    if git clone --depth 1 "$repo" 2>/dev/null; then
        kill $spinner_pid
        printf "\r\033[K"
        $VERBOSE && echo -e "\033[32m[成功]\033[0m $display_name 安装完成"
        
        # 特殊插件依赖处理
        case "$repo_name" in
            "FanSky_Qs") (cd "$repo_name" && pnpm install >/dev/null 2>&1) ;;
            "yenai-plugin") pnpm install >/dev/null 2>&1 ;;
            "chatgpt-plugin") cd "$repo_name" && pnpm install >/dev/null 2>&1 ;;
            "waves-plugin") pnpm install --filter=waves-plugin >/dev/null 2>&1 ;;
            "guoba-plugin") pnpm install --filter=guoba-plugin >/dev/null 2>&1 ;;
            "rconsole-plugin") pnpm i --filter=rconsole-plugin >/dev/null 2>&1 ;;
        esac
    else
        kill $spinner_pid
        printf "\r\033[K"
        echo -e "\033[31m[失败]\033[0m $display_name 安装失败"
    fi
}

# 主流程
$VERBOSE && echo -e "\n\033[1;35mYunzai插件安装工具\033[0m"

choices=$(show_menu)
if [ -z "$choices" ]; then
    $VERBOSE && echo -e "\033[33m[取消]\033[0m 没有选择任何插件"
    exit 0
fi

# 确认安装
if $VERBOSE; then
    echo -e "\n\033[36m将要安装以下插件:\033[0m"
    while IFS= read -r repo; do
        [ -z "$repo" ] && continue
        echo " - ${REPOS[$repo]} ($(basename "$repo"))"
    done <<< "$choices"
    
    read -p "是否继续安装? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "\033[33m[取消]\033[0m 安装已取消"
        exit 0
    fi
fi

# 开始安装
total=$(echo "$choices" | wc -l)
current=0
while IFS= read -r repo; do
    [ -z "$repo" ] && continue
    ((current++))
    $VERBOSE && printf "\r[%d/%d] " $current $total
    install_plugin "$repo"
done <<< "$choices"

# 安装全局依赖
$VERBOSE && echo -e "\n\033[36m[正在安装全局依赖]\033[0m"
start_spinner &
spinner_pid=$!
pnpm install >/dev/null 2>&1
kill $spinner_pid
printf "\r\033[K"

# 完成提示
$VERBOSE && echo -e "\033[1;32m\n╔══════════════════════════════╗"
$VERBOSE && echo -e "║        安装完成!请重启Yunzai      ║"
$VERBOSE && echo -e "╚══════════════════════════════╝\033[0m"

echo -e "\n\n${YELLOW}===============================================${NC}"
echo -e "${GREEN}
██╗  ██╗██╗ █████╗ ███╗   ██╗██╗   ██╗██╗   ██╗
╚██╗██╔╝██║██╔══██╗████╗  ██║██║   ██║██║   ██║
 ╚███╔╝ ██║███████║██╔██╗ ██║██║   ██║██║   ██║
 ██╔██╗ ██║██╔══██║██║╚██╗██║██║   ██║██║   ██║
██╔╝ ██╗██║██║  ██║██║ ╚████║╚██████╔╝╚██████╔╝
╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚═════╝ 
${NC}"
echo -e "${RED}===============================================${NC}"

exit 0
