# Этап сборки (build)
FROM node:20-alpine AS build

# Рабочая директория
WORKDIR /app

# Копируем только package*.json для кеша npm ci
COPY package*.json ./

# Ставим ВСЕ зависимости, включая dev (vite, tsx, typescript и т.п.)
RUN npm ci

# Копируем остальной код
COPY . .

# Собираем клиент и сервер
RUN npm run build

# Этап рантайма (production)
FROM node:20-alpine AS runtime

# Рабочая директория внутри контейнера
WORKDIR /app

ENV NODE_ENV=production

# Ставим только прод-зависимости
COPY package*.json ./
RUN npm ci --omit=dev

# Копируем собранный сервер + фронт из build-стейджа
COPY --from=build /app/dist ./dist

# Костыль: сделать index.html там, где его ищет сервер (/app/index.html)
# Файл реально лежит в /app/dist/index.html, поэтому используем симлинк
RUN ln -s /app/dist/index.html /app/index.html

# Порт, на котором слушает cc-switch-web-ui
EXPOSE 3010

# Запускаем продовый сервер (node dist/server/index.js)
CMD ["npm", "start"]
