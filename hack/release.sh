# Copyright 2020 arugal, zhangwei24@apache.org
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/usr/bin/env bash

if test -z "$version"; then
version=latest
fi

# cross_compiles
make build-all VERSION=${version}

rm -rf ./release
mkdir -p ./release

os_all='linux windows darwin'
arch_all='amd64'

for os in $os_all; do
    for arch in $arch_all; do
        frp_notify_dir_name="frp-notify-${os}-${arch}"
        frp_notify_path="./release/frp-notify-${os}-${arch}"

        if [ "x${os}" = x"windows" ]; then
            if [ ! -f "./bin/frp-notify-${os}-${arch}" ]; then
                continue
            fi

            mkdir -p ./release/${os}
            mv ./bin/frp-notify-${os}-${arch} ./release/${os}/frp-notify.exe
        else
            if [ ! -f "./bin/frp-notify-${os}-${arch}" ]; then
                continue
            fi
            mkdir -p ./release/${os}
            mv ./bin/frp-notify-${os}-${arch} ./release/${os}/frp-notify
        fi
        cp ./LICENSE ./release/${os}/
        cp -rf ./conf/* ./release/${os}/
        # packages
        cd ./release
        if [ "x${os}" = x"windows" ]; then
            zip -rq ${os}.zip ./release/${os}
        else
            tar -zcf ${os}.tar.gz ./release/${os}
        fi
        pwd
        ls
        cd ..
        rm -rf ./release/${os}/
        pwd
        ls
    done
done
