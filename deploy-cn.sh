#!/usr/bin/env bash

set -x
set -e

npm run build

commitMessage=$(git log --oneline -n 1)

rm -fr /tmp/awesome-preview.angular.live

git clone https://asnowwolf:${GITHUB_ACCESS_TOKEN}@github.com/ng-docs/awesome-angular-preview.git /tmp/awesome-preview.angular.live

cp -r ./dist/awesome-angular/* /tmp/awesome-preview.angular.live/

kill `lsof -t -i :4000` || true

npx http-server-spa dist/awesome-angular index.html 4000 &

rm -fr /tmp/awesome-angular-prerender || true

npx prerender mirror -r /tmp/awesome-angular-prerender/ http://localhost:4000/

kill `lsof -t -i :4000` || true

cp -r /tmp/awesome-angular-prerender/localhost:4000/* /tmp/awesome-preview.angular.live/

cd /tmp/awesome-preview.angular.live/

git add .
git commit -am "${commitMessage}"

git push

cd -

set +x
set +e
