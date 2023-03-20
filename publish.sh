#!/bin/sh

set -e

# 获取当前路径, 用于返回
p0=`pwd`
# 获取脚本所在路径, 防止后续操作在非项目路径
p1=$(cd $(dirname $0);pwd)

platform=("windows" "mac" "mac")
OS=("windows" "darwin" "darwin")
arch=("amd64" "amd64" "arm64")
ext=(".exe" "" "")

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
  version=$(git describe --tags `git rev-list --tags --max-count=1`)
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
      env GOOS=${OS[$i]} GOARCH=${arch[$i]} go build -ldflags "-X 'main.MinVersion=${dataVersion}'" -o bin/${app}${ext[$i]} gitee.com/quant1x/data/update/${app}
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
      apps=("zxg" "tick" "snapshot")
      for app in ${apps[@]}
      do
        echo "正在编译${platform[$i]}的${arch[$i]}应用...$app..."
        env GOOS=${OS[$i]} GOARCH=${arch[$i]} go build -ldflags "-X 'main.MinVersion=${dataVersion}'" -o bin/${app}${ext[$i]} gitee.com/quant1x/data/update/${app}
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
quantVersion="0.0.1"
git clone --depth 1 https://${repo}.git ${type}
if [ -d ${type} ]; then
  cd ${type}
  mkdir bin
  version=$(git describe --tags `git rev-list --tags --max-count=1`)
  version=${version:1}
  quantVersion=${version}
  echo "${type} version=${version}"
  for (( i = 0 ; i < ${#platform[@]} ; i++ ))
  do
    rm -f bin/*
    echo "正在编译${platform[$i]}的${arch[$i]}应用..."
    meths=("strategy")
    apps=("quant")
    for (( j = 0 ; j < ${#meths[@]} ; j++ ))
    do
      echo "正在编译${platform[$i]}的${arch[$i]}应用...${meths[$j]}..."
      env GOOS=${OS[$i]} GOARCH=${arch[$i]} go build -ldflags "-X 'main.MinVersion=${quantVersion}'" -o bin/${apps[$j]}${ext[$i]} github.com/quant1x/quant/${meths[$j]}
      echo "正在编译${platform[$i]}的${arch[$i]}应用...${meths[$j]}...OK"
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
version=$(git describe --tags `git rev-list --tags --max-count=1`)
version=${version:1}
if [ "$version" == "$quantVersion" ]; then
  echo "版本相同, 先删除tag"
  git tag --delete v${quantVersion}
  echo "版本相同, 先删除tag...OK"
fi
git tag -a v${quantVersion} -m "Release version ${quantVersion}"
git push
if [ "$version" == "$quantVersion" ]; then
  echo "版本相同, 先删除远程tag"
  git push origin :v${quantVersion}
  echo "版本相同, 先删除远程tag...OK"
fi
git push --tags
cd $p0


