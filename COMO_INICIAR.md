```
╔════════════════════════════════════════════════════════════════════════════════╗
║                                                                                ║
║                   🚀 COMO INICIAR O PROJETO (SIMPLES)                        ║
║                                                                                ║
║                              LIMPEZA PRO v1.0.0                              ║
║                         Pronto para desenvolvimento                           ║
║                                                                                ║
╚════════════════════════════════════════════════════════════════════════════════╝

═══════════════════════════════════════════════════════════════════════════════════

✅ ANTES DE COMEÇAR (Checklist):

  ☑️ npm install (backend)      → Dependências backend instaladas
  ☑️ npm install (frontend)     → Dependências frontend instaladas
  ☑️ npm run build (frontend)   → Frontend compilado (.next/ existe)
  ☑️ backend/.env criado        → Configuração de desenvolvimento ready
  ☑️ frontend/.env.local criado → Feature flags configuradas
  ☑️ Banco SQLite criado        → backend_data/database.db existe

  Se faltou algum, execute:
  $ cd backend && npm install
  $ cd frontend && npm install && npm run build


═══════════════════════════════════════════════════════════════════════════════════

🚀 OPÇÃO 1: Iniciar com Script Automático (RECOMENDADO)

  $ bash start-local.sh
  
  Isso faz automaticamente:
  ✓ Inicia backend na porta 3000
  ✓ Inicia frontend na porta 3001
  ✓ Abre http://localhost:3001 no browser
  
  Para parar: Pressione Ctrl+C


═══════════════════════════════════════════════════════════════════════════════════

🚀 OPÇÃO 2: Iniciar Manualmente (2 Terminais)

  Terminal 1 (Backend):
  ────────────────────  
  $ cd backend
  $ npm install  (se não feito)
  $ npm start
  
  Esperado:
  ✓ "Express server rodando na porta 3000"
  ✓ "Database initialized"
  ✓ Logs limposs


  Terminal 2 (Frontend):
  ─────────────────────
  $ cd frontend
  $ npm install  (se não feito)
  $ npm run build (se não feito)
  $ npm start
  
  Esperado:
  ✓ Abre automaticamente http://localhost:3001
  ✓ Renderiza homepage
  ✓ Sem erro


═══════════════════════════════════════════════════════════════════════════════════

📍 Acessar o Sistema:

  Frontend (Interface do Usuário):
  http://localhost:3001
  
  Backend (API):
  http://localhost:3000
  
  Health Check:
  curl http://localhost:3000/api/health
  
  Swagger (API Docs):
  http://localhost:3000/api-docs


═══════════════════════════════════════════════════════════════════════════════════

🧪 Testar Fluxos

  1️⃣ AGENDAMENTO:
     1. Ir para http://localhost:3001
     2. Clicar em "Agendar" ou "Booking"
     3. Escolher serviço + data/hora
     4. Preencher formulário
     5. Clicar em "Confirmar"
  
  2️⃣ PAGAMENTO PIX:
     1. No checkout, escolher "PIX"
     2. QR Code deve aparecer na tela
     3. Em produção: escanear QR com phone
     4. Em teste: simular pagamento (ver WEBHOOK_TEST.md)
  
  3️⃣ PAGAMENTO STRIPE:
     1. No checkout, escolher "Cartão"
     2. Usar número de teste Stripe: 4242 4242 4242 4242
     3. Validade: 12/25
     4. CVC: 123
     5. Confirmar


═══════════════════════════════════════════════════════════════════════════════════

📊 Verificações Rápidas

  ✅ Backend funcionando:
     $ curl http://localhost:3000/api/health
     → Retorna: {"status":"ok"}
  
  ✅ Base de dados:
     $ sqlite3 backend_data/database.db ".tables"
     → Lista tabelas: users, bookings, payments, etc
  
  ✅ Logs:
     $ tail -f backend/logs/app.log
     → Mostra logs do servidor


═══════════════════════════════════════════════════════════════════════════════════

❌ Se der erro:

  Erro: "Port 3000 already in use"
  Solução: $ lsof -i :3000 | kill -9 $(awk '{print $2}' NR==2)
  
  Erro: "Database locked"
  Solução: Feche outros processos do SQL, reinicie: npm start
  
  Erro: "Module not found"
  Solução: $ npm install (em backend ou frontend)
  
  Erro: "Build failed"
  Solução: $ rm -rf .next && npm run build
  
  Erro: ".env: No such file"
  Solução: backend/.env não existe, copie de backend/.env.example


═══════════════════════════════════════════════════════════════════════════════════

📚 Documentação Completa

  Leia para entender tudo:
  • CORRECOES_APLICADAS.md - Tudo que foi corrigido hoje
  • DEPLOYMENT_READY.md - Como fazer deploy em produção
  • ACOES_PRIORITARIAS.md - Próximos passos recomendados
  • TESTING_STRATEGY.md - Como rodar testes

  Rápido e sujo:
  • README.md - Overview do projeto


═══════════════════════════════════════════════════════════════════════════════════

🎯 Resumo

  1. Execute: bash start-local.sh
  2. Abra: http://localhost:3001
  3. Teste: Agendamento → PIX → Confirmação
  4. Pronto! ✅

  Tudo deve funcionar sem erros.
  Se houver problema, leia CORRECOES_APLICADAS.md ou DEPLOYMENT_READY.md


════════════════════════════════════════════════════════════════════════════════════

Concluído em: 9 de Fevereiro, 2026
Status: ✅ PRONTO PARA USO

════════════════════════════════════════════════════════════════════════════════════
```
