#!/bin/sh

set -e

# 获取当前路径, 用于返回
p0=`pwd`
# 获取脚本所在路径, 防止后续操作在非项目路径
p1=$(cd $(dirname $0);pwd)

platform=("windows" "mac")
OS=("windows" "darwin")
arch=("amd64" "amd64")
ext=(".exe" "")

echo 打包数据工具...
repo="gitee.com/quant1x/data"
type="data"
if [ -d ${type} ]; then
  rm -rf ${type}
fi
dataVersion="0.0.1"
git clone --depth 1 https://gitee.com/quant1x/data.git
if [ -d ${type} ]; then
  cd ${type}
  version=`git describe`
  version=${version:1}
  dataVersion=${version}
  echo "${type} version=${version}"
  mkdir bin
  for (( i = 0 ; i < ${#platform[@]} ; i++ ))
  do
    rm -f bin/*
    echo "正在编译${platform[$i]}的${arch[$i]}应用..."
    #apps=("kline" "realtime" "zxg" "xdxr" "tick")
    apps=("kline" "realtime" "xdxr")
    for app in ${apps[@]}
    do
      echo "正在编译${platform[$i]}的${arch[$i]}应用...$app..."
      env GOOS=${OS[$i]} GOARCH=${arch[$i]} go build -o bin/${app}${ext[$i]} gitee.com/quant1x/data/update/${app}
      echo "正在编译${platform[$i]}的${arch[$i]}应用...$app...OK"
    done
    echo "正在编译${platform[$i]}的${arch[$i]}应用...OK"
    zip ../dl/${type}-$version.${OS[$i]}-${arch[$i]}.zip bin/*
    rm bin/*
  done
  for (( i = 0 ; i < ${#platform[@]} ; i++ ))
    do
      rm -f bin/*
      echo "正在编译${platform[$i]}的${arch[$i]}的其它应用..."
      apps=("zxg" "tick")
      for app in ${apps[@]}
      do
        echo "正在编译${platform[$i]}的${arch[$i]}应用...$app..."
        env GOOS=${OS[$i]} GOARCH=${arch[$i]} go build -o bin/${app}${ext[$i]} gitee.com/quant1x/data/update/${app}
        echo "正在编译${platform[$i]}的${arch[$i]}应用...$app...OK"
      done
      echo "正在编译${platform[$i]}的${arch[$i]}应用...OK"
      zip ../dl/other-$version.${OS[$i]}-${arch[$i]}.zip bin/*
      rm bin/*
    done
  cd ..
  rm -rf ./${type}
fi

echo 打包策略工具...
repo="gitee.com/mymmsc/quant"
type="quant"
if [ -d ${type} ]; then
  rm -rf ${type}
fi
quantVersion="1.0.0"
git clone --depth 1 https://${repo}.git ${type}
if [ -d ${type} ]; then
  cd ${type}
  mkdir bin
  version=`git describe`
  version=${version:1}
  quantVersion=${version}
  echo "${type} version=${version}"
  for (( i = 0 ; i < ${#platform[@]} ; i++ ))
  do
    rm -f bin/*
    echo "正在编译${platform[$i]}的${arch[$i]}应用..."
    meths=("strategy")
    apps=("quant")
    for (( i = 0 ; i < ${#meths[@]} ; i++ ))
    do
      echo "正在编译${platform[$i]}的${arch[$i]}应用...$meths[$i]..."
      env GOOS=${OS[$i]} GOARCH=${arch[$i]} go build -o bin/${apps[$i]}${ext[$i]} github.com/quant1x/quant/${meths[$i]}
      echo "正在编译${platform[$i]}的${arch[$i]}应用...$app...OK"
    done
    echo "正在编译${platform[$i]}的${arch[$i]}应用...OK"
    zip ../dl/${type}-$version.${OS[$i]}-${arch[$i]}.zip bin/*
    rm bin/*
  done
  cd ..
  rm -rf ./${type}
fi
sed "s/\${quant_version}/${quantVersion}/g" index.tpl| sed "s/\${data_version}/${dataVersion}/g" > index.html
git add .
git commit -m "更新版本 ${quantVersion}"
git tag -a v${quantVersion} -m "Release version ${quantVersion}"
git push
git push --tags
cd $p0


