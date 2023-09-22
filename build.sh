#!/bin/bash

result=0

export BUNDLE_GEMFILE=`pwd`/Gemfile
bundle config set specific_platform true

echo "[*] Running drop DB"
bundle exec rails db:drop

echo "[*] Running create and migrate DB"
bundle exec rails environment db:create db:migrate

echo "[*] Running prepare tests"
bundle exec rails db:test:prepare

echo "[*] Running Rspec"
bundle exec rspec spec --force-color
((result+=$?))

cd "$( dirname "${BASH_SOURCE[0]}" )"

for test_script in $(echo "$FINDER"); do
  pushd `dirname $test_script` > /dev/null
  bundle lock --add-platform ruby x86_64-linux x86-mingw32 x86-mswin32 x64-mingw32 java
  chmod +x ./test.sh && ./test.sh
  ((result+=$?))
  popd > /dev/null
done

if [ $result -eq 0 ]; then
  echo "[✓] SUCCESS"
else
  echo "[x] FAILURE"
fi

exit $result
