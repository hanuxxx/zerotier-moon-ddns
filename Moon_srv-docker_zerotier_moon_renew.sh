#!/bin/bash
# ZeroTier Moon服务端更新脚本

# 指定工作路径
work_dir=~/docker/zerotier-moon/moon
docker_name=zerotier-moon

# 获取新的 IP 地址
new_ip=$(curl -4s https://checkip.amazonaws.com)
echo "New IP address is: $new_ip"

# 读取文件中的旧 IP 地址
old_ip=$(cat $work_dir/moon.json| grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
echo "Old IP address is: $old_ip"

# 比较新旧 IP 地址是否相同
if [ "$old_ip" != "$new_ip" ]; then
  echo "IP is different."
  # 执行替换操作
  sed -i "s/$old_ip/$new_ip/g" $work_dir/moon.json
  /usr/bin/docker exec -i $docker_name /bin/sh -c 'cd /var/lib/zerotier-one && zerotier-idtool genmoon moon.json'
  mv $work_dir/*.moon $work_dir/moons.d/
  /usr/bin/docker restart $docker_name
fi
