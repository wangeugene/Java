lsof -i :3000 | grep LISTEN | awk '{print $2}' | xargs kill -9
(pnpm install && pnpm dev ) &  
echo "Waiting for 10 seconds for pnpm dev to start..."
sleep 10
echo "10 seconds passed; Starting pnpm web..."
pnpm web
