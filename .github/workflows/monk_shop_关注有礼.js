# This workflow will do a clean install of node dependencies, build the source code and run tests across different versions of node
# For more information see: https://help.github.com/actions/language-and-framework-guides/using-nodejs-with-github-actions

name: 店铺关注有礼

on:
  workflow_dispatch:
  schedule:
    - cron: '50 15,20 * * *'
  repository_dispatch:
    types: 关注有礼
jobs:
  build:

    runs-on: ubuntu-latest
    if: github.event.repository.owner.id == github.event.sender.id
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          repository: tubie75/jdqd
          ref: main
      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v1
        with:
          node-version: ${{ matrix.node-version }}
      - name: Cache node_modules
        uses: actions/cache@v2 # 使用 GitHub 官方的缓存 Action。
        env:
          cache-name: cache-node-modules
        with:
          path: node_modules
          key: ${{ runner.os }}-${{ env.cache-name }}-${{ hashFiles('package-lock.json') }} # 使用 package-lock.json 的 Hash 作为缓存的 key。也可以使用 package.json 代替
      - name: npm install
        run: |
          npm install
      - name: '关注有礼'
        run: |
          node monk_shop_add_to_car.js 
        env:
          JD_COOKIE: ${{ secrets.JD_COOKIE }}
          JD_USER_AGENT: ${{ secrets.JD_USER_AGENT }}
          JD_DEBUG: ${{ secrets.JD_DEBUG }}
          PUSH_KEY: ${{ secrets.PUSH_KEY }}
          QQ_SKEY: ${{ secrets.QQ_SKEY }}
          QQ_MODE: ${{ secrets.QQ_MODE }}
          BARK_PUSH: ${{ secrets.BARK_PUSH }}
          TG_BOT_TOKEN: ${{ secrets.TG_BOT_TOKEN }}
          TG_USER_ID: ${{ secrets.TG_USER_ID }}
          BARK_SOUND: ${{ secrets.BARK_SOUND }}
          DD_BOT_TOKEN: ${{ secrets.DD_BOT_TOKEN }}
          DD_BOT_SECRET: ${{ secrets.DD_BOT_SECRET }}
          IGOT_PUSH_KEY: ${{ secrets.IGOT_PUSH_KEY }}

