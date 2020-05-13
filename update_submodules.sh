#!/bin/bash

mkdir -p ~/.ssh/
ssh-keyscan github.com >> ~/.ssh/known_hosts
git submodule init
git submodule update
git pull --recurse-submodules
git submodule update --remote --merge

project_root=$(pwd)
cartridge_root="${project_root}/modules/cartridge"
rst_src="${project_root}/modules/cartridge/build.luarocks/build.rst"
rst_dest="${project_root}/doc/book/cartridge"
pot_src="${project_root}/modules/cartridge/build.luarocks/build.rst/locale"
pot_dest="${project_root}/locale/book/cartridge"
po_src="${project_root}/modules/cartridge/build.luarocks/build.rst/locale/ru/LC_MESSAGES"
po_dest="${project_root}/locale/ru/LC_MESSAGES/book/cartridge"

cd "${cartridge_root}" || exit
tarantoolctl rocks install \
  https://raw.githubusercontent.com/tarantool/LDoc/tarantool/ldoc-scm-2.rockspec \
  --server=http://rocks.moonscript.org
CMAKE_DUMMY_WEBUI=true tarantoolctl rocks make


cd "${rst_src}" || exit
mkdir -p "${rst_dest}"
find . -iregex '.*\.\(rst\|png\)$' -exec cp -r --parents {} "${rst_dest}" \;

cd "${pot_src}" || exit
mkdir -p "${pot_dest}"
find . -name '*.pot' -exec cp -r --parents {} "${pot_dest}" \;

cd "${po_src}" || exit
mkdir -p "${po_dest}"
find . -name '*.po' -exec cp -r --parents {} "${po_dest}" \;

