#!/bin/bash

current_dir=$(basename "$PWD")
if [[ "$current_dir" != "Yunzai" && "$current_dir" != "Miao-Yunzai" ]]; then
    echo -e "\033[31m[错误]\033[0m 请在 Yunzai 或 Miao-Yunzai 的根目录运行此脚本"
    exit 1
fi

PLUGINS_DIR="plugins"
if [ ! -d "$PLUGINS_DIR" ]; then
    mkdir -p "$PLUGINS_DIR"
    echo -e "\033[32m[创建]\033[0m 目录: $PLUGINS_DIR"
else
    echo -e "\033[33m[存在]\033[0m 目录: $PLUGINS_DIR"
fi

cd "$PLUGINS_DIR" || exit

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
    ["https://bgithub.xyz/yoimiya-kokomi/miao-plugin"]="喵喵插件 (miao-plugin)"
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

for repo in "${!REPOS[@]}"; do
    repo_name=$(basename "$repo")
    display_name=${REPOS[$repo]}
    
    if [ -d "$repo_name" ]; then
        echo -e "\033[33m[跳过]\033[0m 已安装: $display_name"
        continue
    fi
    
    invalid_attempts=0
    while true; do
        read -rp "是否安装 $display_name ? [Y/n]: " answer
        case ${answer,,} in
            y|yes|"")
                echo -e "\033[36m[正在安装]\033[0m $display_name"
                git clone "$repo"
                
                if [ $? -eq 0 ]; then
                    if [ "$repo_name" == "FanSky_Qs" ]; then
                        echo -e "\033[36m[正在安装依赖]\033[0m 进入 FanSky_Qs 目录..."
                        cd FanSky_Qs && pnpm install && cd ..
                        echo -e "\033[32m[依赖安装完成]\033[0m FanSky_Qs"
                    fi

                    if [ "$repo_name" == "yenai-plugin" ]; then
                        echo -e "\033[36m[正在安装依赖]\033[0m 开始安装..."
                        pnpm install
                        echo -e "\033[32m[依赖安装完成]\033[0m yenai-plugin"
                    fi

                    if [ "$repo_name" == "waves-plugin" ]; then
                        echo -e "\033[36m[正在安装依赖]\033[0m 为 waves-plugin 安装特殊依赖..."
                        pnpm install --filter=waves-plugin
                        echo -e "\033[32m[依赖安装完成]\033[0m waves-plugin 特殊依赖"
                    fi

                    if [ "$repo_name" == "chatgpt-plugin" ]; then
                        echo -e "\033[36m[正在安装依赖]\033[0m 进入 chatgpt-plugin 目录..."
                        cd chatgpt-plugin && pnpm i && cd ..
                        echo -e "\033[32m[依赖安装完成]\033[0m chatgpt-plugin"
                    fi

                    if [ "$repo_name" == "guoba-plugin" ]; then
                        echo -e "\033[36m[正在安装依赖]"
                        pnpm install --filter=guoba-plugin
                        echo -e "\033[32m[依赖安装完成]\033[0m guoba-plugin"
                    fi
                    
                    echo -e "\033[32m[成功]\033[0m $display_name 安装完成"
                else
                    echo -e "\033[31m[失败]\033[0m $display_name 安装失败"
                fi
                break
                ;;
            n|no)
                echo -e "\033[33m[跳过]\033[0m 用户取消安装: $display_name"
                break
                ;;
            *)
                invalid_attempts=$((invalid_attempts + 1))
                if [ $invalid_attempts -ge 3 ]; then
                    echo -e "\033[31m错误: 连续3次无效输入，脚本终止\033[0m"
                    exit 1
                fi
                echo -e "\033[31m错误: 无效输入 (剩余尝试次数 $((3 - invalid_attempts)))\033[0m"
                ;;
        esac
    done
done

echo "克隆执行完成，正在安装依赖..."
pnpm i

echo -e "\033[1;35m"
echo "╔══════════════════════════════╗"
echo "║ 操作已完成！请重启Yunzai(缺少依赖自行安装)  ║"
echo "╚══════════════════════════════╝"
echo -e "\033[0m"

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
