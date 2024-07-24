FROM node:18-alpine as builder
WORKDIR /app

COPY package.json ./
RUN npm install --force
COPY . .
RUN npm run build

FROM node:18-alpine as runner
WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./

RUN npm install --only=production --legacy-peer-deps

EXPOSE 3000
CMD ["npm", "start"]
