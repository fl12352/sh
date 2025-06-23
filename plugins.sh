#!/bin/bash

# 颜色定义
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\033[36m'
NC='\033[0m' # 无颜色

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

# 插件仓库定义（只保留仓库名称）
declare -a PLUGIN_REPOS=(
    "https://gitee.com/xianxincoder/xianxin-plugin"
    "https://bgithub.xyz/kissnavel/bujidaoRUN"
    "https://bgithub.xyz/Ctrlcvs/xiaoyao-cvs-plugin"
    "https://gitee.com/xiaoye12123/xiaoye-plugin"
    "https://gitee.com/xfdown/xiaofei-plugin"
    "https://bgithub.xyz/ZZZure/ZZZ-Plugin"
    "https://gitee.com/Rrrrrrray/mora-plugin"
    "https://gitee.com/wind-trace-typ/wind-plugin"
    "https://bgithub.xyz/liangshi233/liangshi-calc"
    "https://bgithub.xyz/yoimiya-kokomi/miao-plugin"
    "https://gitee.com/guoba-yunzai/Guoba-Plugin"
    "https://gitee.com/Nwflower/atlas"
    "https://bgithub.xyz/GangFaDeShenMe/yunzai-yt-dl-plugin"
    "https://bgithub.xyz/XasYer/YePanel"
    "https://bgithub.xyz/wuliya336/clarity-meme"
    "https://bgithub.xyz/AIGC-Yunzai/siliconflow-plugin"
    "https://bgithub.xyz/ikechan8370/howtocook"
    "https://gitee.com/yeyang52/yenai-plugin"
    "https://gitee.com/haanxuan/GT-Manual"
    "https://bgithub.xyz/V2233/micro-plugin"
    "https://gitee.com/tu-zhengxiong0925/help-plugin"
    "https://bgithub.xyz/NotIvny/ark-plugin"
    "https://gitee.com/yll0614/luoluo-plugin"
    "https://gitee.com/snowtafir/yuki-plugin"
    "https://gitee.com/escaped-spark/esca-plugin"
    "https://gitee.com/memzjs/memz-plugin"
    "https://gitee.com/Vremq_vperyod/better-rc"
    "https://bgithub.xyz/DenFengLai/DF-Plugin"
    "https://gitee.com/adrae/dg-lab-play-plugin"
    "https://gitee.com/kongkongjiang/miaoyu-plugin"
    "https://gitee.com/fantasy-hx/egg-plugin"
    "https://gitee.com/cunyx/xmz-plugin"
    "https://bgithub.xyz/erzaozi/imgS-plugin"
    "https://bgithub.xyz/erzaozi/sunoai-plugin"
    "https://bgithub.xyz/erzaozi/vits-plugin"
    "https://bgithub.xyz/erzaozi/neko-status-plugin"
    "https://gitee.com/logier/logier-plugins"
    "https://gitee.com/xyb12345678qwe/mz-plugin-alemon"
    "https://gitee.com/qiannqq/gi-plugin"
    "https://gitee.com/think-first-sxs/reset-qianyu-plugin"
    "https://bgithub.xyz/Yummy-cookie/biscuit-plugin"
    "https://bgithub.xyz/CikeyQi/nsfwjs-plugin"
    "https://gitee.com/SmallK111407/useless-plugin"
    "https://gitee.com/xiaoye12123/ws-plugin"
    "https://gitee.com/hewang1an/StarRail-plugin"
    "https://gitee.com/wan13877501248/y-tian-plugin"
    "https://bgithub.xyz/AFanSKyQs/FanSky_Qs"
    "https://gitee.com/kyrzy0416/rconsole-plugin"
    "https://bgithub.xyz/ikechan8370/chatgpt-plugin"
    "https://bgithub.xyz/erzaozi/waves-plugin"
    "https://bgithub.xyz/Nwflower/flower-plugin"
    "https://gitee.com/SmallK111407/earth-k-plugin"
    "https://bgithub.xyz/liuly0322/l-plugin"
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

# 获取仓库名称
function get_repo_name() {
    local repo_url="$1"
    basename "$repo_url"
}

# 显示选择菜单
function show_menu() {
    if $USE_WHIPTAIL; then
        local options=()
        for repo_url in "${PLUGIN_REPOS[@]}"; do
            repo_name=$(get_repo_name "$repo_url")
            if [[ " ${installed_plugins[@]} " =~ " $repo_name " ]]; then
                options+=("$repo_url" "$repo_name [已安装]" OFF)
            else
                options+=("$repo_url" "$repo_name" OFF)
            fi
        done
        
        whiptail --title "插件安装" --separate-output \
                 --checklist "选择要安装的插件 (共${#PLUGIN_REPOS[@]}个)" \
                 20 80 10 "${options[@]}" 3>&1 1>&2 2>&3
    else
        # 文本模式
        $VERBOSE && echo -e "\n\033[36m可用插件:\033[0m"
        
        local total_plugins=${#PLUGIN_REPOS[@]}
        local page_size=10
        local current_page=1
        local total_pages=$(( (total_plugins + page_size - 1) / page_size ))
        
        while true; do
            $VERBOSE && echo -e "\n\033[36m第 ${current_page}/${total_pages} 页 (共 ${total_plugins} 个插件)\033[0m"
            
            local start_index=$(( (current_page - 1) * page_size ))
            local end_index=$(( start_index + page_size - 1 ))
            [ $end_index -ge $total_plugins ] && end_index=$((total_plugins-1))
            
            for ((i=start_index; i<=end_index; i++)); do
                repo_url=${PLUGIN_REPOS[$i]}
                repo_name=$(get_repo_name "$repo_url")
                index=$((i+1))
                
                if [[ " ${installed_plugins[@]} " =~ " $repo_name " ]]; then
                    $VERBOSE && printf "\033[33m%3d. %-25s [已安装]\033[0m\n" $index "$repo_name"
                else
                    $VERBOSE && printf "%3d. %-25s\n" $index "$repo_name"
                fi
            done
            
            $VERBOSE && echo -e "\n\033[36m导航: n-下一页, p-上一页, q-退出选择, 或输入要安装的插件编号(多个用空格分隔)\033[0m"
            read -p ">" -a input
            
            if [[ "${input[0]}" == "n" && $current_page -lt $total_pages ]]; then
                ((current_page++))
            elif [[ "${input[0]}" == "p" && $current_page -gt 1 ]]; then
                ((current_page--))
            elif [[ "${input[0]}" == "q" ]]; then
                echo ""
                return
            else
                local selected_repos=()
                for n in "${input[@]}"; do
                    if [[ $n =~ ^[0-9]+$ ]] && [ $n -ge 1 ] && [ $n -le $total_plugins ]; then
                        selected_repos+=("${PLUGIN_REPOS[$((n-1))]}")
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
    local repo_url=$1
    local repo_name=$(get_repo_name "$repo_url")
    
    if [[ " ${installed_plugins[@]} " =~ " $repo_name " ]]; then
        $VERBOSE && echo -e "\033[33m[跳过]\033[0m 已安装: $repo_name"
        return
    fi
    
    $VERBOSE && echo -e "\033[36m[安装]\033[0m 开始安装: $repo_name"
    
    # 启动加载动画
    if $VERBOSE; then
        start_spinner &
        spinner_pid=$!
    fi
    
    # 克隆仓库
    if git clone --depth 1 "$repo_url" 2>/dev/null; then
        if $VERBOSE; then
            kill $spinner_pid
            wait $spinner_pid 2>/dev/null
            printf "\r\033[K"
        fi
        $VERBOSE && echo -e "\033[32m[成功]\033[0m $repo_name 安装完成"
        
        # 特殊插件依赖处理
        case "$repo_name" in
            "FanSky_Qs") (cd "$repo_name" && pnpm install >/dev/null 2>&1) ;;
            "yenai-plugin") pnpm install >/dev/null 2>&1 ;;
            "chatgpt-plugin") cd "$repo_name" && pnpm install >/dev/null 2>&1 ;;
            "waves-plugin") pnpm install --filter=waves-plugin >/dev/null 2>&1 ;;
            "Guoba-Plugin") pnpm install --filter=guoba-plugin >/dev/null 2>&1 ;;
            "rconsole-plugin") pnpm i --filter=rconsole-plugin >/dev/null 2>&1 ;;
        esac
    else
        if $VERBOSE; then
            kill $spinner_pid
            wait $spinner_pid 2>/dev/null
            printf "\r\033[K"
        fi
        $VERBOSE && echo -e "\033[31m[失败]\033[0m $repo_name 安装失败"
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
    while IFS= read -r repo_url; do
        [ -z "$repo_url" ] && continue
        repo_name=$(get_repo_name "$repo_url")
        echo " - $repo_name"
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
while IFS= read -r repo_url; do
    [ -z "$repo_url" ] && continue
    ((current++))
    $VERBOSE && printf "\r[%d/%d] " $current $total
    install_plugin "$repo_url"
