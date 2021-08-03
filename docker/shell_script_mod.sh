#!/bin/sh


function diycron(){
    for jsname in /scripts/jddj_*.js /scripts/long_*.js /scripts/jd_*.js /scripts/jx_*.js; do
        jsnamecron="$(cat $jsname | grep -oE "/?/?cron \".*\"" | cut -d\" -f2)"
        test -z "$jsnamecron" || echo "$jsnamecron node $jsname >> /scripts/logs/$(echo $jsname | cut -d/ -f3).log 2>&1" >> /scripts/docker/merged_list_file.sh
    done
    
    # 修改docker_entrypoint.sh执行频率
    ln -sf /usr/local/bin/docker_entrypoint.sh /usr/local/bin/docker_entrypoint_mix.sh
    echo "18,38,58 */1 * * * docker_entrypoint_mix.sh >> /scripts/logs/default_task.log 2>&1" >> /scripts/docker/merged_list_file.sh
    # 京喜财富岛提现
    #echo "59 23 * * * sleep 58; node /scripts/jx_cfdtx.js >> /scripts/logs/jx_cfdtx.log 2>&1" >> /scripts/docker/merged_list_file.sh
    #收集助力码
    echo "30 * * * * sh +x /scripts/docker/auto_help.sh collect |ts >> /scripts/logs/auto_help_collect.log 2>&1" >> /scripts/docker/merged_list_file.sh
    #东东工厂修改执行频率
    echo "*/43 * * * * node /scripts/jd_jdfactory.js >> /scripts/logs/jd_jdfactory.log 2>&1" >> /scripts/docker/merged_list_file.sh
    # 京东月资产变动通知
    echo "10 7 1-31/7 * * node /scripts/jd_all_bean_change.js >> /scripts/logs/jd_all_bean_change.log 2>&1" >> /scripts/docker/merged_list_file.sh
    # 燃动夏季避免出现来不及互助
    echo "*/15 7-23 * * * node /scripts/jd_summer_movement_help.js >> /scripts/logs/jd_summer_movement_help.log 2>&1" >> /scripts/docker/merged_list_file.sh
    #京喜打工团
    echo "30 6,7,8,22,23 * * * node /scripts/jd_dreamFactory_tuan.js >> /scripts/logs/jd_dreamFactory_tuan.log 2>&1" >> /scripts/docker/merged_list_file.sh
    #领现金提现
    echo "0 0 * * * node /scripts/jd_cash_exchange.js >> /scripts/logs/jd_cash_exchange.log 2>&1" >> /scripts/docker/merged_list_file.sh
    #热气球挂机
    #echo "20 17 * * * node /scripts/jd_cfd_loop.js >> /scripts/logs/jd_cfd_loop.log 2>&1" >> /scripts/docker/merged_list_file.sh
}

