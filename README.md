# AI 嵌名赠礼

输入一个名字和一个场景，30 秒得到一首合律的嵌名诗，外加一张可以直接发出去的宣纸卡片。

- 服务端：Python 3.13 + FastAPI（`server/`）
- 客户端：Flutter 3.x 安卓 App（`app/`，包名 com.aipoem.gift）
- 部署：Docker Compose + Nginx（`deploy/`）
- 出图：服务端 Playwright 渲染 HTML 模板截图，端上不做排版

## 本地启动

```bash
cd deploy
cp .env.example .env     # 填好密码与模型 Key
docker compose -f docker-compose.dev.yml up -d
cd ../server && python -m venv .venv && .venv/Scripts/pip install -r requirements.txt
.venv/Scripts/python -m uvicorn app.main:app --reload --port 8000
```

## 开发顺序

见《AI嵌名赠礼-开发实施手册.md》，按 S01 -> S29 逐步执行，每步有验收。