done <<< "$choices"

# 安装全局依赖
$VERBOSE && echo -e "\n\033[36m[正在安装全局依赖]\033[0m"
if $VERBOSE; then
    start_spinner &
    spinner_pid=$!
fi
pnpm install >/dev/null 2>&1
if $VERBOSE; then
    kill $spinner_pid
    wait $spinner_pid 2>/dev/null
    printf "\r\033[K"
fi

# 完成提示
$VERBOSE && echo -e "\033[1;32m\n╔══════════════════════════════╗"
$VERBOSE && echo -e "║        安装完成!请重启Yunzai      ║"
$VERBOSE && echo -e "╚══════════════════════════════╝\033[0m"

$VERBOSE && echo -e "\n\n${YELLOW}===============================================${NC}"
$VERBOSE && echo -e "${GREEN}
██╗  ██╗██╗ █████╗ ███╗   ██╗██╗   ██╗██╗   ██╗
╚██╗██╔╝██║██╔══██╗████╗  ██║██║   ██║██║   ██║
 ╚███╔╝ ██║███████║██╔██╗ ██║██║   ██║██║   ██║
 ██╔██╗ ██║██╔══██║██║╚██╗██║██║   ██║██║   ██║
██╔╝ ██╗██║██║  ██║██║ ╚████║╚██████╔╝╚██████╔╝
╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚═════╝ 
${NC}"
$VERBOSE && echo -e "${RED}===============================================${NC}"

exit 0