function jd_diy(){
    ## 克隆jd_diy仓库
    if [ ! -d "/jd_diy/" ]; then
        echo "未检查到克隆jd_diy仓库，初始化下载相关脚本..."
        git clone -b main https://ghproxy.com/https://github.com/GARYTEN/xxxl.git /jd_diy
    else
        echo "更新jd_diy脚本相关文件..."
        git -C /jd_diy reset --hard
        git -C /jd_diy pull origin main --rebase
    fi
    cp -f /jd_diy/scripts/*.js /scripts
    
}

function didi_diy(){
    ## 克隆jddj_diy仓库
    if [ ! -d "/didi_diy/" ]; then
        echo "未检查到克隆didi_diy仓库，初始化下载相关脚本..."
        git clone -b main https://github.com/passerby-b/didi_fruit.git /didi_diy
    else
        echo "更新didi_diy脚本相关文件..."
        git -C /didi_diy reset --hard
        git -C /didi_diy pull origin main --rebase
    fi  
       #rm -rf /jddj_diy/sendNotify.js
       cp -f /didi_diy/dd_*.js /scripts
       
       #滴滴果园
       echo "10 0,8,12,18 * * * node /scripts/dd_fruit.js >> /scripts/logs/dd_fruit.js.log 2>&1" >> /scripts/docker/merged_list_file.sh
}


function jddj_diy(){
    ## 克隆jddj_diy仓库
    if [ ! -d "/jddj_diy/" ]; then
        echo "未检查到克隆jddj_diy仓库，初始化下载相关脚本..."
        git clone -b main https://ghproxy.com/https://github.com/717785320/JDDJ.git /jddj_diy
    else
        echo "更新jddj_diy脚本相关文件..."
        git -C /jddj_diy reset --hard
        git -C /jddj_diy pull origin main --rebase
    fi  
       #rm -rf /jddj_diy/sendNotify.js
       cp -f /jddj_diy/jddj_*.js /scripts
       cp -f /scripts/logs/jddj_cookie.js /scripts
}


function panghu_diy(){
    ## 克隆panghu999仓库
    if [ ! -d "/panghu_diy2/" ]; then
        echo "未检查到克隆panghu_diy仓库，初始化下载相关脚本..."
        git clone -b master https://ghproxy.com/https://github.com/panghu999/panghu.git /panghu_diy2
    else
        echo "更新hyzaw脚本相关文件..."
        git -C /panghu_diy2 reset --hard
        git -C /panghu_diy2 pull origin master --rebase
    fi  
       cp -f /panghu_diy2/jd_qmwxj.js /panghu_diy2/jd_wsdlb.js /panghu_diy2/jd_zjb.js /panghu_diy2/jd_hwsx.js /panghu_diy2/jd_ppdz.js /panghu_diy2/jd_tyt.js /panghu_diy2/jd_pk.js /panghu_diy2/jd_lsj.js /scripts
       echo "0 10 * * * node /scripts/jd_qmwxj.js >> /scripts/logs/jd_qmwxj.log 2>&1" >> /scripts/docker/merged_list_file.sh
       echo "5 0-23/6 * * * node /scripts/jd_wsdlb.js >> /scripts/logs/jd_wsdlb.log 2>&1" >> /scripts/docker/merged_list_file.sh
       echo "0 5 * * * node /scripts/jd_zjb.js >> /scripts/logs/jd_zjb.log 2>&1" >> /scripts/docker/merged_list_file.sh
       echo "20 12,14 * * * node /scripts/jd_hwsx.js >> /scripts/logs/jd_hwsx.log 2>&1" >> /scripts/docker/merged_list_file.sh
       echo "1 0 * * * node /scripts/jd_ppdz.js >> /scripts/logs/jd_ppdz.log 2>&1" >> /scripts/docker/merged_list_file.sh
       echo "0 10,11 * * * node /scripts/jd_pk.js >> /scripts/logs/jd_pk.log 2>&1" >> /scripts/docker/merged_list_file.sh
       echo "0 11 * * * node /scripts/jd_lsj.js >> /scripts/logs/jd_lsj.log 2>&1" >> /scripts/docker/merged_list_file.sh
       echo "45 6 * * * node /scripts/jd_senbeans.js >> /scripts/logs/jd_senbeans.log 2>&1" >> /scripts/docker/merged_list_file.sh
}

function panghu999_jd_diy(){
    ## 克隆panghu999仓库
    if [ ! -d "/panghu999_jd_diy/" ]; then
        echo "未检查到克隆panghu999_jd_diy仓库，初始化下载相关脚本..."
        git clone -b master https://ghproxy.com/https://github.com/panghu999/jd_scripts.git /panghu999_jd_diy
    else
        echo "更新hyzaw脚本相关文件..."
        git -C /panghu999_jd_diy reset --hard
        git -C /panghu999_jd_diy pull origin master --rebase
    fi  
       cp -f /panghu999_jd_diy/jd_jdfactory.js /scripts
       sed -i "s/P04z54XCjVWnYaS5u2ak7ZCdan1Bdd2GGiWvC6_uERj/T026aHXGlb6y6IJ_j8x-NCGt4d06TgCjVWnYaS5kRrbA/g" /scripts/jd_jdfactory.js
       sed -i "s/P04z54XCjVWnYaS5m9cZ2ariXVJwHf0bgkG7Uo/T0225KkcR0of9wLfJRKikvIPJQCjVWnYaS5kRrbA/g" /scripts/jd_jdfactory.js
}


# wuzhi_diy
function wuzhi_diy(){
    if [ ! -d "/wuzhi/" ]; then
        echo "未检查到wuzhi仓库脚本，初始化下载相关脚本..."
        git clone -b main https://ghproxy.com/https://github.com/wuzhi04/MyActions.git /wuzhi
    else
        echo "更新wuzhi脚本相关文件..."
        git -C /wuzhi reset --hard
        git -C /wuzhi pull origin main --rebase
    fi
    cp -f /wuzhi/*.js /scripts
    cat /dev/null > /scripts/docker/merged_list_file.sh
    cat /wuzhi/docker/crontab_list.sh >> /scripts/docker/merged_list_file.sh
    sed -i "s/jx_cfdtx.js/jx_cfdtx_bak.js/g" /scripts/docker/merged_list_file.sh
}

# smiek2221
function smiek2221_diy(){
   
    if [ ! -d "/smiek2221/" ]; then
        echo "未检查到smiek2221仓库脚本，初始化下载相关脚本..."
        git clone -b master https://ghproxy.com/https://github.com/smiek2221/scripts.git /smiek2221
    else
        echo "更新wuzhi脚本相关文件..."
        git -C /smiek2221 reset --hard
        git -C /smiek2221 pull origin master --rebase
    fi
    
    cp -f /smiek2221/*.js /scripts
    echo "50 0-23/4 * * * node /scripts/gua_wealth_island.js >> /scripts/logs/gua_wealth_island.log 2>&1" >> /scripts/docker/merged_list_file.sh
    sed -i "s/let summer_movement_joinjoinjoinhui = false/let summer_movement_joinjoinjoinhui = true/g" /scripts/jd_summer_movement.js
    sed -i "s/let summer_movement_HelpHelpHelpFlag = false/let summer_movement_HelpHelpHelpFlag = true/g" /scripts/jd_summer_movement.js
    sed -i "s/const ShHelpAuthorFlag = true/const ShHelpAuthorFlag = false/g" /scripts/jd_summer_movement.js
    sed -i "s/const ShHelpAuthorFlag = true/const ShHelpAuthorFlag = false/g" /scripts/jd_summer_movement_help.js
    sed -i "s/const HelpAuthorFlag = true/const HelpAuthorFlag = false/g" /scripts/gua_wealth_island.js
    
}

# Wenmoux_diy
function Wenmoux_diy(){
    if [ ! -d "/Wenmoux/" ]; then
        echo "未检查到wuzhi仓库脚本，初始化下载相关脚本..."
        git clone -b master https://ghproxy.com/https://github.com/DovFork/Wenmoux.git /Wenmoux
    else
        echo "更新wuzhi脚本相关文件..."
        git -C /Wenmoux reset --hard
        git -C /Wenmoux pull origin master --rebase
    fi
    cp -f /Wenmoux/jd/*.js /scripts
    echo "1 0-23/2 * * * node /scripts/jd_qqxing.js >> /scripts/logs/jd_qqxing.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "59 9 * * * node /scripts/jd_europeancup.js >> /scripts/logs/jd_europeancup.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "28 7 * * * node /scripts/jd_SplitRedPacket.js >> /scripts/logs/jd_SplitRedPacket.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "25 7 * * * node /scripts/jd_ddnc_farmpark.js >> /scripts/logs/jd_ddnc_farmpark.log 2>&1" >> /scripts/docker/merged_list_file.sh
}

# platypus_diy
function platypus_diy(){
    if [ ! -d "/platypus/" ]; then
        echo "未检查到platypus仓库脚本，初始化下载相关脚本..."
        git clone -b main https://ghproxy.com/https://github.com/jiulan/platypus.git /jiulan
    else
        echo "更新platypus脚本相关文件..."
        git -C /platypus reset --hard
        git -C /platypus pull origin main --rebase
    fi
    cp -f /platypus/scripts/jd_joy_park.js /scripts
    echo "20 * * * * node /scripts/jd_joy_park.js >> /scripts/logs/jd_joy_park.log 2>&1" >> /scripts/docker/merged_list_file.sh
}


# star261
function star261_diy(){
   
    if [ ! -d "/star261/" ]; then
        echo "未检查到star261仓库脚本，初始化下载相关脚本..."
        git clone -b main https://ghproxy.com/https://github.com/star261/jd.git /star261
    else
        echo "更新wuzhi脚本相关文件..."
        git -C /star261 reset --hard
        git -C /star261 pull origin main --rebase
    fi
    
    cp -f /star261/scripts/*.js /scripts
    echo "11 12,18,20 * * * node /scripts/jd_summer_movement_bet.js >> /scripts/logs/jd_summer_movement_bet.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "10 8 * * * node /scripts/jd_summer_movement_card.js >> /scripts/logs/jd_summer_movement_card.log 2>&1" >> /scripts/docker/merged_list_file.sh
    echo "7 10,20 * * * node /scripts/jd_summer_movement_map.js >> /scripts/logs/jd_summer_movement_map.log 2>&1" >> /scripts/docker/merged_list_file.sh
}



# 替换
function otherreplace(){
    echo " otherreplace "
    # 注释掉 lxk jd_xtg的启动时间,新建启动时间
    sed -i "s/jd_xtg.js/jd_xtg_bak.js/g" /scripts/docker/merged_list_file.sh
    #京喜工厂兑换失败提醒 一天只提醒一次
    sed -i "s/production.status === 3/production.status === 3 \&\\&\ new Date().getHours() === 12/g" /scripts/jd_dreamFactory.js
    # 金融养猪，一天只提醒一次
    sed -i "s/data.resultData.resultData.wished/data.resultData.resultData.wished \&\\&\ new Date().getHours() === 12/g" /scripts/jd_pigPet.js
    # 关闭京东到家通知
    sed -i "s/let isNotify = true/let isNotify = false/g" /scripts/jddj_fruit.js
    #关闭我是柠檬我是大老板通知
    sed -i "s/let dlbtz = true/let dlbtz = false/g" /scripts/jd_wsdlb.js
    #关闭点点券通知
    #echo "0 6 * * * node /scripts/jd_xtg.js >> /scripts/logs/jd_xtg.log 2>&1" >> /scripts/docker/merged_list_file.sh
    # echo "28 0,12,18,21 * * * node /scripts/jd_carnivalcity.js >> /scripts/logs/jd_carnivalcity.log 2>&1" >> /scripts/docker/merged_list_file.sh
    # sed -i "s/inviteCodes\[tempIndex\].split('@')/[]/g" /scripts/jd_city.js
    # sed -i "s/http:\/\/share.turinglabs.net\/api\/v3\/city\/query\/10\//https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/l107868382\/sharcode\/main\/v1\/jd_city.json/g" /scripts/jd_city.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Fruit.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/l107868382\/sharcode\/main\/v1\/JD_Fruit.json/g" /scripts/jd_fruit.js
    sed -i "s/let helpAuthor = true/let helpAuthor = false/g" /scripts/jd_*.js
    sed -i "s/let jdNotify = true/let jdNotify = false/g" /scripts/jd_*.js
    sed -i "s/const helpFlag  = true/const helpFlag  = false/g" /scripts/jd_dreamFactory_tuan.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Cash.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/JD_Cash.json/g" /scripts/jd_cash.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/shareCodes\/git\/raw\/main\/jd_updateCash.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/jd_updateCash.json/g" /scripts/jd_cash.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Dream_Factory.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/JD_Dream_Factory.json/g" /scripts/jd_dreamFactory.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Health.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/JD_Health.json/g" /scripts/jd_health.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Plant_Bean.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/JD_Plant_Bean.json/g" /scripts/jd_plantBean.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Pet.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/JD_Pet.json/g" /scripts/jd_pet.js
    sed -i "s/https:\/\/wuzhi03.coding.net\/p\/dj\/d\/RandomShareCode\/git\/raw\/main\/JD_Factory.json/https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/GARYTEN2\/xxxl\/sharecode\/shareCodes\/JD_Factory.json/g" /scripts/jd_jdfactory.js
}

# 安装依赖插件
function npmInstall(){
    npm install https http stream zlib vm png-js axios date-fns ts-md5 dotenv crypto-js --prefix /scripts
}

function main(){
    #jd_diy
    wuzhi_diy
    didi_diy
    jddj_diy
    # 柠檬
    panghu_diy
    panghu999_diy
    Wenmoux_diy
    platypus_diy
    smiek2221_diy
    #hyzaw_diy
    star261_diy
    # 判断外网IP,运行自己的代码
    curl icanhazip.com > ./ipstr.txt
    iptxt=$(tail -1 ./ipstr.txt)
    ipbd="152.70"
    result=$(echo $iptxt | grep "${ipbd}")
    if [[ "$result" != "" ]]
    then
      echo "l107服务器，执行性化代码--------------------------------------------------------"
      jd_diy
    else
      echo "非l107服务器，不执行个性化代码---------------------------------------------------"
    fi    
    diycron
    otherreplace
}

main


