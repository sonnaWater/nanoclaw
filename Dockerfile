# 小技巧
# - 使用 node:20-alpine 可大幅減少映像大小（約 120 MB）。
# - 若你在容器內需要 npm run dev 或 npm run build，請把 --omit=dev 改成 npm ci（安裝全部依賴）。
  # docker build -t nanoclaw-dev .

  
 # 1️⃣ 官方 Node 20 LTS 基底映像
  FROM node:20-bullseye

  # 2️⃣ 安裝系統工具（不含 Claude CLI）
  RUN apt-get update && apt-get install -y \
      git bash openssh-client python3 make g++ curl ca-certificates && \
      apt-get clean && rm -rf /var/lib/apt/lists/*

  # 3️⃣ 安裝 Claude Code CLI（下載、去除 Windows CRLF、執行、建立全域連結）
  RUN curl -fsSL https://claude.ai/install.sh -o /tmp/install.sh && \
      tr -d '\r' < /tmp/install.sh > /tmp/install_fixed.sh && \
      bash /tmp/install_fixed.sh && \
      ln -s /root/.local/bin/claude /usr/local/bin/claude && \
      chmod +x /usr/local/bin/claude

  # 4️⃣ 工作目錄（會被掛載）
  WORKDIR /app

  # 5️⃣ 先拷貝 package.json / package-lock.json
  COPY package*.json ./

  # 6️⃣ 之後會在容器啟動後手動執行 npm ci（或你可以自行加入 RUN npm ci ）
  #    這裡不放 npm ci，因為 /app 會被掛載，建議在容器內執行一次：

  # 7️⃣ 預設執行 bash
  CMD ["bash"]

# 5️⃣ (在容器啟動後) 會在此執行 npm ci
